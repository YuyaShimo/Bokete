//
//  ViewController.swift
//  Bokete
//
//  Created by 下新原佑哉 on 2020/03/28.
//  Copyright © 2020 Yuya shimoshimbara. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import Photos

class ViewController: UIViewController {
    
    @IBOutlet weak var odaiImageView: UIImageView!
    
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var seachTextField: UITextField!
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTextView.layer.cornerRadius = 20.0
        
        PHPhotoLibrary.requestAuthorization { (status) in
            
             switch(status) {
                case .authorized: break
                case .denied: break
                case .notDetermined: break
                case .restricted: break
            }
            
        }
        getImages(keyword: "funny")
        
    }
    //検索キーワードを元に画像を持ってくる
    //API:12619274-2b777c518568e9cf35f348af4
    
    func getImages(keyword:String) {
    
        let url = "https://pixabay.com/api/?key=12619274-2b777c518568e9cf35f348af4&q=\(keyword)"
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON
            { (response) in
            
                switch response.result {
                
                case .success:
                    
                    let json:JSON = JSON(response.data as Any)
                    var imageString = json["hits"][self.count]["webformatURL"].string
                    
                    if imageString == nil {
                        
                        imageString = json["hits"][0]["webformatURL"].string
                        self.odaiImageView.sd_setImage(with: URL(string: imageString!), completed: nil)
                        
                    }else{
                        
                        self.odaiImageView.sd_setImage(with: URL(string: imageString!), completed: nil)
                    }
                    
                    
                    
                    
                case .failure(let error):
                    
                    print(error)
                }
            }
        
    }
    @IBAction func nextOdai(_ sender: Any) {  //次のお題ボタン押下時の処理
        
        count = count + 1
        
        if seachTextField.text == "" {
            getImages(keyword: "funny")
            
        }else{
            getImages(keyword: seachTextField.text!)
        }
        
    }
    @IBAction func seachAction(_ sender: Any) {  //虫眼鏡（検索ボタン）押下時の処理
        
        self.count = 0
        
        if seachTextField.text == "" {
            getImages(keyword: "funny")
            
        }else{
            getImages(keyword: seachTextField.text!)
        }
        
    }
    @IBAction func next(_ sender: Any) {  //決定ボタン押下時の処理
        
        performSegue(withIdentifier: "next", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let shareVC = segue.destination as?
            ShareViewController
            shareVC?.commentString = commentTextView.text
        shareVC?.resultImage = odaiImageView.image!
    }
    

}
