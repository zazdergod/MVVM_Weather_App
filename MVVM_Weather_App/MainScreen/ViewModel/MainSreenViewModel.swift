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
        CityWeather.getWeather(city: searchString) {[weak self] city in
            self?.loading.onNext(false)
            self?.city.onNext(city)
        }
    }
    
    public func convertTime(dateTime: String?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD HH:mm"
        let date = formatter.date(from: dateTime ?? "")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date ?? Date())
    }
}
