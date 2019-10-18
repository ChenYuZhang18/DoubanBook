//
//  CategoryFactory.swift
//  DoubaiBooks
//
//  Created by Kirin on 2019/10/14.
//  Copyright © 2019 Kirin. All rights reserved.
//
import CoreData
import Foundation
final class CategoryFactory {
    var repository:CategoryRepositoy
    private static var instance: CategoryFactory?
    
    private init(_ app: AppDelegate) {
        repository = CategoryRepositoy.init(app)
    }
    
    static func getInstance(_ app: AppDelegate) -> CategoryFactory{
        if let obj = instance {
            return obj
        }else{
            let token = "net.lzzy.factory.category"
            DispatchQueue.once(token: token,block: {
                if instance == nil{
                    instance = CategoryFactory(app)
                }
            })
        }
        return CategoryFactory(app)
    }
    
    func getAllCategorys() throws ->[VMCategory] {
        return try repository.get()
    }
    
    func addCategory(vmCategory: VMCategory) -> (Bool,String?) {
        do {
            if try repository.isExists(vmCategory.name!) {
                return (false,"同样的类别已经存在")
            }
            repository.insert(vm: vmCategory)
            return (true,nil)
        } catch DataErrer.entityExistsError(let info) {
            return (false,info)
        } catch {
            return (false,error.localizedDescription)
        }
    }
    
    func deleteCategory(vmCategory: VMCategory) -> (Bool,String?) {
        do {
            if try repository.isExists(vmCategory.name!) {
                try repository.delete(id: vmCategory.id)
                return (true,nil)
            }else{
                return (false,"不存在该类别")
            }
        } catch DataErrer.entityExistsError(let info) {
            return (false,info)
        } catch {
            return (false,error.localizedDescription)
        }
    }
    
    func getByKeyword(keyword: String) -> (Bool,[VMCategory]?,String?) {
        do {
            let categorys = try repository.getByKeyword(keyword: keyword)
            return (true,categorys,nil)
        } catch DataErrer.readCollestionError(let info) {
            return (false,nil,info)
        } catch {
            return (false,nil,error.localizedDescription)
        }
    }
    
    func updateCategorys(_ vMCategory:VMCategory) -> (Bool,String?) {
        do {
            try repository.update(vMCategory)
            return (true,nil)
        } catch DataErrer.readCollestionError(let info) {
            return (false,info)
        } catch {
            return (false,error.localizedDescription)
        }
    }
}

extension DispatchQueue {
    private static var _onceTracker = [String]()
    public class func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
}

