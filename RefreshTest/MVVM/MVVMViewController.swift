//
//  MVVMViewController.swift
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
import SnapKit

class MVVMViewController: UIViewController {
    
    let dispose = DisposeBag()
    var myTableView:UITableView!
    var dataArr = BehaviorRelay.init(value: [ZJReuseModel]())
    lazy var datasource = RxTableViewSectionedReloadDataSource<SectionModel<String,ZJReuseModel>>(configureCell: { (db, tableview, indexPath, model) -> UITableViewCell in
        let cell = tableview.dequeueReusableCell(withIdentifier: "ZJReuseButtonCell") as! ZJReuseButtonCell
        cell.infoModel = model
        cell.cellSub.subscribe(onNext: { (index) in
            let info = "我是第\(index)按钮"
            let alert = UIAlertController.init(title: "你好", message: info, preferredStyle: .alert)
            let action = UIAlertAction.init(title: "确定", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }).disposed(by: cell.dispose)
        return cell
    })
    
    var requestManager:MVVMManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "rx刷新加载"
        setUpMyUI()
    }
    func setUpMyUI() {
        myTableView = UITableView()
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "systemCell")
        myTableView.register(UINib(nibName: "ZJReuseButtonCell", bundle: nil), forCellReuseIdentifier: "ZJReuseButtonCell")
        myTableView.mj_header = MJRefreshNormalHeader()
        myTableView.mj_footer = MJRefreshBackNormalFooter()
        self.view.addSubview(myTableView)
        myTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        //数据处理
        dataArr
            .map{ [SectionModel<String, ZJReuseModel>(model: "", items: $0)]}
            .bind(to: myTableView.rx.items(dataSource: datasource))
            .disposed(by: dispose)
        //初始化manager
        requestManager =  MVVMManager(input: (
            headerRefresh:myTableView.mj_header.rx.refreshing.asDriver(),
            footerRefresh:myTableView.mj_footer.rx.refreshing.asDriver(),
            endHeader:myTableView.mj_header.rx.endRefreshing,
            endFooter:myTableView.mj_footer.rx.endRefreshing),
            dependency: (dispose: dispose, netWork: APIRequest()))
        //绑定数据
        requestManager.tableData
            .bind(to:dataArr)
            .disposed(by: dispose)
    }
}
