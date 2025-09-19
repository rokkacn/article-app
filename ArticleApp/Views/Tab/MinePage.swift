import SwiftUI

struct MinePage: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if appState.isLoggedIn, let userInfo = appState.userInfo {
                    // Logged in state
                    UserCardView(userInfo: userInfo)
                    
                    Spacer()
                    
                    Button("退出登录") {
                        appState.logout()
                    }
                    .foregroundColor(.red)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                    
                } else {
                    // Not logged in state
                    VStack(spacing: 20) {
                        Image(systemName: "person.circle")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                        
                        Text("未登录")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        
                        Button("微信授权登录") {
                            appState.showLoginPage = true
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
            }
            .padding()
            .navigationTitle("我的")
        }
    }
}

struct UserCardView: View {
    let userInfo: UserInfo
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: userInfo.avatar)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.white)
                    )
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 8) {
                Text(userInfo.nickname)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("ID: \(userInfo.id)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("已登录")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
}