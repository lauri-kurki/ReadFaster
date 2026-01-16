import SwiftUI

/// RSVP reader for Speed Test - fixed WPM, transitions to quiz
struct SpeedTestReaderView: View {
    let level: SpeedTestLevel
    @StateObject private var engine = RSVPEngine()
    @Environment(\.dismiss) private var dismiss
    
    @State private var showQuiz = false
    
    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()
            
            if !showQuiz {
                // Reader view
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Theme.textSecondary)
                                .frame(width: 40, height: 40)
                                .background(Theme.surface)
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        Text(level.title)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Theme.textSecondary)
                        
                        Spacer()
                        
                        // Fixed WPM badge
                        Text("\(level.wpm) WPM")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Theme.accent)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Theme.accent.opacity(0.15))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    Spacer()
                    
                    // Word display
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 2, height: 30)
                        
                        ZStack {
                            if engine.words.isEmpty {
                                Text("Tap to start")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white.opacity(0.5))
                            } else if let word = engine.currentWord {
                                let wordLength = word.cleanText.count
                                let fontSize: CGFloat = wordLength > 14 ? 24 : (wordLength > 10 ? 30 : (wordLength > 7 ? 36 : 42))
                                let sideWidth: CGFloat = wordLength > 10 ? 180 : 150
                                
                                HStack(spacing: 0) {
                                    Text(word.beforeORP)
                                        .foregroundColor(.white)
                                        .frame(width: sideWidth, alignment: .trailing)
                                    
                                    Text(word.orpCharacter)
                                        .foregroundColor(Theme.accent)
                                    
                                    Text(word.afterORP)
                                        .foregroundColor(.white)
                                        .frame(width: sideWidth, alignment: .leading)
                                }
                                .font(.system(size: fontSize, weight: .medium, design: .monospaced))
                                .lineLimit(1)
                            }
                        }
                        .frame(height: 60)
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 2, height: 30)
                    }
                    .frame(height: 120)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        engine.togglePlayback()
                    }
                    
                    Spacer()
                    
                    // Controls
                    VStack(spacing: 16) {
                        // Progress
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.white.opacity(0.2))
                                Capsule()
                                    .fill(Theme.accent)
                                    .frame(width: geo.size.width * engine.progress)
                            }
                        }
                        .frame(height: 6)
                        .padding(.horizontal, 20)
                        
                        // Play button only (no skip for tests)
                        Button(action: { engine.togglePlayback() }) {
                            Image(systemName: engine.isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.white)
                                .frame(width: 64, height: 64)
                                .background(Color.white.opacity(0.15))
                                .clipShape(Circle())
                        }
                        
                        // Stats
                        HStack {
                            Text("\(engine.currentIndex + 1)/\(engine.words.count)")
                                .foregroundColor(.white.opacity(0.5))
                            Spacer()
                            Text(engine.remainingTimeString)
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .font(.system(size: 13, design: .monospaced))
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            engine.wordsPerMinute = level.wpm
            engine.loadText(level.text)
        }
        .onDisappear {
            engine.pause()
        }
        .onChange(of: engine.isComplete) { complete in
            if complete {
                showQuiz = true
            }
        }
        .fullScreenCover(isPresented: $showQuiz) {
            SpeedTestQuizView(level: level)
        }
    }
}
