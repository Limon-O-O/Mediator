//
//  Mediator.swift
//  God
//
//  Created by Limon on 27/02/2017.
//  Copyright © 2017 Limon.F. All rights reserved.
//

import Foundation

public class Mediator: NSObject {

    public static let shared = Mediator()

    fileprivate lazy var cachedTarget: [String: NSObject] = [:]
}

extension Mediator {

    /// 远程App调用入口
    /// scheme://[target]/[action]?[params]
    /// url sample:
    /// aaa://targetA/actionB?id=1234
    public func performAction(with url: URL) -> NSObject? {

        var params: [String: Any] = [:]

        guard let urlString = url.query else {
            return nil
        }

        for param in urlString.components(separatedBy: "&") {
            let elts = param.components(separatedBy: "=")
            if elts.count < 2 {
                continue
            }
            params[elts.first!] = elts.last!
        }

        // 这里这么写主要是出于安全考虑，防止黑客通过远程方式调用本地模块。这里的做法足以应对绝大多数场景，如果要求更加严苛，也可以做更加复杂的安全逻辑。
        let actionName = url.path.replacingOccurrences(of: "/", with: "")
        if actionName.hasPrefix("native") {
            return nil
        }

        // 这个 demo 针对 URL 的路由处理非常简单，就只是取对应的 target 名字和 method 名字，但这已经足以应对绝大部份需求。如果需要拓展，可以在这个方法调用之前加入完整的路由逻辑
        guard let host = url.host else {
            return nil
        }

        return performTarget(host, action: actionName, params: params)
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
