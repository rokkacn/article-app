import SwiftUI

struct UniversalLinkSheetView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "link.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("通过链接打开")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("检测到以下参数：")
                        .font(.headline)
                    
                    ForEach(Array(appState.universalLinkParams.keys), id: \.self) { key in
                        HStack {
                            Text("\(key):")
                                .fontWeight(.medium)
                            Text(appState.universalLinkParams[key] ?? "")
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.vertical, 2)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button("立即查看") {
                        appState.handleUniversalLinkNavigation()
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Button("取消") {
                        appState.showUniversalLinkSheet = false
                        appState.universalLinkParams.removeAll()
                    }
                    .foregroundColor(.secondary)
                }
            }
            .padding()
            .navigationTitle("Universal Link")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("关闭") {
                        appState.showUniversalLinkSheet = false
                        appState.universalLinkParams.removeAll()
                    }
                }
            }
        }
    }
}