//
//  HomeViewModel.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/02/23.
//

import Combine
import UIKit

final class HomeViewModel: ViewModelType {
    
    private var cancelBag = CancelBag()
    
    private(set) var mainInfo: MainInfoModel = MainInfoModel(
        nickname: "",
        readToastNum: 0,
        allToastNum: 0,
        mainCategoryListDto: []
    )
    
    private(set) var recentLinks: [RecentLinkModel] = [
        RecentLinkModel(
            toastId: 0,
            toastTitle: "",
            linkUrl: "",
            isRead: true,
            categoryTitle: nil ?? "",
            thumbnailUrl: nil ?? ""
        )
    ]
    
    private(set) var weeklyLinks: [WeeklyLinkModel] = [
        WeeklyLinkModel(
            toastId: 0,
            toastTitle: "",
            toastImg: "",
            toastLink: ""
        )
    ]
    
    private(set) var recommendSites: [RecommendSiteModel] = [
        RecommendSiteModel(
            siteId: 0,
            siteTitle: nil ?? "",
            siteUrl: nil ?? "",
            siteImg: nil ?? "",
            siteSub: nil ?? ""
        )
    ]
    
    private(set) var popupInfoList: [PopupInfoModel]?
    
    // MARK: - Input State
    
    struct Input {
        let requestMainInfo: Driver<Void>
        let requestRecentLinks: Driver<Void>
        let requestWeeklyLinks: Driver<Void>
        let requestRecommendSites: Driver<Void>
        let requestPopupInfoList: Driver<Void>
        let changePopupDate: Driver<(Int, Int)>
    }
    
    // MARK: - Output State
    
    struct Output {
        let needToReload = PassthroughSubject<Void, Never>()
        let navigateToLogin = PassthroughSubject<Void, Never>()
    }
    
    // MARK: - Method
    
    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.requestMainInfo
            .networkFlatMap(self, { context, _ in
                context.fetchMainPageData()
            }, onError: { _ in
                output.navigateToLogin.send()
            })
            .sink { [weak self] mainInfo in
                self?.mainInfo = mainInfo
                output.needToReload.send()
            }.store(in: cancelBag)
        
        input.requestRecentLinks
            .networkFlatMap(self, { context, _ in
                context.fetchRecentLinkData()
            }, onError: { _ in
                output.navigateToLogin.send()
            })
            .sink { [weak self] recentLinks in
                self?.recentLinks = recentLinks
                output.needToReload.send()
            }.store(in: cancelBag)
        
        input.requestWeeklyLinks
            .networkFlatMap(self, { context, _ in
                context.fetchWeeklyLinkData()
            }, onError: { _ in
                output.navigateToLogin.send()
            })
            .sink { [weak self] weeklyLinks in
                self?.weeklyLinks = weeklyLinks
                output.needToReload.send()
            }.store(in: cancelBag)
        
        input.requestRecommendSites
            .networkFlatMap(self, { context, _ in
                context.fetchRecommendSiteData()
            }, onError: { _ in
                output.navigateToLogin.send()
            })
            .sink { [weak self] recommendSites in
                self?.recommendSites = recommendSites
                output.needToReload.send()
            }.store(in: cancelBag)
        
        input.requestPopupInfoList
            .networkFlatMap(self, { context, _ in
                context.fetchPopupInfoAPI()
            }, onError: { _ in
                output.navigateToLogin.send()
            })
            .sink { [weak self] popupInfoList in
                self?.popupInfoList = popupInfoList
            }.store(in: cancelBag)
        
        input.changePopupDate
            .networkFlatMap(self, { context, body in
                context.patchEditPopupHiddenAPI(popupId: body.0, hideDate: body.1)
            }, onError: { _ in
                output.navigateToLogin.send()
            })
            .sink { [weak self] in
                self?.popupInfoList?.removeAll()
            }.store(in: cancelBag)
        return output
    }
}

// MARK: - Network

private extension HomeViewModel {
    func fetchMainPageData() -> AnyPublisher<MainInfoModel, Error> {
        return Future<MainInfoModel, Error> { promise in
            NetworkService.shared.userService.getMainPage { result in
                switch result {
                case .success(let response):
                    if let data = response?.data {
                        var categories: [CategoryList] = [
                            CategoryList(
                                categoryId: 0,
                                categroyTitle: "전체 클립",
                                toastNum: data.allToastNum
                            )
                        ]
                        
                        data.mainCategoryListDto.forEach {
                            categories.append(
                                CategoryList(
                                    categoryId: $0.categoryId,
                                    categroyTitle: $0.categoryTitle,
                                    toastNum: $0.toastNum
                                )
                            )
                        }
                        
                        promise(.success(
                            MainInfoModel(
                                nickname: data.nickname,
                                readToastNum: data.readToastNum,
                                allToastNum: data.allToastNum,
                                mainCategoryListDto: categories
                            )
                        ))
                    }
                case .unAuthorized, .networkFail, .notFound:
                    promise(.failure(NetworkResult<Error>.unAuthorized))
                default:
                    return
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func fetchRecentLinkData() -> AnyPublisher<[RecentLinkModel], Error> {
        return Future<[RecentLinkModel], Error> { promise in
            NetworkService.shared.toastService.getRecentLink { result in
                switch result {
                case .success(let response):
                    var recentLinks: [RecentLinkModel] = []
                    if let data = response?.data {
                        for idx in 0..<data.count {
                            recentLinks.append(
                                RecentLinkModel(
                                    toastId: data[idx].toastId,
                                    toastTitle: data[idx].toastTitle,
                                    linkUrl: data[idx].linkUrl,
                                    isRead: data[idx].isRead,
                                    categoryTitle: data[idx].categoryTitle,
                                    thumbnailUrl: data[idx].thumbnailUrl
                                )
                            )
                        }
                    }
                    promise(.success(recentLinks))
                case .unAuthorized, .networkFail, .notFound:
                    promise(.failure(NetworkResult<Error>.unAuthorized))
                default:
                    return
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func fetchWeeklyLinkData() -> AnyPublisher<[WeeklyLinkModel], Error> {
        return Future<[WeeklyLinkModel], Error> { promise in
            NetworkService.shared.toastService.getWeeksLink { result in
                switch result {
                case .success(let response):
                    var weeklyLinks: [WeeklyLinkModel] = []
                    if let data = response?.data {
                        for idx in 0..<data.count {
                            weeklyLinks.append(
                                WeeklyLinkModel(
                                    toastId: data[idx].linkId,
                                    toastTitle: data[idx].linkTitle,
                                    toastImg: data[idx].linkImg ?? "",
                                    toastLink: data[idx].linkUrl
                                )
                            )
                        }
                    }
                    promise(.success(weeklyLinks))
                case .unAuthorized, .networkFail, .notFound:
                    promise(.failure(NetworkResult<Error>.unAuthorized))
                default:
                    return
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func fetchRecommendSiteData() -> AnyPublisher<[RecommendSiteModel], Error> {
        return Future<[RecommendSiteModel], Error> { promise in
            NetworkService.shared.searchService.getRecommendSite { result in
                switch result {
                case .success(let response):
                    var recommendSites: [RecommendSiteModel] = []
                    if let data = response?.data {
                        for idx in 0..<data.count {
                            recommendSites.append(
                                RecommendSiteModel(
                                    siteId: data[idx].siteId,
                                    siteTitle: data[idx].siteTitle,
                                    siteUrl: data[idx].siteUrl,
                                    siteImg: data[idx].siteImg,
                                    siteSub: data[idx].siteSub
                                )
                            )
                        }
                    }
                    promise(.success(recommendSites))
                case .unAuthorized, .networkFail, .notFound:
                    promise(.failure(NetworkResult<Error>.unAuthorized))
                default:
                    return
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func fetchPopupInfoAPI() -> AnyPublisher<[PopupInfoModel], Error> {
        return Future<[PopupInfoModel], Error> { promise in
            NetworkService.shared.popupService.getPopupInfo { result in
                switch result {
                case .success(let response):
                    var popupInfoList: [PopupInfoModel] = []
                    if let data = response?.data.popupList {
                        for idx in 0..<data.count {
                            popupInfoList.append(
                                PopupInfoModel(
                                    id: data[idx].id,
                                    image: data[idx].image,
                                    activeStartDate: data[idx].activeStartDate,
                                    activeEndDate: data[idx].activeEndDate,
                                    linkURL: data[idx].linkUrl
                                )
                            )
                        }
                    }
                    promise(.success(popupInfoList))
                case .unAuthorized, .networkFail, .notFound:
                    promise(.failure(NetworkResult<Error>.unAuthorized))
                default:
                    return
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func patchEditPopupHiddenAPI(popupId: Int, hideDate: Int) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            NetworkService.shared.popupService.patchEditPopupHidden(
                requestBody: PatchPopupHiddenRequestDTO(
                    popupId: popupId,
                    hideDate: hideDate
                )
            ) { result in
                switch result {
                case .success:
                    promise(.success(()))
                case .networkFail, .unAuthorized, .notFound:
                    promise(.failure(NetworkResult<Error>.unAuthorized))
                default: return
                }
            }
        }.eraseToAnyPublisher()
    }
}
