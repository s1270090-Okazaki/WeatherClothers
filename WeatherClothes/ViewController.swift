//
//  ViewController.swift
//  WeatherClothes
//
//  Created by 岡崎慶汰 on 2022/05/25.
//

import UIKit
import Alamofire
import SwiftyJSON
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var locationText: UILabel!
    @IBOutlet weak var highText: UILabel!
    @IBOutlet weak var lowText: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var clothesImage: UIImageView!
    
    //各種天気データ
    var descriptionWeather: String = ""
    var location: String = "Fukushima"
    var tempStr: String = ""
    var tempNum: Int = 0
    
    //更新
    override func viewDidLoad() {
        super.viewDidLoad()
        getInfo()
        textSetting()
    }
    
    //テキスト設定
    func textSetting() {
        
        //サイズ
        locationText.text = location
        locationText.font = locationText.font.withSize(45)
        highText.font = highText.font.withSize(45)
        lowText.font = lowText.font.withSize(45)
        
        //カラー
        let rgbaHigh = UIColor(red: 244/255, green: 170/255, blue: 154/255, alpha: 1.0)
        let rgbaLow = UIColor(red: 129/255, green: 216/255, blue: 208/255, alpha: 1.0)
        let rgbaLocation = UIColor(red: 26/255, green: 11/255, blue: 8/255, alpha: 1.0)
        highText.textColor = rgbaHigh
        lowText.textColor = rgbaLow
        locationText.textColor = rgbaLocation
    }
    
    //データ情報取得
    func getInfo() {
        
        //Aizu 37.30, 139.56
        //Fukushima 37.382, 140.222
        
        //OpenWeatherサイトのURL関連
        let text = "https://api.openweathermap.org/data/2.5/weather?lat=\(37.382)&lon=\(140.222)&units=metric&appid=e0c443ba38d6f962a800191616f56f76"
        
        let url = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        //APIコール
        AF.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
                    switch response.result {
                    case .success:
                        let json = JSON(response.data as Any)
                        self.descriptionWeather = json["weather"][0]["main"].string!
                        
                        //現在天気を表示
                        if self.descriptionWeather == "Clouds" {
                            self.weatherImage.image = UIImage(named: "cloudy")
                        }else if self.descriptionWeather == "Rain" {
                            self.weatherImage.image = UIImage(named: "rain")
                        }else if self.descriptionWeather == "Snow" {
                            self.weatherImage.image = UIImage(named: "snow")
                        }else{
                            self.weatherImage.image = UIImage(named: "sunny")
                        }
                        
                        self.tempStr = "\(Int(truncating: json["main"]["temp"].number!).description)"
                        self.tempNum = Int(self.tempStr)!
                        
                        //提案する服装を表示
                        if self.tempNum >= 30 {
                            self.clothesImage.image = UIImage(named: "clothes_1")
                        }else if self.tempNum < 30 && self.tempNum >= 25 {
                            self.clothesImage.image = UIImage(named: "clothes_2")
                        }else if self.tempNum < 25 && self.tempNum >= 20 {
                            self.clothesImage.image = UIImage(named: "clothes_3")
                        }else if self.tempNum < 20 && self.tempNum >= 15 {
                            self.clothesImage.image = UIImage(named: "clothes_4")
                        }else if self.tempNum < 15 && self.tempNum >= 10 {
                            self.clothesImage.image = UIImage(named: "clothes_5")
                        }else if self.tempNum < 10 && self.tempNum >= 5 {
                            self.clothesImage.image = UIImage(named: "clothes_6")
                        }else {
                            self.clothesImage.image = UIImage(named: "clothes_7")
                        }
                        
                        //最高気温、最低気温を表示
                        self.highText.text = "\(Int(truncating: json["main"]["temp_max"].number!).description)℃"
                        self.lowText.text = "\(Int(truncating: json["main"]["temp_min"].number!).description)℃"
                        
                    case .failure(let error):
                        print(error)
                    }
                }
    }
    

}

