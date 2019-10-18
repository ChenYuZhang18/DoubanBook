//
//  VMBook.swift
//  DoubanBook
//
//  Created by 2017yd on 2019/10/14.
//  Copyright © 2019 2017yd. All rights reserved.
//

import Foundation
import CoreData
class VMBook :NSObject,DadaViewModelDelegate{
   
    
    var id: UUID
    var author:String?
    var authorIntro:String?
    var categoryId: UUID?
    var image: String?
    var isbn10: String?
    var isbn13: String?
    var pages: Int32?
    var price: String?
    var pubdate: String?
    var publisher: String?
    var summary: String?
    var title: String?
    var binding: String?
    
    override init() {
        id = UUID()
    }
    
    static let entityName = "Book"
    static let colId = "id"
    static let colAuthor = "author"
    static let colAuthorIntro = "authorIntro"
    static let colCategoryId = "categoryId"
    static let colImage = "image"
    static let colIsbn10 = "isbn10"
    static let colIsbn13 = "isbn13"
    static let colPages = "pages"
    static let colPrice = "price"
    static let colPubdate = "pubdate"
    static let colPublisher = "publisher"
    static let colSummary = "summary"
    static let colTitle = "title"
    static let colBinding = "binding"
    
    
    func entityPairs() -> Dictionary<String, Any?> {
        var dict:[String:Any?] = [:]
        dict[VMBook.colId] = id
        dict[VMBook.colCategoryId] = categoryId
        dict[VMBook.colBinding] = binding
        dict[VMBook.colAuthor] = author
        dict[VMBook.colPubdate] = pubdate
        dict[VMBook.colImage] = image
        dict[VMBook.colPages] = pages
        dict[VMBook.colPublisher] = publisher
        dict[VMBook.colIsbn10] = isbn10
        dict[VMBook.colIsbn13] = isbn13
        dict[VMBook.colTitle] = title
        dict[VMBook.colAuthorIntro] = authorIntro
        dict[VMBook.colSummary] = summary
        dict[VMBook.colPrice] = price
        return dict
    }
    
    func packageSelf(result: NSFetchRequestResult) {
        let book = result as! Book
        id = book.id!
        categoryId = book.categoryld
        binding = book.binding
        author = book.author
        pubdate = book.pubdate
        image = book.image
        pages = book.pages
        publisher = book.publisher
        isbn10 = book.isbn10
        isbn13 = book.isbn13
        title = book.title
        authorIntro = book.authorlntro
        summary = book.summary
        price = book.price
    }
    
    
}
