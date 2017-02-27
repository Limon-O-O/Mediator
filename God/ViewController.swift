//
//  ViewController.swift
//  God
//
//  Created by Limon on 27/02/2017.
//  Copyright © 2017 Limon.F. All rights reserved.
//

import UIKit
import Mediator

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let callbackAction: ([String: Any]) -> Void = { info in
            print("Login callbacked with info: \(info)")
        }

        let login = Mediator.shared.loginViewController(with: UIColor.red, callbackAction: callbackAction)!
        navigationController?.pushViewController(login, animated: true)
    }
}

