//
//  DataError.swift
//  DoubanBook
//
//  Created by 2017yd on 2019/10/14.
//  Copyright © 2019 2017yd. All rights reserved.
//

import Foundation
enum DataErrer:Error {
    case readCollestionError(String)
    case readSingError(String)
    case entityExistsError(String)
    case daletEntityError(String)
    case updateEntityError(String)
}
