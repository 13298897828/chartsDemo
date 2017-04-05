//
//  ViewController.swift
//  ChartTapDemo
//
//  Created by Mr Z on 2017/4/5.
//  Copyright © 2017年 C2H4. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        btn.center = self.view.center
        btn.setTitle("just to charts", for: UIControlState())
        btn.addTarget(self, action: #selector(pushAction), for: .touchUpInside)
        btn.backgroundColor = .red
        self.view.addSubview(btn)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func pushAction() {
        
        let chartVC = ChartsViewController()
        chartVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chartVC, animated: true)
    }

}

