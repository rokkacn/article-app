import Foundation

struct Article: Identifiable, Codable {
    let id: String
    let title: String
    let summary: String
    let content: String
    let publishTime: Date
    let author: String
    let imageUrl: String?
    let readCount: Int
    let likeCount: Int
    
    static let mockArticles: [Article] = [
        Article(
            id: "1",
            title: "SwiftUI 深度解析：从入门到精通",
            summary: "本文将深入介绍 SwiftUI 的核心概念和最佳实践，帮助开发者快速掌握现代 iOS 开发技术。",
            content: "SwiftUI 是苹果推出的全新声明式 UI 框架...",
            publishTime: Date().addingTimeInterval(-3600),
            author: "LUOLUO",
            imageUrl: "https://example.com/image1.jpg",
            readCount: 1250,
            likeCount: 89
        ),
        Article(
            id: "2",
            title: "iOS 16 新特性全解析",
            summary: "深入了解 iOS 16 带来的新功能和 API 变化，包括锁屏小组件、动态岛等创新功能。",
            content: "iOS 16 为开发者带来了众多激动人心的新功能...",
            publishTime: Date().addingTimeInterval(-7200),
            author: "LUOLUO",
            imageUrl: "https://example.com/image2.jpg",
            readCount: 2340,
            likeCount: 156
        ),
        Article(
            id: "3",
            title: "微信小程序开发实战指南",
            summary: "从零开始学习微信小程序开发，掌握小程序的核心技术和开发技巧。",
            content: "微信小程序作为轻量级应用平台...",
            publishTime: Date().addingTimeInterval(-10800),
            author: "LUOLUO",
            imageUrl: "https://example.com/image3.jpg",
            readCount: 1890,
            likeCount: 124
        ),
        Article(
            id: "4",
            title: "Flutter vs React Native：跨平台开发对比",
            summary: "全面对比两大主流跨平台开发框架的优劣势，帮助开发者做出明智选择。",
            content: "在移动应用开发领域，跨平台解决方案越来越受到关注...",
            publishTime: Date().addingTimeInterval(-14400),
            author: "LUOLUO",
            imageUrl: "https://example.com/image4.jpg",
            readCount: 3210,
            likeCount: 245
        ),
        Article(
            id: "5",
            title: "AI 时代的移动开发趋势",
            summary: "探讨人工智能技术如何改变移动应用开发，以及开发者应该关注的新趋势。",
            content: "随着人工智能技术的快速发展，移动应用开发正在经历前所未有的变革...",
            publishTime: Date().addingTimeInterval(-18000),
            author: "LUOLUO",
            imageUrl: "https://example.com/image5.jpg",
            readCount: 2750,
            likeCount: 198
        )
    ]
}