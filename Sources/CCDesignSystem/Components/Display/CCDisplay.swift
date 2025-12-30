/*
 ╔═══════════════════════════════════════════════════════════════════════════╗
 ║                         CCDisplay.swift                                    ║
 ║                      展示组件集合                                          ║
 ╚═══════════════════════════════════════════════════════════════════════════╝

 [INPUT]: 配置参数
 [OUTPUT]: 展示型 UI 组件
 [POS]: 设计系统 Components 层 - 展示

 包含:
 - CCDivider: 分割线
 - CCEmptyView: 空状态
 - CCAvatar: 头像
 - CCBadge: 徽章
 - CCTag: 标签
*/

import SwiftUI
import Kingfisher

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - CCDivider 分割线
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 设计系统分割线
public struct CCDivider: View {
    let color: Color
    let height: CGFloat

    public init(
        color: Color = Color.cc.border,
        height: CGFloat = 1.2
    ) {
        self.color = color
        self.height = height
    }

    public var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: height)
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - CCEmptyView 空状态
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 空状态视图
public struct CCEmptyView: View {
    let icon: String
    let title: String
    let description: String?
    let action: CCEmptyAction?

    public struct CCEmptyAction {
        let title: String
        let action: () -> Void

        public init(title: String, action: @escaping () -> Void) {
            self.title = title
            self.action = action
        }
    }

    public init(
        icon: String = "tray",
        title: String,
        description: String? = nil,
        action: CCEmptyAction? = nil
    ) {
        self.icon = icon
        self.title = title
        self.description = description
        self.action = action
    }

    public var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(Color.cc.mutedForeground)

            VStack(spacing: 8) {
                Text(title)
                    .font(.cc.bodyBold)
                    .foregroundStyle(Color.cc.foreground)

                if let description {
                    Text(description)
                        .font(.cc.footnote)
                        .foregroundStyle(Color.cc.mutedForeground)
                        .multilineTextAlignment(.center)
                }
            }

            if let action {
                CCButton(action.title, style: .secondary) {
                    action.action()
                }
            }
        }
        .padding(.cc.xl)
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - CCAvatar 头像
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 头像组件
public struct CCAvatar: View {
    let url: String?
    let placeholder: String
    let size: CGFloat

    public init(
        url: String? = nil,
        placeholder: String = "person.fill",
        size: CGFloat = 40
    ) {
        self.url = url
        self.placeholder = placeholder
        self.size = size
    }

    public var body: some View {
        Group {
            if let url, let imageURL = URL(string: url) {
                KFImage(imageURL)
                    .resizable()
                    .placeholder {
                        placeholderView
                    }
                    .scaledToFill()
            } else {
                placeholderView
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }

    private var placeholderView: some View {
        Circle()
            .fill(Color.cc.muted)
            .overlay {
                Image(systemName: placeholder)
                    .font(.system(size: size * 0.4))
                    .foregroundStyle(Color.cc.mutedForeground)
            }
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - CCBadge 徽章
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 徽章组件
public struct CCBadge: View {
    let text: String
    let style: CCBadgeStyle

    public init(_ text: String, style: CCBadgeStyle = .default) {
        self.text = text
        self.style = style
    }

    public var body: some View {
        Text(text)
            .font(.cc.caption)
            .foregroundStyle(style.foregroundColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(style.backgroundColor)
            .clipShape(Capsule())
    }
}

public enum CCBadgeStyle {
    case `default`
    case primary
    case secondary
    case success
    case warning
    case destructive
    case outline

    var foregroundColor: Color {
        switch self {
        case .default: return Color.cc.foreground
        case .primary: return Color.cc.primaryForeground
        case .secondary: return Color.cc.secondaryForeground
        case .success: return .white
        case .warning: return .white
        case .destructive: return Color.cc.destructiveForeground
        case .outline: return Color.cc.foreground
        }
    }

    var backgroundColor: Color {
        switch self {
        case .default: return Color.cc.muted
        case .primary: return Color.cc.primary
        case .secondary: return Color.cc.secondary
        case .success: return Color.cc.success
        case .warning: return Color.cc.warning
        case .destructive: return Color.cc.destructive
        case .outline: return .clear
        }
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - CCTag 标签
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 标签组件
public struct CCTag: View {
    let text: String
    let icon: String?
    let isSelected: Bool
    let action: (() -> Void)?

    public init(
        _ text: String,
        icon: String? = nil,
        isSelected: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.text = text
        self.icon = icon
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        Button(action: { action?() }) {
            HStack(spacing: 4) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 12))
                }
                Text(text)
                    .font(.cc.footnote)
            }
            .foregroundStyle(isSelected ? Color.cc.primaryForeground : Color.cc.mutedForeground)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.cc.primary : Color.cc.muted)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay {
                if !isSelected {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.cc.border, lineWidth: 1)
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(action == nil)
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - CCWebImage 网络图片
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 网络图片组件
public struct CCWebImage: View {
    let url: String

    public init(_ url: String) {
        self.url = url
    }

    private var imageURL: URL? {
        URL(string: url.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    public var body: some View {
        KFImage(imageURL)
            .resizable()
            .placeholder { _ in
                Rectangle()
                    .fill(Color.cc.skeleton)
                    .shimmer()
            }
            .fade(duration: 0.3)
            .loadDiskFileSynchronously()
            .cancelOnDisappear(false)
            .retry(maxCount: 3)
            .cacheMemoryOnly(false)
            .memoryCacheExpiration(.days(7))
            .diskCacheExpiration(.days(30))
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
