/*
 ╔═══════════════════════════════════════════════════════════════════════════╗
 ║                           CCTheme.swift                                    ║
 ║                      主题系统核心架构                                       ║
 ╚═══════════════════════════════════════════════════════════════════════════╝

 [INPUT]: 颜色、字体、间距配置
 [OUTPUT]: 完整的主题实例
 [POS]: 设计系统核心 - 主题配置与注入

 使用示例:
 ```swift
 // 1. 使用默认主题
 ContentView()
     .ccTheme(.default)

 // 2. 自定义主题
 let customTheme = CCTheme {
     $0.colors.primary = .hex("FF5500")
     $0.colors.background = .hex("FAFAFA")
     $0.spacing.base = 16
 }
 ContentView()
     .ccTheme(customTheme)

 // 3. 基于现有主题修改
 let darkTheme = CCTheme.dark.modified {
     $0.colors.primary = .hex("FFD700")
 }
 ```
*/

import SwiftUI

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - CCTheme 主题核心
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// CCDesignSystem 主题配置
///
/// 主题包含所有设计令牌：颜色、字体、间距、圆角、阴影等。
/// 通过 Environment 注入到视图层级中。
public struct CCTheme: Sendable {

    // ──────────────────────────────────────────────────────────────────
    // 设计令牌
    // ──────────────────────────────────────────────────────────────────

    /// 颜色配置
    public var colors: CCColors

    /// 字体配置
    public var typography: CCTypography

    /// 间距配置
    public var spacing: CCSpacing

    /// 圆角配置
    public var radius: CCRadius

    /// 阴影配置
    public var shadows: CCShadows

    /// 动画配置
    public var animation: CCAnimation

    // ──────────────────────────────────────────────────────────────────
    // 初始化
    // ──────────────────────────────────────────────────────────────────

    /// 创建主题（使用默认值）
    public init(
        colors: CCColors = .default,
        typography: CCTypography = .default,
        spacing: CCSpacing = .default,
        radius: CCRadius = .default,
        shadows: CCShadows = .default,
        animation: CCAnimation = .default
    ) {
        self.colors = colors
        self.typography = typography
        self.spacing = spacing
        self.radius = radius
        self.shadows = shadows
        self.animation = animation
    }

    /// 使用 Builder 闭包创建主题
    public init(_ configure: (inout CCTheme) -> Void) {
        self = .default
        configure(&self)
    }

    /// 基于当前主题修改
    public func modified(_ configure: (inout CCTheme) -> Void) -> CCTheme {
        var copy = self
        configure(&copy)
        return copy
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - 预设主题
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

public extension CCTheme {

    /// 默认主题（浅色）
    static let `default` = CCTheme(
        colors: .default,
        typography: .default,
        spacing: .default,
        radius: .default,
        shadows: .default,
        animation: .default
    )

    /// 深色主题
    static let dark = CCTheme(
        colors: .dark,
        typography: .default,
        spacing: .default,
        radius: .default,
        shadows: .dark,
        animation: .default
    )

    /// 胃之书品牌主题
    static let bellybook = CCTheme(
        colors: .bellybook,
        typography: .bellybook,
        spacing: .default,
        radius: .default,
        shadows: .default,
        animation: .default
    )
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - Environment 注入
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 主题 Environment Key
private struct CCThemeKey: EnvironmentKey {
    static let defaultValue: CCTheme = .default
}

public extension EnvironmentValues {
    /// 当前主题
    var ccTheme: CCTheme {
        get { self[CCThemeKey.self] }
        set { self[CCThemeKey.self] = newValue }
    }
}

public extension View {
    /// 注入主题到视图层级
    ///
    /// ```swift
    /// ContentView()
    ///     .ccTheme(.bellybook)
    /// ```
    func ccTheme(_ theme: CCTheme) -> some View {
        environment(\.ccTheme, theme)
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - 主题访问 Property Wrapper
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 便捷访问当前主题
///
/// ```swift
/// struct MyView: View {
///     @CCThemeValue var theme
///
///     var body: some View {
///         Text("Hello")
///             .foregroundStyle(theme.colors.primary)
///     }
/// }
/// ```
@propertyWrapper
public struct CCThemeValue: DynamicProperty {
    @Environment(\.ccTheme) private var theme

    public init() {}

    public var wrappedValue: CCTheme {
        theme
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - 颜色方案适配
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

public extension CCTheme {
    /// 根据系统颜色方案选择主题
    static func adaptive(light: CCTheme = .default, dark: CCTheme = .dark) -> CCTheme {
        // 这里返回的是静态值，实际的适配在 CCColors 层完成
        light
    }
}
