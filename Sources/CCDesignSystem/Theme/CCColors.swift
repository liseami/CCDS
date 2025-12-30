/*
 ╔═══════════════════════════════════════════════════════════════════════════╗
 ║                          CCColors.swift                                    ║
 ║                    可配置语义化颜色系统                                     ║
 ╚═══════════════════════════════════════════════════════════════════════════╝

 [INPUT]: Hex 颜色字符串 或 Color 实例
 [OUTPUT]: 支持 Light/Dark 自适应的语义颜色
 [POS]: 设计系统 Theme 层 - 颜色配置

 使用示例:
 ```swift
 // 1. 使用预设颜色
 Text("Hello")
     .foregroundStyle(Color.cc.primary)

 // 2. 自定义颜色配置
 var colors = CCColors.default
 colors.primary = .hex("FF5500")
 colors.background = .adaptive(light: .hex("FFFFFF"), dark: .hex("1A1A1A"))

 // 3. 从 Hex 配置创建
 let colors = CCColors(
     primary: "#6B5344",
     secondary: "#EDD9B5",
     background: "#FAF9F9"
 )
 ```
*/

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - CCColors 颜色配置
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 语义化颜色配置
///
/// 采用 shadcn/ui 风格的语义化命名，支持完全自定义。
public struct CCColors: Sendable {

    // ──────────────────────────────────────────────────────────────────
    // 基础语义色
    // ──────────────────────────────────────────────────────────────────

    /// 主背景色 - 页面底层
    public var background: Color

    /// 主前景色 - 主要文字、图标
    public var foreground: Color

    /// 卡片背景
    public var card: Color

    /// 卡片前景
    public var cardForeground: Color

    // ──────────────────────────────────────────────────────────────────
    // 主题色
    // ──────────────────────────────────────────────────────────────────

    /// 主色调 - 品牌色、主要交互元素
    public var primary: Color

    /// 主色调前景 - 主色调上的文字
    public var primaryForeground: Color

    /// 次要色 - 次要交互元素
    public var secondary: Color

    /// 次要色前景
    public var secondaryForeground: Color

    // ──────────────────────────────────────────────────────────────────
    // 静音色（低对比度）
    // ──────────────────────────────────────────────────────────────────

    /// 静音背景 - 次要区域
    public var muted: Color

    /// 静音前景 - 次要文字、占位符
    public var mutedForeground: Color

    // ──────────────────────────────────────────────────────────────────
    // 强调与功能色
    // ──────────────────────────────────────────────────────────────────

    /// 强调背景 - hover、选中状态
    public var accent: Color

    /// 强调前景
    public var accentForeground: Color

    /// 危险色 - 删除、错误
    public var destructive: Color

    /// 危险色前景
    public var destructiveForeground: Color

    /// 成功色
    public var success: Color

    /// 警告色
    public var warning: Color

    /// 信息色
    public var info: Color

    // ──────────────────────────────────────────────────────────────────
    // 边界与输入
    // ──────────────────────────────────────────────────────────────────

    /// 边框色
    public var border: Color

    /// 输入框边框
    public var input: Color

    /// 焦点环
    public var ring: Color

    // ──────────────────────────────────────────────────────────────────
    // 阴影与遮罩
    // ──────────────────────────────────────────────────────────────────

    /// 阴影色
    public var shadow: Color

    /// 遮罩色
    public var overlay: Color

    // ──────────────────────────────────────────────────────────────────
    // 特殊卡片色
    // ──────────────────────────────────────────────────────────────────

    /// 深色卡片背景
    public var darkCard: Color

    /// 深色卡片前景
    public var darkCardForeground: Color

    /// 骨架图颜色
    public var skeleton: Color

    // ──────────────────────────────────────────────────────────────────
    // 图表色（可选）
    // ──────────────────────────────────────────────────────────────────

    /// 图表调色板
    public var chart: ChartColors

    /// 图表颜色配置
    public struct ChartColors: Sendable {
        public var color1: Color
        public var color2: Color
        public var color3: Color
        public var color4: Color
        public var color5: Color

        public init(
            color1: Color = .hex("BAE800"),
            color2: Color = .hex("C73D66"),
            color3: Color = .hex("F24016"),
            color4: Color = .hex("323FD0"),
            color5: Color = .hex("8B5CF6")
        ) {
            self.color1 = color1
            self.color2 = color2
            self.color3 = color3
            self.color4 = color4
            self.color5 = color5
        }
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - 预设颜色配置
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

public extension CCColors {

    /// 默认浅色配置
    static let `default` = CCColors(
        background: .adaptive(light: .hex("FAF9F9"), dark: .hex("282828")),
        foreground: .adaptive(light: .hex("3D3D3D"), dark: .hex("F1F1F1")),
        card: .adaptive(light: .hex("FDFDFD"), dark: .hex("343434")),
        cardForeground: .adaptive(light: .hex("3D3D3D"), dark: .hex("F1F1F1")),
        primary: .adaptive(light: .hex("6B5344"), dark: .hex("EECFA0")),
        primaryForeground: .adaptive(light: .hex("FDFDFD"), dark: .hex("282828")),
        secondary: .adaptive(light: .hex("EDD9B5"), dark: .hex("4E4740")),
        secondaryForeground: .adaptive(light: .hex("6B5344"), dark: .hex("EECFA0")),
        muted: .adaptive(light: .hex("F2F2F2"), dark: .hex("3E3E3E")),
        mutedForeground: .adaptive(light: .hex("7F7F7F"), dark: .hex("C4C4C4")),
        accent: .adaptive(light: .hex("EBEBEB"), dark: .hex("474747")),
        accentForeground: .adaptive(light: .hex("3D3D3D"), dark: .hex("F1F1F1")),
        destructive: .hex("D93B30"),
        destructiveForeground: .hex("FDFDFD"),
        success: .hex("22C55E"),
        warning: .hex("F59E0B"),
        info: .adaptive(light: .hex("323FD0"), dark: .hex("5A6AE8")),
        border: .adaptive(light: .hex("DFDFDF"), dark: .hex("3B3933")),
        input: .adaptive(light: .hex("DFDFDF"), dark: .hex("656565")),
        ring: .adaptive(light: .hex("6B5344"), dark: .hex("EECFA0")),
        shadow: .black,
        overlay: .black.opacity(0.5),
        darkCard: .black,
        darkCardForeground: .white,
        skeleton: .adaptive(light: .hex("E0E0E0"), dark: .hex("505050")),
        chart: .init()
    )

    /// 深色配置
    static let dark = CCColors(
        background: .hex("282828"),
        foreground: .hex("F1F1F1"),
        card: .hex("343434"),
        cardForeground: .hex("F1F1F1"),
        primary: .hex("EECFA0"),
        primaryForeground: .hex("282828"),
        secondary: .hex("4E4740"),
        secondaryForeground: .hex("EECFA0"),
        muted: .hex("3E3E3E"),
        mutedForeground: .hex("C4C4C4"),
        accent: .hex("474747"),
        accentForeground: .hex("F1F1F1"),
        destructive: .hex("D93B30"),
        destructiveForeground: .hex("FDFDFD"),
        success: .hex("22C55E"),
        warning: .hex("F59E0B"),
        info: .hex("5A6AE8"),
        border: .hex("3B3933"),
        input: .hex("656565"),
        ring: .hex("EECFA0"),
        shadow: .black,
        overlay: .black.opacity(0.5),
        darkCard: .black,
        darkCardForeground: .white,
        skeleton: .hex("505050"),
        chart: .init()
    )

    /// 胃之书品牌配置（支持 Light/Dark 自适应）
    static let bellybook = CCColors.default
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - Hex 初始化器
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

public extension CCColors {

    /// 从 Hex 字符串创建颜色配置（简化版）
    init(
        primary: String,
        secondary: String? = nil,
        background: String? = nil,
        foreground: String? = nil
    ) {
        self = .default
        self.primary = .hex(primary)
        if let secondary { self.secondary = .hex(secondary) }
        if let background { self.background = .hex(background) }
        if let foreground { self.foreground = .hex(foreground) }
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - Color 扩展
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

public extension Color {

    /// 从 Hex 字符串创建颜色
    static func hex(_ string: String) -> Color {
        Color(hex: string)
    }

    /// 从 Hex 字符串初始化
    init(hex string: String) {
        var hexString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }

    /// Light/Dark 自适应颜色
    static func adaptive(light: Color, dark: Color) -> Color {
        #if canImport(UIKit)
        Color(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(dark)
                : UIColor(light)
        })
        #else
        light
        #endif
    }

    /// 转换为 RGB SIMD 向量（用于 Metal 着色器）
    func toRGB() -> SIMD3<Float> {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return SIMD3<Float>(Float(red), Float(green), Float(blue))
        #else
        return SIMD3<Float>(0, 0, 0)
        #endif
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - 便捷访问 (Color.cc.xxx)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 颜色访问命名空间
public struct CCColorNamespace {
    fileprivate init() {}
}

public extension Color {
    /// 设计系统颜色命名空间
    ///
    /// ```swift
    /// Text("Hello")
    ///     .foregroundStyle(Color.cc.primary)
    /// ```
    static var cc: CCColorAccessor { CCColorAccessor() }
}

/// 颜色便捷访问器（使用默认主题）
public struct CCColorAccessor {
    private var colors: CCColors { CCColors.default }

    // 基础色
    public var background: Color { colors.background }
    public var foreground: Color { colors.foreground }
    public var card: Color { colors.card }
    public var cardForeground: Color { colors.cardForeground }

    // 主题色
    public var primary: Color { colors.primary }
    public var primaryForeground: Color { colors.primaryForeground }
    public var secondary: Color { colors.secondary }
    public var secondaryForeground: Color { colors.secondaryForeground }

    // 静音色
    public var muted: Color { colors.muted }
    public var mutedForeground: Color { colors.mutedForeground }

    // 强调与功能色
    public var accent: Color { colors.accent }
    public var accentForeground: Color { colors.accentForeground }
    public var destructive: Color { colors.destructive }
    public var destructiveForeground: Color { colors.destructiveForeground }
    public var success: Color { colors.success }
    public var warning: Color { colors.warning }
    public var info: Color { colors.info }

    // 边界
    public var border: Color { colors.border }
    public var input: Color { colors.input }
    public var ring: Color { colors.ring }

    // 阴影
    public var shadow: Color { colors.shadow }
    public var overlay: Color { colors.overlay }

    // 特殊
    public var darkCard: Color { colors.darkCard }
    public var darkCardForeground: Color { colors.darkCardForeground }
    public var skeleton: Color { colors.skeleton }

    // 图表
    public var chart1: Color { colors.chart.color1 }
    public var chart2: Color { colors.chart.color2 }
    public var chart3: Color { colors.chart.color3 }
    public var chart4: Color { colors.chart.color4 }
    public var chart5: Color { colors.chart.color5 }
}

