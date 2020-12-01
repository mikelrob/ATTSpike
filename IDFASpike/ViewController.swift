//
//  ViewController.swift
//  IDFA Spike
//
//  Created by Mike Robinson on 01/12/2020.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var permissionStatusLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var bundleLabel: UILabel!

    let privacyManager = PrivacyManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updatePermissionStatusLabel()
        updateBundleLabel()
    }

    @IBAction func button1Tapped(_ sender: Any) {

        let idfa = privacyManager.getIDFA()
        bottomLabel.text = "IDFA: \(idfa)"

    }

    @IBAction func button2Tapped(_ sender: Any) {
        privacyManager.requestPermission {
            self.updatePermissionStatusLabel()
        }
    }

    func updatePermissionStatusLabel() {
        DispatchQueue.main.async {
            self.permissionStatusLabel.text = self.privacyManager.currentPermission
        }
    }

    func updateBundleLabel() {
        DispatchQueue.main.async {
            self.bundleLabel.text = InfoPlist.bundleIndentifier
        }
    }

}

