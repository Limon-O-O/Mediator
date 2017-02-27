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

    /// 返回值必须是 NSObject，不然 `perform(_ aSelector: Selector!, with object: Any!)` 找不到方法
    func Action_DidLogin() -> [String: Any] {
        return ["result": true]
    }

    func Action_NotFound(params: [String: Any]) {
        print("Not Found. params: \(params)")
    }
}
