//
//  APIClient.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 2/6/17.
//  Copyright © 2017 Maya Saxena. All rights reserved.
//

import Foundation
import Intrepid

public final class CornerAPIClient: APIClient {
    func getMatches() {
        let getRequest = Request.getMatches.urlRequest

        sendDataTask(with: getRequest) { result in
            switch result {
            case .success(let json):
                print(json)
            case .failure(let error):
                print(error)
            }
        }
    }
}

public class APIClient {

    static let unauthorizedStatusCode = 401

    enum Error: Swift.Error {
        case unknown
        case httpError
    }

    let session = URLSession(configuration: URLSessionConfiguration.default)

    func sendDataTask(with request: URLRequest, completion: ((Result<[String : Any]>) -> Void)?) {
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let completion = completion else { return }

            if let error = error {
                completion(.failure(error))
            } else if let httpResponse = response as? HTTPURLResponse {
                var json: [String : Any] = [:]
                if let data = data, data.count > 0 {
                    do {
                        guard let rawJson = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String : Any] else {
                            completion(.failure(Error.unknown))
                            return
                        }

                        json = rawJson
                    } catch {
                        completion(.failure(error))
                    }
                }

                let statusCode = httpResponse.statusCode
                switch statusCode {
                case 200..<300:
                    completion(.success(json))
                default:
                    completion(.failure(Error.httpError))
                }
            } else {
                completion(.failure(Error.unknown))
            }
        })
        dataTask.resume()
    }
}
