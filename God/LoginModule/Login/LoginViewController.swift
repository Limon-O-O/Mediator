//
//  LoginViewController.swift
//  God
//
//  Created by Limon on 27/02/2017.
//  Copyright © 2017 Limon.F. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var innateParams: [String: Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = innateParams["color"] as? UIColor
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        (innateParams["callbackAction"] as? ([String: Any]) -> Void)?(["nickname": "Limon"])
    }

    deinit {
        print("LoginViewController Deinit")
    }
}
