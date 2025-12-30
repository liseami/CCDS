/*
 ╔═══════════════════════════════════════════════════════════════════════════╗
 ║                                                                            ║
 ║                         ██████╗ ██████╗                                    ║
 ║                        ██╔════╝██╔════╝                                    ║
 ║                        ██║     ██║                                         ║
 ║                        ██║     ██║                                         ║
 ║                        ╚██████╗╚██████╗                                    ║
 ║                         ╚═════╝ ╚═════╝                                    ║
 ║                                                                            ║
 ║                      CCDesignSystem v1.0.0                                 ║
 ║                                                                            ║
 ║          A modern, themeable design system for SwiftUI                     ║
 ║                                                                            ║
 ╚═══════════════════════════════════════════════════════════════════════════╝

 # Quick Start

 ```swift
 import CCDesignSystem

 // 1. 使用设计系统颜色
 Text("Hello")
     .foregroundStyle(Color.cc.primary)

 // 2. 使用设计系统字体
 Text("Title")
     .font(.cc.title1)

 // 3. 使用统一修饰符
 Text("Styled")
     .cc.text(.body)
     .cc.foreground(.primary)

 // 4. 使用组件
 CCButton("Submit", style: .primary) {
     await submitForm()
 }

 // 5. 自定义主题
 let theme = CCTheme {
     $0.colors.primary = .hex("FF5500")
 }
 ContentView()
     .ccTheme(theme)
 ```

 # Architecture

 ```
 CCDesignSystem/
 ├── Theme/           → 主题配置（颜色、字体、间距）
 ├── Components/      → UI 组件（按钮、表单、展示）
 ├── Modifiers/       → View 修饰符（.cc.xxx）
 ├── Effects/         → 视觉特效（全息、玻璃、流体）
 └── FluidGradient/   → 流体渐变背景
 ```
*/

import SwiftUI

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - Re-exports
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

@_exported import Pow
@_exported import Kingfisher

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - Version Info
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// CCDesignSystem 版本信息
public enum CCDesignSystem {
    /// 版本号
    public static let version = "1.0.0"

    /// 包名
    public static let name = "CCDesignSystem"

    /// 描述
    public static let description = "A modern, themeable design system for SwiftUI"
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - Type Aliases (向后兼容)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 兼容旧 CCDesigin 命名
public typealias CCDesigin = CCComponents

/// 组件命名空间
public enum CCComponents {
    // 按钮
    public typealias CCButton = CCDesignSystem_CCButton
    public typealias CCBigButton = CCButton
    public typealias CircleButton = CCCircleButton

    // 表单
    public typealias CCTextField = CCDesignSystem_CCTextField

    // 展示
    public typealias CCWebImage = CCDesignSystem_CCWebImage
    public typealias UserAvatar = CCAvatar
    public typealias CCEmptyView = CCDesignSystem_CCEmptyView

    // 分割线
    public static var thinLine: some View {
        CCDivider()
    }
}

// Type aliases for components
public typealias CCDesignSystem_CCButton = CCButton
public typealias CCDesignSystem_CCTextField = CCTextField
public typealias CCDesignSystem_CCWebImage = CCWebImage
public typealias CCDesignSystem_CCEmptyView = CCEmptyView

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - 全局变量（向后兼容）
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 分割线（向后兼容）
public var thinLine: some View {
    CCDivider()
}
