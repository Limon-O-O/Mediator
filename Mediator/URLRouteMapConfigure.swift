//
//  URLRouteMapConfigure.swift
//  God
//
//  Created by Limon on 03/03/2017.
//  Copyright © 2017 Limon.F. All rights reserved.
//

import Foundation

public struct URLRouteMapConfigure {

    public let scheme: String
    public let user: String
    public let password: String
    public let routeMapFilePath: String

    public init(scheme: String, user: String, password: String, routeMapFilePath: String) {
        self.scheme = scheme
        self.user = user
        self.password = password
        self.routeMapFilePath = routeMapFilePath
    }
}

struct URLRouteMap {

    struct Action {
        let name: String
        let verifySkip: Bool

        init?(dict: [String: Any]) {
            guard let name = dict["mapValue"] as? String else { return nil }
            self.name = name
            verifySkip = (dict["verifySkip"] as? Bool) ?? true
        }
    }

    struct Target {
        let name: String
        let allVerifySkip: Bool
        let actions: [String: Action]

        init?(dict: [String: Any]) {

            guard let name = dict["name"] as? String else { return nil }

            self.name = name
            allVerifySkip = (dict["allVerifySkip"] as? Bool) ?? true

            var template: [String: Action] = [:]
            (dict["actions"] as? [String: [String: Any]])?.forEach { key, value in
                if let action = Action(dict: value) {
                    template[key] = action
                }
            }
            actions = template
        }
    }

    private let routeMap: [String: Target]

    init?(filePath: String) {

        do {
            let url = URL(fileURLWithPath: filePath)
            let data = try Data(contentsOf: url)
            let plist = try PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)
            guard let dictArray = plist as? [String: [String: Any]] else { return nil }

            var template: [String: Target] = [:]
            dictArray.forEach { key, value in
                if let target = Target(dict: value) {
                    template[key] = target
                }
            }
            routeMap = template

        } catch {
            return nil
        }
    }

    subscript(key: String) -> Target? {
        return routeMap[key]
    }
}

struct Parser {

    let scheme: String
    let user: String
    let password: String
    let target: String
    let action: String
    let params: [String: Any]

    init?(url: URL) {

        guard let scheme = url.scheme,
            let user = url.user,
            let password = url.password,
            let host = url.host,
            let action = url.path.components(separatedBy: "/").last
            else { return nil }

        self.scheme = scheme
        self.user = user
        self.password = password
        self.target = host
        self.action = action

        params = {
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            guard let items = components?.queryItems else { return [:] }
            var infos: [String: Any] = [:]
            items.forEach {
                if let value = $0.value {
                    infos[$0.name] = value
                }
            }
            return infos
        }()
    }
}
