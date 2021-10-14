//
//  RealmConfigurator.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 23.09.2021.
//

import RealmSwift

enum RealmConfigurator {
    static let baseConfiguration = Realm.Configuration(
        encryptionKey: encryptionKey,
        schemaVersion: schemaVersion,
        migrationBlock: migrationBlock,
        shouldCompactOnLaunch: shouldCompactOnLaunch
    )
}

private extension RealmConfigurator {
    static var encryptionKey = EncryptionKey.getKey()
    static var schemaVersion: UInt64 = 1
    static var shouldCompactOnLaunch: ((Int, Int) -> Bool)? = { totalBytes, usedBytes in
        // Compact if the file is over 100MB in size and less than 50% used
        let oneHundredMB = 100 * 1024 * 1024
        return (totalBytes > oneHundredMB) && (Double(usedBytes) / Double(totalBytes)) < 0.5
    }
}

// MARK: - Migration

private extension RealmConfigurator {
    static func renameProductObjectProperty(_ migration: Migration) {
        migration.renameProperty(onType: ProductObject.className(), from: "desc", to: "descriptionText")
    }
    
    static func updateProductObjectProperty(_ migration: Migration) {
        migration.enumerateObjects(ofType: ProductObject.className()) { oldObject, newObject in
            let price = PriceObject()
            price.usd = Decimal128(value: oldObject!["priceUSD"]!)
            newObject!["price"] = migration.create(PriceObject.className(), value: price)
        }
    }
    
    static func updateOrderItemObjectProperty(_ migration: Migration) {
        migration.enumerateObjects(ofType: OrderItemObject.className()) { oldObject, newObject in
            let price = PriceObject()
            price.usd = Decimal128(value: oldObject!["priceUSD"]!)
            newObject!["price"] = migration.create(PriceObject.className(), value: price)
        }
    }
    
    static var migrationBlock: MigrationBlock = { migration, oldSchemaVersion in
        if oldSchemaVersion < 1 {
            renameProductObjectProperty(migration)
            updateProductObjectProperty(migration)
            updateOrderItemObjectProperty(migration)
        }
    }
}
