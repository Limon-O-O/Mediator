//
//  ViewController.swift
//  God
//
//  Created by Limon on 27/02/2017.
//  Copyright © 2017 Limon.F. All rights reserved.
//

import UIKit
import Mediator

public struct User {
    let nickname = "Limon"
}

class Parent: NSObject {

    func test(_ selectorString: String, _ printString: String) -> AnyObject? {
        let selector: Selector = Selector(selectorString)
        return self.perform(selector, with: printString)?.takeUnretainedValue()
    }

    func parentSelector(_ arg: String) -> [String: Any] {
        return ["result": false]
    }

    func childSelector(_ arg: String) -> User {
        return User()
    }

    func namedChildSelector(arg: String) {
        print(" ---> Child selected: \(arg)")
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction private func test(_ sender: UIButton) {

        let callbackAction: ([String: Any]) -> Void = { info in
            print("Login callbacked with info: \(info)")
        }

        if let login = Mediator.shared.loginViewController(with: UIColor.red, callbackAction: callbackAction) {
            navigationController?.pushViewController(login, animated: true)
            print("Did Login: \(Mediator.shared.didLogin())")
        }
    }

    @IBAction private func testURL(_ sender: UIButton) {

        let filePath = Bundle.main.path(forResource: "RouteMapTemplate", ofType: "plist")!
        let routeMapConfigure = URLRouteMapConfigure(scheme: "God", user: "Limon", password: "123456", routeMapFilePath: filePath)
        Mediator.shared.urlRouteMapConfigure = routeMapConfigure

        /// scheme://[user]:[password]@[target]/[action]?[params]
        let testString = "God://Limon:123456@Target-Login/actionA?id=1234&page=2&name=egg"

        if let test = Mediator.shared.performAction(with: URL(string: testString)!) as? UIViewController {
            navigationController?.pushViewController(test, animated: true)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//        let parent = Parent()
//
//        let result = parent.test("parentSelector:", "coffee") // Works
//        print(result as! [String: Any])

        // let user = parent.test("childSelector:", "apple") // No Works
        // print(user as! User)

        // parent.test("namedChildSelectorWithArg:", "daffodil")
    }
}

