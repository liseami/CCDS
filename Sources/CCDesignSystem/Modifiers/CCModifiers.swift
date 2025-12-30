/*
 ╔═══════════════════════════════════════════════════════════════════════════╗
 ║                         CCModifiers.swift                                  ║
 ║                    统一 View 修饰符 API                                    ║
 ╚═══════════════════════════════════════════════════════════════════════════╝

 [INPUT]: View
 [OUTPUT]: 应用设计系统样式的 View
 [POS]: 设计系统 Modifiers 层 - 视图扩展

 使用示例:
 ```swift
 // 文本样式
 Text("Hello")
     .cc.text(.title)
     .cc.foreground(.primary)

 // 卡片样式
 VStack { content }
     .cc.card()
     .cc.shadow(.md)

 // 按钮样式
 Button("Submit") { }
     .cc.buttonStyle(.primary)

 // 组合链式调用
 Text("Price: $99")
     .cc.text(.body)
     .cc.foreground(.foreground)
     .cc.padding(.md)
 ```
*/

import SwiftUI

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - CC 命名空间入口
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

public extension View {
    /// 设计系统修饰符命名空间
    var cc: CCViewModifier<Self> { CCViewModifier(view: self) }
}

/// View 修饰符包装器
public struct CCViewModifier<Content: View> {
    let view: Content

    init(view: Content) {
        self.view = view
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - 文本样式
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

public extension CCViewModifier {

    /// 应用文本样式
    ///
    /// ```swift
    /// Text("Title")
    ///     .cc.text(.title)
    ///     .cc.foreground(.primary)
    /// ```
    func text(_ style: CCTextStyle, color: CCColorToken = .foreground) -> some View {
        view
            .font(style.font)
            .foregroundStyle(color.color)
    }

    /// 应用数字样式（等宽字体）
    func number(_ style: CCNumberStyle = .medium, color: CCColorToken = .foreground) -> some View {
        view
            .font(style.font)
            .foregroundStyle(color.color)
            .monospacedDigit()
    }

    /// 仅设置前景色
    func foreground(_ token: CCColorToken) -> some View {
        view.foregroundStyle(token.color)
    }
}

/// 文本样式枚举
public enum CCTextStyle {
    case hero, heroBold
    case title1, title1Bold
    case title2, title2Bold
    case title3, title3Bold
    case body, bodyBold
    case callout, calloutBold
    case subheadline, subheadlineBold
    case footnote, footnoteBold
    case caption, captionBold

    var font: Font {
        switch self {
        case .hero: return .cc.hero
        case .heroBold: return .cc.heroBold
        case .title1: return .cc.title1
        case .title1Bold: return .cc.title1Bold
        case .title2: return .cc.title2
        case .title2Bold: return .cc.title2Bold
        case .title3: return .cc.title3
        case .title3Bold: return .cc.title3Bold
        case .body: return .cc.body
        case .bodyBold: return .cc.bodyBold
        case .callout: return .cc.callout
        case .calloutBold: return .cc.calloutBold
        case .subheadline: return .cc.subheadline
        case .subheadlineBold: return .cc.subheadlineBold
        case .footnote: return .cc.footnote
        case .footnoteBold: return .cc.footnoteBold
        case .caption: return .cc.caption
        case .captionBold: return .cc.captionBold
        }
    }
}

/// 数字样式枚举
public enum CCNumberStyle {
    case large   // 28pt
    case medium  // 20pt
    case small   // 14pt
    case custom(CGFloat)

    var font: Font {
        switch self {
        case .large: return .cc.monoLarge
        case .medium: return .cc.monoMedium
        case .small: return .cc.monoSmall
        case .custom(let size): return .cc.mono(size)
        }
    }
}

/// 颜色令牌枚举
public enum CCColorToken {
    // 基础色
    case background, foreground
    case card, cardForeground

    // 主题色
    case primary, primaryForeground
    case secondary, secondaryForeground

    // 静音色
    case muted, mutedForeground

    // 功能色
    case accent, accentForeground
    case destructive, destructiveForeground
    case success, warning, info

    // 边界
    case border, input, ring

    // 特殊
    case shadow, overlay
    case darkCard, darkCardForeground
    case skeleton

    // 图表
    case chart1, chart2, chart3, chart4, chart5

    // 自定义
    case custom(Color)

    var color: Color {
        switch self {
        case .background: return Color.cc.background
        case .foreground: return Color.cc.foreground
        case .card: return Color.cc.card
        case .cardForeground: return Color.cc.cardForeground
        case .primary: return Color.cc.primary
        case .primaryForeground: return Color.cc.primaryForeground
        case .secondary: return Color.cc.secondary
        case .secondaryForeground: return Color.cc.secondaryForeground
        case .muted: return Color.cc.muted
        case .mutedForeground: return Color.cc.mutedForeground
        case .accent: return Color.cc.accent
        case .accentForeground: return Color.cc.accentForeground
        case .destructive: return Color.cc.destructive
        case .destructiveForeground: return Color.cc.destructiveForeground
        case .success: return Color.cc.success
        case .warning: return Color.cc.warning
        case .info: return Color.cc.info
        case .border: return Color.cc.border
        case .input: return Color.cc.input
        case .ring: return Color.cc.ring
        case .shadow: return Color.cc.shadow
        case .overlay: return Color.cc.overlay
        case .darkCard: return Color.cc.darkCard
        case .darkCardForeground: return Color.cc.darkCardForeground
        case .skeleton: return Color.cc.skeleton
        case .chart1: return Color.cc.chart1
        case .chart2: return Color.cc.chart2
        case .chart3: return Color.cc.chart3
        case .chart4: return Color.cc.chart4
        case .chart5: return Color.cc.chart5
        case .custom(let color): return color
        }
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - 卡片样式
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

public extension CCViewModifier {

    /// 应用卡片样式
    ///
    /// ```swift
    /// VStack { content }
    ///     .cc.card()
    /// ```
    func card(
        padding: CGFloat = .cc.card,
        radius: CGFloat = .cc.radiusCard,
        shadow: CCShadowStyle? = .card
    ) -> some View {
        view
            .padding(padding)
            .background(Color.cc.card)
            .clipShape(RoundedRectangle(cornerRadius: radius))
            .if(shadow != nil) { $0.ccShadow(shadow!) }
    }

    /// 深色卡片样式
    func darkCard(
        padding: CGFloat = .cc.card,
        radius: CGFloat = .cc.radiusCard
    ) -> some View {
        view
            .padding(padding)
            .background(Color.cc.darkCard)
            .clipShape(RoundedRectangle(cornerRadius: radius))
    }

    /// 边框卡片样式
    func outlineCard(
        padding: CGFloat = .cc.card,
        radius: CGFloat = .cc.radiusCard,
        borderColor: CCColorToken = .border,
        lineWidth: CGFloat = 1
    ) -> some View {
        view
            .padding(padding)
            .background(Color.cc.card)
            .clipShape(RoundedRectangle(cornerRadius: radius))
            .overlay {
                RoundedRectangle(cornerRadius: radius)
                    .stroke(borderColor.color, lineWidth: lineWidth)
            }
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - Apple Card 样式
// Apple Design 风格卡片：大圆角 + 柔和阴影 + 双层内边框
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

public extension View {

    /// Apple Design 风格卡片
    ///
    /// 特点：大圆角 (20) + 双层内边框 + 柔和双层阴影
    ///
    /// ```swift
    /// VStack { content }
    ///     .appleCard()
    /// ```
    func appleCard(radius: CGFloat = 20) -> some View {
        self
            .background(Color.cc.background)
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .overlay {
                // 外层高光边框
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(Color.cc.background, lineWidth: 2)
                    .blendMode(.overlay)
            }
            .overlay {
                // 内层深色边框
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(Color.cc.foreground.opacity(0.12), lineWidth: 1)
            }
            .shadow(color: Color.cc.shadow.opacity(0.08), radius: 6, y: 3)
            .shadow(color: Color.cc.shadow.opacity(0.12), radius: 16, y: 8)
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - 间距与布局
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

public extension CCViewModifier {

    /// 应用间距
    func padding(_ token: CCSpacingToken) -> some View {
        view.padding(token.value)
    }

    /// 应用水平间距
    func paddingH(_ token: CCSpacingToken) -> some View {
        view.padding(.horizontal, token.value)
    }

    /// 应用垂直间距
    func paddingV(_ token: CCSpacingToken) -> some View {
        view.padding(.vertical, token.value)
    }

    /// 页面级内边距
    func pagePadding() -> some View {
        view.padding(.horizontal, .cc.page)
    }

    /// 圆角
    func radius(_ token: CCRadiusToken) -> some View {
        view.clipShape(RoundedRectangle(cornerRadius: token.value))
    }

    /// 阴影
    func shadow(_ style: CCShadowStyle) -> some View {
        view.ccShadow(style)
    }
}

/// 间距令牌
public enum CCSpacingToken {
    case xs, sm, md, base, lg, xl, xxl, xxxl
    case page, card, section
    case custom(CGFloat)

    var value: CGFloat {
        let spacing = CCSpacing.default
        switch self {
        case .xs: return spacing.xs
        case .sm: return spacing.sm
        case .md: return spacing.md
        case .base: return spacing.base
        case .lg: return spacing.lg
        case .xl: return spacing.xl
        case .xxl: return spacing.xxl
        case .xxxl: return spacing.xxxl
        case .page: return spacing.pageHorizontal
        case .card: return spacing.cardPadding
        case .section: return spacing.section
        case .custom(let v): return v
        }
    }
}

/// 圆角令牌
public enum CCRadiusToken {
    case none, sm, md, base, lg, xl, full
    case button, card, input
    case custom(CGFloat)

    var value: CGFloat {
        let radius = CCRadius.default
        switch self {
        case .none: return radius.none
        case .sm: return radius.sm
        case .md: return radius.md
        case .base: return radius.base
        case .lg: return radius.lg
        case .xl: return radius.xl
        case .full: return radius.full
        case .button: return radius.button
        case .card: return radius.card
        case .input: return radius.input
        case .custom(let v): return v
        }
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - 交互效果
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

public extension CCViewModifier {

    /// 骨架图占位符效果
    func skeleton(isLoading: Bool = true) -> some View {
        view
            .redacted(reason: isLoading ? .placeholder : [])
            .if(isLoading) { $0.shimmer() }
    }

    /// 条件渲染
    func `if`<Transform: View>(
        _ condition: Bool,
        transform: (Content) -> Transform
    ) -> some View {
        Group {
            if condition {
                transform(view)
            } else {
                view
            }
        }
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - 辅助扩展
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

public extension View {
    /// 条件修饰符
    @ViewBuilder
    func `if`<Transform: View>(
        _ condition: Bool,
        transform: (Self) -> Transform
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    /// 闪光效果（骨架图）
    func shimmer() -> some View {
        self.modifier(ShimmerModifier())
    }
}

/// 闪光修饰符
struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay {
                LinearGradient(
                    colors: [
                        Color.white.opacity(0),
                        Color.white.opacity(0.3),
                        Color.white.opacity(0)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: phase)
                .mask(content)
            }
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 200
                }
            }
    }
}

