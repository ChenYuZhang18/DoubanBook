//
//  VMCategory.swift
//  DoubaiBooks
//
//  Created by Kirin on 2019/10/12.
//  Copyright © 2019 Kirin. All rights reserved.
//
import CoreData
import Foundation
class VMCategory :NSObject,DadaViewModelDelegate{
    
    
    var id:UUID
    var name:String?
    var image:String?
    
    static let entityName = "Category"
    static let colId = "id"
    static let colName = "name"
    static let colImage = "image"
    
    override init() {
        self.id=UUID()
    }
    
    init(_ name:String,_ image:String) {
        self.id=UUID()
        self.name=name
        self.image=image
    }
    
    func entityPairs() -> Dictionary<String, Any?> {
        var dict:[String:Any?] = [:]
        dict[VMCategory.colId] = id
        dict[VMCategory.colName] = name
        dict[VMCategory.colImage] = image
        return dict
    }
    
    func packageSelf(result: NSFetchRequestResult) {
        let category = result as! Category
        id = category.id!
        image = category.image
        name = category.name
        
    }
}
