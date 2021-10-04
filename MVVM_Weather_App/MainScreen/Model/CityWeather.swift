//
//  CityWeather.swift
//  MVVM_Weather_App
//
//  Created by Ilya Buzyrev on 17.09.2021.
//

import Foundation

class CityWeather {
    var name, time, region: String?
    var temperature_c, temperature_f: Double?
    var id: Int?
    
    static func getWeather(city: String?, completion: @escaping (CityWeather) -> Void) {
        guard let city = city else { return }
        ApiManager.requestCityData(cityName: city) { result in
            switch result {
            case .success(let cityWeather):
                completion(cityWeather)
            case .failure(let error):
                print(error)
                completion(CityWeather())
            }
        }
    }
    
    static func returnCity(cityName: String, region: String, time: String, temperature_c: Double, temperature_f: Double) -> CityWeather {
        let city = CityWeather()
        city.name = cityName
        city.region = region
        city.time = time
        city.temperature_c = temperature_c
        city.temperature_f = temperature_f
        return city
    }
}


