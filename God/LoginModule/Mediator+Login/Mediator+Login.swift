//
//  Mediator+Login.swift
//  God
//
//  Created by Limon on 27/02/2017.
//  Copyright © 2017 Limon.F. All rights reserved.
//

import UIKit
import Mediator

extension Mediator {

    public func loginViewController(with color: UIColor, callbackAction: @escaping (([String: Any]) -> Void)) -> UIViewController? {
        let deliverParams: [String: Any] = ["color": color, "callbackAction": callbackAction]
        return performTarget("Login", action: "LoginViewController", params: deliverParams, shouldCacheTarget: false) as? UIViewController
    }
}
