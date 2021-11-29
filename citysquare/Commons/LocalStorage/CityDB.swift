//
//  CityDB.swift
//  citysquare
//
//  Created by Maria Garcia Luque on 28/11/21.
//

import Foundation
import RealmSwift

class CityDB: Object {
    @objc dynamic var id:Int = 0
    @objc dynamic var name:String = "name"
    @objc dynamic var localName:String = "local name"
    @objc dynamic var lat:Double = 0.0
    @objc dynamic var lng:Double = 0.0
    @objc dynamic var createdAt:String = "AAAA-MM-DD hh:mm:ss"
    @objc dynamic var updatedAt:String = "AAAA-MM-DD hh:mm:ss"
    @objc dynamic var countryId:Int = -1

  override static func primaryKey() -> String? {
    "id"
  }
}
