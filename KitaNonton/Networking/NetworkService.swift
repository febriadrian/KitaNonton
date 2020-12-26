//
//  NetworkService.swift
//  KitaNonton
//
//  Created by Febri Adrian on 25/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Alamofire

enum FetchResult<Success, GeneralError> {
    case success(Success)
    case failure(GeneralError)
}

protocol IEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
    var encoding: ParameterEncoding { get }
}

struct NetworkStatus {
    static var isInternetAvailable: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

class NetworkService {
    static let share = NetworkService()
    private var dataRequest: DataRequest!
    private var decoder: JSONDecoder!

    init() {
        decoder = JSONDecoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            decoder.dateDecodingStrategy = .iso8601
        }
    }

    deinit {
        dataRequest = nil
        decoder = nil
    }

    @discardableResult
    private func _dataRequest(endpoint: IEndpoint) -> DataRequest {
        return AF.request(endpoint.path,
                          method: endpoint.method,
                          parameters: endpoint.parameters,
                          encoding: endpoint.encoding,
                          headers: endpoint.headers)
    }

    func request<T: Decodable>(endpoint: IEndpoint, completion: @escaping (FetchResult<T, ErrorResponse?>) -> Void) {
        guard NetworkStatus.isInternetAvailable else {
            completion(.failure(nil))
            return
        }

        dataRequest = _dataRequest(endpoint: endpoint)
        dataRequest.validate().responseDecodable(decoder: decoder) {
            (response: AFDataResponse<T>) in
            TRACER(endpoint, response.data?.toJSON)
            
            switch response.result {
            case .success(let response):
                completion(.success(response))
            case .failure:
                if let data = response.data, let errorResponse = try? self.decoder.decode(ErrorResponse.self, from: data) {
                    completion(.failure(errorResponse))
                } else {
                    completion(.failure(nil))
                }
            }
        }
    }
}

private func TRACER(_ endpoint: IEndpoint, _ data: String? = nil) {
    let trace = """
    --------------------------REQUEST BEGIN-------------------------
    [REQUEST]: \(endpoint.method.rawValue) \(endpoint.path)
    
    [ENCODING]: \(endpoint.encoding)
    
    [PARAMETERS]: \(endpoint.parameters == nil ? "-" : "\n" + (endpoint.parameters!.toJSON!))
    
    [HEADERS]: \(endpoint.headers == nil ? "-" : "\n" + (endpoint.headers!.dictionary.toJSON!))
    
    [RESPONSE]: \(data == nil ? "-" : "\n" + data!)
    --------------------------REQUEST END--------------------------
    """
    print(trace)
}
