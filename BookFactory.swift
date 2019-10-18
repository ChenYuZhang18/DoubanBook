//
//  BookFactory.swift
//  DoubaiBooks
//
//  Created by Kirin on 2019/10/14.
//  Copyright © 2019 Kirin. All rights reserved.
//

import CoreData
import Foundation
final class BookFactory {
    var repository:BookRepositoy
    private static var instance: BookFactory?
    
    private init(_ app: AppDelegate) {
        repository = BookRepositoy.init(app)
    }
    
    static func getInstance(_ app: AppDelegate) -> BookFactory{
        if let obj = instance {
            return obj
        }else{
            let token = "info.lzzy.factory.book"
            DispatchQueue.once(token: token,block: {
                if instance == nil{
                    instance = BookFactory(app)
                }
            })
        }
        return BookFactory(app)
    }
    
    func getAllBooks() throws ->[VMBook] {
        return try repository.get()
    }
    
    func addBook(vmBook: VMBook) -> (Bool,String?) {
        do {
            if try repository.isExists(vmBook) {
                return (false,"该书已经添加")
            }
            repository.insert(vm: vmBook)
            return (true,nil)
        } catch DataErrer.entityExistsError(let info) {
            return (false,info)
        } catch {
            return (false,error.localizedDescription)
        }
    }
    
    func deleteBook(vmBook: VMBook) -> (Bool,String?) {
        do {
            if try repository.isExists(vmBook) {
                try repository.delete(id: vmBook.id)
                return (true,nil)
            }else{
                return (false,"不存在该图书")
            }
        } catch DataErrer.entityExistsError(let info) {
            return (false,info)
        } catch {
            return (false,error.localizedDescription)
        }
    }
    
    func getByKeyword(keyword: String) -> (Bool,[VMBook]?,String?) {
        do {
            let books = try repository.getByKeyword(keyword: "\(VMBook.colTitle) like[c] %@ || \(VMBook.colId) like[c] %@", args: [keyword,keyword] )
            return (true,books,nil)
        } catch DataErrer.readCollestionError(let info) {
            return (false,nil,info)
        } catch {
            return (false,nil,error.localizedDescription)
        }
    }
    
    func updateBook(vm:VMBook) -> (Bool,String?) {
        do {
            try repository.update(vm)
            return (true,nil)
        } catch DataErrer.readCollestionError(let info){
            return (false,info)
        } catch {
            return (false,error.localizedDescription)
        }
    }
    
}



