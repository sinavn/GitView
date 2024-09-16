//
//  ReadmeWebView.swift
//  GitView
//
//  Created by Sina Vosough Nia on 6/24/1403 AP.
//

import UIKit
import WebKit

class ReadmeWebView: WKWebView  {
    
    var heightConstraint : NSLayoutConstraint!
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        navigationDelegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getUserReadme(userName:String) async{
        do{
            let readmeContent = try await NetworkManager.shared.getUserReadme(userName: userName)
            if readmeContent.isEmpty {
                            // No content, hide the web view by setting height to 0
                            DispatchQueue.main.async {
                                self.heightConstraint.constant = 0
                                self.isHidden = true
                            }
                            return
                        }

            let convertedtoHTMLContent = try await NetworkManager.shared.convertMarkdownToHTML(content: readmeContent)
            // Simple HTML wrapper for the README content
            let htmlContent = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
            body {
                margin: 0;
                padding: 16px;
                background-color: \(UIColor.secondarySystemBackground.toHexString());
                color: \(UIColor.label.toHexString());
                font-family: -apple-system, BlinkMacSystemFont, 'Helvetica Neue', 'Helvetica', 'Arial', sans-serif;
            }
            pre {
                white-space: pre-wrap;
                word-wrap: break-word;
                max-width: 100%;
                width: 100%;
                box-sizing: border-box;
            }
            img, video {
                max-width: 100%;
                height: auto;
            }
        </style>
        </head>
        <body>
        \(convertedtoHTMLContent)
        </body>
        </html>
        """
            
            let repositoryBaseURL = URL(string: "https://raw.githubusercontent.com/\(userName)/\(userName)/main/")
            DispatchQueue.main.async {
                self.loadHTMLString(htmlContent, baseURL: repositoryBaseURL)
            }
        }catch let error{
            print(error)
        }
        
    }
}

extension ReadmeWebView :WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
          // Check if the navigation action is a link click
          if let url = navigationAction.request.url, navigationAction.navigationType == .linkActivated {
              // Open the link in Safari
              await UIApplication.shared.open(url)
              // Cancel the web view's navigation
              return .cancel
          }
          
          // Allow navigation for other types of actions
          return .allow
      }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.body.scrollHeight") {[weak self] result, error in
            if let height = result as? CGFloat {
                self?.heightConstraint.constant = height
                self?.isHidden = height == 0
                self?.superview?.layoutIfNeeded()
            }
        }
    }
}
