//
//  AchieveService.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 12/3/24.
//

import Foundation

import Alamofire

final class AchieveService: BaseService {
    
    static let shared = AchieveService()
    
    private override init() {}
}

extension AchieveService {
    
    func getMemberProfileAPI(completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = URLConstant.membersProfileURL
        let header: HTTPHeaders = NetworkConstant.hasTokenHeader
        let dataRequest = AF.request(url,
                                     method: .get,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        dataRequest.responseData { response in
            print("🌀🌀🌀🌀🌀")
            dump(response)
            print("🌀🌀🌀🌀🌀")
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.data else { return }
                let networkResult = self.judgeStatus(by: statusCode,
                                                     data,
                                                     MemberProfileEntity.self)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
}
