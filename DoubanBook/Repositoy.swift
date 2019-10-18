//
//  Repositoy.swift
//  DoubaiBooks
//
//  Created by Kirin on 2019/10/15.
//  Copyright © 2019 Kirin. All rights reserved.
//
import CoreData
import Foundation
class Repositoy<T: DadaViewModelDelegate> where T:NSObject{
    var app: AppDelegate
    var context: NSManagedObjectContext
    
    init(_ app: AppDelegate) {
        self.app = app
        context = app.persistentContainer.viewContext
    }
    
    func insert(vm: T) {
        let description = NSEntityDescription.entity(forEntityName: T.entityName, in: context)
        let obj = NSManagedObject(entity: description!, insertInto: context)
        for (key,value) in vm.entityPairs() {
            obj.setValue(value, forKey: key)
        }
        app.saveContext()
    }
    
    func isEntityExists(_ cols: [String],keyword: String) throws -> Bool{
        let (format,args) = createFormatArgs(cols,keyword,true)
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: format, args)
        do {
            let result = try context.fetch(fetch)
            return result.count > 0
        } catch {
            throw DataErrer.readCollestionError("读取集合数据失败")
        }
    }
    func get() throws -> [T] {
        var vMs = [T]()
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        let result = try context.fetch(fetch) as! [T]
        for item in result {
            let vm = T()
            vm.packageSelf(result: item as! NSFetchRequestResult)
            vMs.append(vm)
        }
        return vMs
    }
    
    func getBy(cols: [String],keyword: String,preciseQuery: Bool) throws -> [T] {
        let (format,args) = createFormatArgs(cols,keyword,preciseQuery)
        var vMs = [T]()
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: format, args)
        do {
            let result = try context.fetch(fetch) as! [T]
            for item in result {
                let vm = T()
                vm.packageSelf(result: item as! NSFetchRequestResult)
                vMs.append(vm)
            }
            return vMs
        } catch {
            throw DataErrer.readCollestionError("读取集合数据失败")
        }
    }
    
    func delete(id: UUID) throws {
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", id.uuidString)
        do {
            let result = try context.fetch(fetch)
            for m in result {
                context.delete(m as! NSManagedObject)
            }
            app.saveContext()
        } catch  {
            throw DataErrer.readCollestionError("删除图书失败")
        }
        
    }
    
    func update(_ vM:T) throws {
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        
        fetch.predicate = NSPredicate(format: "id = %@", vM.id.uuidString)
        do {
            let vm = try context.fetch(fetch)[0] as! NSManagedObject
            for (key,value) in vM.entityPairs() {
                vm.setValue(value, forKey: key)
            }
            app.saveContext()
        } catch {
            throw DataErrer.readCollestionError("更新图书失败")
        }
        
    }
    
    func createFormatArgs(_ cols: [String],_ keyword: String,_ preciseQuery:Bool) -> (String,[String]) {
        var format = ""
        var args = [String]()
        var symbol = "="
        if !preciseQuery {
            symbol =  "like[c]"
        }
        for col in cols {
            format += "\(col) \(symbol) %@ || "
            if preciseQuery{
                args.append(keyword)
            }else{
                args.append("*\(keyword)*")
            }
        }
        format.removeLast(3)
        return (format,args)
    }
}
