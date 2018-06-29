//
//  UIimage.swift
//  GithubClient
//
//  Created by 倉田　隆成 on 2018/06/29.
//  Copyright © 2018年 倉田　隆成. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    convenience init?(color: UIColor, size: CGSize) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil}
        self.init(cgImage: cgImage)
    }
}
