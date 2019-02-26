//
//  ParallaxView.swift
//  RefreshTest
//
//  Created by zxd on 2019/2/19.
//  Copyright © 2019 张江. All rights reserved.
//

import UIKit

class ParallaxImageView: UIView {

    private lazy var bgView: UIImageView = {
        let bw = UIImageView()
        bw.contentMode = .scaleAspectFill
        bw.image = UIImage.init(named: "mine_bg_for_boy")
        return bw
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(bgView)
        
        bgView.snp.makeConstraints {$0.edges.equalToSuperview() }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
