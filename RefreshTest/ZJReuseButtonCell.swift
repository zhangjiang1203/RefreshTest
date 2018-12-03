//
//  ZJReuseButtonCell.swift
//  RefreshTest
//
//  Created by zxd on 2018/12/3.
//  Copyright © 2018 张江. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ZJReuseButtonCell: UITableViewCell {
    
    var dispose = DisposeBag()
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var testMyBtn: UIButton!
    @IBOutlet weak var testMyBtn1: UIButton!
    
    var infoModel:ZJReuseModel?{
        didSet{
            guard let model = infoModel else {
                return
            }
            self.infoLabel.text = model.titleInfo
        }
    }
    var cellSub = PublishSubject<ZJReuseModel>.init()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //设置按钮点击事件
        testMyBtn.rx.tap.subscribe(onNext: { (_) in
            guard self.infoModel != nil else {
                return
            }
            var model = self.infoModel
            model?.name = "按钮1"
            self.cellSub.onNext(model!)
        }).disposed(by: dispose)
        testMyBtn1.rx.tap.subscribe(onNext: { (_) in
            guard self.infoModel != nil else {
                return
            }
            var model = self.infoModel
            model?.name = "按钮2"
            self.cellSub.onNext(model!)
        }).disposed(by: dispose)
    }
    
   //每次重用cell的时候都会释放之前的disposeBag，为cell创建一个新的dispose。保证cell被重用的时候不会被多次订阅，造成错误
    override func prepareForReuse() {
        super.prepareForReuse()
        dispose = DisposeBag()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
