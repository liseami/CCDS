/*
 ╔═══════════════════════════════════════════════════════════════════════════╗
 ║                          CCButton.swift                                    ║
 ║                       按钮组件系统                                         ║
 ╚═══════════════════════════════════════════════════════════════════════════╝

 [INPUT]: 标签、样式、动作
 [OUTPUT]: 带触觉反馈和加载状态的按钮
 [POS]: 设计系统 Components 层 - 按钮

 使用示例:
 ```swift
 // 主按钮
 CCButton("Submit", style: .primary) {
     await submitForm()
 }

 // 次要按钮
 CCButton("Cancel", style: .secondary) {
     dismiss()
 }

 // 自定义内容
 CCButton(style: .outline) {
     await action()
 } label: {
     HStack { Image(systemName: "plus"); Text("Add") }
 }
 ```
*/

import SwiftUI
import Pow

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - CCButton 主按钮组件
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 设计系统按钮组件
///
/// 支持多种样式、异步操作、加载状态、触觉反馈。
public struct CCButton<Label: View>: View {

    // ──────────────────────────────────────────────────────────────────
    // 属性
    // ──────────────────────────────────────────────────────────────────

    private let style: CCButtonStyle
    private let isEnabled: Bool
    private let action: () async -> Void
    private let label: Label

    @State private var isLoading = false
    @State private var isPressed = false
    @State private var shakeCount = 0

    // ──────────────────────────────────────────────────────────────────
    // 初始化器
    // ──────────────────────────────────────────────────────────────────

    /// 创建按钮（自定义标签）
    public init(
        style: CCButtonStyle = .primary,
        isEnabled: Bool = true,
        action: @escaping () async -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.style = style
        self.isEnabled = isEnabled
        self.action = action
        self.label = label()
    }

    // ──────────────────────────────────────────────────────────────────
    // Body
    // ──────────────────────────────────────────────────────────────────

    public var body: some View {
        label
            .opacity(isLoading ? 0.6 : 1)
            ._onButtonGesture { pressing in
                guard !isLoading else { return }
                isPressed = pressing
            } perform: {
                Task { await handleTap() }
            }
            // 加载状态效果
            .conditionalEffect(
                .repeat(.glow(color: style.backgroundColor.opacity(0.5)), every: 0.6),
                condition: isLoading
            )
            .conditionalEffect(
                .repeat(.shine(duration: 0.5), every: 0.5),
                condition: isLoading
            )
            // 点击效果
            .changeEffect(.glow(color: style.backgroundColor.opacity(0.3)), value: isPressed)
            // 禁用抖动
            .changeEffect(.shake(rate: .fast), value: shakeCount)
    }

    // ──────────────────────────────────────────────────────────────────
    // 交互处理
    // ──────────────────────────────────────────────────────────────────

    private func handleTap() async {
        guard !isLoading else { return }

        if !isEnabled {
            shakeCount += 1
            CCHaptics.error()
            return
        }

        CCHaptics.soft()
        isLoading = true
        await action()
        isLoading = false
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - 文本按钮便捷初始化
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

public extension CCButton where Label == CCButtonLabel {

    /// 创建文本按钮
    init(
        _ title: String,
        icon: String? = nil,
        style: CCButtonStyle = .primary,
        size: CCButtonSize = .medium,
        isEnabled: Bool = true,
        action: @escaping () async -> Void
    ) {
        self.style = style
        self.isEnabled = isEnabled
        self.action = action
        self.label = CCButtonLabel(
            title: title,
            icon: icon,
            style: style,
            size: size
        )
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - 按钮标签视图
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 标准按钮标签
public struct CCButtonLabel: View {
    let title: String
    let icon: String?
    let style: CCButtonStyle
    let size: CCButtonSize

    public var body: some View {
        HStack(spacing: 8) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: size.iconSize))
            }
            Text(title)
                .font(size.font)
                .kerning(1)
        }
        .foregroundStyle(style.foregroundColor)
        .padding(.horizontal, size.horizontalPadding)
        .padding(.vertical, size.verticalPadding)
        .frame(maxWidth: size == .full ? .infinity : nil)
        .background(style.backgroundColor)
        .clipShape(size.shape)
        .overlay {
            if case .outline = style {
                size.shape
                    .stroke(Color.cc.border, lineWidth: 1)
            }
        }
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - 按钮样式
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 按钮样式
public enum CCButtonStyle {
    case primary
    case secondary
    case outline
    case ghost
    case destructive
    case custom(foreground: Color, background: Color)

    var foregroundColor: Color {
        switch self {
        case .primary: return Color.cc.primaryForeground
        case .secondary: return Color.cc.secondaryForeground
        case .outline: return Color.cc.foreground
        case .ghost: return Color.cc.foreground
        case .destructive: return Color.cc.destructiveForeground
        case .custom(let fg, _): return fg
        }
    }

    var backgroundColor: Color {
        switch self {
        case .primary: return Color.cc.primary
        case .secondary: return Color.cc.secondary
        case .outline: return .clear
        case .ghost: return .clear
        case .destructive: return Color.cc.destructive
        case .custom(_, let bg): return bg
        }
    }
}

/// 按钮尺寸
public enum CCButtonSize {
    case small
    case medium
    case large
    case full

    var font: Font {
        switch self {
        case .small: return .cc.footnote
        case .medium: return .cc.bodyBold
        case .large: return .cc.title3Bold
        case .full: return .cc.bodyBold
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .small: return 14
        case .medium: return 18
        case .large: return 22
        case .full: return 18
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .small: return 12
        case .medium: return 16
        case .large: return 24
        case .full: return 16
        }
    }

    var verticalPadding: CGFloat {
        switch self {
        case .small: return 8
        case .medium: return 12
        case .large: return 16
        case .full: return 16
        }
    }

    var shape: some Shape {
        RoundedRectangle(cornerRadius: self == .full ? 999 : .cc.radiusButton)
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - 圆形按钮
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 圆形图标按钮
public struct CCCircleButton: View {
    let icon: String
    let size: CGFloat
    let action: () async -> Void

    public init(
        icon: String,
        size: CGFloat = 48,
        action: @escaping () async -> Void = {}
    ) {
        self.icon = icon
        self.size = size
        self.action = action
    }

    public var body: some View {
        CCButton(style: .ghost, action: action) {
            buttonContent
        }
    }

    private var buttonContent: some View {
        Circle()
            .fill(Color.cc.background)
            .frame(width: size, height: size)
            .shadow(color: Color.cc.shadow.opacity(0.1), radius: 12)
            .overlay {
                Image(systemName: icon)
                    .font(.system(size: size * 0.4))
                    .foregroundStyle(Color.cc.foreground)
            }
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - 触觉反馈
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 触觉反馈工具
public enum CCHaptics {
    #if canImport(UIKit)
    public static func soft() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }

    public static func light() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    public static func medium() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    public static func heavy() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }

    public static func error() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }

    public static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    public static func warning() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }
    #else
    public static func soft() {}
    public static func light() {}
    public static func medium() {}
    public static func heavy() {}
    public static func error() {}
    public static func success() {}
    public static func warning() {}
    #endif
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
