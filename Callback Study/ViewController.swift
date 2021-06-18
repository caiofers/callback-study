//
//  ViewController.swift
//  Callback Study
//
//  Created by Caio Fernandes on 17/06/21.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet private weak var weatherInformationView: UIStackView!
    @IBOutlet private weak var getWeatherButton: UIButton!
    @IBOutlet private weak var loadingView: UIActivityIndicatorView!
    
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var weatherStateLabel: UILabel!
    @IBOutlet private weak var windSpeedLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var minTempLabel: UILabel!
    @IBOutlet private weak var maxTempLabel: UILabel!
    @IBOutlet private weak var theTempLabel: UILabel!
    
    private var locationManager = CLLocationManager()
    private var latitude: CLLocationDegrees?
    private var longitude: CLLocationDegrees?
    
    private var weatherInfo: ConsolidatedWeather?
    private var cityName: String?
    
    @IBAction private func getWeatherDidClicked(_ sender: Any) {
        getWeatherButton.isHidden = true
        loadingView.isHidden = false
        fetchWeather { [weak self] in
            print("Disso aqui")
            guard let weatherInfo = self?.weatherInfo, let cityName = self?.cityName else {
                self?.loadingView.isHidden = true
                self?.getWeatherButton.isHidden = false
                self?.weatherInformationView.isHidden = true
                return
            }
            
            self?.cityLabel.text = cityName
            self?.weatherStateLabel.text = weatherInfo.weatherStateName
            self?.windSpeedLabel.text = weatherInfo.weatherStateName
            self?.humidityLabel.text = String(weatherInfo.humidity)
            self?.minTempLabel.text = String(weatherInfo.minTemp)
            self?.maxTempLabel.text = String(weatherInfo.maxTemp)
            self?.theTempLabel.text = String(weatherInfo.theTemp)
            
            self?.loadingView.isHidden = true
            self?.getWeatherButton.isHidden = false
            self?.weatherInformationView.alpha = 1.0
        }
    }
    
    func fetchWeather(callback: @escaping () -> Void) -> Void {
        fetchLocationId { [weak self] result in
            if let woeid = result {
                self?.fetchWeatherInfo(locationId: woeid) {
                    callback()
                }
            }
        }
        print("Isso aqui executa antes")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherInformationView.alpha = 0.0
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied {
            presentLocationAlertDenied()
        }
    }
    
    func presentLocationAlertDenied(){
        let alertDenied = UIAlertController(title: "Localization Permission", message: "We need that you allow localization service to app works fine", preferredStyle: .alert)
        
        let configurationAction = UIAlertAction(title: "Open configuration", style: .default, handler: {(UIAlertAction) -> Void in
            
            if let configuration = NSURL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(configuration as URL)
            }
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertDenied.addAction(configurationAction)
        alertDenied.addAction(cancelAction)
        
        present(alertDenied, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocalization: CLLocation? = locations.last
        self.longitude = userLocalization?.coordinate.longitude
        self.latitude = userLocalization?.coordinate.latitude
    }
    
    func fetchLocationId(callback: @escaping (Int?) -> Void) {
        guard let latitude = latitude, let longitude = longitude else {
            return
        }
        
        let fullURL = "https://www.metaweather.com/api/location/search/?lattlong=\(latitude),\(longitude)"

      DispatchQueue.main.async {
        guard let url = URL(string: fullURL),
        let data = try? Data(contentsOf: url) else { return }

        if let weatherLocations = try? JSONDecoder().decode(WeatherLocations.self, from: data) {
            let woeid = weatherLocations.first?.woeid
            self.cityName = weatherLocations.first?.title
            callback(woeid)
        } else {
          print("Algo deu errado :(")
        }
      }
    }
    
    func fetchWeatherInfo(locationId: Int, callback: @escaping () -> Void) {
        
        let fullURL = "https://www.metaweather.com/api/location/\(locationId)/"

      DispatchQueue.main.async {
        guard let url = URL(string: fullURL),
        let data = try? Data(contentsOf: url) else { return }

        if let weatherInfo = try? JSONDecoder().decode(WeatherInfo.self, from: data) {
            self.weatherInfo = weatherInfo.consolidatedWeather.first
            callback()
        } else {
          print("Algo deu errado :(")
        }
      }
    }
}

