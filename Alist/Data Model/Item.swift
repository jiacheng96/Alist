//
//  Item.swift
//  Alist
//
//  Created by Jiacheng Xia on 2019-01-29.
//  Copyright © 2019 Jiacheng Xia. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
