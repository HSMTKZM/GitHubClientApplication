//
//  ImageDownloader.swift
//  GithubClient
//
//  Created by 倉田　隆成 on 2018/06/27.
//  Copyright © 2018年 倉田　隆成. All rights reserved.
//

import Foundation
import UIKit

final class ImageDownloader {
    //UIimageをキャッシュするための変数
    var cacheImage: UIImage?
    
    func downloadImage(imageURL: String,
                       success: @escaping (UIImage) -> Void,
                       failure: @escaping (Error) -> Void) {
        //もしキャッシュされたUIImageがあればそれをClosureで返す
        if let cacheImage = cacheImage {
            success(cacheImage)
        }
        
        //リクエストを作成
        var request = URLRequest(url: URL(string: imageURL)!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //ErrorがあったらErrorを返す
            if let error = error {
                DispatchQueue.main.async {
                    failure(error)
                }
                return
            }
            
            //dataがなかったら、APIError.unknownErrorをClosureで返す
            guard let data = data else {
                DispatchQueue.main.async {
                    failure(APIError.unknown)
                }
                return
            }
            
            //受け取ったデータからUIImageを作成できなければAPIError.unknownをClosuerで返す
            
            guard let imageFromData = UIImage(data: data) else {
                DispatchQueue.main.async {
                    failure(APIError.unknown)
                }
                return
            }
            //imageDataをClosureで返す
            DispatchQueue.main.async {
                success(imageFromData)
            }
            
            //画像をキャッシュする
            self.cacheImage = imageFromData
        }
        task.resume()
    }
}
