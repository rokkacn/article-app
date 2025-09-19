import SwiftUI

struct ArticleDetailPage: View {
    @EnvironmentObject var appState: AppState
    @State private var article: Article?
    @State private var isLoading = true
    
    var body: some View {
        NavigationView {
            ZStack {
                if isLoading {
                    ProgressView("加载中...")
                } else if let article = article {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            // Article Header
                            VStack(alignment: .leading, spacing: 12) {
                                Text(article.title)
                                    .font(.title)
                                    .fontWeight(.bold)
                                
                                HStack {
                                    Text(article.author)
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                    
                                    Spacer()
                                    
                                    Text(article.publishTime, style: .date)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                HStack {
                                    Label("\(article.readCount)", systemImage: "eye")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Label("\(article.likeCount)", systemImage: "heart")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            // Article Image
                            if let imageUrl = article.imageUrl {
                                AsyncImage(url: URL(string: imageUrl)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(height: 200)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            
                            // Article Content
                            VStack(alignment: .leading, spacing: 16) {
                                Text("摘要")
                                    .font(.headline)
                                
                                Text(article.summary)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                
                                Divider()
                                
                                Text("正文")
                                    .font(.headline)
                                
                                Text(article.content)
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .padding()
                    }
                } else {
                    Text("文章加载失败")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("文章详情")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("返回") {
                        appState.showArticleDetail = false
                        appState.currentArticleId = nil
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Share article
                    }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            await loadArticle()
        }
    }
    
    private func loadArticle() async {
        guard let articleId = appState.currentArticleId else {
            isLoading = false
            return
        }
        
        article = await ArticleApi.shared.getArticle(by: articleId)
        isLoading = false
    }
}