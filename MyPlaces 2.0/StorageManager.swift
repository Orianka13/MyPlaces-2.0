//
//  StorageManager.swift
//  Pods
//
//  Created by Олеся Егорова on 02.05.2021.
//

import RealmSwift

//создаем объект который будет предоставлять доступ к БД
let realm = try!Realm()

class StorageManager {
    
    static func saveObject(_ place: Place) {
        try!realm.write {
            realm.add(place)
        }
    }
}
