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
    let toastInfoListDto: [ToastInfoList]
}

struct CategoryList: Codable {
    let categoryId: Int
    let categroyTitle: String
    let toastNum: Int
}

struct ToastInfoList: Codable {
    let toastId: Int
    let toastTitle: String
    let toastLink: String
}

//let dummyCategory1 = CategoryList(categoryId: 1, categroyTitle: "전체 클립", toastNum: 10)
//let dummyCategory2 = CategoryList(categoryId: 2, categroyTitle: "Category 2", toastNum: 5)
//let dummyCategory3 = CategoryList(categoryId: 3, categroyTitle: "Category 3", toastNum: 3)
//let dummyCategory4 = CategoryList(categoryId: 4, categroyTitle: "Category 4", toastNum: 2)
//
//let dummyToast1 = ToastInfoList(toastId: 1, toastTitle: "Toast 1", toastLink: "https://example.com/toast1")
//let dummyToast2 = ToastInfoList(toastId: 2, toastTitle: "Toast 2", toastLink: "https://example.com/toast2")
//let dummyToast3 = ToastInfoList(toastId: 3, toastTitle: "Toast 3", toastLink: "https://example.com/toast3")
//let dummyToast4 = ToastInfoList(toastId: 4, toastTitle: "Toast 4", toastLink: "https://example.com/toast4")

var dummyCategoryInfo: [CategoryList] = [CategoryList(categoryId: 1, categroyTitle: "전체 클립", toastNum: 10),
                                         CategoryList(categoryId: 2, categroyTitle: "Category 2", toastNum: 2),
                                         CategoryList(categoryId: 3, categroyTitle: "Category 3", toastNum: 5),
                                         CategoryList(categoryId: 4, categroyTitle: "Category 4", toastNum: 7),
                                         CategoryList(categoryId: 5, categroyTitle: "Category 5", toastNum: 3)]


var dummyToastInfo: [ToastInfoList] = [ToastInfoList(toastId: 1, toastTitle: "Toast 1", toastLink: "https://example.com/toast1"),
                                       ToastInfoList(toastId: 2, toastTitle: "Toast 2", toastLink: "https://example.com/toast2"),
                                       ToastInfoList(toastId: 3, toastTitle: "Toast 3", toastLink: "https://example.com/toast3"),
                                       ToastInfoList(toastId: 4, toastTitle: "Toast 4", toastLink: "https://example.com/toast4"),
                                       ToastInfoList(toastId: 5, toastTitle: "Toast 5", toastLink: "https://example.com/toast5")]


//
//var dummyMainInfo: [MainInfoModel] = [MainInfoModel(nickname: "김가현",
//                                                    readToastNum: 3,
//                                                    allToastNum: 10,
//                                                    mainCategoryListDto: [dummyCategory1, dummyCategory2, dummyCategory3, dummyCategory4],
//                                                    toastInfoListDto: [dummyToast1, dummyToast2, dummyToast3, dummyToast4])
//]
//


