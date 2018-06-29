//
//  UserCellViewModel.swift
//  GithubClient
//
//  Created by 倉田　隆成 on 2018/06/29.
//  Copyright © 2018年 倉田　隆成. All rights reserved.
//

import Foundation
import UIKit

/*現在ダウンロード中か、ダウンロード終了か、エラーかの状態をenumで定義*/
enum ImageDownloadProgress {
    case loading(UIImage)
    case finish(UIImage)
    case error
}

final class UserCellViewModel {
    //Userを変数として保持
    private var user: User
    
    //ImageDownloaderを変数として保持
    private let imageDownloader = ImageDownloader()
    //ImageDownloaderでダウンロード中かどうかのBool変数として保持
    private var isLoading = false
    
    //Cellに反映させるインプット
    var nickName: String {
        return user.name
    }
    
    //Cellを洗濯した時に必要なURL
    var webURL: URL{
        return URL(string: user.webUrl)!
    }
    
    //userを引数にinit
    init(user: User) {
        self.user = user
    }
    
    //imageDownloaderを使ってダウンロードし、その結果をImageDownLoaderProgressとしてClosureで返している
    func downloadImage(progress: @escaping (ImageDownloadProgress) -> Void) {
        // isLoadingtrueだったら、return している。このメソッドは、cellForRowメソッドで呼ばれていることを想定しているため、何回もダウンロードしないためにisLoadingを使用している
        if isLoading == true {
            return
        }
        
        isLoading = true
        
        //grayのUIIMageを作成
        let loadingImage = UIImage(color: .gray, size: CGSize(width: 45, height: 45))!
        
        //loadingをclosureで返している
        progress(.loading(loadingImage))
        
        /*imageDownloaderを用いて画像をダウンロードしている。
            引数にuser.iconUrlを使っている.
        ダウンロード終了したら、.finishをClosureで返している
        Errorだったら、.errorをClosureで返している */
        imageDownloader.downloadImage(imageURL: user.iconUrl,
                                      success: {(image) in
                                        progress(.finish(image))
                                        self.isLoading = false
        }) { (error) in
            progress(.error)
            self.isLoading = true
        }
     
        
    }
    
}
