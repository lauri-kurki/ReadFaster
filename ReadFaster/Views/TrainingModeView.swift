import SwiftUI

/// Training mode view with level selection
struct TrainingModeView: View {
    @State private var selectedText: TrainingText?
    @State private var completedLevels: Set<Int> = []
    
    var body: some View {
        ZStack {
            Color(hex: "1A1A2E")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Training Mode")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Complete each level to improve your reading speed")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    // Training texts
                    VStack(spacing: 12) {
                        ForEach(TrainingTexts.allTexts) { text in
                            Button(action: {
                                selectedText = text
                            }) {
                                HStack(spacing: 14) {
                                    // Level badge
                                    ZStack {
                                        Circle()
                                            .fill(completedLevels.contains(text.level) ? Color(hex: "4ECDC4") : Color(hex: "FF6B6B"))
                                            .frame(width: 48, height: 48)
                                        
                                        if completedLevels.contains(text.level) {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 18, weight: .bold))
                                                .foregroundColor(.white)
                                        } else {
                                            Text("\(text.level)")
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    
                                    // Text info
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(text.title)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                            .lineLimit(1)
                                        
                                        Text(text.author)
                                            .font(.system(size: 13))
                                            .foregroundColor(.white.opacity(0.5))
                                        
                                        HStack(spacing: 12) {
                                            Label("\(text.targetWPM) wpm", systemImage: "speedometer")
                                            Label(text.estimatedTimeString, systemImage: "clock")
                                        }
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(.white.opacity(0.4))
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white.opacity(0.3))
                                }
                                .padding(14)
                                .background(Color(hex: "252542"))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedText) { text in
            RSVPReaderView(
                text: text.content,
                initialWPM: text.targetWPM,
                title: text.title
            ) {
                completedLevels.insert(text.level)
            }
        }
    }
}

#Preview {
    NavigationStack {
        TrainingModeView()
    }
}
