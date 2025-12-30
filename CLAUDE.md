# CCDesignSystem Architecture

> 可主题化的现代 SwiftUI 设计系统

---

## 目录结构

```
CCDesignSystem/
├── Package.swift                    # SPM 配置
├── README.md                        # 使用文档
├── CLAUDE.md                        # 架构文档（本文件）
│
├── Sources/CCDesignSystem/
│   ├── CCDesignSystem.swift         # 入口文件 + Re-exports
│   │
│   ├── Theme/                       # 主题配置层
│   │   ├── CCTheme.swift              # 主题核心 + Environment 注入
│   │   ├── CCColors.swift             # 语义化颜色配置
│   │   ├── CCTypography.swift         # 字体排版系统
│   │   └── CCTokens.swift             # 间距/圆角/阴影/动画
│   │
│   ├── Components/                  # UI 组件层
│   │   ├── Buttons/
│   │   │   └── CCButton.swift         # 按钮组件 + 触觉反馈
│   │   ├── Forms/
│   │   │   └── CCTextField.swift      # 输入框 + 验证
│   │   └── Display/
│   │       └── CCDisplay.swift        # 展示组件集合
│   │
│   └── Modifiers/                   # View 修饰符层
│       ├── CCModifiers.swift          # 统一修饰符 API (.cc.xxx)
│       └── CCCardEffects.swift        # 卡片特效修饰符
│
└── Tests/CCDesignSystemTests/       # 单元测试
```

---

## 核心设计原则

### 1. 主题优先 (Theme-First)

所有设计令牌通过 `CCTheme` 统一管理，支持运行时切换：

```swift
// 主题结构
CCTheme
├── colors: CCColors          // 语义化颜色
├── typography: CCTypography  // 字体排版
├── spacing: CCSpacing        // 间距系统
├── radius: CCRadius          // 圆角配置
├── shadows: CCShadows        // 阴影配置
└── animation: CCAnimation    // 动画参数
```

### 2. 统一 API (Unified API)

所有修饰符通过 `.cc` 命名空间访问，保持一致性：

```swift
Text("Hello")
    .cc.text(.body)           // 文本样式
    .cc.foreground(.primary)  // 前景色
    .cc.padding(.md)          // 间距
```

### 3. 向后兼容 (Backward Compatible)

保留旧 API 作为别名，确保平滑迁移：

```swift
// 旧 API（仍可用）
.ccText(font: .CCFont.f1, color: .CC.foreground)
Color.CC.primary

// 新 API（推荐）
.cc.text(.body)
Color.cc.primary
```

---

## 文件职责

| 文件 | 职责 | 公共 API |
|------|------|----------|
| `CCTheme.swift` | 主题配置 + 环境注入 | `CCTheme`, `.ccTheme()`, `@CCThemeValue` |
| `CCColors.swift` | 语义化颜色 | `CCColors`, `Color.cc.xxx` |
| `CCTypography.swift` | 字体系统 | `CCTypography`, `Font.cc.xxx` |
| `CCTokens.swift` | 设计令牌 | `CCSpacing`, `CCRadius`, `CCShadows` |
| `CCModifiers.swift` | 修饰符 | `.cc.text()`, `.cc.card()`, `.cc.padding()` |
| `CCCardEffects.swift` | 卡片特效 | `.ccGlass()`, `.ccElevated()`, `.ccLeather()` |
| `CCButton.swift` | 按钮组件 | `CCButton`, `CCCircleButton`, `CCHaptics` |
| `CCTextField.swift` | 表单组件 | `CCTextField`, `CCValidation` |
| `CCDisplay.swift` | 展示组件 | `CCDivider`, `CCEmptyView`, `CCAvatar`, `CCBadge`, `CCTag` |

---

## 依赖关系

```
应用层 (YUI App)
      │
      ▼
CCDesignSystem
      │
      ├─► Pow (动画特效)
      │
      └─► Kingfisher (图片加载)
```

---

## 扩展指南

### 添加新颜色

1. 在 `CCColors.swift` 中添加属性
2. 在 `CCColorAccessor` 中添加访问器
3. 在 `CCColorToken` 枚举中添加 case

### 添加新组件

1. 在 `Components/` 对应目录创建文件
2. 使用 `Color.cc.xxx` 和 `Font.cc.xxx` 访问设计令牌
3. 在 `CCDesignSystem.swift` 添加 typealias（如需要）

### 添加新修饰符

1. 在 `CCViewModifier` 中添加方法
2. 或创建独立的 View 扩展方法

---

## 命名约定

- **类型**: `CC` 前缀 (`CCButton`, `CCTheme`)
- **修饰符**: `.cc.xxx()` 命名空间
- **令牌**: 语义化命名 (`primary`, `muted`, `destructive`)
- **样式枚举**: `CCXxxStyle` (`CCButtonStyle`, `CCBadgeStyle`)

---

## 版本记录

- **1.0.0** - 初始版本，从 YUI 项目抽离
