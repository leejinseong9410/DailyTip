//
//  WearWebViewPageController.swift
//  DailyTip
//
//  Created by MacBookPro on 2021/09/07.
//

import UIKit
import WebKit

class WearWebViewPageController: UIViewController,WKUIDelegate,WKNavigationDelegate {

    private let backButtonBarItem : UIBarButtonItem = {
        let back = UIBarButtonItem()
        back.image = UIImage(named: "BackDtAppButton")?.withRenderingMode(.alwaysOriginal)
        back.action = #selector(showMainPage)
        return back
    }()
    
    var select = ""
    
    private let webView : WKWebView = {
       let webView = WKWebView()
        return webView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        backButtonBarItem.target = self
        navigationItem.leftBarButtonItem = backButtonBarItem
        
    }
    @objc func showMainPage(){
        let main = MainPageController()
        main.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(main, animated: true)
        print("remove WebView")
        view.removeFromSuperview()
    }
    private func configure(){
        view.addSubview(webView)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.frame = view.frame
        self.view = self.webView
        let url = URL(string: select)
                let request = URLRequest(url: url!)
                self.webView.allowsBackForwardNavigationGestures = true 
                //webView.configuration.preferences.javaScriptEnabled = true  //자바스크립트 활성화
                webView.load(request)
    }
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
        //alert 처리
        func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String,
                     initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void){
            let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in completionHandler() }))
            self.present(alertController, animated: true, completion: nil) }

        //confirm 처리
        func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
            let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "취소", style: .default, handler: { (action) in completionHandler(false) }))
            alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in completionHandler(true) }))
            self.present(alertController, animated: true, completion: nil) }
        
        // href="_blank" 처리
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if navigationAction.targetFrame == nil { webView.load(navigationAction.request) }
            return nil }
}
