//
//  BookRepository.swift
//  DoubanBook
//
//  Created by 2017yd on 2019/10/14.
//  Copyright © 2019 2017yd. All rights reserved.
//
import CoreData
import Foundation

class BookRepositoy {
    var app: AppDelegate
    var context: NSManagedObjectContext
    
    init(_ app: AppDelegate) {
        self.app = app
        context = app.persistentContainer.viewContext
    }
    
    func insert(vm: VMBook) {
        let description = NSEntityDescription.entity(forEntityName: "Book", in: context)
        let vMBook = NSManagedObject(entity: description!, insertInto: context)
        vMBook.setValue(vm.id, forKey: "id")
        vMBook.setValue(vm.author, forKey: "author")
        vMBook.setValue(vm.binding, forKey: "binding")
        vMBook.setValue(vm.image, forKey: "image")
        vMBook.setValue(vm.authorIntro, forKey: "authorIntro")
        vMBook.setValue(vm.categoryId, forKey: "categoryId")
        vMBook.setValue(vm.isbn10, forKey: "isbn10")
        vMBook.setValue(vm.isbn13, forKey: "isbn13")
        vMBook.setValue(vm.pages, forKey: "pages")
        vMBook.setValue(vm.price, forKey: "price")
        vMBook.setValue(vm.pubdate, forKey: "pubdate")
        vMBook.setValue(vm.publisher, forKey: "publisher")
        vMBook.setValue(vm.summary, forKey: "summary")
        vMBook.setValue(vm.title, forKey: "title")
        app.saveContext()
    }
    
    func get() throws -> [VMBook] {
        var vMBooks = [VMBook]()
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        let result = try context.fetch(fetch) as! [VMBook]
        for item in result {
            let vm = VMBook()
            vm.id = item.id
            vm.categoryId = item.categoryId
            vm.image = item.image
            vm.author = item.author
            vm.authorIntro = item.authorIntro
            vm.binding = item.binding
            vm.isbn10 = item.isbn10
            vm.isbn13 = item.isbn13
            vm.pages = item.pages
            vm.price = item.price
            vm.pubdate = item.pubdate
            vm.publisher = item.publisher
            vm.summary = item.summary
            vm.title = item.title
            vMBooks.append(vm)
            
        }
        return vMBooks
    }
    
    func getByKeyword(keyword format:String,args:[Any]) throws -> [VMBook] {
        var vMBooks = [VMBook]()
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        
        //fetch.predicate = NSPredicate(format: "\(VMBook.colTitle) like[c] %@ || \(VMBook.colId) like[c] %@", "*\(kw)*","*\(kw)*")
        fetch.predicate = NSPredicate(format: format, args)
        do {
            let result = try context.fetch(fetch) as! [VMBook]
            for item in result {
                let vm = VMBook()
                vm.id = item.id
                vm.categoryId = item.categoryId
                vm.image = item.image
                vm.author = item.author
                vm.authorIntro = item.authorIntro
                vm.binding = item.binding
                vm.isbn10 = item.isbn10
                vm.isbn13 = item.isbn13
                vm.pages = item.pages
                vm.price = item.price
                vm.pubdate = item.pubdate
                vm.publisher = item.publisher
                vm.summary = item.summary
                vm.title = item.title
                vMBooks.append(vm)
            }
            return vMBooks
        } catch {
            throw DataErrer.readCollestionError("读取集合数据失败")
        }
    }
    
    func getBookByCategoryId(_ categoryId: UUID) throws -> [VMBook] {
        var vMBooks = [VMBook]()
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        do {
            let result = try context.fetch(fetch) as! [VMBook]
            fetch.predicate = NSPredicate(format: "id = %@", "*\(categoryId.uuidString)*")
            
            for item in result {
                let vm = VMBook()
                vm.id = item.id
                vm.categoryId = item.categoryId
                vm.image = item.image
                vm.author = item.author
                vm.authorIntro = item.authorIntro
                vm.binding = item.binding
                vm.isbn10 = item.isbn10
                vm.isbn13 = item.isbn13
                vm.pages = item.pages
                vm.price = item.price
                vm.pubdate = item.pubdate
                vm.publisher = item.publisher
                vm.summary = item.summary
                vm.title = item.title
                vMBooks.append(vm)
                
            }
        } catch {
            throw DataErrer.readCollestionError("读取集合数据失败")
        }
        
        return vMBooks
    }
    
    func delete(id: UUID) throws {
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        fetch.predicate = NSPredicate(format: "id = %@", id.uuidString)
        let result = try context.fetch(fetch) as! [Book]
        for m in result {
            context.delete(m)
        }
        app.saveContext()
   }
    
    func update(_ vMBook:VMBook) throws {
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        fetch.predicate = NSPredicate(format: "\(VMBook.colId) = %@", vMBook.id.uuidString)
        do {
            let m = try context.fetch(fetch)[0] as! NSManagedObject
            m.setValue(vMBook.author, forKey: VMBook.colAuthor)
            m.setValue(vMBook.binding, forKey: VMBook.colBinding)
            m.setValue(vMBook.image, forKey: VMBook.colImage)
            m.setValue(vMBook.authorIntro, forKey: VMBook.colAuthorIntro)
            m.setValue(vMBook.categoryId, forKey: VMBook.colCategoryId)
            m.setValue(vMBook.isbn10, forKey: VMBook.colIsbn10)
            m.setValue(vMBook.isbn13, forKey: VMBook.colIsbn13)
            m.setValue(vMBook.pages, forKey: VMBook.colPages)
            m.setValue(vMBook.price, forKey: VMBook.colPrice)
            m.setValue(vMBook.pubdate, forKey: VMBook.colPubdate)
            m.setValue(vMBook.publisher, forKey: VMBook.colPublisher)
            m.setValue(vMBook.summary, forKey: VMBook.colSummary)
            m.setValue(vMBook.title, forKey: VMBook.colTitle)
            app.saveContext()
        } catch {
            throw DataErrer.readCollestionError("读取集合数据失败")
        }
        
    }
    
    func isExists(_ vmBook:VMBook) throws -> Bool {
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        fetch.predicate = NSPredicate(format: "\(VMBook.colIsbn10) = %@ || \(VMBook.colIsbn13) = %@", vmBook.isbn10!,vmBook.isbn13!)
        do {
            let result = try context.fetch(fetch) as! [Book]
            return result.count>0
        } catch  {
            throw DataErrer.entityExistsError("判断数据失败")
        }
        
    }
}
