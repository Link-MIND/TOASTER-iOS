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

    func fetchRecentLinkData() -> AnyPublisher<[RecentLinkModel], ToasterError> {
        return NetworkService.shared.toastService.getRecentLink()
            .map { response in
                response.data.map {
                    RecentLinkModel(
                        toastId: $0.toastId,
                        toastTitle: $0.toastTitle,
                        linkUrl: $0.linkUrl,
                        isRead: $0.isRead,
                        categoryTitle: $0.categoryTitle,
                        thumbnailUrl: $0.thumbnailUrl
                    )
                }
            }
            .eraseToAnyPublisher()
    }

    func fetchWeeklyLinkData() -> AnyPublisher<[WeeklyLinkModel], ToasterError> {
        return NetworkService.shared.toastService.getWeeksLink()
            .map { response in
                response.data.map {
                    WeeklyLinkModel(
                        toastId: $0.linkId,
                        toastTitle: $0.linkTitle,
                        toastImg: $0.linkImg ?? "",
                        toastLink: $0.linkUrl
                    )
                }
            }
            .eraseToAnyPublisher()
    }

    func fetchRecommendSiteData() -> AnyPublisher<[RecommendSiteModel], ToasterError> {
        return NetworkService.shared.searchService.getRecommendSite()
            .map { response in
                response.data.map {
                    RecommendSiteModel(
                        siteId: $0.siteId,
                        siteTitle: $0.siteTitle,
                        siteUrl: $0.siteUrl,
                        siteImg: $0.siteImg,
                        siteSub: $0.siteSub
                    )
                }
            }
            .eraseToAnyPublisher()
    }

    func fetchPopupInfoAPI() -> AnyPublisher<[PopupInfoModel], ToasterError> {
        return NetworkService.shared.popupService.getPopupInfo()
            .map { response in
                response.data.popupList.map {
                    PopupInfoModel(
                        id: $0.id,
                        image: $0.image,
                        activeStartDate: $0.activeStartDate,
                        activeEndDate: $0.activeEndDate,
                        linkURL: $0.linkUrl
                    )
                }
            }
            .eraseToAnyPublisher()
    }

    func patchEditPopupHiddenAPI(popupId: Int, hideDate: Int) -> AnyPublisher<Void, ToasterError> {
        return NetworkService.shared.popupService.patchEditPopupHidden(
            requestBody: PatchPopupHiddenRequestDTO(popupId: popupId, hideDate: hideDate)
        )
        .map { _ in () }
        .eraseToAnyPublisher()
    }
}
