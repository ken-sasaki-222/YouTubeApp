//
//  MainViewController.swift
//  YouTubeApp
//
//  Created by 佐々木　謙 on 2021/03/29.
//

import UIKit

// Youtube検索結果を管理するクラス
class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    // MARK: - プロパティ
    // tableViewのインスタンス
    @IBOutlet weak var youTubeTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // デリゲートの委託
        youTubeTable.delegate   = self
        youTubeTable.dataSource = self
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

}

