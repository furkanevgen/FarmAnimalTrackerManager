import SwiftUI
import WebKit

struct FarmScreen: View {
    let linkString: String
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea(.all)
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            }
            
            BrowserView(linkString: linkString, isLoading: $isLoading)
                .opacity(isLoading ? 0 : 1)
                .ignoresSafeArea(.all)
        }
        .statusBar(hidden: true)
        .onAppear {
            AppDelegate.setOrientation(.all)
        }
        .onDisappear {
            AppDelegate.setOrientation(.portrait)
        }
    }
}

struct BrowserView: UIViewRepresentable {
    let linkString: String
    @Binding var isLoading: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let browserView = WKWebView(frame: .zero, configuration: configuration)
        browserView.navigationDelegate = context.coordinator
        browserView.allowsBackForwardNavigationGestures = true
        browserView.scrollView.contentInsetAdjustmentBehavior = .never
        browserView.scrollView.contentInset = .zero
        browserView.scrollView.scrollIndicatorInsets = .zero
        
        if let link = URL(string: linkString) {
            let request = URLRequest(url: link)
            browserView.load(request)
        }
        
        return browserView
    }
    
    func updateUIView(_ browserView: WKWebView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isLoading: $isLoading)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        @Binding var isLoading: Bool
        private var isInitialLoad = true
        
        init(isLoading: Binding<Bool>) {
            _isLoading = isLoading
        }
        
        func webView(_ browserView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            if isInitialLoad {
                isLoading = true
            }
        }
        
        func webView(_ browserView: WKWebView, didFinish navigation: WKNavigation!) {
            if isInitialLoad {
                withAnimation {
                    isLoading = false
                    isInitialLoad = false
                }
            }
        }
        
        func webView(_ browserView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            if isInitialLoad {
                withAnimation {
                    isLoading = false
                    isInitialLoad = false
                }
            }
        }
        
        func webView(_ browserView: WKWebView, didCommit navigation: WKNavigation!) {
        }
    }
}

#Preview {
    FarmScreen(linkString: "https://example.com")
}

