//
//  MainViewController.swift
//  YouTubeApp
//
//  Created by 佐々木　謙 on 2021/03/29.
//

import UIKit
import Alamofire

// Youtube検索結果を管理するクラス
class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    

    // MARK: - プロパティ
    // tableViewのインスタンス
    @IBOutlet weak var youTubeTable: UITableView!
    
    // 検索バーのインスタンス
    @IBOutlet weak var searchBar: UISearchBar!
    
    // APIへのアクセスキー
    // YouTubeAPIは q="検索ワード", &=情報の繋げ役, key= youTubeAPIKey, 必須パラメーターpart= snipeet
    var youTubeAPIKey = "AIzaSyAAMmYlyBkUeVtBpagqXAQoPgOJ9-HAtmg"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // デリゲートの委託
        youTubeTable.delegate   = self
        youTubeTable.dataSource = self
        searchBar.delegate      = self
        
        // キーボードにツールバーを反映
        createToolbar()
        
        // 検索情報（仮）
        let searchURL = "https://www.googleapis.com/youtube/v3/search?q=baseball&key=AIzaSyAAMmYlyBkUeVtBpagqXAQoPgOJ9-HAtmg&part=snippet"
        
        // APIに送信するリクエスト
        let request = AF.request(searchURL)
        
        // リクエストを受けとる
        request.responseJSON {
            (response) in
            
            print("response: \(response)")
        }
    }
    
    
    // MARK: - キーボードにツールバーを追加
    // "閉じる", "検索"ボタンをキーボードに追加
    func createToolbar() {
        
        // ツールバーを作成
        let toolbar = UIToolbar()
            toolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        
        // 余白用アイテム
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        // "閉じる"ボタンを作成
        let croseButtonItem = UIBarButtonItem(title: "閉じる", style: UIBarButtonItem.Style.plain, target: self, action: #selector(croseKeyboard))
        
        // "検索"ボタンを作成
        let searchButtonItem = UIBarButtonItem(title: "検索", style: UIBarButtonItem.Style.plain, target: self, action: #selector(tapSearchButton))
        
        // ツールバーにボタンを反映（閉じる, クリア, 翻訳実行）
        toolbar.setItems([croseButtonItem, flexibleItem, searchButtonItem], animated: true)
        
        // ツールバーを反映
        searchBar.inputAccessoryView = toolbar
    }
    
    
    // MARK: - テーブルビューの設定
    // セルの数を決める
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    // セルの高さを決める
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    // セルを構築
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // tableCellのID（youtubeCell）でセルのインスタンスを作成
        let cell = youTubeTable.dequeueReusableCell(withIdentifier: "youtubeCell",
                                             for: indexPath)
        
        // Tag番号(1)〜(3)でセルのパーツを管理
        let videoTitle = cell.viewWithTag(1) as! UILabel
        let videoSize  = cell.viewWithTag(2) as! UILabel
        let videoImage = cell.viewWithTag(3) as! UIImageView
        
        // 空のセルを削除
        youTubeTable.tableFooterView = UIView(frame: .zero)
        
        return cell
    }
    
    // セルをタップすると呼ばれる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // タップ時の選択色の常灯を消す
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }

    
    // MARK: -  検索アクション
    // キーボード閉じるボタンをタップすると呼ばれる
    @objc func croseKeyboard() {
        // キーボードを閉じる
        self.view.endEditing(true)
    }
    
    // キーボード検索ボタンをタップすると呼ばれる
    @objc func tapSearchButton() {
        // キーボードを閉じる
        self.view.endEditing(true)
    }
}

