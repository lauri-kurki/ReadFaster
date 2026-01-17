import Foundation
import PDFKit
import UniformTypeIdentifiers
import ZIPFoundation

/// Helper for extracting text from PDF and DOCX files
struct DocumentHelper {
    
    /// Extracts text from a PDF or DOCX file
    /// - Parameter url: URL of the document
    /// - Returns: Extracted text or nil if failed
    static func extractText(from url: URL) -> String? {
        let fileExtension = url.pathExtension.lowercased()
        
        // Start accessing security-scoped resource
        let didStartAccessing = url.startAccessingSecurityScopedResource()
        defer {
            if didStartAccessing {
                url.stopAccessingSecurityScopedResource()
            }
        }
        
        switch fileExtension {
        case "pdf":
            return extractTextFromPDF(url: url)
        case "docx":
            return extractTextFromDOCX(url: url)
        default:
            // Try to read as plain text
            return try? String(contentsOf: url, encoding: .utf8)
        }
    }
    
    // MARK: - PDF Extraction
    
    private static func extractTextFromPDF(url: URL) -> String? {
        guard let document = PDFDocument(url: url) else { return nil }
        
        var text = ""
        for i in 0..<document.pageCount {
            if let page = document.page(at: i),
               let pageText = page.string {
                text += pageText + "\n\n"
            }
        }
        
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // MARK: - DOCX Extraction
    
    private static func extractTextFromDOCX(url: URL) -> String? {
        // DOCX files are ZIP archives containing XML
        guard let archive = Archive(url: url, accessMode: .read) else { return nil }
        
        // Find the document.xml file which contains the main content
        guard let documentEntry = archive["word/document.xml"] else { return nil }
        
        var xmlData = Data()
        do {
            _ = try archive.extract(documentEntry) { data in
                xmlData.append(data)
            }
        } catch {
            return nil
        }
        
        // Parse the XML to extract text
        return parseDocxXML(data: xmlData)
    }
    
    private static func parseDocxXML(data: Data) -> String? {
        guard let xmlString = String(data: data, encoding: .utf8) else { return nil }
        
        var text = ""
        var inText = false
        var currentText = ""
        
        // Simple XML parsing for <w:t> elements
        let scanner = Scanner(string: xmlString)
        scanner.charactersToBeSkipped = nil
        
        while !scanner.isAtEnd {
            if scanner.scanString("<w:t") != nil {
                // Skip attributes until >
                _ = scanner.scanUpToString(">")
                _ = scanner.scanString(">")
                inText = true
                currentText = ""
            } else if scanner.scanString("</w:t>") != nil {
                text += currentText
                inText = false
            } else if scanner.scanString("<w:p") != nil {
                // Paragraph start - if we have content, add newline
                if !text.isEmpty && !text.hasSuffix("\n\n") {
                    text += "\n\n"
                }
                _ = scanner.scanUpToString(">")
                _ = scanner.scanString(">")
            } else if inText {
                if let char = scanner.scanCharacter() {
                    currentText.append(char)
                }
            } else {
                // Skip other content
                _ = scanner.scanCharacter()
            }
        }
        
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
