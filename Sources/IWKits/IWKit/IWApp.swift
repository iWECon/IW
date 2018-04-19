//  Created by iWe on 2017/9/20.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

/// (App 相关信息).
public class IWApp: NSObject {
    
    private struct Key {
        /// App version
        static let versionKey = "CFBundleShortVersionString"
        
        /// App build version
        static let buildKey = "CFBundleVersion"
        
        /// App name
        static let displayNameKey = "CFBundleDisplayName"
        
        static let bundleNameKey = "CFBundleName"
    }
    
    public static var infoDictionary: [String: Any]? = { return Bundle.main.infoDictionary }()
    
    /// App Version.
    /// (Version 关键词被OC占用).
    public static var shortVersion: String? {
        return infoDictionary?[Key.versionKey] as? String
    }
    
    /// Build.
    /// (Build 编译号).
    public static var build: String? {
        return infoDictionary?[Key.buildKey] as? String
    }
    
    /// App Name.
    /// (App 名称).
    public static var name: String? {
        return infoDictionary?[Key.displayNameKey] as? String
    }
    
    /// (支持旋转, 设置后会响应 CGFloat.screenWidth, .screenHeight 动态取值).
    public static var supportRotation = false
    
    /// (project name / bundle name).
    public static var bundleName: String? {
        return infoDictionary?[Key.bundleNameKey] as? String
    }
}

