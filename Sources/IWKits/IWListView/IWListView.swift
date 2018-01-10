//  Created by iWe on 2017/6/14.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

/// UITableView Override.
/// (UITableView 的子类, 相比较增加了更多便捷功能).
public class IWListView: UITableView {
    
    /// (是否为第一次加载数据).
    public final var isFirstReloadData: Bool!
    /// (是否正在刷新).
    public final var isRefreshing: Bool!
    /// (是否开启自动反选, 用于 didselect 中, 为 true 时自动触发 deselect 操作).
    public final var isAutoDeselect: Bool = true
    
    /// (是否隐藏横向&竖直的滚动条).
    public final var isHideVandHScrollIndicator: Bool = false {
        willSet {
            self.showsVerticalScrollIndicator = !newValue
            self.showsHorizontalScrollIndicator = !newValue
        }
    }
    /// (是否隐藏 Cell 下划线).
    public final var isHideSeparator: Bool = false {
        willSet {
            if newValue {
                self.separatorStyle = .none
            } else {
                self.separatorStyle = .singleLine
            }
        }
    }
    
    
    private final var tapToHideKeyborderGesture: UITapGestureRecognizer?
    /// (是否在 touch 时隐藏 keyboard).
    public final var isTouchHideKeyborder: Bool = false {
        willSet {
            if newValue {
                let tap = UITap(target: self, action: #selector(IWListView.touchHideKeyboard))
                self.tapToHideKeyborderGesture = tap
                self.addGestureRecognizer(tap)
            } else {
                if self.tapToHideKeyborderGesture != nil {
                    self.removeGestureRecognizer(tapToHideKeyborderGesture!)
                    self.tapToHideKeyborderGesture = nil
                }
            }
        }
    }
    
    fileprivate var moveToSuperView: UIView?
    
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        _init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _init() {
        initUserInterface()
    }
    
    public override func reloadData() {
        super.reloadData()
    }
    
}


extension IWListView {
    
    fileprivate func initUserInterface() -> Void {
        
        isFirstReloadData = false
        isRefreshing = false
        
        autoresizingMask = .flexibleWidth
        
        separatorColor = .groupTableViewBackground
        
        tableHeaderView = UIView(frame: MakeRect(0, 0, .screenWidth, .min))
        tableFooterView = UIView()
        
        registReusable(UITableViewCell.self)
    }
    
}

extension IWListView {
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        moveToSuperView = newSuperview
        iwe.autoSetEdge(moveToSuperView)
    }
    
    @objc public final func touchHideKeyboard() {
        self.endEditing(true)
    }
}

