//
//  TimeLineCell.swift
//  GithubClient
//
//  Created by 倉田　隆成 on 2018/06/29.
//  Copyright © 2018年 倉田　隆成. All rights reserved.
//

import Foundation
import UIKit

final class TimeLineCell: UITableViewCell {
    //ユーザーのアイコンを表示させるためのUIImageView
    private var iconView: UIImageView!
    
    //ユーザーのnicknameを表示させるためのUILabel
    private var nickNameLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        iconView = UIImageView()
        iconView.clipsToBounds = true
        contentView.addSubview(iconView)
        
        nickNameLabel = UILabel()
        nickNameLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(nickNameLabel)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconView.frame = CGRect(x: 15,
                                y: 15,
                                width: 45,
                                height: 45)
        iconView.layer.cornerRadius = iconView.frame.size.width / 2
        
        nickNameLabel.frame = CGRect(x: iconView.frame.maxX + 15,
                                     y: iconView.frame.origin.y,
                                     width: contentView.frame.width - iconView.frame.maxX - 15 * 2,
                                     height: 15)
        
    }
    //ユーザーのnicknameをセット
    func setNickName(nickname: String) {
        nickNameLabel.text = nickname
    }
    
    func setIcon(icon: UIImage) {
        iconView.image = icon
    }
}
