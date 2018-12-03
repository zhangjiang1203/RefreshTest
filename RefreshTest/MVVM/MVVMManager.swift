//
//  MVVMManager.swift
//  RefreshTest
//
//  Created by 张江 on 2018/11/26.
//  Copyright © 2018 张江. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MVVMManager {
    
    //展示数据
    let tableData = BehaviorRelay(value:[ZJReuseModel]())
    //停止头部刷新
    let endHeaderRefreshing:Driver<Bool>?
    //停止尾部刷新
    let endFooterRefreshing:Driver<Bool>?
    
    /// 初始化数据
    ///
    /// - Parameters:
    ///   - input: tableview的刷新和加载事件
    ///   - dependency: 网络请求和释放
    init(input:(headerRefresh:Driver<Void>,
                footerRefresh:Driver<Void>,
                endHeader:Binder<Bool>,
                endFooter:Binder<Bool>),
         dependency:(dispose:DisposeBag,
                     netWork:APIRequest)){
        
        //在doonNext事件中执行刷新和加载之前数据处理的功能
        let headerRefreshData = input.headerRefresh
            .startWith(())
            .skip(1)
            .do(onNext: { _ in
                //在这里设置page的初始值 page = 1
                print("开始刷新")
            })
            .flatMapLatest { _ in
                return dependency.netWork.getRandomResult()
        }
        
        let footerRefreshData = input.footerRefresh
            .startWith(())
            .skip(1)
            .do(onNext: { _ in
                //page += 1
                print("开始加载")
            })
            .flatMapLatest { _ in
                return dependency.netWork.getRandomResult()
        }
        
        //绑定刷新事件，处理函数
        self.endHeaderRefreshing = Driver.merge(
            headerRefreshData.map({ _ in true}),
            input.footerRefresh.map{_ in true})
        
        self.endFooterRefreshing = Driver.merge(
            footerRefreshData.map({ _ in true}),
            input.headerRefresh.map{_ in true})
        //加载初始化数据
        dependency.netWork.getRandomResult().drive(self.tableData).disposed(by: dependency.dispose)
        
        //拼接返回值 添加
        headerRefreshData.drive(onNext: { (data) in
            self.tableData.accept(data)
        }).disposed(by: dependency.dispose)
        
        footerRefreshData.drive(onNext: { (items) in
            self.tableData.accept(self.tableData.value + items)
        }).disposed(by: dependency.dispose)
        
        //结束刷新
        self.endHeaderRefreshing?
            .drive(input.endHeader)
            .disposed(by: dependency.dispose)
        self.endFooterRefreshing?
            .drive(input.endFooter)
            .disposed(by: dependency.dispose)
    }

}

class APIRequest {
    
    /// 获取随机数据
    ///
    /// - Returns: 返回driver
    func getRandomResult() -> Driver<[ZJReuseModel]> {
        print("正在请求数据......")
        var items = [ZJReuseModel]()
        
        for _ in 0..<15{
            var model = ZJReuseModel()
            model.titleInfo = "随机数据\(Int(arc4random()))"
            model.name = "测试数据"
            items.append(model)
        }
    
//        let items = (0..<15).ma

        return Observable.just(items)
            .delay(1, scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: [ZJReuseModel]())
    }
}
