//
//  ViewController.swift
//  RefreshTest
//
//  Created by 张江 on 2018/11/26.
//  Copyright © 2018 张江. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

extension ViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let mvc =  ZJMVCViewController()
            self.navigationController?.pushViewController(mvc, animated: true)
        }else{
            let mvvm =  MVVMViewController()
            self.navigationController?.pushViewController(mvvm, animated: true)
        }
        
    }
}

