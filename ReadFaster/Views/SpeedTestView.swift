import SwiftUI

/// Speed Test level selection view
struct SpeedTestView: View {
    @StateObject private var data = SpeedTestData.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Theme.textSecondary)
                            .frame(width: 40, height: 40)
                            .background(Theme.surface)
                            .clipShape(Circle())
                    }
                    
                    Text(NSLocalizedString("speedtest.title", comment: ""))
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, Theme.paddingMedium)
                .padding(.top, Theme.paddingSmall)
                
                Text(NSLocalizedString("speedtest.subtitle", comment: ""))
                    .font(Theme.bodyFont)
                    .foregroundColor(Theme.textSecondary)
                    .padding(.horizontal, Theme.paddingMedium)
                    .padding(.top, 4)
                    .padding(.bottom, Theme.paddingLarge)
                
                // Level list
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(data.levels) { level in
                            SpeedTestLevelCard(
                                level: level,
                                isUnlocked: data.isUnlocked(level),
                                isCompleted: data.completedLevels.contains(level.id)
                            )
                        }
                    }
                    .padding(.horizontal, Theme.paddingMedium)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Reload levels when language might have changed
            data.loadLevels()
        }
    }
}

struct SpeedTestLevelCard: View {
    let level: SpeedTestLevel
    let isUnlocked: Bool
    let isCompleted: Bool
    
    var body: some View {
        NavigationLink(destination: SpeedTestReaderView(level: level)) {
            HStack(spacing: 16) {
                // Level number
                ZStack {
                    Circle()
                        .fill(isCompleted ? Theme.success.opacity(0.2) : (isUnlocked ? Theme.accent.opacity(0.15) : Theme.surface))
                        .frame(width: 50, height: 50)
                    
                    if isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Theme.success)
                    } else if isUnlocked {
                        Text("\(level.level)")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(Theme.accent)
                    } else {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 18))
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(level.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(isUnlocked ? Theme.textPrimary : Theme.textSecondary)
                    
                    HStack(spacing: 12) {
                        Label("\(level.wpm) WPM", systemImage: "bolt.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.yellow)
                        
                        Label(NSLocalizedString("speedtest.questions", comment: ""), systemImage: "questionmark.circle")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                
                Spacer()
                
                if isUnlocked {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Theme.textSecondary)
                }
            }
            .padding(16)
            .background(Theme.surface)
            .cornerRadius(Theme.cornerRadiusLarge)
            .opacity(isUnlocked ? 1 : 0.6)
        }
        .disabled(!isUnlocked)
    }
}

#Preview {
    NavigationStack {
        SpeedTestView()
    }
}
