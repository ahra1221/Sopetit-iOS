//
//  DailyRoutineService.swift
//  Sopetit-iOS
//
//  Created by Minjoo Kim on 8/16/24.
//

import Foundation

import Alamofire

final class OngoingService: BaseService {
    
    static let shared = OngoingService()
    
    private override init() {}
}

// MARK: - Extension

extension OngoingService {
    
    func getDailyRoutine(completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = URLConstant.v2DailyMemberURL
        let header: HTTPHeaders = NetworkConstant.hasTokenHeader
        let dataRequest = AF.request(url,
                                     method: .get,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.data else { return }
                let networkResult = self.judgeStatus(by: statusCode,
                                                     data,
                                                     NewDailyRoutineEntity.self)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    func patchRoutineAPI(
        routineId: Int,
        completion: @escaping (NetworkResult<Any>) -> Void) {
            let url = URLConstant.patchRoutineURL + "\(routineId)"
            let header: HTTPHeaders = NetworkConstant.hasTokenHeader
            let dataRequest = AF.request(url,
                                         method: .patch,
                                         encoding: JSONEncoding.default,
                                         headers: header)
            
            dataRequest.responseData { response in
                switch response.result {
                case .success:
                    guard let statusCode = response.response?.statusCode else { return }
                    guard let data = response.data else { return }
                    let networkResult = self.judgeStatus(by: statusCode,
                                                         data,
                                                         PatchRoutineEntity.self)
                    completion(networkResult)
                case .failure:
                    completion(.networkFail)
                }
            }
        }
    
    func deleteRoutineListAPI(routineIdList: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = URLConstant.dailyMemberURL + "?routines=\(routineIdList)"
        let header: HTTPHeaders = NetworkConstant.hasTokenHeader
        let dataRequest = AF.request(url,
                                     method: .delete,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.data else { return }
                let networkResult = self.judgeStatus(by: statusCode,
                                                     data,
                                                     DeleteDailyEntity.self)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    func getChallengeRoutine(completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = URLConstant.challengeMemberURL
        let header: HTTPHeaders = NetworkConstant.hasTokenHeader
        let dataRequest = AF.request(url,
                                     method: .get,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.data else { return }
                let networkResult = self.judgeStatus(by: statusCode,
                                                     data,
                                                     ChallengeMemberEntity.self)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    func patchChallengeAPI(routineId: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = URLConstant.happinessMemberRoutineURL + "\(routineId)"
        let header: HTTPHeaders = NetworkConstant.hasTokenHeader
        let dataRequest = AF.request(url,
                                     method: .patch,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.data else { return }
                let networkResult = self.judgeStatus(by: statusCode,
                                                     data,
                                                     PatchChallengeEntity.self)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    func deleteChallengeAPI(routineId: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = URLConstant.happinessMemberRoutineURL + "\(routineId)"
        let header: HTTPHeaders = NetworkConstant.hasTokenHeader
        let dataRequest = AF.request(url,
                                     method: .delete,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.data else { return }
                let networkResult = self.judgeStatus(by: statusCode,
                                                     data,
                                                     DeleteChallengeEntity.self)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
}
