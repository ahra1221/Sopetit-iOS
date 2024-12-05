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
    
    func postMemoAPI(addMemoEntity: AddMemosRequestEntity,
                     completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = URLConstant.memosURL
        let header: HTTPHeaders = NetworkConstant.hasTokenHeader
        let body: Parameters = [
            "achievedDate": addMemoEntity.achievedDate,
            "content": addMemoEntity.content
        ]
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        dataRequest.responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.data else { return }
                let networkResult = self.judgeStatus(by: statusCode,
                                                     data,
                                                     MemosResponseEntity.self)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    func deleteRoutineListAPI(memoId: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = URLConstant.memosWithIdURL + "\(memoId)"
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
                                                     EmptyEntity.self)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    func patchRoutineAPI(memoId: Int,
                         content: String,
                         completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = URLConstant.memosWithIdURL + "\(memoId)"
        let header: HTTPHeaders = NetworkConstant.hasTokenHeader
        let body: Parameters = [
            "content": content
        ]
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
                                                     EmptyEntity.self)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    func getCalendar(requestEntity: CalendarRequestEntity,
                     completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = URLConstant.calendarURL
        let header: HTTPHeaders = NetworkConstant.hasTokenHeader
        let parameters: Parameters = [
            "year": requestEntity.year,
            "month": requestEntity.month
        ]
        let dataRequest = AF.request(url,
                                     method: .get,
                                     parameters: parameters,
                                     encoding: URLEncoding.default,
                                     headers: header)
        dataRequest.responseData { response in
            print("🍎🍎🍎datarequest🍎🍎")
            print(dataRequest)
            print("🍎🍎🍎response🍎🍎")
            print(response)
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.data else { return }
                let networkResult = self.judgeNoGenericStatus(by: statusCode,
                                                              data,
                                                              CalendarEntity.self)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
}
