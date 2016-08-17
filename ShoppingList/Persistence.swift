//
//  Persistence.swift
//  ShoppingList
//
//  Created by Brent Raines on 8/17/16.
//  Copyright © 2016 Brent Raines. All rights reserved.
//

import Foundation
import RealmSwift

class Persistence {
    private static let defaultRealmConfig = Realm.Configuration(
        schemaVersion: 5,
        migrationBlock: { _, _ in }
    )
    
    static func setDefaultConfig() {
        Realm.Configuration.defaultConfiguration = defaultRealmConfig
    }
    
    func objects<T where T: Object>(type: T.Type) -> Results<T>? {
        do {
            let realm = try Realm(configuration: Persistence.defaultRealmConfig)
            return realm.objects(type)
        } catch {
            print(error)
            return nil
        }
    }
    
    func write(writeFunction: (Realm) -> (), errorHandler: ((ErrorType) -> ())? = nil) {
        do {
            let realm = try Realm(configuration: Persistence.defaultRealmConfig)
            try realm.write {
                writeFunction(realm)
            }
        } catch {
            errorHandler?(error)
        }
    }
    
    func add(object: Object, update: Bool = false, errorHandler: ((ErrorType) -> ())? = nil) {
        write({ realm in
            realm.add(object, update: update)
        }) { error in
            errorHandler?(error)
        }
    }
    
    func add<S: SequenceType where S.Generator.Element: Object>(objects: S, update: Bool = false, errorHandler: ((ErrorType) -> ())? = nil) {
        write({ realm in
            realm.add(objects, update: update)
        }) { error in
            errorHandler?(error)
        }
    }

    func delete(object: Object) {
        write({ realm in
            realm.delete(object)
        })
    }
    
    func delete<S: SequenceType where S.Generator.Element: Object>(objects: S) {
        write({ realm in
            realm.delete(objects)
        })
    }
}