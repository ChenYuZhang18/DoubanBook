//
//  DadaViewModelDelegate.swift
//  DoubanBook
//
//  Created by 2017yd on 2019/10/15.
//  Copyright © 2019 2017yd. All rights reserved.
//
import CoreData
import Foundation

protocol DadaViewModelDelegate {
    ///  视图模型必须具备有的id属性
    var id: UUID {get}
    /// 视图模型对应的CoreData Entity的名称
    static var entityName: String {get}
    /// CoreData Entity 属性与对应的视图模型对象值集合
    ///
    /// - returns: key是CoreData Entity 的各个属性的名称，Any是对应的值
    func entityPairs() -> Dictionary<String,Any?>
    /// 根据查询结果组装视图模型对象
    ///
    /// - parameter result: fetch方法查询结果
    func packageSelf(result: NSFetchRequestResult)
    
}
