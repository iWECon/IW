//  Created by iWe on 2017/9/20.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit
import WebKit

open class IWWebView: WKWebView {
    
    fileprivate var _superView: UIView?
    
    public override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        _init()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _init() {
        
    }
    
}

extension IWWebView {
    
//    open override func willMove(toSuperview newSuperview: UIView?) {
//        _superView = newSuperview
//        scrollView.iwe.autoSetEdge(_superView)
//    }
}

