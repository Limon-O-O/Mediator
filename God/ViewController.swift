//
//  ViewController.swift
//  God
//
//  Created by Limon on 27/02/2017.
//  Copyright © 2017 Limon.F. All rights reserved.
//

import UIKit
import Mediator

public class User: NSObject {
    let nickname = "Limon"
}

class Parent: NSObject {
    func parentSelector(_ arg: String) {
        print(" ---> Selected: \(arg)")
    }
    func test(_ selectorString: String, _ printString: String) {
        let selector: Selector = Selector(selectorString)
        if self.responds(to: selector) {
            self.perform(selector, with: printString)
        }
    }
}

class Child: Parent {
    func childSelector(_ arg: String) -> User {
        print(" ---> Child selected: \(arg)")
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

        /*
        let parent = Parent()
        let child = Child()

        parent.test("parentSelector:", "apple") // Works
        child.test("parentSelector:", "banana") // Works
        child.test("childSelector:", "coffee") // Works
        child.test("namedChildSelectorWithArg:", "daffodil")
        */

        let callbackAction: ([String: Any]) -> Void = { info in
            print("Login callbacked with info: \(info)")
        }

        let login = Mediator.shared.loginViewController(with: UIColor.red, callbackAction: callbackAction)!
        navigationController?.pushViewController(login, animated: true)

        print("Did Login: \(Mediator.shared.didLogin())")
    }
}

