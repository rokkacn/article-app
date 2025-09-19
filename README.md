# ArticleApp - SwiftUI 微信公众号文章App完整模板

这是一个完整的 SwiftUI 微信公众号文章App模板实现，包含了微信登录、Universal Link、剪贴板检测等功能。

## 功能特性

✅ **仅主要页面有 TabBar**：只有"首页"、"今日文章"、"我的"页面显示底部 TabBar，其他页面（如登录页、详情页、弹窗等）均无 TabBar

✅ **下拉刷新和上拉加载**：首页和今日文章页支持下拉刷新和上拉加载更多功能

✅ **登录流程控制**：点击文章列表项时，若未登录则跳转微信授权登录页，登录成功自动跳详情页，返回不会回到登录页

✅ **我的页面状态管理**：未登录显示"微信授权登录"按钮，登录后显示头像和昵称卡片

✅ **Universal Link 支持**：支持 Universal Link 唤起 App，弹窗显示参数及"立即查看"按钮，跳详情页并清理参数

✅ **剪贴板内容检测**：检查剪贴板内容，存在"【LUOLUO】"并有##...##结构时弹窗显示内容，支持跳详情页，及时清理参数

✅ **微信SDK集成**：完整集成微信OpenSDK，桥接登录、Universal Link、URL Scheme 参数获取

## 项目结构

```
ArticleApp/
├── ArticleApp.xcodeproj/         # Xcode 项目文件
├── ArticleApp/                   # 主要源码目录
│   ├── ArticleAppApp.swift      # App 入口文件
│   ├── AppDelegate.swift        # AppDelegate 处理 URL 和生命周期
│   ├── AppState.swift           # 全局状态管理
│   ├── Models/                  # 数据模型
│   │   └── Article.swift        
│   ├── API/                     # API 接口
│   │   └── ArticleApi.swift     
│   ├── Views/                   # 视图文件
│   │   ├── RootView.swift       # 根视图，控制 TabBar 显示
│   │   ├── Tab/                 # TabBar 页面
│   │   │   ├── ArticleListPage.swift   # 文章列表页
│   │   │   └── MinePage.swift          # 我的页面
│   │   ├── Detail/              # 详情页面
│   │   │   └── ArticleDetailPage.swift
│   │   ├── Login/               # 登录页面
│   │   │   └── LoginPage.swift
│   │   └── Sheet/               # 弹窗视图
│   │       ├── UniversalLinkSheetView.swift
│   │       └── ClipboardSheetView.swift
│   ├── Bridge/                  # 第三方SDK桥接
│   │   └── WeChatBridge.swift   
│   ├── Utils/                   # 工具类
│   │   └── ScrollToBottom.swift 
│   ├── Assets.xcassets          # 资源文件
│   └── Info.plist              # 应用配置
├── Podfile                      # CocoaPods 依赖
└── README.md                    # 项目说明
```

## 配置指南

### 1. 微信SDK配置

#### 1.1 注册微信开放平台账号
1. 访问 [微信开放平台](https://open.weixin.qq.com/)
2. 注册开发者账号并创建移动应用
3. 获取 AppID 和 AppSecret

#### 1.2 修改配置文件

**文件：`ArticleApp/Bridge/WeChatBridge.swift`**
```swift
// 第 10-11 行：替换为你的微信应用信息
private let appId = "YOUR_WECHAT_APP_ID"        // 替换为你的微信 AppID
private let appSecret = "YOUR_WECHAT_APP_SECRET" // 替换为你的微信 AppSecret
```

**文件：`ArticleApp/Info.plist`**
```xml
<!-- 第 49 行：替换 URL Scheme -->
<string>YOUR_WECHAT_APP_ID</string>  <!-- 替换为你的微信 AppID -->
```

### 2. Universal Link 配置

#### 2.1 服务器配置
在你的服务器根目录下创建 `apple-app-site-association` 文件：

```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "TEAM_ID.com.yourcompany.ArticleApp",
        "paths": [ "/article/*", "/share/*" ]
      }
    ]
  }
}
```

#### 2.2 修改应用配置

**文件：`ArticleApp/Info.plist`**
```xml
<!-- 第 57 行：替换为你的域名 -->
<string>applinks:yourdomain.com</string>  <!-- 替换为你的域名 -->
```

**文件：`ArticleApp.xcodeproj/project.pbxproj`**
```
// 第 215 和 235 行：修改 Bundle Identifier
PRODUCT_BUNDLE_IDENTIFIER = com.yourcompany.ArticleApp;  // 替换为你的 Bundle ID
```

### 3. 项目基本信息配置

**文件：`ArticleApp.xcodeproj/project.pbxproj`**
```
// 第 213 和 233 行：设置开发团队
DEVELOPMENT_TEAM = "YOUR_TEAM_ID";  // 替换为你的开发团队 ID
```

### 4. 依赖安装

在项目根目录执行：
```bash
# 安装 CocoaPods（如果尚未安装）
sudo gem install cocoapods

# 安装项目依赖
pod install

# 使用 .xcworkspace 文件打开项目
open ArticleApp.xcworkspace
```

### 5. 测试配置

#### 5.1 Universal Link 测试
1. 部署 `apple-app-site-association` 文件到服务器
2. 在 Safari 中访问：`https://yourdomain.com/article/123`
3. 应该能够唤起 App 并显示参数弹窗

#### 5.2 剪贴板检测测试
1. 复制以下内容到剪贴板：
   ```
   这是【LUOLUO】的内容 ##测试内容##
   ```
2. 打开 App，应该显示剪贴板检测弹窗

#### 5.3 微信登录测试
1. 确保已安装微信客户端
2. 在 App 中点击登录按钮
3. 应该跳转到微信进行授权

## 关键实现说明

### TabBar 控制逻辑
```swift
// RootView.swift 中的关键代码
if !appState.showLoginPage && !appState.showArticleDetail {
    TabView(selection: $appState.selectedTab) {
        // 只在主要页面显示 TabBar
    }
}
```

### 登录流程控制
```swift
// AppState.swift 中的导航逻辑
func navigateToArticle(_ articleId: String) {
    if isLoggedIn {
        currentArticleId = articleId
        showArticleDetail = true
    } else {
        pendingArticleId = articleId  // 记住待跳转文章
        showLoginPage = true
    }
}
```

### Universal Link 处理
```swift
// ArticleAppApp.swift 中的 URL 处理
.onOpenURL { url in
    if let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
        if let articleId = components.queryItems?.first(where: { $0.name == "articleId" })?.value {
            appState.showUniversalLinkSheet(with: ["articleId": articleId])
        }
    }
}
```

### 剪贴板检测
```swift
// ArticleAppApp.swift 中的剪贴板检测
private func checkClipboard() {
    let pasteboard = UIPasteboard.general
    if let clipboardText = pasteboard.string {
        if clipboardText.contains("【LUOLUO】") {
            // 提取 ##...## 之间的内容
            let pattern = "##(.+?)##"
            // 正则表达式处理...
        }
    }
}
```

## 常见问题

### Q1: 编译错误 "WechatOpenSDK not found"
**解决方案：**
1. 确保执行了 `pod install`
2. 使用 `.xcworkspace` 文件打开项目，不是 `.xcodeproj`

### Q2: Universal Link 不工作
**解决方案：**
1. 确保 `apple-app-site-association` 文件正确部署
2. 检查域名配置是否正确
3. 在设备上删除并重新安装 App

### Q3: 微信登录回调不工作
**解决方案：**
1. 检查 AppID 配置是否正确
2. 确保 URL Scheme 配置正确
3. 检查微信开放平台应用配置

### Q4: 剪贴板检测不触发
**解决方案：**
1. 确保剪贴板内容包含"【LUOLUO】"
2. 检查内容是否有 ##...## 结构
3. 在 App 切换到前台时会触发检测

## 扩展功能

### 添加新的页面
1. 在 `Views` 目录下创建新的 Swift 文件
2. 在 `RootView.swift` 中添加导航逻辑
3. 在 `AppState.swift` 中添加状态管理

### 集成其他第三方SDK
1. 在 `Podfile` 中添加依赖
2. 在 `Bridge` 目录下创建对应的桥接文件
3. 在 `AppDelegate.swift` 中添加初始化代码

### 自定义剪贴板检测规则
修改 `ArticleAppApp.swift` 中的 `checkClipboard()` 方法：
```swift
// 自定义检测规则
if clipboardText.contains("你的关键词") {
    // 自定义处理逻辑
}
```

## 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 贡献

欢迎提交 Issues 和 Pull Requests 来完善这个模板项目。

---

如有问题，请查看常见问题部分或提交 Issue。