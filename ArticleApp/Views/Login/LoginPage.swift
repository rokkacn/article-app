import SwiftUI

struct LoginPage: View {
    @EnvironmentObject var appState: AppState
    @State private var isLoggingIn = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                // WeChat Logo
                Image(systemName: "message.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                
                VStack(spacing: 16) {
                    Text("微信授权登录")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Text("使用您的微信账号快速登录\n享受个性化文章推荐服务")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    Button(action: {
                        performWeChatLogin()
                    }) {
                        HStack {
                            if isLoggingIn {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .tint(.white)
                            } else {
                                Image(systemName: "message.fill")
                            }
                            
                            Text(isLoggingIn ? "登录中..." : "微信登录")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(isLoggingIn)
                    
                    Button("取消") {
                        appState.showLoginPage = false
                    }
                    .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationTitle("登录")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("关闭") {
                        appState.showLoginPage = false
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func performWeChatLogin() {
        isLoggingIn = true
        
        WeChatBridge.shared.login { result in
            DispatchQueue.main.async {
                isLoggingIn = false
                
                switch result {
                case .success(let userInfo):
                    appState.login(with: userInfo)
                    appState.showLoginPage = false
                    
                case .failure(let error):
                    print("WeChat login failed: \(error)")
                    // Show error alert in a real app
                    
                    // For demo purposes, simulate successful login
                    let mockUser = UserInfo(
                        id: "mock_user_\(Date().timeIntervalSince1970)",
                        nickname: "微信用户",
                        avatar: "https://example.com/avatar.jpg"
                    )
                    appState.login(with: mockUser)
                    appState.showLoginPage = false
                }
            }
        }
    }
}