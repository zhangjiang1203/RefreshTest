//
//  ParallaxViewController.swift
//  RefreshTest
//
//  Created by zxd on 2019/2/19.
//  Copyright © 2019 张江. All rights reserved.
//

import UIKit
class ParallaxViewController: ZJBaseViewController {
    
    lazy var headerView:ParallaxImageView = {
        let view = ParallaxImageView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 200))
        return view
    }()
    
    private lazy var navigationBarY: CGFloat = {
        return navigationController?.navigationBar.frame.maxY ?? 0
    }()
    
    var myTableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .top
        setUpMyTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.barStyle(.clear)
        myTableView.contentOffset = CGPoint(x: 0, y: -myTableView.parallaxHeader.height)

    }
    
    func setUpMyTableView() {
        myTableView = UITableView(frame: self.view.bounds, style: .plain)
        myTableView.backgroundColor = UIColor.white
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "systemCell")
        self.view.addSubview(myTableView)
        
        myTableView.parallaxHeader.view = headerView
        myTableView.parallaxHeader.height = 200
        myTableView.parallaxHeader.minimumHeight = navigationBarY
        myTableView.parallaxHeader.mode = .fill

    }

}

extension ParallaxViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "systemCell") as! UITableViewCell
        cell.textLabel?.text = "当前序号\(indexPath.row)"
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= -(scrollView.parallaxHeader.minimumHeight){
            self.navigationController?.barStyle(.theme)
            self.navigationItem.title = "我的"
        }else{
            self.navigationItem.title = ""
            self.navigationController?.barStyle(.clear)
        }
    }
}
