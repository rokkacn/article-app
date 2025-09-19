import SwiftUI

struct ArticleListPage: View {
    let isToday: Bool
    @EnvironmentObject var appState: AppState
    @StateObject private var api = ArticleApi.shared
    @State private var isRefreshing = false
    
    private var articles: [Article] {
        isToday ? api.todayArticles : api.articles
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(articles) { article in
                    ArticleRowView(article: article) {
                        appState.navigateToArticle(article.id)
                    }
                    .onAppear {
                        if article.id == articles.last?.id {
                            loadMoreArticles()
                        }
                    }
                }
                
                if api.isLoading && !articles.isEmpty {
                    HStack {
                        Spacer()
                        ProgressView()
                            .padding()
                        Spacer()
                    }
                }
            }
            .navigationTitle(isToday ? "今日文章" : "首页")
            .refreshable {
                await refreshArticles()
            }
            .task {
                if articles.isEmpty {
                    await loadInitialArticles()
                }
            }
        }
    }
    
    private func loadInitialArticles() async {
        if isToday {
            await api.loadTodayArticles(refresh: true)
        } else {
            await api.loadArticles(refresh: true)
        }
    }
    
    private func refreshArticles() async {
        if isToday {
            await api.loadTodayArticles(refresh: true)
        } else {
            await api.loadArticles(refresh: true)
        }
    }
    
    private func loadMoreArticles() {
        guard !api.isLoading else { return }
        
        Task {
            if isToday {
                await api.loadTodayArticles(refresh: false)
            } else {
                await api.loadArticles(refresh: false)
            }
        }
    }
}

struct ArticleRowView: View {
    let article: Article
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(article.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(article.summary)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                    
                    HStack {
                        Text(article.author)
                            .font(.caption)
                            .foregroundColor(.blue)
                        
                        Spacer()
                        
                        Text(article.publishTime, style: .relative)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("👁 \(article.readCount)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("❤️ \(article.likeCount)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                if let imageUrl = article.imageUrl {
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}