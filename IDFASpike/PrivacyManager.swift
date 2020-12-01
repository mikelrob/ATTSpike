//
//  PrivacyManager.swift
//  IDFA Spike
//
//  Created by Mike Robinson on 01/12/2020.
//

import Foundation
import AdSupport
import AppTrackingTransparency

class PrivacyManager {

    var currentPermission: String {
        return ATTrackingManager.trackingAuthorizationStatus.description
    }

    func requestPermission(completion: (() -> Void)? = nil) {

        print("Requesting tracking status from App Transparency Tracking Manager")
        ATTrackingManager
            .requestTrackingAuthorization { status in
            print("\(status)")
                completion?()
        }
    }

    func getIDFA() -> UUID {
        return ASIdentifierManager.shared().advertisingIdentifier
    }

}

extension ATTrackingManager.AuthorizationStatus: CustomStringConvertible {
    public var description: String {
        switch ATTrackingManager.trackingAuthorizationStatus {
        case .notDetermined:
            return "Not Determined"
        case .restricted:
            return "Restricted"
        case .denied:
            return "Denied"
        case .authorized:
            return "Authorized"
        @unknown default:
            return " Unknown (default)"
        }
    }

}

extension UUID {
    static var allZeros = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
}
