import SwiftUI

/// The main RSVP reading view
struct RSVPReaderView: View {
    @StateObject private var engine = RSVPEngine()
    @Environment(\.dismiss) private var dismiss
    
    let text: String
    let initialWPM: Int
    let title: String
    var onComplete: (() -> Void)?
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "1A1A2E")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top bar
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white.opacity(0.6))
                            .frame(width: 36, height: 36)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    // Tappable WPM selector
                    Menu {
                        ForEach([100, 150, 200, 250, 300, 400, 500, 600, 750], id: \.self) { speed in
                            Button("\(speed) WPM") {
                                engine.setSpeed(speed)
                            }
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text("\(engine.wordsPerMinute)")
                                .font(.system(size: 16, weight: .bold, design: .monospaced))
                            Text("WPM")
                                .font(.system(size: 12, weight: .medium))
                            Image(systemName: "chevron.down")
                                .font(.system(size: 10, weight: .semibold))
                        }
                        .foregroundColor(Color(hex: "FF6B6B"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(hex: "FF6B6B").opacity(0.15))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                Spacer()
                
                // Word display - ORP centered under guide
                VStack(spacing: 0) {
                    // Top guide line
                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 2, height: 35)
                    
                    // Word with ORP highlighted
                    if engine.words.isEmpty {
                        Text("Tap to start")
                            .font(.system(size: 20))
                            .foregroundColor(.white.opacity(0.5))
                            .frame(height: 70)
                    } else if let word = engine.currentWord {
                        // Dynamic font size based on word length
                        let wordLength = word.text.count
                        let fontSize: CGFloat = wordLength > 14 ? 24 : (wordLength > 10 ? 30 : (wordLength > 7 ? 36 : 42))
                        // Dynamic width based on font size
                        let sideWidth: CGFloat = wordLength > 10 ? 180 : 150
                        
                        // ORP-centered display with monospace for exact alignment
                        HStack(spacing: 0) {
                            // Before ORP - fixed width, right aligned
                            Text(word.beforeORP)
                                .foregroundColor(.white)
                                .frame(width: sideWidth, alignment: .trailing)
                            
                            // ORP character - red, at exact center
                            Text(word.orpCharacter)
                                .foregroundColor(Color(hex: "FF6B6B"))
                            
                            // After ORP - fixed width, left aligned
                            Text(word.afterORP)
                                .foregroundColor(.white)
                                .frame(width: sideWidth, alignment: .leading)
                        }
                        .font(.system(size: fontSize, weight: .medium, design: .monospaced))
                        .lineLimit(1)
                        .frame(height: 70)
                    }
                    
                    // Bottom guide line
                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 2, height: 35)
                }
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
                                .fill(Color(hex: "FF6B6B"))
                                .frame(width: geo.size.width * engine.progress)
                        }
                    }
                    .frame(height: 6)
                    .padding(.horizontal, 20)
                    
                    // Buttons
                    HStack(spacing: 24) {
                        // Backward buttons
                        HStack(spacing: 16) {
                            skipButton(count: 5, forward: false)
                            skipButton(count: 3, forward: false)
                        }
                        
                        Button(action: { engine.togglePlayback() }) {
                            Image(systemName: engine.isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.white)
                                .frame(width: 64, height: 64)
                                .background(Color.white.opacity(0.15))
                                .clipShape(Circle())
                        }
                        
                        // Forward buttons
                        HStack(spacing: 16) {
                            skipButton(count: 3, forward: true)
                            skipButton(count: 5, forward: true)
                        }
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
            
            // Completion overlay
            if engine.isComplete {
                Color(hex: "1A1A2E")
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 72))
                        .foregroundColor(Color(hex: "4ECDC4"))
                    
                    Text("Complete!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("\(engine.words.count) words at \(engine.wordsPerMinute) WPM")
                        .foregroundColor(.white.opacity(0.6))
                    
                    Button(action: {
                        onComplete?()
                        dismiss()
                    }) {
                        Text("Done")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(Color(hex: "1A1A2E"))
                            .frame(width: 200, height: 50)
                            .background(Color(hex: "FF6B6B"))
                            .cornerRadius(12)
                    }
                    .padding(.top, 20)
                }
            }
        }
        .onAppear {
            engine.wordsPerMinute = initialWPM
            engine.loadText(text)
        }
        .onDisappear {
            engine.pause()
        }
    }
    
    // MARK: - Skip Button
    
    @ViewBuilder
    private func skipButton(count: Int, forward: Bool) -> some View {
        Button(action: {
            if forward {
                engine.skipForward(count)
            } else {
                engine.skipBackward(count)
            }
        }) {
            HStack(spacing: 2) {
                if !forward {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 12, weight: .bold))
                }
                Text("\(count)")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                if forward {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .bold))
                }
            }
            .foregroundColor(.white.opacity(0.8))
            .frame(width: 44, height: 36)
            .background(Color.white.opacity(0.1))
            .cornerRadius(8)
        }
    }
}
