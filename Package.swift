// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

/*
 ╔═══════════════════════════════════════════════════════════════════════════╗
 ║                        CCDesignSystem                                      ║
 ║                                                                            ║
 ║  [POS]: 跨项目共享的设计系统 Swift Package                                  ║
 ║  [PROTOCOL]: 语义化 Tokens + 可复用组件 + 视觉特效                          ║
 ║                                                                            ║
 ║  结构:                                                                     ║
 ║    Tokens/     → 色彩、字体、间距等设计令牌                                 ║
 ║    Components/ → 按钮、表单、展示等 UI 组件                                 ║
 ║    Effects/    → 全息卡片、流体背景等视觉特效                               ║
 ║    Modifiers/  → View 扩展修饰符                                           ║
 ╚═══════════════════════════════════════════════════════════════════════════╝
*/

import PackageDescription

let package = Package(
    name: "CCDesignSystem",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "CCDesignSystem",
            targets: ["CCDesignSystem"]
        ),
    ],
    dependencies: [
        // ────────────────────────────────────────────────────────────
        // Pow: SwiftUI 动画特效库 (glow, shake, shine 等)
        // ────────────────────────────────────────────────────────────
        .package(url: "https://github.com/EmergeTools/Pow", from: "1.0.0"),

        // ────────────────────────────────────────────────────────────
        // Kingfisher: 网络图片加载与缓存
        // ────────────────────────────────────────────────────────────
        .package(url: "https://github.com/onevcat/Kingfisher", from: "8.0.0"),
    ],
    targets: [
        .target(
            name: "CCDesignSystem",
            dependencies: [
                "Pow",
                "Kingfisher"
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "CCDesignSystemTests",
            dependencies: ["CCDesignSystem"]
        ),
    ]
)
