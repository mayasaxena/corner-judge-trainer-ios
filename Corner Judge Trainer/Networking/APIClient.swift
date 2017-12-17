//
//  APIClient.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 2/6/17.
//  Copyright © 2017 Maya Saxena. All rights reserved.
//

import Foundation
import Intrepid
import Genome

final class CornerAPIClient: APIClient {

    static let shared = CornerAPIClient()

    func getMatches(completion: @escaping (Result<[Match]>) -> Void) {
        let getRequest = Request.getMatches.urlRequest

        sendDataTask(with: getRequest) { result in
            switch result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .secondsSince1970
                do {
                    let matchResponse = try jsonDecoder.decode(MatchesResponse.self, from: data)
                    completion(.success(matchResponse.matches))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
                print(error)
            }
        }
    }
}

class APIClient {

    static let unauthorizedStatusCode = 401

    enum Error: Swift.Error {
        case unknown
        case jsonSerialization
        case httpError
        case custom(message: String)
    }

    let session = URLSession(configuration: URLSessionConfiguration.default)

    func sendDataTask(with request: URLRequest, completion: ((Result<Data>) -> Void)?) {
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let completion = completion else { return }

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(Error.unknown))
                return
            }

            guard let data = data else {
                completion(.failure(Error.unknown))
                return
            }

            switch httpResponse.statusCode {
            case 200..<300:
                completion(.success(data))
            default:
                completion(.failure(Error.httpError))
            }
        }
        dataTask.resume()
    }
}

extension Data {
    var jsonObject: [String: Any]? {
        let jsonObject = try? JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions())
        return jsonObject as? [String: Any]
    }
}
