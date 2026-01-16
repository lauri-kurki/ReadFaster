import SwiftUI

/// Design system for the ReadFaster app
enum Theme {
    // MARK: - Colors
    
    /// Deep charcoal background
    static let background = Color(hex: "1A1A2E")
    
    /// Slightly lighter surface for cards
    static let surface = Color(hex: "252542")
    
    /// Primary text color (off-white)
    static let textPrimary = Color(hex: "EAEAEA")
    
    /// Secondary text color (muted)
    static let textSecondary = Color(hex: "8B8B9E")
    
    /// Accent color for ORP highlight (coral)
    static let accent = Color(hex: "FF6B6B")
    
    /// Success/completion color
    static let success = Color(hex: "4ECDC4")
    
    /// Gradient for cards
    static let cardGradient = LinearGradient(
        colors: [surface, surface.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Typography
    
    /// Main reading font - monospace for consistent spacing
    static let readingFont = Font.system(.largeTitle, design: .monospaced).weight(.medium)
    
    /// Large reading font size
    static let readingFontSize: CGFloat = 48
    
    /// Title font
    static let titleFont = Font.system(.title, design: .rounded).weight(.bold)
    
    /// Body font
    static let bodyFont = Font.system(.body, design: .rounded)
    
    /// Caption font
    static let captionFont = Font.system(.caption, design: .rounded)
    
    // MARK: - Spacing
    
    static let paddingSmall: CGFloat = 8
    static let paddingMedium: CGFloat = 16
    static let paddingLarge: CGFloat = 24
    static let paddingXLarge: CGFloat = 32
    
    // MARK: - Corner Radius
    
    static let cornerRadiusSmall: CGFloat = 8
    static let cornerRadiusMedium: CGFloat = 12
    static let cornerRadiusLarge: CGFloat = 20
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
