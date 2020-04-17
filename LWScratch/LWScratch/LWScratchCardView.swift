//
//  LWScratchCardView.swift
//  LWScratch
//
//  Created by liwei on 2020/4/17.
//  Copyright © 2020 lw. All rights reserved.
//

import UIKit
// 呱呱图视图
class LWScratchCardView: UIView {

    // 图层
    var scratchCardMask : LWScratchCardMask!
    // 底层券面图片
    var couponImageView : UIImageView!
    // 呱呱开代理
    weak var delegate : LWScratchCardMaskDelegate? {
        didSet {
            scratchCardMask.delegate = delegate
        }
    }
    public init(frame: CGRect, couponImage: UIImage, maskImage: UIImage,
                scratchWidth: CGFloat = 15, scratchType: CGLineCap = .square) {
        super.init(frame: frame)
        let childFrame = CGRect.init(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
        // 添加底层券面
        couponImageView = UIImageView.init(frame: childFrame)
        couponImageView.image = couponImage
        addSubview(couponImageView)
        // 添加图层
        scratchCardMask = LWScratchCardMask.init(frame: childFrame)
        scratchCardMask.image = maskImage
        scratchCardMask.lineWidth = scratchWidth
        scratchCardMask.lineType = scratchType
        addSubview(scratchCardMask)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//刮刮卡代理协议
@objc protocol LWScratchCardMaskDelegate {
    @objc optional func scratchCardMaskBegan(point: CGPoint)
    @objc optional func scratchCardMaskMoved(progress: Float)
    @objc optional func scratchCardMaskEnded(point: CGPoint)
}
// 呱呱图呱呱图层
class LWScratchCardMask: UIImageView {

    // 代理
    weak var delegate : LWScratchCardMaskDelegate?
    // 线条形状
    var lineType  : CGLineCap?
    // 线条粗细
    var lineWidth : CGFloat?
    // 保留上一次停留的位置
    var lastPoint : CGPoint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 开始触摸
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        lastPoint = touch.location(in: self)
        // 调用代理
        delegate?.scratchCardMaskBegan?(point: lastPoint!)
    }
    // 滑动
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let point = lastPoint, let img = image else {
            return
        }
        let newPoint  = touch.location(in: self)
        // 清除两点的图层
        eraseMask(fromPoint: point, toPoint: newPoint)
        lastPoint = newPoint
        // 计算刮开的百分比
        delegate?.scratchCardMaskMoved?(progress: getAlphaPixelPercent(img: img))
    }
    
    // 结束
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.first != nil else {
            return
        }
        delegate?.scratchCardMaskEnded?(point: lastPoint!)
    }
    
    
    // 清除两点的图层
    func eraseMask(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
        // 先将图片绘制到上下文中
        image?.draw(in: bounds)
        // 再绘制线条
        let path = CGMutablePath()
        path.move(to: fromPoint)
        path.addLine(to: toPoint)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setShouldAntialias(true)
        context?.setLineCap(lineType!)
        context?.setLineWidth(lineWidth!)
        // 混合模式设置为清除
        context?.setBlendMode(.clear)
        context?.addPath(path)
        context?.strokePath()
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
    }
    
    //获取透明像素占总像素的百分比
       private func getAlphaPixelPercent(img: UIImage) -> Float {
           //计算像素总个数
           let width = Int(img.size.width)
           let height = Int(img.size.height)
           let bitmapByteCount = width * height
            
           //得到所有像素数据
           let pixelData = UnsafeMutablePointer<UInt8>.allocate(capacity: bitmapByteCount)
           let colorSpace = CGColorSpaceCreateDeviceGray()
           let context = CGContext(data: pixelData,
                                   width: width,
                                   height: height,
                                   bitsPerComponent: 8,
                                   bytesPerRow: width,
                                   space: colorSpace,
                                   bitmapInfo: CGBitmapInfo(rawValue:
                                       CGImageAlphaInfo.alphaOnly.rawValue).rawValue)!
           let rect = CGRect(x: 0, y: 0, width: width, height: height)
           context.clear(rect)
           context.draw(img.cgImage!, in: rect)
            
           //计算透明像素个数
           var alphaPixelCount = 0
           for x in 0...Int(width) {
               for y in 0...Int(height) {
                   if pixelData[y * width + x] == 0 {
                       alphaPixelCount += 1
                   }
               }
           }
            
           free(pixelData)
            
           return Float(alphaPixelCount) / Float(bitmapByteCount)
       }
    
    
    
}
