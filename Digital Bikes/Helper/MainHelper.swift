//
//  MainHelper.swift
//  Prime Learn App
//
//  Created by PSE on 16.01.23.
//

import Foundation
import SwiftyJSON
import UIKit
import Alamofire

func switchScreen(parent:UIViewController, storyBoard : String){
    let storyboard = UIStoryboard(name: storyBoard, bundle: nil)
    let vc = storyboard.instantiateInitialViewController()! as UIViewController
    vc.modalPresentationStyle = .fullScreen
    parent.present(vc, animated: true)
}

func getScreen(parent:UIViewController, storyBoard : String, id : String) -> UIViewController?{
    let storyboard = UIStoryboard(name: storyBoard, bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: id)
    return vc
}



func showPopUpMessage(controller:UIViewController?, title: String?, message: String?, button: String? = "OK"){
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: button, style: .default, handler: nil) )
    controller?.present(alert, animated: true, completion: nil)
}


//ANY SAVE
func saveObject(key:String, obj:JSON){
    UserDefaults.standard.set(obj.rawString(), forKey: key)
}
func getObject(key:String) -> JSON?{
    if let objStr = UserDefaults.standard.string(forKey: key) {
        return JSON(parseJSON: objStr)
    }
    return nil
}



//SETTING -------------------------------------
func getAppSettings() -> [JSON]?{
    if let settings = UserDefaults.standard.string(forKey: "app_settings") {
        return JSON(parseJSON: settings).array
    }
    return nil
}
func saveAppSettings(settings:JSON){
    UserDefaults.standard.set(settings.rawString(), forKey: "app_settings")
}
func getAppSettingsValue(key:String) -> String? {
    let setting = getAppSettings()?.first(where: { it in
        it["setting_key"].string == key
    })
    return setting?["setting_value"].string
}




func getUser() -> JSON?{
    if let user = UserDefaults.standard.string(forKey: "user") {
        return JSON(parseJSON: user)
    }
    return nil
}

func getUserId() -> Int? {
    return getUser()?["id"].int ?? 0
}

func isUserFromAppleTest() -> Bool {
    let s = getUserId() ?? 0
    
    if s == 2 {
        return true
    }else{
        return false
    }
    
}

func getUserTemp() -> JSON?{
    if let user = UserDefaults.standard.string(forKey: "user-temp") {
        return JSON(parseJSON: user)
    }
    return nil
}
func isLoggedIn() -> Bool{
    return getUser() != nil
}
func saveUser(user:JSON){
    UserDefaults.standard.set(user.rawString(), forKey: "user")
}
func saveUserTemp(user:JSON){
    UserDefaults.standard.set(user.rawString(), forKey: "user-temp")
}
func logoutUser(){
    UserDefaults.standard.removeObject(forKey: "user")
}



func networkAction(controller : UIViewController, activity : UIActivityIndicatorView? = nil, url_part:String, method : HTTPMethod = .post, parameters : [String:String], outFunction : @escaping (JSON) -> Void){
    
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    if activity == nil {
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        controller.present(alert, animated: true, completion: nil)
    }else{
        activity?.isHidden = false
        activity?.hidesWhenStopped = true
        activity?.startAnimating()
    }
    
    func processData(response: AFDataResponse<String>){
        if response.value == nil {
            showPopUpMessage(controller: controller, title: "Caution \(response.response?.statusCode ?? 0)", message: "No Response")
        }else{
            let resJSON = JSON(parseJSON: response.value!)
            print(resJSON)
            outFunction(resJSON)
        }
    }
    
    AF.request("\(BASE_URL_FOR_API)\(url_part)", method: method, parameters: parameters)
        .responseString { response in
            if activity == nil {
                alert.dismiss(animated: true) {
                    processData(response:response)
                }
            }else{
                activity?.stopAnimating()
                processData(response: response)
            }
        }
}


func showComingSoon(vc : UIViewController?){
    
    let alert = UIAlertController(title: "Coming Soon", message: "Thank you for using Prime Learn App", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil) )
    vc?.present(alert, animated: true, completion: nil)
    
}





enum TimeFormat {
    case date
    case time
    case combined
    case brief
}

func formatLARAVELTIME(format:TimeFormat, datetime:String) -> String {
    let dateFormatterPrint = DateFormatter()
    
        if(format == .date){
            dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        }else if(format == .time){
            dateFormatterPrint.dateFormat = "h:mm a"
        }else if(format == .combined){
            dateFormatterPrint.dateFormat = "MMM dd,yyyy h:mm a"
        }else if(format == .brief){
            dateFormatterPrint.dateFormat = "dd,MMM h:mma"
        }else{
            dateFormatterPrint.dateFormat = "MMM dd,yyyy h:mm a"
        }
    
    return dateFormatterPrint.string(from: datetime.iso8601withFractionalSeconds!)
}
extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options) {
        self.init()
        self.formatOptions = formatOptions
    }
}
extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}
extension Date {
    var iso8601withFractionalSeconds: String { return Formatter.iso8601withFractionalSeconds.string(from: self) }
}
extension String {
    var iso8601withFractionalSeconds: Date? { return Formatter.iso8601withFractionalSeconds.date(from: self) }
}



//DELEGATE
protocol RefreshDelegate {
    func refresh (data:Any?)
}
