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

public final class CornerAPIClient: APIClient {

    static let shared = CornerAPIClient()

    func getMatches(completion: @escaping (Result<[Match]>) -> Void) {
        let getRequest = Request.getMatches.urlRequest

        sendDataTask(with: getRequest) { result in
            switch result {
            case .success(let json):
                guard let matchesNode = json["matches"] else {
                    completion(.failure(Error.custom(message: "Could not parse match JSON")))
                    return
                }

                do {
                    let matches = try [Match](node: matchesNode)
                    completion(.success(matches))
                } catch(let error) {
                    completion(.failure(error))
                }
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
        case jsonSerialization
        case httpError
        case custom(message: String)
    }

    let session = URLSession(configuration: URLSessionConfiguration.default)

    func sendDataTask(with request: URLRequest, completion: ((Result<Node>) -> Void)?) {
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

            let json: Node
            do {
                json = try data.makeNode()
            } catch(let error) {
                completion(.failure(error))
                return
            }

            switch httpResponse.statusCode {
            case 200..<300:
                completion(.success(json))
            default:
                completion(.failure(Error.httpError))
            }
        }
        dataTask.resume()
    }
}

extension Data {
    var jsonObject: [String : Any]? {
        let jsonObject = try? JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions())
        return jsonObject as? [String : Any]
    }
}
