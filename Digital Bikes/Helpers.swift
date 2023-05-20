//
//  Helpers.swift
//  Digital Bikes
//
//  Created by PSE on 18.05.23.
//

import Foundation
import UIKit

func updateUserDefaultsInfo(userData : [String : Any] ){
    let defaults = UserDefaults.standard
    
    defaults.set(userData["firstname"], forKey: "firstname")
    defaults.set(userData["surname"], forKey: "surname")
    defaults.set(userData["phone_number"], forKey: "phone_number")
    defaults.set(userData["email"], forKey: "email")
    defaults.set(userData["agent_name"], forKey: "agent_name")
    defaults.set(userData["agent_code"], forKey: "agent_code")
    defaults.set(userData["fine_status"], forKey: "fine_status")
    defaults.set(userData["bicycle_out"], forKey: "bicycle_out")
    defaults.set(userData["bicycle_number"], forKey: "bicycle_number")
    defaults.set(userData["helmet"], forKey: "helmet")
    defaults.set(userData["suspension"], forKey: "suspension")
    defaults.set(userData["residence"], forKey: "residence")
    defaults.set(userData["digital_time"], forKey: "digital_time")
    defaults.set(userData["registration"], forKey: "registration")
    defaults.set(userData["renting_times"], forKey: "renting_times")
    defaults.set(userData["free_digital_time"], forKey: "free_digital_time")
    defaults.set(userData["share_coded"], forKey: "share_coded")
    defaults.set(userData["preferred_location"], forKey: "preferred_location")
    defaults.set(userData["earning"], forKey: "earning")
    defaults.set(userData["gender"], forKey: "gender")
    defaults.set(userData["date_of_joining"], forKey: "date_of_joining")
    defaults.set(userData["registered_by"], forKey: "registered_by")
    defaults.set(userData["fine_times"], forKey: "fine_times")
    defaults.set(userData["password_recovery"], forKey: "password_recovery")
    defaults.set(userData["recovery_code"], forKey: "recovery_code")
    defaults.set(userData["time_riding"], forKey: "time_riding")
    defaults.set(userData["stars"], forKey: "stars")
    defaults.set(userData["comment"], forKey: "comment")
    defaults.set(userData["app_opens"], forKey: "app_opens")
    defaults.set(userData["profile_photo"], forKey: "profile_photo")
    defaults.set(userData["profile_photo_url"], forKey: "profile_photo_url")
    
    // Synchronize UserDefaults to make sure the values are saved
    defaults.synchronize()
}
