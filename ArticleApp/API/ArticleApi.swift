import Foundation
import Combine

class ArticleApi: ObservableObject {
    static let shared = ArticleApi()
    
    @Published var isLoading = false
    @Published var articles: [Article] = []
    @Published var todayArticles: [Article] = []
    
    private var currentPage = 1
    private var todayPage = 1
    private let pageSize = 10
    
    private init() {}
    
    // MARK: - Home Articles
    func loadArticles(refresh: Bool = false) async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        if refresh {
            currentPage = 1
        }
        
        // Simulate API delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        let newArticles = generateMockArticles(page: currentPage, isToday: false)
        
        DispatchQueue.main.async {
            if refresh {
                self.articles = newArticles
            } else {
                self.articles.append(contentsOf: newArticles)
            }
            self.currentPage += 1
            self.isLoading = false
        }
    }
    
    // MARK: - Today Articles
    func loadTodayArticles(refresh: Bool = false) async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        if refresh {
            todayPage = 1
        }
        
        // Simulate API delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        let newArticles = generateMockArticles(page: todayPage, isToday: true)
        
        DispatchQueue.main.async {
            if refresh {
                self.todayArticles = newArticles
            } else {
                self.todayArticles.append(contentsOf: newArticles)
            }
            self.todayPage += 1
            self.isLoading = false
        }
    }
    
    // MARK: - Article Detail
    func getArticle(by id: String) async -> Article? {
        // Simulate API delay
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // First check in existing articles
        if let article = articles.first(where: { $0.id == id }) {
            return article
        }
        
        if let article = todayArticles.first(where: { $0.id == id }) {
            return article
        }
        
        // Return a mock article if not found
        return Article(
            id: id,
            title: "文章详情",
            summary: "这是一篇通过链接打开的文章",
            content: "文章内容正在加载中...",
            publishTime: Date(),
            author: "LUOLUO",
            imageUrl: nil,
            readCount: 0,
            likeCount: 0
        )
    }
    
    // MARK: - Mock Data Generation
    private func generateMockArticles(page: Int, isToday: Bool) -> [Article] {
        let baseArticles = Article.mockArticles
        let start = (page - 1) * pageSize
        
        return (0..<pageSize).compactMap { index in
            let articleIndex = (start + index) % baseArticles.count
            let baseArticle = baseArticles[articleIndex]
            
            let timeOffset = isToday ? -Double(index * 300) : -Double((start + index) * 3600)
            
            return Article(
                id: "\(isToday ? "today" : "home")-\(page)-\(index)",
                title: baseArticle.title + (isToday ? " (今日)" : ""),
                summary: baseArticle.summary,
                content: baseArticle.content,
                publishTime: Date().addingTimeInterval(timeOffset),
                author: baseArticle.author,
                imageUrl: baseArticle.imageUrl,
                readCount: baseArticle.readCount + Int.random(in: 0...500),
                likeCount: baseArticle.likeCount + Int.random(in: 0...50)
            )
        }
    }
}