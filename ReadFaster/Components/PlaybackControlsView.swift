import SwiftUI

/// Bottom control bar for the RSVP reader
/// Contains play/pause, progress, and WPM display
struct PlaybackControlsView: View {
    @ObservedObject var engine: RSVPEngine
    var onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                    Capsule()
                        .fill(Color(hex: "FF6B6B"))
                        .frame(width: geometry.size.width * engine.progress)
                }
            }
            .frame(height: 6)
            
            // Controls row
            HStack {
                // Close button
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.6))
                        .frame(width: 44, height: 44)
                }
                
                Spacer()
                
                // Skip backward
                Button(action: { engine.skipBackward() }) {
                    Image(systemName: "gobackward.10")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                }
                
                // Play/Pause button
                Button(action: { engine.togglePlayback() }) {
                    Image(systemName: engine.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Color.white.opacity(0.15))
                        .clipShape(Circle())
                }
                
                // Skip forward
                Button(action: { engine.skipForward() }) {
                    Image(systemName: "goforward.10")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                }
                
                Spacer()
                
                // WPM display
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(engine.wordsPerMinute)")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(Color(hex: "FF6B6B"))
                    Text("wpm")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.5))
                }
                .frame(width: 44)
            }
            
            // Word count and time
            HStack {
                Text("\(engine.currentIndex + 1) / \(engine.words.count)")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(.white.opacity(0.5))
                
                Spacer()
                
                Text(engine.remainingTimeString)
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .padding(16)
        .background(Color(hex: "252542"))
    }
}
