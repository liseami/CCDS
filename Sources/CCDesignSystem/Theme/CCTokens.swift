/*
 ╔═══════════════════════════════════════════════════════════════════════════╗
 ║                          CCTokens.swift                                    ║
 ║                间距 / 圆角 / 阴影 / 动画 设计令牌                           ║
 ╚═══════════════════════════════════════════════════════════════════════════╝

 [INPUT]: 语义化令牌名称
 [OUTPUT]: CGFloat / Animation / Shadow 值
 [POS]: 设计系统 Theme 层 - 设计令牌

 使用示例:
 ```swift
 // 间距
 .padding(.cc.md)
 .padding(.horizontal, .cc.page)

 // 圆角
 .cornerRadius(.cc.card)

 // 阴影
 .shadow(.cc.sm)
 ```
*/

import SwiftUI

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - CCSpacing 间距配置
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 间距配置（基于 4pt 网格）
public struct CCSpacing: Sendable {

    /// 极小 4pt
    public var xs: CGFloat
    /// 小 8pt
    public var sm: CGFloat
    /// 中 12pt
    public var md: CGFloat
    /// 标准 16pt
    public var base: CGFloat
    /// 大 20pt
    public var lg: CGFloat
    /// 特大 24pt
    public var xl: CGFloat
    /// 超大 32pt
    public var xxl: CGFloat
    /// 巨大 48pt
    public var xxxl: CGFloat

    /// 页面水平内边距
    public var pageHorizontal: CGFloat
    /// 页面垂直内边距
    public var pageVertical: CGFloat
    /// 卡片内边距
    public var cardPadding: CGFloat
    /// 列表项间距
    public var listItem: CGFloat
    /// 分组间距
    public var section: CGFloat

    public init(
        xs: CGFloat = 4,
        sm: CGFloat = 8,
        md: CGFloat = 12,
        base: CGFloat = 16,
        lg: CGFloat = 20,
        xl: CGFloat = 24,
        xxl: CGFloat = 32,
        xxxl: CGFloat = 48,
        pageHorizontal: CGFloat = 16,
        pageVertical: CGFloat = 16,
        cardPadding: CGFloat = 16,
        listItem: CGFloat = 12,
        section: CGFloat = 24
    ) {
        self.xs = xs
        self.sm = sm
        self.md = md
        self.base = base
        self.lg = lg
        self.xl = xl
        self.xxl = xxl
        self.xxxl = xxxl
        self.pageHorizontal = pageHorizontal
        self.pageVertical = pageVertical
        self.cardPadding = cardPadding
        self.listItem = listItem
        self.section = section
    }

    public static let `default` = CCSpacing()
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - CCRadius 圆角配置
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 圆角配置
public struct CCRadius: Sendable {

    /// 无圆角
    public var none: CGFloat
    /// 小圆角 4pt
    public var sm: CGFloat
    /// 中圆角 8pt
    public var md: CGFloat
    /// 标准圆角 12pt
    public var base: CGFloat
    /// 大圆角 16pt
    public var lg: CGFloat
    /// 特大圆角 24pt
    public var xl: CGFloat
    /// 完全圆角
    public var full: CGFloat

    /// 按钮圆角
    public var button: CGFloat
    /// 卡片圆角
    public var card: CGFloat
    /// 输入框圆角
    public var input: CGFloat
    /// 头像圆角
    public var avatar: CGFloat

    public init(
        none: CGFloat = 0,
        sm: CGFloat = 4,
        md: CGFloat = 8,
        base: CGFloat = 12,
        lg: CGFloat = 16,
        xl: CGFloat = 24,
        full: CGFloat = 9999,
        button: CGFloat = 12,
        card: CGFloat = 16,
        input: CGFloat = 10,
        avatar: CGFloat = 9999
    ) {
        self.none = none
        self.sm = sm
        self.md = md
        self.base = base
        self.lg = lg
        self.xl = xl
        self.full = full
        self.button = button
        self.card = card
        self.input = input
        self.avatar = avatar
    }

    public static let `default` = CCRadius()
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - CCShadows 阴影配置
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 阴影配置
public struct CCShadows: Sendable {

    public struct Shadow: Sendable {
        public var color: Color
        public var radius: CGFloat
        public var x: CGFloat
        public var y: CGFloat

        public init(color: Color, radius: CGFloat, x: CGFloat = 0, y: CGFloat) {
            self.color = color
            self.radius = radius
            self.x = x
            self.y = y
        }
    }

    /// 小阴影
    public var sm: Shadow
    /// 中阴影
    public var md: Shadow
    /// 大阴影
    public var lg: Shadow
    /// 特大阴影
    public var xl: Shadow

    /// 卡片阴影
    public var card: Shadow
    /// 浮动按钮阴影
    public var fab: Shadow
    /// 弹窗阴影
    public var modal: Shadow

    public init(
        sm: Shadow = Shadow(color: .black.opacity(0.05), radius: 2, y: 1),
        md: Shadow = Shadow(color: .black.opacity(0.1), radius: 4, y: 2),
        lg: Shadow = Shadow(color: .black.opacity(0.15), radius: 8, y: 4),
        xl: Shadow = Shadow(color: .black.opacity(0.2), radius: 16, y: 8),
        card: Shadow = Shadow(color: .black.opacity(0.08), radius: 6, y: 3),
        fab: Shadow = Shadow(color: .black.opacity(0.15), radius: 8, y: 4),
        modal: Shadow = Shadow(color: .black.opacity(0.25), radius: 24, y: 12)
    ) {
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
        self.card = card
        self.fab = fab
        self.modal = modal
    }

    public static let `default` = CCShadows()

    public static let dark = CCShadows(
        sm: Shadow(color: .black.opacity(0.3), radius: 2, y: 1),
        md: Shadow(color: .black.opacity(0.4), radius: 4, y: 2),
        lg: Shadow(color: .black.opacity(0.5), radius: 8, y: 4),
        xl: Shadow(color: .black.opacity(0.6), radius: 16, y: 8),
        card: Shadow(color: .black.opacity(0.4), radius: 6, y: 3),
        fab: Shadow(color: .black.opacity(0.5), radius: 8, y: 4),
        modal: Shadow(color: .black.opacity(0.6), radius: 24, y: 12)
    )
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - CCAnimation 动画配置
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 动画配置
public struct CCAnimation: Sendable {

    /// 快速动画时长
    public var fast: Double
    /// 标准动画时长
    public var normal: Double
    /// 慢速动画时长
    public var slow: Double

    /// 弹簧阻尼
    public var springDamping: Double
    /// 弹簧响应
    public var springResponse: Double

    public init(
        fast: Double = 0.15,
        normal: Double = 0.25,
        slow: Double = 0.4,
        springDamping: Double = 0.7,
        springResponse: Double = 0.3
    ) {
        self.fast = fast
        self.normal = normal
        self.slow = slow
        self.springDamping = springDamping
        self.springResponse = springResponse
    }

    public static let `default` = CCAnimation()

    // 快捷动画
    public var fastAnimation: Animation { .easeOut(duration: fast) }
    public var normalAnimation: Animation { .easeInOut(duration: normal) }
    public var slowAnimation: Animation { .easeInOut(duration: slow) }
    public var springAnimation: Animation {
        .spring(response: springResponse, dampingFraction: springDamping)
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - 便捷访问 (.cc 命名空间)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// CGFloat 间距便捷访问
public extension CGFloat {
    static var cc: CCSpacingAccessor { CCSpacingAccessor() }
}

public struct CCSpacingAccessor {
    private var spacing: CCSpacing { .default }
    private var radius: CCRadius { .default }

    // 间距
    public var xs: CGFloat { spacing.xs }
    public var sm: CGFloat { spacing.sm }
    public var md: CGFloat { spacing.md }
    public var base: CGFloat { spacing.base }
    public var lg: CGFloat { spacing.lg }
    public var xl: CGFloat { spacing.xl }
    public var xxl: CGFloat { spacing.xxl }
    public var xxxl: CGFloat { spacing.xxxl }
    public var page: CGFloat { spacing.pageHorizontal }
    public var card: CGFloat { spacing.cardPadding }

    // 圆角
    public var radiusSm: CGFloat { radius.sm }
    public var radiusMd: CGFloat { radius.md }
    public var radiusBase: CGFloat { radius.base }
    public var radiusLg: CGFloat { radius.lg }
    public var radiusXl: CGFloat { radius.xl }
    public var radiusButton: CGFloat { radius.button }
    public var radiusCard: CGFloat { radius.card }
    public var radiusInput: CGFloat { radius.input }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - View Shadow 扩展
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

public extension View {
    /// 应用设计系统阴影
    func ccShadow(_ shadow: CCShadows.Shadow) -> some View {
        self.shadow(
            color: shadow.color,
            radius: shadow.radius,
            x: shadow.x,
            y: shadow.y
        )
    }

    /// 应用预设阴影
    func ccShadow(_ style: CCShadowStyle) -> some View {
        let shadows = CCShadows.default
        let shadow: CCShadows.Shadow
        switch style {
        case .sm: shadow = shadows.sm
        case .md: shadow = shadows.md
        case .lg: shadow = shadows.lg
        case .xl: shadow = shadows.xl
        case .card: shadow = shadows.card
        case .fab: shadow = shadows.fab
        case .modal: shadow = shadows.modal
        }
        return ccShadow(shadow)
    }
}

/// 阴影样式枚举
public enum CCShadowStyle {
    case sm, md, lg, xl
    case card, fab, modal
}
