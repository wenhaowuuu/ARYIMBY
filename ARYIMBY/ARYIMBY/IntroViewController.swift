//
//  IntroViewController.swift
//  ARYIMBY
//
//  Created by Wenhao Wu on 4/9/23.
//

import UIKit
import WebKit
//import YouTubePlayer

class IntroViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let webViewHeight: CGFloat = 50
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 360, height: 250))
        webView.center = CGPoint(x: view.center.x, y: view.frame.height / 2 + 25)
        let url = URL(string: "https://www.youtube.com/embed/oR85FFoyCAo")!
        let request = URLRequest(url: url)
        webView.load(request)
        view.addSubview(webView)

        // Do any additional setup after loading the view.
//        let videoID = "oR85FFoyCAo"
//        let html = "<iframe width=\"823\" height=\"419\" src=\"https://www.youtube.com/embed/\(videoID)\" frameborder=\"0\" allowfullscreen></iframe>"
//        webView.loadHTMLString(html, baseURL: nil)
//        webView.scrollView.contentInsetAdjustmentBehavior = .never // Disable automatic content inset adjustment
//        webView.evaluateJavaScript("document.body.style.display = 'flex';" +
//                                       "document.body.style.justifyContent = 'center';" +
//                                       "document.body.style.alignItems = 'center';")

        //reference: embed code from youtube
//        <iframe width="823" height="419" src="https://www.youtube.com/embed/oR85FFoyCAo" title="5 Myths About Urban Density" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
