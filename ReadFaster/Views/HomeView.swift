import SwiftUI

/// Main home screen with mode selection
struct HomeView: View {
    @State private var showSettings = false
    
    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()
            
            VStack(spacing: Theme.paddingXLarge) {
                // Settings button
                HStack {
                    Spacer()
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Theme.textSecondary)
                            .frame(width: 40, height: 40)
                            .background(Theme.surface)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, Theme.paddingMedium)
                .padding(.top, Theme.paddingSmall)
                
                Spacer()
                
                // Logo and title
                VStack(spacing: Theme.paddingMedium) {
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    Text(NSLocalizedString("app.name", comment: ""))
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                    
                    Text(NSLocalizedString("app.tagline", comment: ""))
                        .font(Theme.bodyFont)
                        .foregroundColor(Theme.textSecondary)
                }
                
                Spacer()
                
                // Mode selection cards
                VStack(spacing: Theme.paddingMedium) {
                    NavigationLink(destination: SpeedTestView()) {
                        ModeCard(
                            icon: "stopwatch.fill",
                            title: NSLocalizedString("mode.speedtest", comment: ""),
                            description: NSLocalizedString("mode.speedtest.description", comment: ""),
                            color: .purple
                        )
                    }
                    
                    NavigationLink(destination: TrainingModeView()) {
                        ModeCard(
                            icon: "graduationcap.fill",
                            title: NSLocalizedString("mode.training", comment: ""),
                            description: NSLocalizedString("mode.training.description", comment: ""),
                            color: Theme.accent
                        )
                    }
                    
                    NavigationLink(destination: FreeReadingView()) {
                        ModeCard(
                            icon: "doc.text.fill",
                            title: NSLocalizedString("mode.freereading", comment: ""),
                            description: NSLocalizedString("mode.freereading.description", comment: ""),
                            color: Theme.success
                        )
                    }
                }
                .padding(.horizontal, Theme.paddingMedium)
                
                Spacer()
                    .frame(height: Theme.paddingXLarge)
            }
        }
    }
}

/// Card for mode selection
struct ModeCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: Theme.paddingMedium) {
            // Icon
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 56, height: 56)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
            }
            
            // Text
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            // Arrow
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Theme.textSecondary)
        }
        .padding(Theme.paddingMedium)
        .background(Theme.surface)
        .cornerRadius(Theme.cornerRadiusLarge)
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
