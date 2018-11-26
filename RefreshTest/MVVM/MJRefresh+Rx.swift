//
//  MJRefresh+Rx.swift
//  LearnRxSwiftRoute
//
//  Created by zitang on 2018/5/4.
//  Copyright © 2018年 张江. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MJRefresh

extension Reactive where Base:MJRefreshComponent{
    
    //MAARK:刷新状态
    var refreshing: ControlEvent<Void> {
        let source: Observable<Void> = Observable.create { [weak control = self.base](observer)  in
            if let control = control {
                control.refreshingBlock = {
                    observer.onNext(())
                }
            }
            return Disposables.create()
        }
        return ControlEvent(events: source)
        
    }
    
    /// 结束刷新或加载状态
    public var endRefreshing: Binder<Bool> {
        return Binder(base) { refresh, isEnd in
            if isEnd {
                refresh.endRefreshing()
            }
        }
    }
}








