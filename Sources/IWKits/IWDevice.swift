//  Created by iWe on 2017/9/20.
//  Copyright © 2017年 iWe. All rights reserved.
//

#if os(iOS)
import UIKit

/// (设备信息相关).
public class IWDevice: NSObject {
    
    public static let DeviceOrientationDidChange: String = "IWDeviceOrientationDidChange"
    
    /// (是否为 iPad).
    public static let isiPad: Bool = { return (UIDevice.current.model == "iPad") }()
    /// (是否为 iPhone).
    public static let isiPhone: Bool = { return (UIDevice.current.model == "iPhone") }()
    /// (是否为 iPhone X).
    public static let isiPhoneX: Bool = {
        return iw.isDebugMode.founded({ iw.screen.height == 812 }, elseReturn: { IWDevice.isiPhone.and(iw.screen.height == 812) })
    }()
    
    /// (设备方向).
    public static var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    /// (注册设备旋转通知, 使用 DeviceOrientationDidChange 接收通知).
    public static func registerOrientationDidChange() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(postChangeNotification), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    @objc private static func postChangeNotification() -> Void {
        NotificationCenter.default.post(name: NSNotification.Name.init(DeviceOrientationDidChange), object: orientation)
    }
    
    /// (设置 通用 关于本机 名称).
    public static var aboutPhoneName: String {
        return UIDevice.current.name
    }
    
    /// (系统类型 eg: iOS/tvOS/watchOS).
    public static var deviceName: String {
        return UIDevice.current.systemName
    }
    
    /// (设备区域化型号 eg: iPhone).
    public static var localPhoneModel: String {
        return UIDevice.current.localizedModel
    }
    
    /// (电池状态).
    public static var batterState: UIDeviceBatteryState {
        return UIDevice.current.batteryState
    }
    
    /// (电池电量).
    public static var batteryQuantity: Float {
        return UIDevice.current.batteryLevel
    }
    
    /// (是否越狱).
    public static var isJailbroken: Bool {
        // 1. 是否存在越狱文件
        if examineBreakToolPathes.filter({ FileManager.default.fileExists(atPath: $0) }).count > 0 {
            return true
        }
        // 2. 是否存在 cydia 应用
        if UIApplication.shared.canOpenURL("cydia://".toURLValue) {
            return true
        }
        // 3. 是否可以读取所有应用
        if FileManager.default.fileExists(atPath: "/User/Applications/") {
            return true
        }
        // 4. 是否可以读取环境变量
        return (getenv("DYLD_INSERT_LIBRARIES") != nil)
    }
    
    /// (设备标识, 推荐使用 IWUUID. eg: E621E1F8-C36C-495A-93FC-0C247A3E6E5F).
    public static var UUID: String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    /// (返回机型内部标识, 例如: iPhone9,1).
    public static var modelIdentifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    /// (返回机型, 例如: iPhone 7).
    public static var modelName: String {
        let identifier = modelIdentifier
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone9,1":                               return "iPhone 7"
        case "iPhone9,2":                               return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}

extension IWDevice {
    
    private static func sizeAddDigit(with size: Float) -> String {
        let kb: Float = 1024
        let mb = kb * kb;
        let gb = mb * kb;
        
        if size < 10 {
            return "0 B"
        } else if size < kb {
            return "< 1 KB"
        } else if size < mb {
            return String.init(format: "%.2f KB", size)
        } else if size < gb {
            return String.init(format: "%.2f MB", size / mb)
        } else {
            return String.init(format: "%.2f GB", size / gb)
        }
    }
    
    private static let examineBreakToolPathes: [String] = ["/Applications/Cydia.app",  "/Library/MobileSubstrate/MobileSubstrate.dylib", "/bin/bash", "/usr/sbin/sshd", "/etc/apt"]
    
}
#endif
