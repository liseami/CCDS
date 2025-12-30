/*
 ╔═══════════════════════════════════════════════════════════════════════════╗
 ║                       CCCardEffects.swift                                  ║
 ║                     卡片特效修饰符                                         ║
 ╚═══════════════════════════════════════════════════════════════════════════╝

 [INPUT]: View + 特效参数
 [OUTPUT]: 带特效的 View
 [POS]: 设计系统 Modifiers 层 - 卡片特效

 使用示例:
 ```swift
 // 玻璃效果
 Card { content }
     .cc.glass()

 // 皮革质感
 Card { content }
     .cc.leather()

 // 3D 倾斜追踪
 Card { content }
     .cc.tiltTracking()
 ```
*/

import SwiftUI

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - 卡片特效扩展
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

public extension CCViewModifier {

    /// 玻璃效果
    @ViewBuilder
    func glass(style: CCGlassStyle = .regular) -> some View {
        view
            .background(style.material)
            .clipShape(RoundedRectangle(cornerRadius: .cc.radiusCard))
    }

    /// 皮革质感
    func leather(borderColor: Color = Color.cc.border) -> some View {
        view
            .overlay {
                RoundedRectangle(cornerRadius: .cc.radiusCard)
                    .stroke(borderColor, lineWidth: 2)
            }
            .shadow(color: Color.cc.shadow.opacity(0.1), radius: 4, y: 2)
    }

    /// 浮起效果
    func elevated(level: CCElevationLevel = .medium) -> some View {
        view
            .shadow(color: Color.cc.shadow.opacity(level.opacity), radius: level.radius, y: level.y)
    }

    /// 3D 倾斜追踪
    func tiltTracking(
        tiltX: Binding<CGFloat>,
        tiltY: Binding<CGFloat>,
        sensitivity: CGFloat = 0.3,
        maxAngle: CGFloat = 15
    ) -> some View {
        CCTiltTrackingView(
            tiltX: tiltX,
            tiltY: tiltY,
            sensitivity: sensitivity,
            maxAngle: maxAngle
        ) {
            view
        }
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - 玻璃样式
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 玻璃效果样式
public enum CCGlassStyle {
    case regular
    case thin
    case thick

    var material: Material {
        switch self {
        case .regular: return .regularMaterial
        case .thin: return .thinMaterial
        case .thick: return .thickMaterial
        }
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - 浮起层级
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 浮起层级
public enum CCElevationLevel {
    case low
    case medium
    case high

    var opacity: Double {
        switch self {
        case .low: return 0.05
        case .medium: return 0.1
        case .high: return 0.2
        }
    }

    var radius: CGFloat {
        switch self {
        case .low: return 4
        case .medium: return 8
        case .high: return 16
        }
    }

    var y: CGFloat {
        switch self {
        case .low: return 2
        case .medium: return 4
        case .high: return 8
        }
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - 3D 倾斜追踪视图
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 3D 倾斜追踪容器
public struct CCTiltTrackingView<Content: View>: View {
    @Binding private var tiltX: CGFloat
    @Binding private var tiltY: CGFloat
    @State private var isDragging = false
    @State private var isPressed = false

    private let content: Content
    private let sensitivity: CGFloat
    private let maxAngle: CGFloat
    private let pressedScale: CGFloat

    public init(
        tiltX: Binding<CGFloat>,
        tiltY: Binding<CGFloat>,
        sensitivity: CGFloat = 0.3,
        maxAngle: CGFloat = 15,
        pressedScale: CGFloat = 1.03,
        @ViewBuilder content: () -> Content
    ) {
        self._tiltX = tiltX
        self._tiltY = tiltY
        self.sensitivity = sensitivity
        self.maxAngle = maxAngle
        self.pressedScale = pressedScale
        self.content = content()
    }

    public var body: some View {
        content
            .rotation3DEffect(.degrees(tiltY), axis: (x: 1, y: 0, z: 0))
            .rotation3DEffect(.degrees(tiltX), axis: (x: 0, y: 1, z: 0))
            .scaleEffect(isPressed ? pressedScale : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
            .gesture(dragGesture)
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                isDragging = true
                #if canImport(UIKit)
                let width = UIScreen.main.bounds.width
                let height = UIScreen.main.bounds.height
                tiltX = min(maxAngle, max(-maxAngle, value.translation.width / width * 100 * sensitivity))
                tiltY = min(maxAngle, max(-maxAngle, -value.translation.height / height * 100 * sensitivity))
                #endif
            }
            .onEnded { _ in
                isDragging = false
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    tiltX = 0
                    tiltY = 0
                }
            }
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - 独立 View 扩展
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

public extension View {

    /// 玻璃效果
    func ccGlass(_ style: CCGlassStyle = .regular) -> some View {
        self
            .background(style.material)
            .clipShape(RoundedRectangle(cornerRadius: .cc.radiusCard))
    }

    /// 皮革边框
    func ccLeather(borderColor: Color = Color.cc.border) -> some View {
        self
            .overlay {
                RoundedRectangle(cornerRadius: .cc.radiusCard)
                    .stroke(borderColor, lineWidth: 2)
            }
            .shadow(color: Color.cc.shadow.opacity(0.1), radius: 4, y: 2)
    }

    /// 浮起效果
    func ccElevated(_ level: CCElevationLevel = .medium) -> some View {
        self
            .shadow(color: Color.cc.shadow.opacity(level.opacity), radius: level.radius, y: level.y)
    }

    /// 卡片样式
    func ccCard(
        padding: CGFloat = .cc.card,
        radius: CGFloat = .cc.radiusCard,
        elevation: CCElevationLevel? = .medium
    ) -> some View {
        self
            .padding(padding)
            .background(Color.cc.card)
            .clipShape(RoundedRectangle(cornerRadius: radius))
            .if(elevation != nil) { $0.ccElevated(elevation!) }
    }

    /// 深色卡片
    func ccDarkCard(
        padding: CGFloat = .cc.card,
        radius: CGFloat = .cc.radiusCard
    ) -> some View {
        self
            .padding(padding)
            .background(Color.cc.darkCard)
            .clipShape(RoundedRectangle(cornerRadius: radius))
    }

    /// 边框卡片
    func ccOutlineCard(
        padding: CGFloat = .cc.card,
        radius: CGFloat = .cc.radiusCard,
        borderColor: Color = Color.cc.border
    ) -> some View {
        self
            .padding(padding)
            .background(Color.cc.card)
            .clipShape(RoundedRectangle(cornerRadius: radius))
            .overlay {
                RoundedRectangle(cornerRadius: radius)
                    .stroke(borderColor, lineWidth: 1)
            }
    }
}
