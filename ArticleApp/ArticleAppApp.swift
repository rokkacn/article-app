import SwiftUI

@main
struct ArticleAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .onOpenURL { url in
                    handleURL(url)
                }
                .onAppear {
                    checkClipboard()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    checkClipboard()
                }
        }
    }
    
    private func handleURL(_ url: URL) {
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            if let articleId = components.queryItems?.first(where: { $0.name == "articleId" })?.value {
                appState.showUniversalLinkSheet(with: ["articleId": articleId])
            }
        }
    }
    
    private func checkClipboard() {
        let pasteboard = UIPasteboard.general
        if let clipboardText = pasteboard.string {
            if clipboardText.contains("【LUOLUO】") {
                // Extract content between ##...##
                let pattern = "##(.+?)##"
                if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
                    let range = NSRange(location: 0, length: clipboardText.utf16.count)
                    if let match = regex.firstMatch(in: clipboardText, options: [], range: range) {
                        let extractedRange = Range(match.range(at: 1), in: clipboardText)
                        if let extractedRange = extractedRange {
                            let content = String(clipboardText[extractedRange])
                            appState.showClipboardSheet(with: content)
                        }
                    }
                }
            }
        }
    }
}