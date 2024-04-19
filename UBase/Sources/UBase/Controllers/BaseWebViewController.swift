//
//  BaseWebViewController.swift
//  
//
//  Created by youzy01 on 2021/3/16.
//

import UIKit
import WebKit

public class JavaScript {
    var items: [Handler] = []

    weak var webViewController: BaseWebViewController?

    var webView: WKWebView? {
        return webViewController?.webView
    }

    public func append(_ newElement: Handler) {
        newElement.webController = webViewController
        items.append(newElement)
        webView?.configuration.userContentController.add(newElement, name: newElement.name)
    }

    public func append(contentsOf newElements: [Handler]) {
        newElements.forEach { $0.webController = webViewController }
        items.append(contentsOf: newElements)
        newElements.forEach { webView?.configuration.userContentController.add($0, name: $0.name) }
    }

    public func remove(for name: String) {
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: name)
        items.removeAll(where: { $0.name == name })
    }

    public func removeAll() {
        items.forEach { webView?.configuration.userContentController.removeScriptMessageHandler(forName: $0.name) }
        items.removeAll()
    }
}

extension JavaScript {
    open class Handler: NSObject {
        open var name: String {
            fatalError("子类提供")
        }

        public weak var webController: BaseWebViewController?

        public var webView: WKWebView? {
            return webController?.webView
        }

        open func run(_ sender: WKScriptMessage) {
        }
    }
}

extension JavaScript.Handler: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        debugPrint()
        debugPrint("[Script] name: \(message.name)")
        debugPrint(message.body)
        debugPrint()
        run(message)
    }
}

open class ScriptHandler: NSObject {
    public let name: String
    private let handler: ((WKScriptMessage) -> Void)?

    deinit {
        debugPrint("ScriptHandler_\(name)_deinit")
    }

    public init(name: String, handler: ((WKScriptMessage) -> Void)?) {
        self.name = name
        self.handler = handler
        super.init()
    }
}

extension ScriptHandler: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        handler?(message)
    }
}

open class BaseWebViewController: BaseViewController {
    /// 请求类型
    enum RequestType {
        /// 本地文件
        case path
        /// 网络链接
        case url
    }

    public lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true

        let view = WKWebView(frame: .zero, configuration: configuration)
        view.allowsLinkPreview = false
        view.navigationDelegate = self
        view.uiDelegate = self
        return view
    }()

    /// 进度条
    public let progressView = UIProgressView(progressViewStyle: .bar)

    var userController: WKUserContentController {
        return webView.configuration.userContentController
    }

    /// 进度观察者
    private var progressObservation: NSKeyValueObservation?
    /// 标题观察者
    private var titleObservation: NSKeyValueObservation?

    private var scripts: [String] = []

    private let javaScript = JavaScript()

    /// 要打开的URL
    public let url: String
    /// 请求类型
    private let requestType: RequestType
    /// 是否改变标题
    private let isChangeTitle: Bool

    /// 自定义标题
    private let customTitle: String

    public var isHiddeNavigationBar: Bool = false

    deinit {
        progressObservation?.invalidate()
        progressObservation = nil

        scripts.forEach { (name) in
            userController.removeScriptMessageHandler(forName: name)
        }
    }

    /// 使用网络链接初始化
    /// - Parameters:
    ///   - title: 标题
    ///   - url: 网络链接
    public init(title: String = "", url: String) {
        self.url = url
        isChangeTitle = title.isEmpty
        customTitle = title
        requestType = .url
        super.init(nibName: nil, bundle: nil)
    }

    /// 使用本地文件地址初始化
    /// - Parameters:
    ///   - title: 标题
    ///   - path: 本地文件地址
    public init(title: String = "", path: String) {
        self.url = path
        isChangeTitle = title.isEmpty
        customTitle = title
        requestType = .path
        super.init(nibName: nil, bundle: nil)
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        url = ""
        isChangeTitle = false
        customTitle = ""
        requestType = .url
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        uNavigationBar.isHidden = isHiddeNavigationBar
        setup()
        javaScript.webViewController = self
        addScript(at: javaScript)
        loadRequest(value: url)
    }

    open func loadRequest(value: String) {
        switch requestType {
        case .path:
            let url = URL(fileURLWithPath: value)
            webView.load(URLRequest(url: url))
        case .url:
            if let url = URL(string: value) {
                webView.load(URLRequest(url: url))
            }
        }
    }

    /// 显示loading视图
    ///
    /// 默认是进度条
    open func showLoadingView() {
        progressView.isHidden = false
    }

    /// 隐藏loading视图
    open func hideLoadingView() {
        UIView.animate(withDuration: 0.3) {
            self.progressView.isHidden = true
        } completion: { (_) in
            self.progressView.setProgress(0, animated: false)
        }
    }

    @objc open func closeAction() {
    }

    open func addScript(at javaScript: JavaScript) {

    }

    public final func addScriptHandler(_ item: ScriptHandler) {
        userController.add(item, name: item.name)
        scripts.append(item.name)
    }
}

extension BaseWebViewController: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

    }
}

private extension BaseWebViewController {
    func setup() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)

        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)
        if isHiddeNavigationBar {
            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: view.topAnchor),
                webView.leftAnchor.constraint(equalTo: view.leftAnchor),
                webView.rightAnchor.constraint(equalTo: view.rightAnchor),
                webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                progressView.leftAnchor.constraint(equalTo: view.leftAnchor),
                progressView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                webView.leftAnchor.constraint(equalTo: view.leftAnchor),
                webView.rightAnchor.constraint(equalTo: view.rightAnchor),
                webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                progressView.leftAnchor.constraint(equalTo: view.leftAnchor),
                progressView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
        }

        progressObservation = webView.observe(\.estimatedProgress) { [weak progressView] (view, _) in
            progressView?.setProgress(Float(view.estimatedProgress), animated: true)
            debugPrint(view.estimatedProgress)
        }

        if isChangeTitle {
            titleObservation = webView.observe(\.title) { [weak self] (view, _) in
                self?.title = view.title
            }
        } else {
            title = customTitle
        }
    }
}

extension BaseWebViewController: WKNavigationDelegate {
    @available(iOS 13.0, *)
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        debugPrint("决定是允许还是取消导航。iOS 13")
        debugPrint(navigationAction.request.url?.absoluteString ?? "url == nil")
        decisionHandler(.allow, preferences)
    }

    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        debugPrint("决定是允许还是取消导航。")
        decisionHandler(.allow)
    }

    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        debugPrint("webView 开始导航")
        showLoadingView()
    }

    open func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        debugPrint("webView 已收到请求的服务器重定向。")
    }

    open func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        debugPrint("webView 开始加载内容")
    }

    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        debugPrint("webView 导航已完成")
        hideLoadingView()
    }

    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        debugPrint("导航期间发生错误。")
    }

    open func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        debugPrint("早期导航过程中发生了错误。")
        hideLoadingView()
    }

    open func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        debugPrint("该Web视图的内容过程已终止。")
    }
}

// MARK: - WKUIDelegate
extension BaseWebViewController: WKUIDelegate {
    // 创建一个新的WebView
    open func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // 如果是跳转一个新页面
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }

    // WebView关闭
    open func webViewDidClose(_ webView: WKWebView) {
//        debugPrint("WebView关闭")
    }

    // 显示一个JS的alert
    open func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        debugPrint(message)
        // 确定按钮
        let alertAction = UIAlertAction(title: "OK", style: .cancel) { (_) in
            completionHandler()
        }
        // alert弹出框
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alertController.addAction(alertAction)

        present(alertController, animated: true, completion: nil)
    }

    // 弹出一个输入框
    open func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        debugPrint(prompt, defaultText ?? "")
    }

    // 弹出一个确认框
    open func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        debugPrint(message)
    }
}
