import Foundation
import SwiftUI

class AppState: ObservableObject {
    @Published var isLoggedIn = false
    @Published var userInfo: UserInfo?
    @Published var selectedTab = 0
    @Published var showUniversalLinkSheet = false
    @Published var showClipboardSheet = false
    @Published var universalLinkParams: [String: String] = [:]
    @Published var clipboardContent = ""
    @Published var pendingArticleId: String?
    
    // Navigation state
    @Published var showLoginPage = false
    @Published var showArticleDetail = false
    @Published var currentArticleId: String?
    
    init() {
        checkLoginStatus()
    }
    
    private func checkLoginStatus() {
        // Check if user is logged in (from UserDefaults or Keychain)
        if let userInfoData = UserDefaults.standard.data(forKey: "userInfo"),
           let userInfo = try? JSONDecoder().decode(UserInfo.self, from: userInfoData) {
            self.userInfo = userInfo
            self.isLoggedIn = true
        }
    }
    
    func login(with userInfo: UserInfo) {
        self.userInfo = userInfo
        self.isLoggedIn = true
        
        // Save to UserDefaults
        if let encoded = try? JSONEncoder().encode(userInfo) {
            UserDefaults.standard.set(encoded, forKey: "userInfo")
        }
        
        // Handle pending article navigation
        if let articleId = pendingArticleId {
            navigateToArticle(articleId)
            pendingArticleId = nil
        }
    }
    
    func logout() {
        self.userInfo = nil
        self.isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: "userInfo")
    }
    
    func navigateToArticle(_ articleId: String) {
        if isLoggedIn {
            currentArticleId = articleId
            showArticleDetail = true
        } else {
            pendingArticleId = articleId
            showLoginPage = true
        }
    }
    
    func showUniversalLinkSheet(with params: [String: String]) {
        universalLinkParams = params
        showUniversalLinkSheet = true
    }
    
    func showClipboardSheet(with content: String) {
        clipboardContent = content
        showClipboardSheet = true
        
        // Clear clipboard after showing
        UIPasteboard.general.string = ""
    }
    
    func handleUniversalLinkNavigation() {
        if let articleId = universalLinkParams["articleId"] {
            showUniversalLinkSheet = false
            universalLinkParams.removeAll()
            navigateToArticle(articleId)
        }
    }
    
    func handleClipboardNavigation() {
        showClipboardSheet = false
        // Extract article ID from clipboard content if needed
        // For now, we'll use a mock article ID
        navigateToArticle("clipboard-article")
        clipboardContent = ""
    }
}

struct UserInfo: Codable {
    let id: String
    let nickname: String
    let avatar: String
}