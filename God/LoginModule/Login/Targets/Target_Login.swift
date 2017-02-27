//
//  Target_Login.swift
//  God
//
//  Created by Limon on 27/02/2017.
//  Copyright © 2017 Limon.F. All rights reserved.
//

import UIKit

@objc(Target_Login)
class Target_Login: NSObject {

    func Action_LoginViewController(params: [String: Any]) -> UIViewController {
        let viewController = LoginViewController()
        viewController.innateParams = params
        return viewController
    }
}
