/*
 ╔═══════════════════════════════════════════════════════════════════════════╗
 ║                        CCTextField.swift                                   ║
 ║                      表单输入组件                                          ║
 ╚═══════════════════════════════════════════════════════════════════════════╝

 [INPUT]: 绑定文本、验证规则
 [OUTPUT]: 带验证的输入框
 [POS]: 设计系统 Components 层 - 表单

 使用示例:
 ```swift
 CCTextField(
     "用户名",
     text: $username,
     validation: .nonEmpty
 )

 CCTextField(
     "邮箱",
     text: $email,
     validation: .email,
     icon: "envelope"
 )
 ```
*/

import SwiftUI

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - CCTextField
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 设计系统输入框
public struct CCTextField: View {

    // ──────────────────────────────────────────────────────────────────
    // 属性
    // ──────────────────────────────────────────────────────────────────

    private let label: String
    private let placeholder: String
    @Binding private var text: String
    private let validation: CCValidation?
    private let icon: String?
    @Binding private var isValid: Bool

    @FocusState private var isFocused: Bool
    @State private var hasEdited = false

    // ──────────────────────────────────────────────────────────────────
    // 初始化
    // ──────────────────────────────────────────────────────────────────

    public init(
        _ label: String,
        placeholder: String = "",
        text: Binding<String>,
        validation: CCValidation? = nil,
        icon: String? = nil,
        isValid: Binding<Bool> = .constant(true)
    ) {
        self.label = label
        self.placeholder = placeholder.isEmpty ? label : placeholder
        self._text = text
        self.validation = validation
        self.icon = icon
        self._isValid = isValid
    }

    // ──────────────────────────────────────────────────────────────────
    // Body
    // ──────────────────────────────────────────────────────────────────

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 标签
            Text(label)
                .font(.cc.footnote)
                .foregroundStyle(Color.cc.mutedForeground)

            // 输入框
            HStack(spacing: 12) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundStyle(isFocused ? Color.cc.primary : Color.cc.mutedForeground)
                }

                TextField(placeholder, text: $text)
                    .font(.cc.body)
                    .foregroundStyle(Color.cc.foreground)
                    .focused($isFocused)

                if hasEdited && validation != nil {
                    Image(systemName: currentIsValid ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                        .foregroundStyle(currentIsValid ? Color.cc.success : Color.cc.destructive)
                        .font(.system(size: 18))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.cc.muted.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: .cc.radiusInput))
            .overlay {
                RoundedRectangle(cornerRadius: .cc.radiusInput)
                    .stroke(borderColor, lineWidth: isFocused ? 2 : 1)
            }

            // 错误信息
            if hasEdited, let validation, !currentIsValid {
                Text(validation.errorMessage)
                    .font(.cc.caption)
                    .foregroundStyle(Color.cc.destructive)
            }
        }
        .onChange(of: text) { _ in
            hasEdited = true
            updateValidation()
        }
        .onChange(of: isFocused) { focused in
            if !focused { hasEdited = true }
        }
    }

    // ──────────────────────────────────────────────────────────────────
    // 计算属性
    // ──────────────────────────────────────────────────────────────────

    private var currentIsValid: Bool {
        guard let validation else { return true }
        return validation.validate(text)
    }

    private var borderColor: Color {
        if isFocused {
            return Color.cc.ring
        } else if hasEdited && !currentIsValid {
            return Color.cc.destructive
        } else {
            return Color.cc.border
        }
    }

    private func updateValidation() {
        isValid = currentIsValid
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - 验证规则
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 验证规则
public enum CCValidation {
    case nonEmpty
    case email
    case phone
    case minLength(Int)
    case maxLength(Int)
    case regex(String, message: String)
    case custom((String) -> Bool, message: String)

    var errorMessage: String {
        switch self {
        case .nonEmpty: return "此字段不能为空"
        case .email: return "请输入有效的邮箱地址"
        case .phone: return "请输入有效的手机号码"
        case .minLength(let count): return "至少需要 \(count) 个字符"
        case .maxLength(let count): return "最多 \(count) 个字符"
        case .regex(_, let message): return message
        case .custom(_, let message): return message
        }
    }

    func validate(_ text: String) -> Bool {
        switch self {
        case .nonEmpty:
            return !text.trimmingCharacters(in: .whitespaces).isEmpty
        case .email:
            let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            return text.range(of: regex, options: .regularExpression) != nil
        case .phone:
            let regex = "^1[3-9]\\d{9}$"
            return text.range(of: regex, options: .regularExpression) != nil
        case .minLength(let count):
            return text.count >= count
        case .maxLength(let count):
            return text.count <= count
        case .regex(let pattern, _):
            return text.range(of: pattern, options: .regularExpression) != nil
        case .custom(let validator, _):
            return validator(text)
        }
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - CCFormRow
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// 表单行容器
public struct CCFormRow<Content: View>: View {
    let label: String
    let content: Content

    public init(_ label: String, @ViewBuilder content: () -> Content) {
        self.label = label
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.cc.footnote)
                .foregroundStyle(Color.cc.mutedForeground)
            content
        }
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
