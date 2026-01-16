import SwiftUI

/// Quiz view after speed test reading
struct SpeedTestQuizView: View {
    let level: SpeedTestLevel
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentQuestionIndex = 0
    @State private var answers: [Int] = []
    @State private var showResult = false
    
    var currentQuestion: SpeedTestQuestion {
        level.questions[currentQuestionIndex]
    }
    
    var score: Int {
        var correct = 0
        for (index, answer) in answers.enumerated() {
            if level.questions[index].correctIndex == answer {
                correct += 1
            }
        }
        return correct
    }
    
    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header
                HStack {
                    Text("Question \(currentQuestionIndex + 1) of 5")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Theme.textSecondary)
                    
                    Spacer()
                    
                    // Progress dots
                    HStack(spacing: 6) {
                        ForEach(0..<5, id: \.self) { index in
                            Circle()
                                .fill(index < answers.count ? Theme.accent : Theme.surface)
                                .frame(width: 8, height: 8)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
                
                Spacer()
                
                // Question
                Text(currentQuestion.question)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Spacer()
                
                // Options
                VStack(spacing: 12) {
                    ForEach(0..<4, id: \.self) { index in
                        Button(action: { selectAnswer(index) }) {
                            HStack {
                                Text(["A", "B", "C", "D"][index])
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Theme.accent)
                                    .frame(width: 30)
                                
                                Text(currentQuestion.options[index])
                                    .font(.system(size: 16))
                                    .foregroundColor(Theme.textPrimary)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                            }
                            .padding(16)
                            .background(Theme.surface)
                            .cornerRadius(Theme.cornerRadiusMedium)
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                    .frame(height: 40)
            }
        }
        .fullScreenCover(isPresented: $showResult) {
            SpeedTestResultView(level: level, score: score)
        }
    }
    
    private func selectAnswer(_ index: Int) {
        answers.append(index)
        
        if currentQuestionIndex < 4 {
            withAnimation {
                currentQuestionIndex += 1
            }
        } else {
            showResult = true
        }
    }
}
