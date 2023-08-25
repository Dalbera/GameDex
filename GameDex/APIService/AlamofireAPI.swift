//
//  AlamofireAPI.swift
//  GameDex
//
//  Created by Gabrielle Dalbera on 24/08/2023.
//

import Foundation
import Alamofire

class AlamofireAPI: API {
    
    // MARK: - Properties
    var lastTask: URLSessionTask?
    var basePath: String {
        return "https://api.mobygames.com/v1/"
    }
    
    func getData<T,U>(with endpoint: T, resultType: U.Type) async -> Result<U, APIError> where T: APIEndpoint, U: Decodable {
        //        self.session = Alamofire.Session(configuration: configuration)
        guard let url = URL(string: "\(self.basePath)\(endpoint.path)") else {
            //            return result
            return .failure(APIError.wrongUrl)
        }
        
        do {
            let (data, response) = try await makeRequest(url: url, endpoint: endpoint) // Data and response are stored
            
            guard let httpResponse = response,
                  httpResponse.statusCode == 200 else { // we check the type of response (HTTPURLResponse) and then we check the status code as it needs to be 200 to be OK
                return .failure(APIError.server)
            }
            guard let requestData = data else {
                return .failure(APIError.noData)
            }
            
            let decoder = JSONDecoder()
            let decodedResponse: U
            decodedResponse = try decoder.decode(U.self, from: requestData)
            return .success(decodedResponse)
        }
        catch {
            return .failure(APIError.parsingError)
        }
    }
    
    private func makeRequest(url: URL, endpoint: APIEndpoint) async throws -> (Data?, HTTPURLResponse?) {
        let APIrequest = await withCheckedContinuation { continuation in Session.default.request(
            url,
            method: AlamofireAPI.method(
                apiMethod: endpoint.method
            ),
            parameters: endpoint.entryParameters,
            encoding: URLEncoding.default,
            headers: nil
        ).validate().responseData { apiRequest in
            continuation.resume(returning: apiRequest)
        }
        }
        let data = APIrequest.value
        let response = APIrequest.response
        return (data, response)
    }
    
    class func method(apiMethod: APIMethod) -> HTTPMethod {
        
        let alamofireMethod: HTTPMethod
        
        switch apiMethod {
        case .get:
            alamofireMethod = .get
        case .post:
            alamofireMethod = .post
        case .put:
            alamofireMethod = .put
        case .delete:
            alamofireMethod = .delete
        }
        
        return alamofireMethod
    }
}