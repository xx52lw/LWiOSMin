//
//  ViewController.swift
//  LWCaptureView
//
//  Created by liwei on 2020/4/20.
//  Copyright © 2020 lw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var  captureView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
         captureView = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 100, height: 1000))
        let label1 = UILabel.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 100.0, height: 30.0))
        label1.text = "label1"
        label1.textColor = .red
        captureView.addSubview(label1)
        
        let label2 = UILabel.init(frame: CGRect.init(x: 0.0, y: 950.0, width: 100.0, height: 30.0))
        label2.text = "label2"
        label2.textColor = .red
        captureView.addSubview(label2)
        
        view.addSubview(captureView)
    }


    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        captureView.capture { (capturedImage) in
             UIImageWriteToSavedPhotosAlbum(capturedImage!, self, nil, nil)
        }
    }
    
    
}

