//
//  FileHelper.swift
//  Prime Learn App
//
//  Created by PSE on 28.02.23.
//

import Foundation
import UIKit

enum FILE_TYPE {
    case pdf, video, picture, audio, other, none
}


extension UIViewController {
    var size: Double {
        /*guard let attributes = try? FileManager.default.attributesOfItem(atPath: path), let size = attributes[.size] as? Double else {
            return 0.0
        }*/
        return 100
    }
    
    var sizeInKb: Double {
        return size / 1024
    }
    
    var sizeInMb: Double {
        return sizeInKb / 1024
    }
    
    var sizeInGb: Double {
        return sizeInMb / 1024
    }
    
    var sizeInTb: Double {
        return sizeInGb / 1024
    }
    
    func sizeStr() -> String {
        return String(format: "%.0f", size)
    }
    
    func sizeStrInKb(decimals: Int = 0) -> String {
        return String(format: "%.\(decimals)f", sizeInKb) + "Kb"
    }
    
    func sizeStrInMb(decimals: Int = 0) -> String {
        return String(format: "%.\(decimals)f", sizeInMb) + "Mb"
    }
    
    func sizeStrInGb(decimals: Int = 0) -> String {
        return String(format: "%.\(decimals)f", sizeInGb) + "Gb"
    }
    
    func sizeStrWithBytes() -> String {
        return sizeStr() + "b"
    }
    
    func sizeStrWithKb(decimals: Int = 0) -> String {
        return sizeStrInKb(decimals: decimals) + "Kb"
    }
    
    func sizeStrWithMb(decimals: Int = 0) -> String {
        return sizeStrInMb(decimals: decimals) + "Mb"
    }
    
    func sizeStrWithGb(decimals: Int = 0) -> String {
        return sizeStrInGb(decimals: decimals) + "Gb"
    }
    
    func whichFileIs(path : String) -> FILE_TYPE {
        let components = path.components(separatedBy: ".")
        guard components.count > 1 else { return .other }
            
        let x =  components.last!.lowercased()
        
        if x.isEmpty { return .none }
        
        switch true {
        case FileHelper.EXTENSION_VIDEOS.contains(x):
            return .video
        case FileHelper.EXTENSION_AUDIO.contains(x):
            return .audio
        case FileHelper.EXTENSION_PDF.contains(x):
            return .pdf
        case FileHelper.EXTENSION_PICTURE.contains(x):
            return .picture
        default:
            return .other
        }
    }
}

class FileHelper {
    static let EXTENSION_VIDEOS = ["mp4", "3gp"]
    static let EXTENSION_AUDIO = ["mp3", "wave", "m4a"]
    static let EXTENSION_PDF = ["pdf"]
    static let EXTENSION_PICTURE = ["jpg", "png", "jpeg", "gif"]
    /*
     class func isFileSizeAccepted(context: Context, file: URL) -> Bool {
     let upperLimitSize = Double(AppPreferences(context).getAppSettingsValue("expert_forum_maximum_file_size") ?? "0.0") ?? 0.0
     
     if file.sizeInMb < upperLimitSize {
     return true
     }
     
     let alertController = UIAlertController(title: "File Too Big", message: "We do not accept files whose size is above \(upperLimitSize) MBs (yours is \(file.sizeInMb) MBs)", preferredStyle: .alert)
     let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil
     
     */
    
}
