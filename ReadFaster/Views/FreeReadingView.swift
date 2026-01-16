import SwiftUI

/// Free reading mode where users can input their own text
struct FreeReadingView: View {
    @State private var inputText: String = ""
    @State private var wpm: Double = 300
    @State private var showReader = false
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: Theme.paddingSmall) {
                    Text("Free Reading")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                    
                    Text("Paste or type any text to speed read")
                        .font(Theme.bodyFont)
                        .foregroundColor(Theme.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(Theme.paddingMedium)
                
                // Text input area
                VStack(alignment: .leading, spacing: Theme.paddingSmall) {
                    // Paste button row
                    HStack {
                        Spacer()
                        Button(action: {
                            if let clipboardText = UIPasteboard.general.string {
                                inputText = clipboardText
                            }
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "doc.on.clipboard")
                                Text("Paste")
                            }
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Theme.accent)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Theme.accent.opacity(0.15))
                            .cornerRadius(8)
                        }
                    }
                    
                    ZStack(alignment: .topLeading) {
                        if inputText.isEmpty {
                            Text("Paste your text here...")
                                .font(Theme.bodyFont)
                                .foregroundColor(Theme.textSecondary.opacity(0.6))
                                .padding(.horizontal, 4)
                                .padding(.vertical, 8)
                        }
                        
                        TextEditor(text: $inputText)
                            .font(Theme.bodyFont)
                            .foregroundColor(Theme.textPrimary)
                            .scrollContentBackground(.hidden)
                            .focused($isTextFieldFocused)
                    }
                    .padding(Theme.paddingMedium)
                    .background(Theme.surface)
                    .cornerRadius(Theme.cornerRadiusMedium)
                    
                    // Word count
                    if !inputText.isEmpty {
                        let wordCount = inputText.components(separatedBy: .whitespacesAndNewlines)
                            .filter { !$0.isEmpty }.count
                        Text("\(wordCount) words")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                .padding(.horizontal, Theme.paddingMedium)
                .frame(maxHeight: .infinity)
                
                // WPM Slider
                VStack(spacing: Theme.paddingSmall) {
                    HStack {
                        Text("Speed")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Theme.textSecondary)
                        
                        Spacer()
                        
                        Text("\(Int(wpm)) WPM")
                            .font(.system(size: 17, weight: .bold, design: .monospaced))
                            .foregroundColor(Theme.accent)
                    }
                    
                    Slider(value: $wpm, in: 100...800, step: 25)
                        .tint(Theme.accent)
                    
                    HStack {
                        Text("100")
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textSecondary)
                        Spacer()
                        Text("800")
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                .padding(Theme.paddingMedium)
                .background(Theme.surface)
                
                // Start button
                Button(action: {
                    if !inputText.isEmpty {
                        isTextFieldFocused = false
                        showReader = true
                    }
                }) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("Start Reading")
                    }
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(inputText.isEmpty ? Theme.textSecondary : Theme.background)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Theme.paddingMedium)
                    .background(inputText.isEmpty ? Theme.surface : Theme.accent)
                    .cornerRadius(Theme.cornerRadiusMedium)
                }
                .disabled(inputText.isEmpty)
                .padding(Theme.paddingMedium)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isTextFieldFocused = false
                }
            }
        }
        .sheet(isPresented: $showReader) {
            RSVPReaderView(
                text: inputText,
                initialWPM: Int(wpm),
                title: "Free Reading"
            )
        }
    }
}

#Preview {
    NavigationStack {
        FreeReadingView()
    }
}
