//
//  WebViewController.swift
//  YouTubeApp
//
//  Created by 佐々木　謙 on 2021/03/30.
//

import UIKit
import WebKit

// YouTubeの動画ページを管理するクラス
class WebViewController: UIViewController, WKUIDelegate {

    
    // MARK: - プロパティ
    // WKWebViewのインスタンス
    var webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // WebViewのサイズを設定しviewに反映
        webView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.addSubview(webView)
        
        // openWebViewの呼び出し
        openWebView()
    }
    
    
    // MARK: - WebViewを開く
    func openWebView() {
        
        // セルタップ時にローカル保存した動画のパラメーターを取得
        let params = UserDefaults.standard.string(forKey: "videoParams") as! String
        
        // 取得したパラメータを文字列に結合
        let videoString = "https://www.youtube.com/watch?v=\(params)"
        print("videoString: \(videoString)")
                
        // 結合した文字列URLをURL型にキャスト
        let videoURL = URL(string: videoString)
        
        // URLのリクエストを投げる
        let tapCellRequest = URLRequest(url: videoURL!)
        
        //WebViewを開く
        webView.load(tapCellRequest)
    }
}
