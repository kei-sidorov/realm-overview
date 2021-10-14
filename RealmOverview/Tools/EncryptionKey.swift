//
//  EncryptionKey.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 07.09.2021.
//

import Foundation

enum EncryptionKey {
    static func getKey() -> Data {
        let keychainIdentifier = "RealmDataBaseTraining.Key"
        let keychainIdentifierData = keychainIdentifier.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!
        
        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecReturnData: true as AnyObject
        ]
        
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        if status == errSecSuccess {
            return dataTypeRef as! Data
        }
        
        let keyData = NSMutableData(length: 64)!
        let result = SecRandomCopyBytes(
            kSecRandomDefault,
            64,
            keyData.mutableBytes.bindMemory(to: UInt8.self, capacity: 64)
        )
        assert(result == 0, "Failed to get random bytes")
        
        query = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecValueData: keyData
        ]
        
        status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to insert the new key in the keychain")
        
        return keyData as Data
    }
}
