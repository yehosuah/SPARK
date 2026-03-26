import SwiftUI

enum TypographyTokens {
    static let display = Font.system(size: 34, weight: .semibold, design: .serif)
    static let hero = display
    static let title = Font.system(size: 28, weight: .semibold, design: .serif)
    static let sectionTitle = Font.system(size: 22, weight: .semibold, design: .serif)
    static let deck = Font.system(size: 17, weight: .medium, design: .default)
    static let body = Font.system(.body, design: .default)
    static let bodyEmphasis = Font.system(.body, design: .default, weight: .medium)
    static let editorBody = Font.system(.body, design: .serif)
    static let footnote = Font.system(.footnote, design: .default)
    static let note = Font.system(size: 15, weight: .regular, design: .default)
    static let caption = Font.system(size: 13, weight: .medium, design: .default)
    static let microLabel = Font.system(size: 11, weight: .semibold, design: .default)
    static let chip = Font.system(size: 14, weight: .medium, design: .default)
    static let action = Font.system(size: 15, weight: .medium, design: .default)
}
