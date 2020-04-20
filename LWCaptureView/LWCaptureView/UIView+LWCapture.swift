
import UIKit
import WebKit

 extension UIView {
  
    
   
    public func containsWKWebView() -> Bool {
           if self.isKind(of: WKWebView.self) {
               return true
           }
           for subView in self.subviews {
               if (subView.containsWKWebView()) {
                   return true
               }
           }
           return false
       }
       
       public func capture(_ completionHandler: (_ capturedImage: UIImage?) -> Void) {
           
//           self.isCapturing = true
           
        let bounds = self.bounds
           
           UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
           
           let context = UIGraphicsGetCurrentContext()
           context?.saveGState()
        context?.translateBy(x: -self.frame.origin.x, y: -self.frame.origin.y);
           
           if (containsWKWebView()) {
               self.drawHierarchy(in: bounds, afterScreenUpdates: true)
           }else{
               self.layer.render(in: context!)
           }
           let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
           
           context?.restoreGState();
           UIGraphicsEndImageContext()
           
//           self.isCapturing = false
           
           completionHandler(capturedImage)
       }

}
