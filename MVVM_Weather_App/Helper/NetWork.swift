//
//  NetWork.swift
//  MVVM_Weather_App
//
//  Created by Ilya Buzyrev on 17.09.2021.
//

import Foundation
import SwiftyJSON

class ApiManager {
    
    static let baseUrl: String = "https://api.weatherapi.com/v1/current.json"
    static let apiKey: String = "f02e5ea0f4484b34a3d162233211709"
    
    
    enum RequestError: Error {
        case unknownError
        case connectionError
        case authorizationError(JSON)
        case invalidRequest
        case notFound
        case invalidResponse
        case serverError
        case serverUnavailable
    }
    
    enum HTTPMethod: String {
        case options = "OPTIONS"
        case get     = "GET"
        case head    = "HEAD"
        case post    = "POST"
        case put     = "PUT"
        case patch   = "PATCH"
        case delete  = "DELETE"
        case trace   = "TRACE"
        case connect = "CONNECT"
    }
    
    static func requestCityData(cityName: String, completion: @escaping (Result<CityWeather, RequestError>) -> Void) {
        
            let header: [String: String] = ["Content-Type": "application/json"]
        guard let url = URL(string: baseUrl + "?key=\(apiKey)&q=\(cityName)&aqi=no") else { return }
        var request = URLRequest(url: url)
        
        request.allHTTPHeaderFields = header
        request.httpMethod = HTTPMethod.get.rawValue
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.connectionError))
            } else if let data = data, let responseCode = response as? HTTPURLResponse {
                switch responseCode.statusCode {
                case 200:
                    do {
                        let responseJson = try? JSON(data: data)
                        guard let cityName = responseJson?["location"]["name"].string else { return }
                        guard let region = responseJson?["location"]["region"].string else { return }
                        guard let time = responseJson?["location"]["localtime"].string else { return }
                        guard let temperature_c = responseJson?["current"]["temp_c"].double else { return }
                        guard let temperature_f = responseJson?["current"]["temp_f"].double else { return }
                        let city = CityWeather.returnCity(cityName: cityName, region: region, time: time, temperature_c: temperature_c, temperature_f: temperature_f)
                        completion(.success(city))
                    }
                case 400...499:
                    completion(.failure(.invalidResponse))
                case 500...599:
                    completion(.failure(.serverError))
                default:
                    completion(.failure(.unknownError))
                    break
                }
            }
        }.resume()
    }
}
