//
//  Config.swift
//  Example
//
//  Created by macos on 22/7/24.
//

import Foundation
import CryptoKit

struct Config: Codable {
    let API_SID_KEY: String
    let API_SECRET_KEY: String

    static func loadConfig() -> Config? {
        guard let url = Bundle.main.url(forResource: "config", withExtension: "json") else { return nil }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(Config.self, from: data)
        } catch {
            print("Error loading config: \(error)")
            return nil
        }
    }
}

struct EnvironmentConfig {
    static let config = Config.loadConfig()

    static let API_SID_KEY = config?.API_SID_KEY ?? ""
    static let API_SECRET_KEY = config?.API_SECRET_KEY ?? ""
}

func base64UrlEncode(_ data: Data) -> String {
    var base64 = data.base64EncodedString()
    base64 = base64
        .replacingOccurrences(of: "+", with: "-")
        .replacingOccurrences(of: "/", with: "_")
        .replacingOccurrences(of: "=", with: "")
    return base64
}

func getAccessToken(apiKeySid: String = EnvironmentConfig.API_SID_KEY,
                    apiKeySecret: String = EnvironmentConfig.API_SECRET_KEY,
                    userId: String,
                    ttl: Int = 3600) -> String {
    let now = Int(Date().timeIntervalSince1970)
    let exp = now + ttl

    let header: [String: Any] = ["cty": "stringee-api;v=1",
                                 "alg": "HS256",
                                 "typ": "JWT"
    ]
    let payload: [String: Any] = [
        "jti": "\(apiKeySid)-\(now)",
        "iss": apiKeySid,
        "exp": exp,
        "userId": userId
    ]

    let jwtHeader = try! JSONSerialization.data(withJSONObject: header)
    let jwtPayload = try! JSONSerialization.data(withJSONObject: payload)

    let headerBase64 = base64UrlEncode(jwtHeader)
    let payloadBase64 = base64UrlEncode(jwtPayload)

    let unsignedToken = "\(headerBase64).\(payloadBase64)"

    let key = SymmetricKey(data: Data(apiKeySecret.utf8))
    let signature = HMAC<SHA256>.authenticationCode(for: Data(unsignedToken.utf8), using: key)
    let signatureBase64 = base64UrlEncode(Data(signature))

    let token = "\(unsignedToken).\(signatureBase64)"

    return token
}
