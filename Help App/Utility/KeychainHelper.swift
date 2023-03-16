//
//  KeychainHelper.swift
//  Help App
//
//  Created by Artem Rakhmanov on 08/03/2023.
//

import Foundation

//https://swiftsenpai.com/development/persist-data-using-keychain/
final class KeychainHelper {
    static let standard = KeychainHelper()
    
    func save(_ data: Data, service: String, account: String) {
        
        #if targetEnvironment(simulator)
        return
        #endif
        
        // Create query
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ] as CFDictionary
        
        // Add data in query to keychain
        let status = SecItemAdd(query, nil)
        
        print(status)
        
        if status == errSecDuplicateItem {
                // Item already exist, thus update it.
                let query = [
                    kSecAttrService: service,
                    kSecAttrAccount: account,
                    kSecClass: kSecClassGenericPassword,
                ] as CFDictionary

                let attributesToUpdate = [kSecValueData: data] as CFDictionary

                // Update existing item
                SecItemUpdate(query, attributesToUpdate)
            }
    }
    
    func save(jwt: String, service: String, account: String) {
        #if targetEnvironment(simulator)
        return
        #endif
        let dataRepresentation = Data(jwt.utf8)
        self.save(dataRepresentation, service: service, account: account)
    }
    
    func read(service: String, account: String) -> String? {
        #if targetEnvironment(simulator)
        return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySUQiOiI2NDA4ZWNiMjVjZGVmMjg0ZGRmN2RkNDQiLCJhY2Nlc3MiOiJhdXRob3Jpc2VkIiwiaWF0IjoxNjc4NjU0NTA1LCJleHAiOjE2OTQyMDY1MDV9.RZ9hIPQw7LCqyEVertCVr7P0MqkOvUjjcuov1SK9jiI"
        #endif
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        if let dataRepresentation = result as? Data {
            let jwt = String(data: dataRepresentation, encoding: .utf8)!
            print("key: " + jwt)
            return jwt
        } else {
            return nil
        }
    }
    
    func delete(service: String, account: String) {
        
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            ] as CFDictionary
        
        // Delete item from keychain
        SecItemDelete(query)
    }
}
