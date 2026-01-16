import Foundation

/// Represents a single word with Optimal Recognition Point (ORP) calculation
/// The ORP is the position in a word where the eye naturally focuses for fastest recognition
struct Word: Identifiable {
    let id = UUID()
    let text: String
    
    /// Cleaned text with special characters removed (except period)
    var cleanText: String {
        // Remove all punctuation except period
        let allowedCharacters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "."))
        return text.unicodeScalars.filter { allowedCharacters.contains($0) }.map { String($0) }.joined()
    }
    
    /// Whether this word ends with a period (for pause)
    var endsWithPeriod: Bool {
        return cleanText.hasSuffix(".")
    }
    
    /// The index of the ORP character (0-based)
    /// Calculated based on word length - typically around 35% into the word
    var orpIndex: Int {
        let length = cleanText.count
        guard length > 0 else { return 0 }
        
        // ORP calculation based on research:
        // - 1 char: position 0
        // - 2-5 chars: position 1
        // - 6-9 chars: position 2
        // - 10-13 chars: position 3
        // - 14+ chars: position 4
        switch length {
        case 1:
            return 0
        case 2...5:
            return 1
        case 6...9:
            return 2
        case 10...13:
            return 3
        default:
            return 4
        }
    }
    
    /// The portion of the word before the ORP character
    var beforeORP: String {
        guard orpIndex > 0 else { return "" }
        let index = cleanText.index(cleanText.startIndex, offsetBy: orpIndex)
        return String(cleanText[..<index])
    }
    
    /// The ORP character itself (highlighted)
    var orpCharacter: String {
        guard cleanText.count > orpIndex else { return "" }
        let index = cleanText.index(cleanText.startIndex, offsetBy: orpIndex)
        return String(cleanText[index])
    }
    
    /// The portion of the word after the ORP character
    var afterORP: String {
        guard orpIndex < cleanText.count - 1 else { return "" }
        let index = cleanText.index(cleanText.startIndex, offsetBy: orpIndex + 1)
        return String(cleanText[index...])
    }
}

// MARK: - Text Parsing

extension Word {
    /// Parse a text string into an array of Words
    static func parse(text: String) -> [Word] {
        // Split by whitespace and filter empty strings
        let components = text.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
        
        return components.map { Word(text: $0) }
    }
}
