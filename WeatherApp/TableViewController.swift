//
//  TableViewController.swift
//  WeatherApp
//
//  Created by Sunrise Sunrise on 9/8/20.
//  Copyright © 2020 Sunrise Sunrise. All rights reserved.
//

import UIKit
import CoreLocation

class TableViewController: UITableViewController, CLLocationManagerDelegate {
 

    private var gradientLayer = CAGradientLayer()
    var models = [Daily]()
    var todayWeather: Daily?
    var hourlyModels = [Hourly]()
    var addInfoArray : [AddInfo] = [AddInfo]()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var current: Current?
    var result: WeatherInformation?
  let apiKey = "7124a0493ece31f57c27c6eb0ebdcad4"
    
   
    
   
   override func viewDidLoad() {
        super.viewDidLoad()
    
    tableView.register(DailyForecastCell.nib(), forCellReuseIdentifier: DailyForecastCell.identifier)
    tableView.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
    tableView.register(DailyInfoTableViewCell.nib(), forCellReuseIdentifier: DailyInfoTableViewCell.identifier)
    tableView.register(AdditionalInfoCell.nib(), forCellReuseIdentifier: AdditionalInfoCell.identifier)
     tableView.register(HeaderTableViewCell.nib(), forCellReuseIdentifier: HeaderTableViewCell.identifier)
 tableView.tableFooterView = UIView()
    
  
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        determineMyCurrentLocation()
    }

    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
           
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation:CLLocation = locations[0] as CLLocation

        manager.stopUpdatingLocation()

       let long = currentLocation.coordinate.longitude
       let lat = currentLocation.coordinate.latitude
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&appid=\(apiKey)"
    
            URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in

                    guard let data = data, error == nil else {
                        print("something went wrong")
                        return
                    }
        
                    var json: WeatherInformation?
                    do {
                        json = try JSONDecoder().decode(WeatherInformation.self, from: data)
                                    }
                    catch {
                        print(error)
                    }
       
                    guard let result = json else {
                        return
                    }

                    let entries = result.daily
               
                self.models.append(contentsOf: entries)
                self.todayWeather = self.models[0]
                self.models.removeFirst()
                let current = result.current
                self.result = result
                self.current = current
                self.hourlyModels = result.hourly
                
                    DispatchQueue.main.async {
                        
                        self.createAddArray()
                        self.tableView.reloadData()
                    }
                }).resume()
    
    }
    

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }

 
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier, for: indexPath) as! HeaderTableViewCell
                  guard let currentWeather = self.current else {return cell }
            let location = CLLocation(latitude: result!.lat, longitude: result!.lon)
            fetchCountryAndCity(location: location) { country, city in
                cell.cityLabel.text = city
            }
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
            cell.cityLabel.isHidden = false
            cell.tempLabel.isHidden = false
            cell.weatherLabel.isHidden = false
            cell.configure(with: currentWeather)
        return cell
        }
        if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: DailyForecastCell.identifier, for: indexPath) as! DailyForecastCell
              guard let currentWeather = self.todayWeather else {return cell }
            cell.configureCurrent (with: currentWeather )
            cell.dayLabel.isHidden = false
                       cell.maxTempLabel.isHidden = false
                       cell.minTempLabel.isHidden = false
                       cell.icon.isHidden = false
            return cell
        }
        if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
            cell.configure(with: hourlyModels)
            return cell
        } else if indexPath.section == 3{
        let cell = tableView.dequeueReusableCell(withIdentifier: DailyForecastCell.identifier, for: indexPath) as! DailyForecastCell
        cell.configure(with: models[indexPath.row])
            cell.dayLabel.isHidden = false
            cell.maxTempLabel.isHidden = false
            cell.minTempLabel.isHidden = false
            cell.icon.isHidden = false
        return cell
        } else if indexPath.section == 4{
        let cell = tableView.dequeueReusableCell(withIdentifier: DailyInfoTableViewCell.identifier, for: indexPath) as! DailyInfoTableViewCell
        guard let currentWeather = self.current else {return cell }
        cell.configure(with: currentWeather)
            cell.dailyInfo.isHidden = false
        return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: AdditionalInfoCell.identifier, for: indexPath) as! AdditionalInfoCell
        let currentLastItem = addInfoArray[indexPath.row]
        cell.descriptionLabel.text = "\(currentLastItem.descriptionInfo)"
        cell.titleLabel.text = currentLastItem.titleInfo
        
        return cell
        
      
    }
   override  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 2 || section == 4 || section == 1 {
            return 1
        } else if section == 5 {
            return addInfoArray.count
        }
        return models.count
    }
    override  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0   {
            return 200
        }
        else if indexPath.section == 2 || indexPath.section == 4{
            return 100
        } else if indexPath.section == 3{
            return 30
        }
        return 50
    }
  func fetchCountryAndCity(location: CLLocation, completion: @escaping (String, String) -> ()) {
                  CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                      if let error = error {
                          print(error)
                      } else if let country = placemarks?.first?.country,
                          let city = placemarks?.first?.locality {
                          completion(country, city)
                      }
                  }
           }
    func createAddArray(){
        
        addInfoArray.append(AddInfo(titleInfo: "HUMIDITY", descriptionInfo: "\(Int(current!.humidity))%"))
        addInfoArray.append(AddInfo(titleInfo: "PRESSURE", descriptionInfo: "\(Int(current!.pressure)) hPa"))
        addInfoArray.append(AddInfo(titleInfo: "FEELS LIKE", descriptionInfo: "\(Int( current!.feels_like - 273.15))°C"))
        addInfoArray.append(AddInfo(titleInfo: "WIND SPEED", descriptionInfo: "\(Int(current!.wind_speed)) metre/sec"))
        addInfoArray.append(AddInfo(titleInfo: "UV INDEX", descriptionInfo: "\(Int(current!.uvi))"))
        addInfoArray.append(AddInfo(titleInfo: "CLOUDINESS", descriptionInfo: "\(Int(current!.clouds))%"))

    }
}


