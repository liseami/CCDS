/*
 ╔═══════════════════════════════════════════════════════════════════════════╗
 ║                        CCTypography.swift                                  ║
 ║                      字体排版系统                                          ║
 ╚═══════════════════════════════════════════════════════════════════════════╝

 [INPUT]: 字体名称、字号配置
 [OUTPUT]: Font 实例
 [POS]: 设计系统 Theme 层 - 字体配置

 使用示例:
 ```swift
 // 1. 使用预设字体
 Text("Title")
     .font(.cc.title)

 // 2. 自定义字体配置
 var typography = CCTypography.default
 typography.primaryFontName = "CustomFont-Regular"
 typography.boldFontName = "CustomFont-Bold"
 ```
*/

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - CCTypography 字体配置
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 字体排版配置
public struct CCTypography: Sendable {

    // ──────────────────────────────────────────────────────────────────
    // 字体名称
    // ──────────────────────────────────────────────────────────────────

    /// 主字体（常规）
    public var primaryFontName: String

    /// 主字体（粗体）
    public var boldFontName: String

    /// 等宽数字字体
    public var monoFontName: String

    /// 中文回退字体（常规）
    public var fallbackFontName: String

    /// 中文回退字体（粗体）
    public var fallbackBoldFontName: String

    // ──────────────────────────────────────────────────────────────────
    // 字号配置
    // ──────────────────────────────────────────────────────────────────

    /// 字号配置
    public var sizes: FontSizes

    public struct FontSizes: Sendable {
        public var hero: CGFloat       // 超大标题 34pt
        public var title1: CGFloat     // 大标题 28pt
        public var title2: CGFloat     // 中标题 24pt
        public var title3: CGFloat     // 小标题 20pt
        public var body: CGFloat       // 正文 17pt
        public var callout: CGFloat    // 说明文字 16pt
        public var subheadline: CGFloat // 副标题 15pt
        public var footnote: CGFloat   // 脚注 13pt
        public var caption: CGFloat    // 标题 11pt

        public init(
            hero: CGFloat = 34,
            title1: CGFloat = 28,
            title2: CGFloat = 24,
            title3: CGFloat = 20,
            body: CGFloat = 17,
            callout: CGFloat = 16,
            subheadline: CGFloat = 15,
            footnote: CGFloat = 13,
            caption: CGFloat = 11
        ) {
            self.hero = hero
            self.title1 = title1
            self.title2 = title2
            self.title3 = title3
            self.body = body
            self.callout = callout
            self.subheadline = subheadline
            self.footnote = footnote
            self.caption = caption
        }
    }

    // ──────────────────────────────────────────────────────────────────
    // 初始化
    // ──────────────────────────────────────────────────────────────────

    public init(
        primaryFontName: String = "InstrumentSerif-Regular",
        boldFontName: String = "Nunito-Bold",
        monoFontName: String = "MapleMono-CN-SemiBold",
        fallbackFontName: String = "NotoSerifSC-Regular",
        fallbackBoldFontName: String = "NotoSerifSC-Bold",
        sizes: FontSizes = .init()
    ) {
        self.primaryFontName = primaryFontName
        self.boldFontName = boldFontName
        self.monoFontName = monoFontName
        self.fallbackFontName = fallbackFontName
        self.fallbackBoldFontName = fallbackBoldFontName
        self.sizes = sizes
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - 预设配置
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

public extension CCTypography {

    /// 默认配置
    static let `default` = CCTypography()

    /// 胃之书品牌配置
    static let bellybook = CCTypography()

    /// 系统字体配置
    static let system = CCTypography(
        primaryFontName: ".SFUI-Regular",
        boldFontName: ".SFUI-Semibold",
        monoFontName: "SFMono-Regular",
        fallbackFontName: "PingFangSC-Regular",
        fallbackBoldFontName: "PingFangSC-Semibold"
    )
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - 字体工厂方法
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

public extension CCTypography {

    /// 创建带中文回退的字体
    func font(size: CGFloat, bold: Bool = false) -> Font {
        let primary = bold ? boldFontName : primaryFontName
        let fallback = bold ? fallbackBoldFontName : fallbackFontName
        return .withFallback(primary: primary, fallback: fallback, size: size)
    }

    /// 创建等宽数字字体
    func monoFont(size: CGFloat) -> Font {
        .custom(monoFontName, size: size)
    }

    // 预设字体快捷方法
    var hero: Font { font(size: sizes.hero) }
    var heroBold: Font { font(size: sizes.hero, bold: true) }
    var title1: Font { font(size: sizes.title1) }
    var title1Bold: Font { font(size: sizes.title1, bold: true) }
    var title2: Font { font(size: sizes.title2) }
    var title2Bold: Font { font(size: sizes.title2, bold: true) }
    var title3: Font { font(size: sizes.title3) }
    var title3Bold: Font { font(size: sizes.title3, bold: true) }
    var body: Font { font(size: sizes.body) }
    var bodyBold: Font { font(size: sizes.body, bold: true) }
    var callout: Font { font(size: sizes.callout) }
    var calloutBold: Font { font(size: sizes.callout, bold: true) }
    var subheadline: Font { font(size: sizes.subheadline) }
    var subheadlineBold: Font { font(size: sizes.subheadline, bold: true) }
    var footnote: Font { font(size: sizes.footnote) }
    var footnoteBold: Font { font(size: sizes.footnote, bold: true) }
    var caption: Font { font(size: sizes.caption) }
    var captionBold: Font { font(size: sizes.caption, bold: true) }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - Font 扩展
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

#if canImport(UIKit)
public extension UIFont {
    /// 创建带中文回退的字体
    static func withFallback(primary: String, fallback: String, size: CGFloat) -> UIFont {
        let primaryDescriptor = UIFontDescriptor(fontAttributes: [.name: primary])
        let fallbackDescriptor = UIFontDescriptor(fontAttributes: [.name: fallback])
        let cascadeDescriptor = primaryDescriptor.addingAttributes([
            .cascadeList: [fallbackDescriptor]
        ])
        return UIFont(descriptor: cascadeDescriptor, size: size)
    }
}
#endif

public extension Font {
    /// 创建带中文回退的字体
    static func withFallback(primary: String, fallback: String, size: CGFloat) -> Font {
        #if canImport(UIKit)
        Font(UIFont.withFallback(primary: primary, fallback: fallback, size: size))
        #else
        Font.custom(primary, size: size)
        #endif
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - 便捷访问 (Font.cc.xxx)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

public extension Font {
    /// 设计系统字体命名空间
    static var cc: CCFontAccessor { CCFontAccessor() }
}

/// 字体便捷访问器
public struct CCFontAccessor {
    private var typography: CCTypography { .default }

    // 标题字体
    public var hero: Font { typography.hero }
    public var heroBold: Font { typography.heroBold }
    public var title1: Font { typography.title1 }
    public var title1Bold: Font { typography.title1Bold }
    public var title2: Font { typography.title2 }
    public var title2Bold: Font { typography.title2Bold }
    public var title3: Font { typography.title3 }
    public var title3Bold: Font { typography.title3Bold }

    // 正文字体
    public var body: Font { typography.body }
    public var bodyBold: Font { typography.bodyBold }
    public var callout: Font { typography.callout }
    public var calloutBold: Font { typography.calloutBold }
    public var subheadline: Font { typography.subheadline }
    public var subheadlineBold: Font { typography.subheadlineBold }
    public var footnote: Font { typography.footnote }
    public var footnoteBold: Font { typography.footnoteBold }
    public var caption: Font { typography.caption }
    public var captionBold: Font { typography.captionBold }

    // 数字字体
    public func mono(_ size: CGFloat) -> Font { typography.monoFont(size: size) }
    public var monoLarge: Font { typography.monoFont(size: 28) }
    public var monoMedium: Font { typography.monoFont(size: 20) }
    public var monoSmall: Font { typography.monoFont(size: 14) }

    // 自定义尺寸
    public func custom(_ size: CGFloat, bold: Bool = false) -> Font {
        typography.font(size: size, bold: bold)
    }
}

