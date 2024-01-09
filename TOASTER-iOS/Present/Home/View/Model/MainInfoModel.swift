//
//  MainInfoModel.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/01/09.
//

import Foundation

struct MainInfoModel: Codable {
    let nickname: String
    let readToastNum: Int
    let allToastNum: Int
    let mainCategoryListDto: [CategoryList]
    let toastListDto: [ToastList]
}

struct CategoryList: Codable {
    let categoryId: Int
    let categroyTitle: String
    let toastNum: Int
}

struct ToastList: Codable {
    let toastId: Int
    let toastTitle: String
    let toastLink: String
}

// var dummyMainInfoList: [MainInfoModel] = []
