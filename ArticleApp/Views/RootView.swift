import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Main Tab View (only shown for main tabs)
                if !appState.showLoginPage && !appState.showArticleDetail {
                    TabView(selection: $appState.selectedTab) {
                        ArticleListPage(isToday: false)
                            .tabItem {
                                Image(systemName: "house")
                                Text("首页")
                            }
                            .tag(0)
                        
                        ArticleListPage(isToday: true)
                            .tabItem {
                                Image(systemName: "calendar")
                                Text("今日文章")
                            }
                            .tag(1)
                        
                        MinePage()
                            .tabItem {
                                Image(systemName: "person")
                                Text("我的")
                            }
                            .tag(2)
                    }
                    .accentColor(.blue)
                }
                
                // Login Page (no TabBar)
                if appState.showLoginPage {
                    LoginPage()
                        .transition(.move(edge: .trailing))
                }
                
                // Article Detail Page (no TabBar)
                if appState.showArticleDetail {
                    ArticleDetailPage()
                        .transition(.move(edge: .trailing))
                }
            }
            .animation(.easeInOut(duration: 0.3), value: appState.showLoginPage)
            .animation(.easeInOut(duration: 0.3), value: appState.showArticleDetail)
        }
        .sheet(isPresented: $appState.showUniversalLinkSheet) {
            UniversalLinkSheetView()
        }
        .sheet(isPresented: $appState.showClipboardSheet) {
            ClipboardSheetView()
        }
    }
}