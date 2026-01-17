import SwiftUI
import UniformTypeIdentifiers

/// Free reading mode where users can input their own text
struct FreeReadingView: View {
    @State private var inputText: String = ""
    @State private var wpm: Double = 300
    @State private var showReader = false
    @State private var showDocumentPicker = false
    @State private var isLoading = false
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: Theme.paddingSmall) {
                    Text(NSLocalizedString("freereading.title", comment: ""))
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                    
                    Text(NSLocalizedString("freereading.subtitle", comment: ""))
                        .font(Theme.bodyFont)
                        .foregroundColor(Theme.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(Theme.paddingMedium)
                
                // Text input area
                VStack(alignment: .leading, spacing: Theme.paddingSmall) {
                // Button row - Paste and Upload
                    HStack(spacing: 12) {
                        Spacer()
                        
                        // Paste button
                        Button(action: {
                            if let clipboardText = UIPasteboard.general.string {
                                inputText = clipboardText
                            }
                        }) {
                            Text(NSLocalizedString("freereading.paste", comment: ""))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Theme.accent)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Theme.accent, lineWidth: 2)
                                )
                        }
                        
                        // Upload button
                        Button(action: {
                            showDocumentPicker = true
                        }) {
                            Text(NSLocalizedString("freereading.upload", comment: ""))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Theme.accent)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Theme.accent, lineWidth: 2)
                                )
                        }
                    }
                    
                    ZStack(alignment: .topLeading) {
                        if inputText.isEmpty && !isLoading {
                            Text(NSLocalizedString("freereading.placeholder", comment: ""))
                                .font(Theme.bodyFont)
                                .foregroundColor(Theme.textSecondary.opacity(0.6))
                                .padding(.horizontal, 4)
                                .padding(.vertical, 8)
                        }
                        
                        if isLoading {
                            VStack {
                                ProgressView()
                                    .tint(Theme.accent)
                                Text(NSLocalizedString("freereading.loading", comment: ""))
                                    .font(Theme.bodyFont)
                                    .foregroundColor(Theme.textSecondary)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            TextEditor(text: $inputText)
                                .font(Theme.bodyFont)
                                .foregroundColor(Theme.textPrimary)
                                .scrollContentBackground(.hidden)
                                .focused($isTextFieldFocused)
                        }
                    }
                    .padding(Theme.paddingMedium)
                    .background(Theme.surface)
                    .cornerRadius(Theme.cornerRadiusMedium)
                    
                    // Word count
                    if !inputText.isEmpty {
                        let wordCount = inputText.components(separatedBy: .whitespacesAndNewlines)
                            .filter { !$0.isEmpty }.count
                        Text(String(format: NSLocalizedString("freereading.words", comment: ""), wordCount))
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                .padding(.horizontal, Theme.paddingMedium)
                .frame(maxHeight: .infinity)
                
                // WPM Slider
                VStack(spacing: Theme.paddingSmall) {
                    HStack {
                        Text(NSLocalizedString("freereading.speed", comment: ""))
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
                        Text(NSLocalizedString("freereading.start", comment: ""))
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
                Button(NSLocalizedString("freereading.done", comment: "")) {
                    isTextFieldFocused = false
                }
            }
        }
        .sheet(isPresented: $showReader) {
            RSVPReaderView(
                text: inputText,
                initialWPM: Int(wpm),
                title: NSLocalizedString("freereading.title", comment: "")
            )
        }
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPicker { url in
                loadDocument(from: url)
            }
        }
    }
    
    private func loadDocument(from url: URL) {
        isLoading = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let text = DocumentHelper.extractText(from: url)
            
            DispatchQueue.main.async {
                isLoading = false
                if let text = text, !text.isEmpty {
                    inputText = text
                }
            }
        }
    }
}

/// Document picker for PDF and DOCX files
struct DocumentPicker: UIViewControllerRepresentable {
    let onPick: (URL) -> Void
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let types: [UTType] = [.pdf, UTType(filenameExtension: "docx")!]
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: types)
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onPick: onPick)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let onPick: (URL) -> Void
        
        init(onPick: @escaping (URL) -> Void) {
            self.onPick = onPick
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            onPick(url)
        }
    }
}

#Preview {
    NavigationStack {
        FreeReadingView()
    }
}
