//
//  WeatherManager.swift
//  Clima
//
//  Created by besim on 28.4.22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error)
}

let apiKey = "44c089b00d79fdad4dc74d12b8a3d9e7"
let city = ""

struct WeatherManager {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(city: String) {
        let urlString = "\(weatherUrl)&q=\(city)"
        performRequest(url: urlString)
    }
    
    func performRequest (url: String) {
        //1 create URL
        if let url = URL(string: url){
            
            //2 Create Url Session
            let session = URLSession(configuration: .default)
            
            //3 Give Session a Task
            let task = session.dataTask(with: url, completionHandler: hande(data:response:error:))
            
            //4 Taskat default jon pause ose stop faze kur inicaliozhet kshau g duhet resume tbohen
            task.resume()
        }
    }
    
    func hande(data: Data?, response: URLResponse?, error: Error?){
        if error != nil {
            delegate?.didFailWithError(error: error!)
            return
        }
        
        if let safeData = data {
//            let dataString  = String(data: safeData, encoding: String.Encoding.utf8)
            if let weather = self.parseJSON(weatherData: safeData){
             self.delegate?.didUpdateWeather(weather: weather)
            }
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temp: temp)
            
            return weather
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    
    
   
}
