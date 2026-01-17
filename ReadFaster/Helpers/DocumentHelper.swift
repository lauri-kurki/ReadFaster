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
        case "epub":
            return extractTextFromEPUB(url: url)
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
    
    // MARK: - EPUB Extraction
    
    private static func extractTextFromEPUB(url: URL) -> String? {
        // EPUB files are ZIP archives containing XHTML
        guard let archive = Archive(url: url, accessMode: .read) else { return nil }
        
        var text = ""
        
        // Find all HTML/XHTML files in the archive
        var htmlFiles: [String] = []
        for entry in archive {
            let path = entry.path
            if path.hasSuffix(".html") || path.hasSuffix(".xhtml") || path.hasSuffix(".htm") {
                htmlFiles.append(path)
            }
        }
        
        // Sort to get chapters in order
        htmlFiles.sort()
        
        // Extract text from each HTML file
        for htmlPath in htmlFiles {
            guard let entry = archive[htmlPath] else { continue }
            
            var htmlData = Data()
            do {
                _ = try archive.extract(entry) { data in
                    htmlData.append(data)
                }
            } catch {
                continue
            }
            
            if let htmlString = String(data: htmlData, encoding: .utf8) {
                let extractedText = parseHTMLForText(htmlString)
                if !extractedText.isEmpty {
                    text += extractedText + "\n\n"
                }
            }
        }
        
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private static func parseHTMLForText(_ html: String) -> String {
        var text = ""
        
        // Remove script and style content
        var cleanedHTML = html
        
        // Remove scripts
        while let range = cleanedHTML.range(of: "<script[^>]*>.*?</script>", options: [.regularExpression, .caseInsensitive]) {
            cleanedHTML.removeSubrange(range)
        }
        
        // Remove styles
        while let range = cleanedHTML.range(of: "<style[^>]*>.*?</style>", options: [.regularExpression, .caseInsensitive]) {
            cleanedHTML.removeSubrange(range)
        }
        
        // Simple tag removal - extract text between tags
        var inTag = false
        var addSpace = false
        
        for char in cleanedHTML {
            if char == "<" {
                inTag = true
                addSpace = true
            } else if char == ">" {
                inTag = false
            } else if !inTag {
                if addSpace && !text.isEmpty && !text.hasSuffix(" ") && !text.hasSuffix("\n") {
                    text += " "
                    addSpace = false
                }
                text.append(char)
            }
        }
        
        // Clean up whitespace
        text = text.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        text = text.replacingOccurrences(of: " \n", with: "\n")
        text = text.replacingOccurrences(of: "\n ", with: "\n")
        
        // Decode common HTML entities
        text = text.replacingOccurrences(of: "&nbsp;", with: " ")
        text = text.replacingOccurrences(of: "&amp;", with: "&")
        text = text.replacingOccurrences(of: "&lt;", with: "<")
        text = text.replacingOccurrences(of: "&gt;", with: ">")
        text = text.replacingOccurrences(of: "&quot;", with: "\"")
        text = text.replacingOccurrences(of: "&#39;", with: "'")
        text = text.replacingOccurrences(of: "&apos;", with: "'")
        
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

