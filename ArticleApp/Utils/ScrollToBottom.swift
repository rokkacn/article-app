import SwiftUI

// Utility for detecting when user scrolls to bottom of a list for pagination
struct ScrollToBottom: ViewModifier {
    let threshold: CGFloat
    let onReachBottom: () -> Void
    
    init(threshold: CGFloat = 100, onReachBottom: @escaping () -> Void) {
        self.threshold = threshold
        self.onReachBottom = onReachBottom
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(
                            key: ScrollOffsetPreferenceKey.self,
                            value: geometry.frame(in: .named("scroll")).origin.y
                        )
                }
            )
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                if offset < -threshold {
                    onReachBottom()
                }
            }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    func onScrollToBottom(threshold: CGFloat = 100, perform action: @escaping () -> Void) -> some View {
        modifier(ScrollToBottom(threshold: threshold, onReachBottom: action))
    }
}

// Additional utility for better scroll detection in Lists
struct ListBottomDetector: View {
    let onReachBottom: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
        }
        .frame(height: 1)
        .onAppear {
            onReachBottom()
        }
    }
}