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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let parent = Parent()

        let result = parent.test("parentSelector:", "coffee") // Works
        print(result as! [String: Any])

        let user = parent.test("childSelector:", "apple") // No Works
        print(user as! User)

        // parent.test("namedChildSelectorWithArg:", "daffodil")


        /*
        let callbackAction: ([String: Any]) -> Void = { info in
            print("Login callbacked with info: \(info)")
        }

        let login = Mediator.shared.loginViewController(with: UIColor.red, callbackAction: callbackAction)!
        navigationController?.pushViewController(login, animated: true)

        print("Did Login: \(Mediator.shared.didLogin())")
        */
    }
}

