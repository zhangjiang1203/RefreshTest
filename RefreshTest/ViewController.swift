//
//  ViewController.swift
//  RefreshTest
//
//  Created by 张江 on 2018/11/26.
//  Copyright © 2018 张江. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.edgesForExtendedLayout = .top
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .automatic
        } else {
            self.automaticallyAdjustsScrollViewInsets = true
        }
        self.navigationController?.barStyle(.theme)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        arrayTest()
    }
    
    func arrayTest()  {
        //过滤指定的元素数据
        var showArr = [PersonModel]()
        for i in 1...9{
            let person = PersonModel(userId: i, name: "张三", sex: i % 2, age: 10+i)
            showArr.append(person)
        }
    }


}

extension ViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let mvc =  ZJMVCViewController()
            self.navigationController?.pushViewController(mvc, animated: true)
        case 1:
            let mvvm =  MVVMViewController()
            self.navigationController?.pushViewController(mvvm, animated: true)
        case 2:
            let vc = ParallaxViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print("哈哈哈")
            
        }
      
        
    }
}

