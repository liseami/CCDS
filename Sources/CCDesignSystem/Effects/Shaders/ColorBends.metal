//
//  ColorBends.metal
//  YUI
//
//  流动光效着色器 - 从 React Three.js 移植
//

#include <metal_stdlib>
using namespace metal;

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// ColorBends - 流动光效
// 三层颜色叠加 + 正弦波扭曲 = 有机流动感
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[[ stitchable ]] half4 colorBends(
    float2 position,
    half4 color,
    float time,
    float2 size,
    float scale,
    float frequency,
    float warpStrength,
    float3 color1,
    float3 color2,
    float3 color3
) {
    // 归一化坐标 [-1, 1]
    float2 uv = position / size;
    float2 p = uv * 2.0 - 1.0;

    // 宽高比校正 + 缩放
    float aspect = size.x / size.y;
    float2 q = float2(p.x * aspect, p.y);
    q /= max(scale, 0.0001);
    q /= 0.5 + 0.2 * dot(q, q);
    q += 0.2 * cos(time) - 7.56;

    // 累积颜色
    float3 sumCol = float3(0.0);
    float2 s = q;

    // 扭曲参数
    float kBelow = clamp(warpStrength, 0.0, 1.0);
    float kMix = pow(kBelow, 0.3);
    float gain = 1.0 + max(warpStrength - 1.0, 0.0);

    // 第一层颜色
    s -= 0.01;
    float2 r1 = sin(1.5 * (s.yx * frequency) + 2.0 * cos(s * frequency));
    float m1 = length(r1 + sin(5.0 * r1.y * frequency - 3.0 * time) / 4.0);
    float2 disp1 = (r1 - s) * kBelow;
    float2 warped1 = s + disp1 * gain;
    float m1w = length(warped1 + sin(5.0 * warped1.y * frequency - 3.0 * time) / 4.0);
    float m1f = mix(m1, m1w, kMix);
    float w1 = 1.0 - exp(-6.0 / exp(6.0 * m1f));
    sumCol += color1 * w1;

    // 第二层颜色
    s -= 0.01;
    float2 r2 = sin(1.5 * (s.yx * frequency) + 2.0 * cos(s * frequency));
    float m2 = length(r2 + sin(5.0 * r2.y * frequency - 3.0 * time + 1.0) / 4.0);
    float2 disp2 = (r2 - s) * kBelow;
    float2 warped2 = s + disp2 * gain;
    float m2w = length(warped2 + sin(5.0 * warped2.y * frequency - 3.0 * time + 1.0) / 4.0);
    float m2f = mix(m2, m2w, kMix);
    float w2 = 1.0 - exp(-6.0 / exp(6.0 * m2f));
    sumCol += color2 * w2;

    // 第三层颜色
    s -= 0.01;
    float2 r3 = sin(1.5 * (s.yx * frequency) + 2.0 * cos(s * frequency));
    float m3 = length(r3 + sin(5.0 * r3.y * frequency - 3.0 * time + 2.0) / 4.0);
    float2 disp3 = (r3 - s) * kBelow;
    float2 warped3 = s + disp3 * gain;
    float m3w = length(warped3 + sin(5.0 * warped3.y * frequency - 3.0 * time + 2.0) / 4.0);
    float m3f = mix(m3, m3w, kMix);
    float w3 = 1.0 - exp(-6.0 / exp(6.0 * m3f));
    sumCol += color3 * w3;

    return half4(half3(clamp(sumCol, 0.0, 1.0)), 1.0);
}
