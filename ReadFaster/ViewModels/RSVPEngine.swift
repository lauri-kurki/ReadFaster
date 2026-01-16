import Foundation
import SwiftUI

/// Engine that manages the RSVP reading session
/// Uses simple Timer for word progression
class RSVPEngine: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var words: [Word] = []
    @Published var currentIndex: Int = 0
    @Published var wordsPerMinute: Int = 300
    @Published var isPlaying: Bool = false
    @Published var isComplete: Bool = false
    
    // MARK: - Private Properties
    
    private var timer: Timer?
    
    // MARK: - Computed Properties
    
    var currentWord: Word? {
        guard currentIndex >= 0 && currentIndex < words.count else { return nil }
        return words[currentIndex]
    }
    
    var progress: Double {
        guard words.count > 0 else { return 0 }
        return Double(currentIndex) / Double(max(words.count - 1, 1))
    }
    
    var wordInterval: TimeInterval {
        60.0 / Double(wordsPerMinute)
    }
    
    var remainingSeconds: Int {
        let remainingWords = max(0, words.count - currentIndex)
        return Int(Double(remainingWords) * wordInterval)
    }
    
    var remainingTimeString: String {
        let seconds = remainingSeconds
        if seconds < 60 {
            return "\(seconds)s"
        } else {
            let mins = seconds / 60
            let secs = seconds % 60
            return String(format: "%d:%02d", mins, secs)
        }
    }
    
    // MARK: - Public Methods
    
    func loadText(_ text: String) {
        stopTimer()
        
        // Parse words
        let components = text.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
        
        words = components.map { Word(text: $0) }
        currentIndex = 0
        isComplete = false
        isPlaying = false
    }
    
    func play() {
        guard !words.isEmpty && !isComplete else { return }
        isPlaying = true
        startTimer()
    }
    
    func pause() {
        isPlaying = false
        stopTimer()
    }
    
    func togglePlayback() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    func reset() {
        stopTimer()
        currentIndex = 0
        isComplete = false
        isPlaying = false
    }
    
    func skipForward(_ count: Int = 10) {
        currentIndex = min(currentIndex + count, words.count - 1)
    }
    
    func skipBackward(_ count: Int = 10) {
        currentIndex = max(currentIndex - count, 0)
        isComplete = false
    }
    
    func setSpeed(_ newWPM: Int) {
        wordsPerMinute = newWPM
        // Restart timer with new speed if currently playing
        if isPlaying {
            startTimer()
        }
    }
    
    // MARK: - Private Methods
    
    private func startTimer() {
        stopTimer()
        scheduleNextWord()
    }
    
    private func scheduleNextWord() {
        // Calculate interval - add extra pause for period-ending words
        var interval = wordInterval
        if let word = currentWord, word.endsWithPeriod {
            interval *= 1.5 // 50% longer pause for sentences
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            self?.advanceWord()
            if self?.isPlaying == true && self?.isComplete == false {
                self?.scheduleNextWord()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func advanceWord() {
        if currentIndex >= words.count - 1 {
            isComplete = true
            isPlaying = false
            stopTimer()
        } else {
            currentIndex += 1
        }
    }
    
    deinit {
        stopTimer()
    }
}
