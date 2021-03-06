#if os(OSX)
import Cocoa
#else
import Foundation
import UIKit
#endif

public enum UIBackgroundModes: String {
    case audio
    case location
    case voip
    case fetch
    case remoteNotification = "remote-notification"
    case newsstandContent = "newsstand-content"
    case externalAccessory = "external-accessory"
    case bluetoothCentral = "bluetooth-central"
    case bluetoothPeripheral = "bluetooth-peripheral"
}

/// Info.plist assistant.
public class InfoPlist {

    /// Info.plist as a dictionary objec
    public static var dictionary: [String: Any]? {
        return Bundle.main.infoDictionary
    }

    /// Getting string, could be empty
    ///
    /// - Parameter key: Key String
    /// - Returns: `String` object, could be empty
    public static func getStringValue(forKey key: String) -> String {
        return (getValue(forKey: key) as? String) ?? ""
    }

    /// Getting string, could be `nil`
    ///
    /// - Parameter key: Key String
    /// - Returns: `String?` object, could be `nil`
    public static func getString(forKey key: String) -> String? {
        return getValue(forKey: key) as? String
    }

    /// Getting string, could be `nil`
    ///
    /// - Parameter key: Key String
    /// - Returns: `String?` object, could be `nil`
    public static func getRequiredString(forKey key: String) -> String {
        let value = getValue(forKey: key) as? String
        assert(value != nil, "\(key) should be available in Info.plist")
        return value!
    }

    /// Getting Bool value
    ///
    /// - Parameter key: Key String
    /// - Returns: `Bool` value
    public static func getBool(forKey key: String) -> Bool {
        return (InfoPlist.getValue(forKey: key) as? Bool) ?? false
    }

    /// Getting value, could be `nil`
    ///
    /// - Parameter key: Key String
    /// - Returns: `Any?`, could be `nil`
    public static func getValue(forKey key: String) -> Any? {
        guard let infoDictionary = InfoPlist.dictionary else {
            return nil
        }
        return infoDictionary[key]
    }
}

// MARK: - Common
public extension InfoPlist {
    /// CFBundleDisplayName
    static var bundleDisplayName: String = {
        return InfoPlist.getRequiredString(forKey: "CFBundleDisplayName")
    }()

    /// CFBundleName
    static var bundleName: String = {
        return InfoPlist.getRequiredString(forKey: "CFBundleName")
    }()

    /// Return CFBundleDisplayName if not empty, otherwise return CFBundleName
    static var name: String = {
        return !bundleDisplayName.isEmpty ? bundleDisplayName : bundleName
    }()

    /// CFBundleShortVersionString
    static var version: String = {
        return InfoPlist.getRequiredString(forKey: "CFBundleShortVersionString")
    }()

    /// CFBundleVersion
    static var build: String = {
        return InfoPlist.getRequiredString(forKey: "CFBundleVersion")
    }()

    /// CFBundleExecutable
    static var executable: String = {
        return InfoPlist.getStringValue(forKey: "CFBundleExecutable")
    }()

    /// CFBundleIdentifier
    static var bundleIndentifier: String = {
        return InfoPlist.getRequiredString(forKey: "CFBundleIdentifier")
    }()

    /// CFBundleURLTypes.first[CFBundleURLSchemes]
    static var schemes: [String] = {
        guard let urlTypes = InfoPlist.getValue(forKey: "CFBundleURLTypes") as? [AnyObject],
            let urlType = urlTypes.first as? [String: AnyObject],
            let urlSchemes = urlType["CFBundleURLSchemes"] as? [String] else {
                return []
        }

        return urlSchemes
    }()

    /// Main Scheme String, could be `nil`
    static var mainScheme: String? = {
        return schemes.first
    }()
}

// MARK: - App Center Token
extension InfoPlist {
    static var appCenterToken: String {
        return InfoPlist.getRequiredString(forKey: "AppCenterToken")
    }
}

// MARK: - Version Comparison
public extension InfoPlist {

    /// Compare tow version string (eg: `1.0.0`, `2.0.1`, `3.0`)
    ///
    /// - Parameters:
    ///   - lhs: First version string
    ///   - rhs: Second version string
    /// - Returns: Compare result
    static func compare(version lhs: String, with rhs: String) -> ComparisonResult {
        guard !lhs.isEmpty else {
            if rhs.isEmpty {
                return .orderedSame
            }
            return .orderedAscending
        }
        guard !rhs.isEmpty else {
            return .orderedDescending
        }

        return lhs.compare(rhs, options: .numeric, range: rhs.range(of: rhs), locale: nil)
    }

    /// Compare tow version string (eg: `1.0.0`, `2.0.1`, `3.0`)
    ///
    /// - Parameters:
    ///   - lhs: First version string
    ///   - rhs: Second version string
    /// - Returns: If `lhs` is equal to `rhs`
    static func version(_ lhs: String, equalTo rhs: String) -> Bool {
        return compare(version: lhs, with: rhs) == .orderedSame
    }

    /// Compare tow version string (eg: `1.0.0`, `2.0.1`, `3.0`)
    ///
    /// - Parameters:
    ///   - lhs: First version string
    ///   - rhs: Second version string
    /// - Returns: If `lhs` is greater than `rhs`
    static func version(_ lhs: String, greaterThan rhs: String) -> Bool {
        return compare(version: lhs, with: rhs) == .orderedDescending
    }

    /// Compare tow version string (eg: `1.0.0`, `2.0.1`, `3.0`)
    ///
    /// - Parameters:
    ///   - lhs: First version string
    ///   - rhs: Second version string
    /// - Returns: If `lhs` is less than `rhs`
    static func version(_ lhs: String, lessThan rhs: String) -> Bool {
        return compare(version: lhs, with: rhs) == .orderedAscending
    }

    /// Compare tow version string (eg: `1.0.0`, `2.0.1`, `3.0`)
    ///
    /// - Parameters:
    ///   - lhs: First version string
    ///   - rhs: Second version string
    /// - Returns: If `lhs` is greater than or equal to `rhs`
    static func version(_ lhs: String, greaterThanOrEqualTo rhs: String) -> Bool {
        return compare(version: lhs, with: rhs) != .orderedAscending
    }

    /// Compare tow version string (eg: `1.0.0`, `2.0.1`, `3.0`)
    ///
    /// - Parameters:
    ///   - lhs: First version string
    ///   - rhs: Second version string
    /// - Returns: If `lhs` is less than or equal to `rhs`
    static func version(_ lhs: String, lessThanOrEqualTo rhs: String) -> Bool {
        return compare(version: lhs, with: rhs) != .orderedDescending
    }
}

#if os(iOS)
// MARK: - iOS Only
public extension InfoPlist {

    /// UIFileSharingEnabled
    @available(iOS 7.0, *)
    static var iTunesFileSharingEnabled: Bool = {
        return InfoPlist.getBool(forKey: "UIFileSharingEnabled")
    }()

    /// UIStatusBarHidden
    @available(iOS 7.0, *)
    static var isStatusBarHidden: Bool = {
        return InfoPlist.getBool(forKey: "UIStatusBarHidden")
    }()

    /// UIStatusBarStyle
    @available(iOS 7.0, *)
    static var statusBarStyleString: String? = {
        return InfoPlist.getString(forKey: "UIStatusBarStyle")
    }()

    /// UIStatusBarStyle
    @available(iOS 7.0, *)
    static var statusBarStyle: UIStatusBarStyle? = {
        guard let style = InfoPlist.statusBarStyleString else {
            return nil
        }
        switch style {
        case "UIStatusBarStyleDefault":
            return UIStatusBarStyle.default
        case "UIStatusBarStyleLightContent":
            return UIStatusBarStyle.lightContent
        default:
            return nil
        }
    }()

    /// UIViewControllerBasedStatusBarAppearance
    @available(iOS 7.0, *)
    static var viewControllerBasedStatusBarAppearance: Bool = {
        return InfoPlist.getBool(forKey: "UIViewControllerBasedStatusBarAppearance")
    }()

    /// UISupportedInterfaceOrientations
    @available(iOS 7.0, *)
    static var iPhoneSupportedInterfaceOrientationStrings: [String] = {
        (InfoPlist.getValue(forKey: "UISupportedInterfaceOrientations") as? [String]) ?? []
    }()

    /// UISupportedInterfaceOrientations
    @available(iOS 7.0, *)
    static var iPhoneSupportedInterfaceOrientations: [UIInterfaceOrientation] = {
        return InfoPlist.supportedInterfaceOrientations(of: InfoPlist.iPhoneSupportedInterfaceOrientationStrings)
    }()

    /// UISupportedInterfaceOrientations~ipad
    @available(iOS 7.0, *)
    static var iPadSupportedInterfaceOrientationStrings: [String] = {
        return (InfoPlist.getValue(forKey: "UISupportedInterfaceOrientations~ipad") as? [String]) ?? []
    }()

    /// UISupportedInterfaceOrientations~ipad
    @available(iOS 7.0, *)
    static var iPadSupportedInterfaceOrientations: [UIInterfaceOrientation] = {
        return InfoPlist.supportedInterfaceOrientations(of: InfoPlist.iPadSupportedInterfaceOrientationStrings)
    }()

    @available(iOS 7.0, *)
    private static func supportedInterfaceOrientations(of strings: [String]) -> [UIInterfaceOrientation] {
        return strings.map { UIInterfaceOrientation(string: $0) }
    }

    static var backgroundModes: [UIBackgroundModes] {
        guard let modes = InfoPlist.getValue(forKey: "UIBackgroundModes") as? [String] else { return [] }
        return modes.compactMap { UIBackgroundModes(rawValue: $0) }
    }
}
#endif

// MARK: - iOS 9 or macOS 10.11
public extension InfoPlist {

    /// NSAppTransportSecurity
    @available(iOS 9.0, OSX 10.11, *)
    static var appTransportSecurityConfiguration: [String: Any]? = {
        return InfoPlist.getValue(forKey: "NSAppTransportSecurity") as? [String: Any]
    }()

    /// NSAllowsArbitraryLoads
    @available(iOS 9.0, OSX 10.11, *)
    static var allowsArbitraryLoads: Bool = {
        guard let infoDictionary = InfoPlist.appTransportSecurityConfiguration else {
            return false
        }
        return (infoDictionary["NSAllowsArbitraryLoads"] as? Bool) ?? false
    }()

    #if os(iOS)
    /// UIRequiresFullScreen
    @available(iOS 9.0, *)
    static var requiresFullScreen: Bool = {
        return InfoPlist.getBool(forKey: "UIRequiresFullScreen")
    }()
    #endif
}

// MARK: - Privacy
public extension InfoPlist {

    /// Privacy - NSBluetoothPeripheralUsageDescription
    @available(iOS 10.0, OSX 10.12, *)
    static var bluetoothPeripheralUsageDescription: String? = {
        return InfoPlist.getString(forKey: "NSBluetoothPeripheralUsageDescription")
    }()

    /// Privacy - NSCalendarsUsageDescription
    @available(iOS 10.0, OSX 10.12, *)
    static var calendarsUsageDescription: String? = {
        return InfoPlist.getString(forKey: "NSCalendarsUsageDescription")
    }()

    /// Privacy - NSCameraUsageDescription
    @available(iOS 10.0, OSX 10.12, *)
    static var cameraUsageDescription: String? = {
        return InfoPlist.getString(forKey: "NSCameraUsageDescription")
    }()

    /// Privacy - NSContactsUsageDescription
    @available(iOS 10.0, OSX 10.12, *)
    static var contactsUsageDescription: String? = {
        return InfoPlist.getString(forKey: "NSContactsUsageDescription")
    }()

    /// Privacy - NSHealthShareUsageDescription
    @available(iOS 10.0, OSX 10.12, *)
    static var healthShareUsageDescription: String? = {
        return InfoPlist.getString(forKey: "NSHealthShareUsageDescription")
    }()

    /// Privacy - NSHealthUpdateUsageDescription
    @available(iOS 10.0, OSX 10.12, *)
    static var healthUpdateUsageDescription: String? = {
        return InfoPlist.getString(forKey: "NSHealthUpdateUsageDescription")
    }()

    /// Privacy - NSHomeKitUsageDescription
    @available(iOS 10.0, OSX 10.12, *)
    static var homeKitUsageDescription: String? = {
        return InfoPlist.getString(forKey: "NSHomeKitUsageDescription")
    }()

    /// Privacy - NSLocationAlwaysUsageDescription
    @available(iOS 10.0, OSX 10.12, *)
    static var locationAlwaysUsageDescription: String? = {
        return InfoPlist.getString(forKey: "NSLocationAlwaysUsageDescription")
    }()

    /// Privacy - NSLocationUsageDescription
    @available(iOS 10.0, OSX 10.12, *)
    static var locationUsageDescription: String? = {
        return InfoPlist.getString(forKey: "NSLocationUsageDescription")
    }()

    /// Privacy - NSLocationWhenInUseUsageDescription
    @available(iOS 10.0, OSX 10.12, *)
    static var locationWhenInUseUsageDescription: String? = {
        return InfoPlist.getString(forKey: "NSLocationWhenInUseUsageDescription")
    }()

    /// Privacy - NSAppleMusicUsageDescription
    @available(iOS 10.0, OSX 10.12, *)
    static var appleMusicUsageDescription: String? = {
        return InfoPlist.getString(forKey: "NSAppleMusicUsageDescription")
    }()

    /// Privacy - NSMicrophoneUsageDescription
    @available(iOS 10.0, OSX 10.12, *)
    static var microphoneUsageDescription: String? = {
        return InfoPlist.getString(forKey: "NSMicrophoneUsageDescription")
    }()

    /// Privacy - NSMotionUsageDescription
    @available(iOS 10.0, OSX 10.12, *)
    static var motionUsageDescription: String? = {
        return InfoPlist.getString(forKey: "NSMotionUsageDescription")
    }()

    /// Privacy - NSPhotoLibraryUsageDescription
    @available(iOS 10.0, OSX 10.12, *)
    static var photoLibraryUsageDescription: String? = {
        return InfoPlist.getString(forKey: "NSPhotoLibraryUsageDescription")
    }()

    /// Privacy - NSRemindersUsageDescription
    @available(iOS 10.0, OSX 10.12, *)
    static var remindersUsageDescription: String? = {
        return InfoPlist.getString(forKey: "NSRemindersUsageDescription")
    }()

    /// Privacy - NSSiriUsageDescription
    @available(iOS 10.0, OSX 10.12, *)
    static var siriUsageDescription: String? = {
        return InfoPlist.getString(forKey: "NSSiriUsageDescription")
    }()

    /// Privacy - NSSpeechRecognitionUsageDescription
    @available(iOS 10.0, OSX 10.12, *)
    static var speechRecognitionUsageDescription: String? = {
        return InfoPlist.getString(forKey: "NSSpeechRecognitionUsageDescription")
    }()

    /// Privacy - NSVideoSubscriberAccountUsageDescription
    @available(iOS 10.0, OSX 10.12, *)
    static var videoSubscriberAccountUsageDescription: String? = {
        return InfoPlist.getString(forKey: "NSVideoSubscriberAccountUsageDescription")
    }()

}

private extension UIInterfaceOrientation {
    init(string: String) {
        switch string {
        case "UIInterfaceOrientationPortrait":
            self = .portrait
        case "UIInterfaceOrientationPortraitUpsideDown":
            self = .portraitUpsideDown
        case "UIInterfaceOrientationLandscapeLeft":
            self = .landscapeLeft
        case "UIInterfaceOrientationLandscapeRight":
            self = .landscapeRight
        default:
            self = .unknown
        }
    }
}
