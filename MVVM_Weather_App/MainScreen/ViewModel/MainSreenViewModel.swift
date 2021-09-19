//
//  MainSreenViewModel.swift
//  MVVM_Weather_App
//
//  Created by Ilya Buzyrev on 17.09.2021.
//

import Foundation
import RxSwift
import RxCocoa

class MainScreenViewModel {
    
    public let city: PublishSubject<CityWeather> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let showCelsius: PublishSubject<Bool> = PublishSubject()
    
    init() {
        showCelsius.onNext(true)
    }
    
    public func requestData(searchString: String) {
        self.loading.onNext(true)
        ApiManager.requestCityData(cityName: searchString) {[weak self] result in
            self?.loading.onNext(false)
            switch result {
            case .success(let city):
                self?.city.onNext(city)
            case .failure(let error):
                print(error)
                self?.city.onNext(CityWeather(name: "", time: "", temperature_c: nil, temperature_f: nil))
            }
        }
    }
    
    public func convertTime(dateTime: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD HH:mm"
        let date = formatter.date(from: dateTime)
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date ?? Date())
    }
}
