//
//  AppDelegate.swift
//  God
//
//  Created by Limon on 27/02/2017.
//  Copyright © 2017 Limon.F. All rights reserved.
//

import UIKit
import Mediator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        Mediator.shared.coolie = self

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let result = Mediator.shared.performAction(with: url)
        return result != nil
    }
}

extension AppDelegate: Coolie {

    func mediatorCannotParse(_ url: URL) {
        print("Mediator can not parse url: \(url)")
    }

    func mediatorCannotMatchScheme(of url: URL) {
        print("Mediator can not parse scheme of url: \(url)")
    }

    func mediatorCannotMatch(_ target: String, action: String, of url: URL) {
        print("Mediator can not match `target` or `action` of url: \(url)")
    }

    func mediatorCannotMatch(_ user: String, password: String, of url: URL) -> Bool {
        print("Mediator can not match `user` or `password` of url: \(url)")
        return false
    }

    func mediatorNotFound(_ target: String) {
        print("Mediator not found \(target)")
    }

    func mediatorNotFound(_ action: String, of target: NSObject) {
        print("Mediator not found \(action) of \(target)")
    }
}
