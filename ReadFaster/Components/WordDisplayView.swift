import SwiftUI

/// Displays a single word with the ORP (Optimal Recognition Point) highlighted
/// The word is centered on the ORP character so it remains fixed on screen
struct WordDisplayView: View {
    let word: Word
    var fontSize: CGFloat = 48
    var accentColor: Color = Theme.accent
    var textColor: Color = Theme.textPrimary
    
    var body: some View {
        HStack(spacing: 0) {
            // Before ORP - right-aligned
            Text(word.beforeORP)
                .foregroundColor(textColor)
                .frame(minWidth: 120, alignment: .trailing)
            
            // ORP character - highlighted
            Text(word.orpCharacter)
                .foregroundColor(accentColor)
            
            // After ORP - left-aligned
            Text(word.afterORP)
                .foregroundColor(textColor)
                .frame(minWidth: 120, alignment: .leading)
        }
        .font(.system(size: fontSize, weight: .medium, design: .monospaced))
    }
}

/// Alignment guides that help the eye focus on the ORP
struct AlignmentGuidesView: View {
    var color: Color = Theme.textSecondary.opacity(0.3)
    var width: CGFloat = 1
    var height: CGFloat = 20
    var spacing: CGFloat = 60
    
    var body: some View {
        VStack(spacing: spacing) {
            // Top guide
            Rectangle()
                .fill(color)
                .frame(width: width, height: height)
            
            // Bottom guide
            Rectangle()
                .fill(color)
                .frame(width: width, height: height)
        }
    }
}

#Preview {
    ZStack {
        Theme.background
            .ignoresSafeArea()
        
        VStack(spacing: 40) {
            WordDisplayView(word: Word(text: "people."))
            WordDisplayView(word: Word(text: "the"))
            WordDisplayView(word: Word(text: "extraordinary"))
        }
    }
}
