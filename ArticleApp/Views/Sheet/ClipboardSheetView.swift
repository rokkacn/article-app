import SwiftUI

struct ClipboardSheetView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "doc.on.clipboard.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)
                
                Text("检测到剪贴板内容")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("发现【LUOLUO】内容：")
                        .font(.headline)
                    
                    ScrollView {
                        Text(appState.clipboardContent)
                            .font(.body)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .frame(maxHeight: 200)
                }
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button("立即查看") {
                        appState.handleClipboardNavigation()
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Button("忽略") {
                        appState.showClipboardSheet = false
                        appState.clipboardContent = ""
                    }
                    .foregroundColor(.secondary)
                }
            }
            .padding()
            .navigationTitle("剪贴板检测")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("关闭") {
                        appState.showClipboardSheet = false
                        appState.clipboardContent = ""
                    }
                }
            }
        }
    }
}