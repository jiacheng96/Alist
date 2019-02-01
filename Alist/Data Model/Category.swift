//
//  Category.swift
//  Alist
//
//  Created by Jiacheng Xia on 2019-01-29.
//  Copyright © 2019 Jiacheng Xia. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
    
}
