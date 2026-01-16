import SwiftUI

/// Result view with trophy animation
struct SpeedTestResultView: View {
    let level: SpeedTestLevel
    let score: Int
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var data = SpeedTestData.shared
    
    @State private var showTrophy = false
    @State private var showText = false
    @State private var showButtons = false
    
    var passed: Bool {
        if level.level <= 2 {
            return score >= 3
        } else {
            return score >= 4
        }
    }
    
    var resultMessage: (emoji: String, title: String, subtitle: String) {
        switch score {
        case 5:
            return ("🏆", "Perfect!", "You're a Speed Reading Champion!")
        case 4:
            return ("⭐", "Excellent!", "You're a Speedy Reader!")
        case 3:
            return ("✓", "Good Job!", "You passed the test!")
        case 2:
            return ("📚", "Almost There!", "Keep practicing to improve!")
        default:
            return ("💪", "Keep Trying!", "Practice makes perfect!")
        }
    }
    
    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                // Trophy/emoji animation
                if showTrophy {
                    Text(resultMessage.emoji)
                        .font(.system(size: 100))
                        .scaleEffect(showTrophy ? 1 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.6), value: showTrophy)
                }
                
                // Result text
                if showText {
                    VStack(spacing: 12) {
                        Text(resultMessage.title)
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                        
                        Text(resultMessage.subtitle)
                            .font(.system(size: 18))
                            .foregroundColor(Theme.textSecondary)
                        
                        // Score
                        Text("\(score)/5 correct")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(passed ? Theme.success : Theme.accent)
                            .padding(.top, 8)
                    }
                    .transition(.opacity)
                }
                
                Spacer()
                
                // Buttons
                if showButtons {
                    VStack(spacing: 12) {
                        if passed && level.level < 5 {
                            Button(action: { nextLevel() }) {
                                HStack {
                                    Text("Next Level")
                                    Image(systemName: "arrow.right")
                                }
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Theme.accent)
                                .cornerRadius(Theme.cornerRadiusLarge)
                            }
                        }
                        
                        if !passed {
                            Button(action: { retryLevel() }) {
                                HStack {
                                    Image(systemName: "arrow.clockwise")
                                    Text("Try Again")
                                }
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Theme.accent)
                                .cornerRadius(Theme.cornerRadiusLarge)
                            }
                        }
                        
                        Button(action: { goHome() }) {
                            Text("Back to Menu")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Theme.textSecondary)
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 20)
                    .transition(.opacity)
                }
                
                Spacer()
                    .frame(height: 40)
            }
        }
        .onAppear {
            if passed {
                data.markCompleted(level.id)
            }
            
            // Animate in sequence
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation { showTrophy = true }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation { showText = true }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                withAnimation { showButtons = true }
            }
        }
    }
    
    private func nextLevel() {
        // Navigate back to level selection
        dismiss()
        dismiss()
    }
    
    private func retryLevel() {
        dismiss()
        dismiss()
    }
    
    private func goHome() {
        dismiss()
        dismiss()
    }
}
