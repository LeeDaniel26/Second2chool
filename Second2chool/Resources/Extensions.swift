//
//  Extensions.swift
//  Second2chool
//
//  Created by Daniel Lee on 2024/01/28.
//

import UIKit

extension UIView {
    
    public var width: CGFloat {
        return frame.size.width
    }
    
    public var height: CGFloat {
        return frame.size.height
    }
    
    public var top: CGFloat {
        return frame.origin.y
    }
    
    public var bottom: CGFloat {
        return frame.origin.y + frame.size.height
    }
    
    public var left: CGFloat {
        return frame.origin.x
    }
    
    public var right: CGFloat {
        return frame.origin.x + frame.size.width
    }
    
}


// Use it like: "UIColor(rgb: 0xEB455F)"

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

extension Foundation.Data {
    // (중요): Reusable parseJSON for variety of return database types
    func parseJSON<T: Decodable>(type: T.Type) -> T? {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: self)
            return decodedData
        } catch {
            print("Error: parseJSON error -> singlePostManager")
            return nil
        }
    }
    
    // (중요): console에 출력된 data response 가독성을 높이기 위한 코드이다.
    // JSONSerialization 대신 parseJSON에서 사용한 JSONDecoder, JSONEncoder를 사용해봤지만 '.prettyPrinted'는 Dictionary, Array 구조를 갖는 data만 지원하므로 JSONDecoder를 사용하여 'struct'로 decode한 데이터에 .prettyPrinted를 적용할수 없었다. (코드는 돌아갔지만 .prettyPrinted되지 않은 결과가 나왔다.)
    func prettyPrintJSON() {
        if let json = try? JSONSerialization.jsonObject(with: self, options: .allowFragments),
           let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            print(prettyString)
        } else {
            print("Failed to print pretty JSON")
        }
    }
}

extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }

        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }

        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0

        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}

