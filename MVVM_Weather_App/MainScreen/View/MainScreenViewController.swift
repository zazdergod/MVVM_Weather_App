//
//  MainScreenViewController.swift
//  MVVM_Weather_App
//
//  Created by Ilya Buzyrev on 17.09.2021.
//

import UIKit
import RxCocoa
import RxSwift

class MainScreenViewController: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var temperatureCelsiusLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureFarenheightLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private let viewModel = MainScreenViewModel()
    private let disposeBag = DisposeBag()
    private let temperatureValue = PublishSubject<String>()
    private var showCelsius = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBindings()
        labelsSetting()
    }
    
    private func labelsSetting() {
        temperatureCelsiusLabel.text = ""
        temperatureFarenheightLabel.text = ""
        cityLabel.text = ""
        timeLabel.text = ""
        temperatureFarenheightLabel.isHidden = true
    }
    
    
    private func addBindings() {
        viewModel.city
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] city in
                self?.cityLabel.text = city.name
                if let temperature_f = city.temperature_f, let temperature_c = city.temperature_c {
                    self?.temperatureFarenheightLabel.text = "\(temperature_f) F"
                    self?.temperatureCelsiusLabel.text = "\(temperature_c) C"
                } else {
                    self?.temperatureFarenheightLabel.text = ""
                    self?.temperatureCelsiusLabel.text = ""
                }
                self?.timeLabel.text = self?.viewModel.convertTime(dateTime: city.time)
            }).disposed(by: disposeBag)
        viewModel.showCelsius
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] show in
                if show {
                    self?.temperatureCelsiusLabel.isHidden = false
                    self?.temperatureFarenheightLabel.isHidden = true
                } else {
                    self?.temperatureFarenheightLabel.isHidden = false
                    self?.temperatureCelsiusLabel.isHidden = true
                }
                self?.showCelsius = show
            }).disposed(by: disposeBag)
        viewModel.loading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] loading in
                if loading {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            }).disposed(by: disposeBag)
        searchField.rx.text.orEmpty
            .throttle(.microseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { text in
                self.viewModel.requestData(searchString: text)
            }).disposed(by: disposeBag)
        
    }
   
    @IBAction func changeTemperatureType(_ sender: Any) {
        viewModel.showCelsius.onNext(!self.showCelsius)
    }

}
