//
//  CountryDB.swift
//  citysquare
//
//  Created by Maria Garcia Luque on 28/11/21.
//

import Foundation
import RealmSwift

class CountryDB: Object {

    @objc dynamic var id:Int = 0
    @objc dynamic var name:String = "country name"
    @objc dynamic var code:String = "code"
    @objc dynamic var createdAt:String = "AAAA-MM-DD hh:mm:ss"
    @objc dynamic var updatedAt:String = "AAAA-MM-DD hh:mm:ss"
    @objc dynamic var continentId:Int = -1

  override static func primaryKey() -> String? {
    "id"
  }
}
