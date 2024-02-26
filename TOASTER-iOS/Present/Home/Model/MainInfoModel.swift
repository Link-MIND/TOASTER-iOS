//
//  MainInfoModel.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/01/09.
//

import Foundation

//struct MainModel {
//    var mainInfoModelList: [MainInfoModel]
//    let categoryList: [CategoryList]
//}

struct MainInfoModel {
    let nickname: String
    let readToastNum: Int
    let allToastNum: Int
    let mainCategoryListDto: [CategoryList]
    
}

struct CategoryList {
    let categoryId: Int
    let categroyTitle: String
    let toastNum: Int
}
