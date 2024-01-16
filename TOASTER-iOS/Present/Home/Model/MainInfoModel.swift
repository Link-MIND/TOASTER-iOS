//
//  MainInfoModel.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/01/09.
//

import Foundation

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



//var dummyCategoryInfo: [CategoryList] = [CategoryList(categoryId: 1, categroyTitle: "전체 클립", toastNum: 10),
//                                         CategoryList(categoryId: 2, categroyTitle: "Category 2", toastNum: 2)]
//
//var dummyToastInfo: [ToastInfoList] = [ToastInfoList(toastId: 1, toastTitle: "Toast 1", toastLink: "https://example.com/toast1"),
//                                       ToastInfoList(toastId: 2, toastTitle: "Toast 2", toastLink: "https://example.com/toast2"),
//                                       ToastInfoList(toastId: 3, toastTitle: "Toast 3", toastLink: "https://example.com/toast3"),
//                                       ToastInfoList(toastId: 4, toastTitle: "Toast 4", toastLink: "https://example.com/toast4"),
//                                       ToastInfoList(toastId: 5, toastTitle: "Toast 5", toastLink: "https://example.com/toast5")]
//
//var mainInfoModel: [MainInfoModel] = [MainInfoModel(nickname: "토스터", readToastNum: 10, allToastNum: 32, mainCategoryListDto: dummyCategoryInfo, toastInfoListDto: dummyToastInfo)]
