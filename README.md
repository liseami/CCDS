# CCDesignSystem

A modern, themeable design system for SwiftUI applications.

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2016%2B-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Features

- 🎨 **Themeable** - Complete theme customization with semantic tokens
- 🧱 **Components** - Ready-to-use UI components (buttons, forms, cards)
- ✨ **Effects** - Modern visual effects (glass, holographic, elevation)
- 📱 **iOS 26 Ready** - Liquid Glass and native effects support
- 🔤 **Typography** - Chinese fallback fonts built-in
- 🌗 **Dark Mode** - Automatic light/dark adaptation

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourname/CCDesignSystem", from: "1.0.0")
]
```

Or in Xcode: File → Add Packages → Enter URL

## Quick Start

```swift
import CCDesignSystem

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            // 颜色
            Text("Hello")
                .foregroundStyle(Color.cc.primary)

            // 字体
            Text("Title")
                .font(.cc.title1)

            // 统一修饰符
            Text("Styled")
                .cc.text(.body)
                .cc.foreground(.primary)

            // 按钮组件
            CCButton("Submit", style: .primary) {
                await submitForm()
            }

            // 卡片效果
            VStack { content }
                .ccCard()
                .ccElevated(.medium)
        }
    }
}
```

## Theming

### Default Theme

```swift
// 直接使用默认主题
Text("Hello")
    .foregroundStyle(Color.cc.primary)
```

### Custom Theme

```swift
// 创建自定义主题
let customTheme = CCTheme {
    $0.colors.primary = .hex("FF5500")
    $0.colors.background = .hex("FAFAFA")
    $0.spacing.base = 16
}

// 注入主题
ContentView()
    .ccTheme(customTheme)
```

### From Hex Colors

```swift
let colors = CCColors(
    primary: "#6B5344",
    secondary: "#EDD9B5",
    background: "#FAF9F9"
)

let theme = CCTheme(colors: colors)
```

## Components

### Buttons

```swift
// 主按钮
CCButton("Primary", style: .primary) { await action() }

// 次要按钮
CCButton("Secondary", style: .secondary) { await action() }

// 边框按钮
CCButton("Outline", style: .outline) { await action() }

// 圆形按钮
CCCircleButton(icon: "plus") { await action() }
```

### Forms

```swift
CCTextField(
    "用户名",
    text: $username,
    validation: .nonEmpty,
    icon: "person"
)

CCTextField(
    "邮箱",
    text: $email,
    validation: .email,
    icon: "envelope",
    isValid: $isEmailValid
)
```

### Display

```swift
// 头像
CCAvatar(url: imageURL, size: 48)

// 徽章
CCBadge("New", style: .primary)

// 标签
CCTag("Category", icon: "tag", isSelected: true)

// 空状态
CCEmptyView(
    icon: "tray",
    title: "暂无数据",
    description: "点击添加开始",
    action: .init(title: "添加") { }
)
```

## View Modifiers

### Text Styling

```swift
Text("Title")
    .cc.text(.title1)
    .cc.foreground(.primary)

Text("1,234")
    .cc.number(.large, color: .foreground)
```

### Card Effects

```swift
// 标准卡片
content.ccCard()

// 深色卡片
content.ccDarkCard()

// 边框卡片
content.ccOutlineCard()

// 浮起效果
content.ccElevated(.high)

// 玻璃效果 (iOS 26+)
content.ccGlass()

// 皮革质感
content.ccLeather(borderColor: .hex("C4A88A"))
```

### Spacing & Layout

```swift
content
    .cc.padding(.md)
    .cc.paddingH(.page)
    .cc.radius(.card)
    .cc.shadow(.md)
```

## Color Tokens

| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| `primary` | #6B5344 | #EECFA0 | Brand color |
| `secondary` | #EDD9B5 | #4E4740 | Secondary actions |
| `background` | #FAF9F9 | #282828 | Page background |
| `foreground` | #3D3D3D | #F1F1F1 | Text/icons |
| `muted` | #F2F2F2 | #3E3E3E | Subtle backgrounds |
| `destructive` | #D93B30 | #D93B30 | Error/delete |

## Typography

| Style | Size | Usage |
|-------|------|-------|
| `hero` | 34pt | Hero headlines |
| `title1` | 28pt | Page titles |
| `title2` | 24pt | Section titles |
| `body` | 17pt | Body text |
| `footnote` | 13pt | Supporting text |
| `caption` | 11pt | Labels |

## Requirements

- iOS 16.0+
- macOS 13.0+
- Swift 5.9+
- Xcode 15.0+

## Dependencies

- [Pow](https://github.com/EmergeTools/Pow) - Animation effects
- [Kingfisher](https://github.com/onevcat/Kingfisher) - Image loading

## License

MIT License. See [LICENSE](LICENSE) for details.
