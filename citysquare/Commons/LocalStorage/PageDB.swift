//
//  PaginationDB.swift
//  citysquare
//
//  Created by Maria Garcia Luque on 28/11/21.
//

import Foundation
import RealmSwift


class PageDB: Object {
    @objc dynamic var id:Int = 0
    @objc dynamic var lastPage:Int = 0
    @objc dynamic var perPage:Int = 0
    @objc dynamic var total:Int = 0
    var citiesId:[Int] = [Int]()

  override static func primaryKey() -> String? {
    "id"
  }
}
