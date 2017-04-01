//
//  BookConstants.swift
//  BookHack
//
//  Created by E on 4/1/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import Foundation


struct Book {
    init(names:String!, auth:String!, ISBNs:Int!, urls:String!, created:Date!) {
        name = names
        author = auth
        ISBN = ISBNs
        url = urls
        createdAt = created
    }
    var name:String!
    var author:String!
    var ISBN:Int!
    var url:String!
    var createdAt:Date!
}
