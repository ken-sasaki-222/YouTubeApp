//
//  MainViewController.swift
//  YouTubeApp
//
//  Created by 佐々木　謙 on 2021/03/29.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

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
    
    // レスポンス結果を保存する配列
    var videoItemArray: [VideoItems] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // デリゲートの委託
        youTubeTable.delegate   = self
        youTubeTable.dataSource = self
        searchBar.delegate      = self
        
        // キーボードにツールバーを反映
        createToolbar()
    }
    
    
    // MARK: - キーボードにツールバーを追加
    // 閉じるボタンをキーボードに追加
    func createToolbar() {
        
        // ツールバーを作成
        let toolbar = UIToolbar()
            toolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        
        // "閉じる"ボタンを作成
        let croseButtonItem = UIBarButtonItem(title: "閉じる", style: UIBarButtonItem.Style.plain, target: self, action: #selector(croseKeyboard))
        
        // ツールバーにボタンを反映（閉じる）
        toolbar.setItems([croseButtonItem], animated: true)
        
        // ツールバーを反映
        searchBar.inputAccessoryView = toolbar
    }

    
    // MARK: -  検索アクション
    // キーボードの検索ボタンをタップすると呼ばれる
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("検索")
        
        // キーボードを閉じる
        searchBar.resignFirstResponder()
        
        // 検索情報
        let searchText = searchBar.text
        
        // 検索情報を渡してAPI通信を行う
        getYoutubeResponse(searchWord: searchText!)
    }
    
    // YouTubeAPIと通信を行う
    func getYoutubeResponse(searchWord: String) {
        
        // 検索URL（q以外は固定値）
        let searchString = "https://www.googleapis.com/youtube/v3/search?q=\(searchWord)&key=AIzaSyAAMmYlyBkUeVtBpagqXAQoPgOJ9-HAtmg&part=snippet"
        
        // 日本語検索を可能に変換
        let encodeString: String = searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        // 変換後のURLのインスタンス
        let searchURL = URL(string: encodeString)
        
        // Alamofireを用いてAPIにリクエスト
        AF.request(searchURL as! URLConvertible, method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON {
            (response) in
            
            // 通信の結果で分岐
            switch response.result {
            case .success:
                
                // レスポンス結果をJSON型に変換
                let resultJSON = JSON(response.data as Any)
                
                // JSON解析をおこなう
                for i in 0..<resultJSON["items"].count {
                    
                    // レスポンス結果のキー値を指定して値を取得
                    let videoItems = VideoItems(videTitle: resultJSON["items"][i]["snippet"]["title"].string!, videoChannel: resultJSON["items"][i]["snippet"]["channelTitle"].string!, videoImage: resultJSON["items"][i]["snippet"]["thumbnails"]["medium"]["url"].string!)
                    
                    // videoItems型の配列に保管
                    self.videoItemArray.append(videoItems)
                }
                
                print("videoItemArray: \(self.videoItemArray)")
                print("videoItemArray.count: \(self.videoItemArray.count)")
                
                // tableViewの更新
                self.youTubeTable.reloadData()
                
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
    
    // 検索バーのキャンセルボタンをタップすると呼ばれる
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        // キーボードを閉じて検索内容をクリア
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    // キーボードの閉じるボタンをタップすると呼ばれる
    @objc func croseKeyboard() {
        
        // キーボードを閉じて検索内容をクリア
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    
    // MARK: - テーブルビューの設定
    // セルの数を決める
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoItemArray.count
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
        
        // 検索結果のインスタンス
        let searchResults = videoItemArray[indexPath.row]
        
        // Tag番号(1)〜(3)でセルのパーツを管理
        let videoTitle   = cell.viewWithTag(1) as! UILabel
        let videoChannel = cell.viewWithTag(2) as! UILabel
        let videoImage   = cell.viewWithTag(3) as! UIImageView
        
        // サムネイルのプレースホルダーとURL
        let placeholder  = UIImage(named: "placeholder")
        let thumbnail    = URL(string: searchResults.thumbnailURL)
        
        // 検索結果を反映
        videoTitle.text   = searchResults.title
        videoChannel.text = searchResults.channelTitle
        videoImage.kf.setImage(with: thumbnail, placeholder: placeholder, options: [.transition(.fade(0.7))], progressBlock: nil)
        
        // 空のセルを削除
        youTubeTable.tableFooterView = UIView(frame: .zero)
        
        return cell
    }
    
    // セルをタップすると呼ばれる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // タップ時の選択色の常灯を消す
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
}

