import Foundation

/// A training text for the speed reading practice
struct TrainingText: Identifiable {
    let id = UUID()
    let title: String
    let author: String
    let content: String
    let level: Int  // 1-5, determines starting WPM
    
    /// Target WPM for this level
    var targetWPM: Int {
        switch level {
        case 1: return 150
        case 2: return 200
        case 3: return 300
        case 4: return 500
        case 5: return 750
        default: return 200
        }
    }
    
    /// Word count of the content
    var wordCount: Int {
        content.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .count
    }
    
    /// Estimated reading time in seconds at target WPM
    var estimatedSeconds: Int {
        let minutes = Double(wordCount) / Double(targetWPM)
        return Int(minutes * 60)
    }
    
    /// Formatted reading time string
    var estimatedTimeString: String {
        let seconds = estimatedSeconds
        if seconds < 60 {
            return "\(seconds)s"
        } else {
            let mins = seconds / 60
            let secs = seconds % 60
            return secs > 0 ? "\(mins)m \(secs)s" : "\(mins)m"
        }
    }
    
    /// Difficulty label based on level
    var difficultyLabel: String {
        switch level {
        case 1: return "Beginner"
        case 2: return "Easy"
        case 3: return "Intermediate"
        case 4: return "Advanced"
        case 5: return "Expert"
        default: return "Unknown"
        }
    }
}
