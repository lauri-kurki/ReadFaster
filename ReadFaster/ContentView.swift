import SwiftUI

/// Root content view with navigation
struct ContentView: View {
    var body: some View {
        NavigationStack {
            HomeView()
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
