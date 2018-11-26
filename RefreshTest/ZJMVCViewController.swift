//
//  ZJMVCViewController.swift
//  RefreshTest
//
//  Created by 张江 on 2018/11/26.
//  Copyright © 2018 张江. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import MJRefresh


class ZJMVCViewController: UIViewController {

    let dispose = DisposeBag()
    fileprivate var myTableView:UITableView!
    fileprivate var dataArr = BehaviorRelay.init(value: [String]())
    fileprivate var page = 1
    fileprivate let datasource = RxTableViewSectionedReloadDataSource<SectionModel<String,String>>(configureCell: { (db, tableview, indexPath, model) -> UITableViewCell in
        let cell = tableview.dequeueReusableCell(withIdentifier: "systemCell")
        cell?.textLabel?.text = "\(indexPath.row+1)"
        return cell!
    })


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "MVC"
        setUpMyUI()
    }
    
    func setUpMyUI() {
        myTableView = UITableView()
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "systemCell")
        myTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 1
            self.getDataFromServer().drive(self.dataArr).disposed(by: self.dispose)
        })
        myTableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.page += 1
            self.getDataFromServer().drive(onNext: { (strings) in
                self.dataArr.accept(self.dataArr.value + strings)
            }).disposed(by: self.dispose)
        })
        self.view.addSubview(myTableView)
        
        myTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        //数据处理
        dataArr
            .map{ [SectionModel<String, String>(model: "", items: $0)]}
            .bind(to: myTableView.rx.items(dataSource: datasource))
            .disposed(by: dispose)
        //初始化数据
        getDataFromServer().drive(dataArr).disposed(by: dispose)
    }
    
    func getDataFromServer() -> Driver<[String]> {
        var tempArr = [String]()
        for i in 1...10{
            tempArr.append("\(i)")
        }
        self.myTableView.mj_header.endRefreshing()
        self.myTableView.mj_footer.endRefreshing()
        return Observable.just(tempArr)
            .delay(1, scheduler: MainScheduler.instance)
            .asDriver(onErrorDriveWith: Driver.empty())
    }
}
