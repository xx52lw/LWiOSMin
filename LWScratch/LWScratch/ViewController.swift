//
//  ViewController.swift
//  LWScratch
//
//  Created by liwei on 2020/4/17.
//  Copyright © 2020 lw. All rights reserved.
//

import UIKit

class ViewController: UIViewController,LWScratchCardMaskDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let scratchCard = LWScratchCardView.init(frame: CGRect.init(x: 20, y: 70.0, width: 241.0, height: 106.0), couponImage: UIImage.init(named: "coupon")!, maskImage: UIImage.init(named: "mask")!)
        scratchCard.delegate = self
        
        view.addSubview(scratchCard)
        
    }

    
    func scratchCardMaskMoved(progress: Float) {
        print("当前进度：\(progress)")
        
    }

}

