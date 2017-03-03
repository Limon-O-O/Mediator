//
//  Mediator.swift
//  God
//
//  Created by Limon on 27/02/2017.
//  Copyright © 2017 Limon.F. All rights reserved.
//

import Foundation

public protocol Coolie: class {

    func mediatorCannotParse(_ url: URL)
    func mediatorCannotMatchScheme(of url: URL)
    func mediatorCannotMatch(_ target: String, action: String, of url: URL)

    /// 无法匹配 User 或 Password
    /// return 是否允许继续执行
    func mediatorCannotMatch(_ user: String, password: String, of url: URL) -> Bool
}

public class Mediator {

    public static let shared = Mediator()

    public weak var coolie: Coolie?

    public var urlRouteMapConfigure: URLRouteMapConfigure?

    private init() {}

    fileprivate lazy var cachedTarget: [String: NSObject] = [:]

    fileprivate lazy var urlRouteMap: URLRouteMap? = {
        guard let filePath = self.urlRouteMapConfigure?.routeMapFilePath else { return nil }
        return URLRouteMap(filePath: filePath)
    }()
}

extension Mediator {

    /// 远程调用入口
    /// scheme://[user]:[password]@[target]/[action]?[params]
    /// url sample:
    /// "myapp://Limon:123456@targetA/actionB?id=1234&page=2"
    public func performAction(with url: URL) -> NSObject? {

        guard let routeMapConfigure = urlRouteMapConfigure else {
            assert(false, "urlRouteMapConfigure is empty!")
            return nil
        }

        guard let parser = Parser(url: url) else {
            coolie?.mediatorCannotParse(url)
            return nil
        }

        if routeMapConfigure.scheme != parser.scheme {
            coolie?.mediatorCannotMatchScheme(of: url)
            return nil
        }

        guard let urlRouteMap = urlRouteMap, let target = urlRouteMap[parser.target], let action = target.actions[parser.action] else {
            coolie?.mediatorCannotMatch(parser.target, action: parser.action, of: url)
            return nil
        }

        if target.allVerifySkip {
            return performTarget(target.name, action: action.name, params: parser.params)
        }

        if (parser.user != routeMapConfigure.user || parser.password != routeMapConfigure.password) && !action.verifySkip {
            let next = coolie?.mediatorCannotMatch(parser.user, password: parser.password, of: url) ?? false
            if !next {
                return nil
            }
        }

        return performTarget(target.name, action: action.name, params: parser.params)
    }

    /// 本地组件调用入口
    public func performTarget(_ targetName: String, action actionName: String, params: [String: Any], shouldCacheTarget: Bool = false) -> NSObject? {

        let targetClassString = String(format: "Target_%@", targetName)

        let target = cachedTarget[targetClassString] ?? (NSClassFromString(targetClassString) as? NSObject.Type)?.init()

        guard let unwrappedTarget = target else {
            // 这里是处理无响应请求的地方之一，这个 demo 做得比较简单，如果没有可以响应的 target，就直接 return 了。实际开发过程中是可以事先给一个固定的 target 专门用于在这个时候顶上，然后处理这种请求的
            return nil
        }

        if shouldCacheTarget {
            self.cachedTarget[targetClassString] = unwrappedTarget
        }

        var result: AnyObject?
        let actionString = String(format: "Action_%@", actionName)
        let action = Selector(actionString)

        if unwrappedTarget.responds(to: action) {
            result = unwrappedTarget.perform(action, with: params)?.takeUnretainedValue()
        } else {

            let actionString = String(format: "Action_%@WithParams:", actionName)
            let action = Selector(actionString)

            if unwrappedTarget.responds(to: action) {
                result = unwrappedTarget.perform(action, with: params)?.takeUnretainedValue()
            } else {

                // 这里是处理无响应请求的地方，如果无响应，则尝试调用对应 target 的 notFound 方法统一处理
                let action = Selector(("Action_NotFoundWithParams:"))
                if unwrappedTarget.responds(to: action) {
                    result = unwrappedTarget.perform(action, with: params)?.takeUnretainedValue()
                } else {
                    // 这里也是处理无响应请求的地方，在 notFound 都没有的时候，这个 demo 是直接 return 了。实际开发过程中，可以用前面提到的固定的 target 顶上的。
                    cachedTarget.removeValue(forKey: targetClassString)
                }
            }
        }

        return result as? NSObject
    }

    public func releaseCachedTarget(with targetName: String) {
        let targetClassString = String(format: "Target_%@", targetName)
        cachedTarget.removeValue(forKey: targetClassString)
    }
}


