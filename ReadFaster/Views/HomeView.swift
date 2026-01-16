import SwiftUI

/// Main home screen with mode selection
struct HomeView: View {
    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()
            
            VStack(spacing: Theme.paddingXLarge) {
                Spacer()
                
                // Logo and title
                VStack(spacing: Theme.paddingMedium) {
                    // App icon
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Theme.accent.opacity(0.15))
                            .frame(width: 80, height: 80)
                        
                        Text("R")
                            .font(.system(size: 40, weight: .bold, design: .monospaced))
                            .foregroundColor(Theme.accent)
                    }
                    
                    Text("ReadFaster")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                    
                    Text("Train your speed reading skills")
                        .font(Theme.bodyFont)
                        .foregroundColor(Theme.textSecondary)
                }
                
                Spacer()
                
                // Mode selection cards
                VStack(spacing: Theme.paddingMedium) {
                    NavigationLink(destination: TrainingModeView()) {
                        ModeCard(
                            icon: "graduationcap.fill",
                            title: "Training Mode",
                            description: "Progressive lessons to build your speed",
                            color: Theme.accent
                        )
                    }
                    
                    NavigationLink(destination: FreeReadingView()) {
                        ModeCard(
                            icon: "doc.text.fill",
                            title: "Free Reading",
                            description: "Read any text at your chosen speed",
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
