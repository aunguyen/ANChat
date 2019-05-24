//
//  Extensions.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/17/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

extension UIViewController{
	func goto(vc: UIViewController, animated: Bool = true) {
		guard let navi = self.navigationController else {return}
		
		for v in navi.viewControllers{
			if v .isKind(of: vc.classForCoder){
				navi.popToViewController(v, animated: animated)
				return
			}
		}
		navi.pushViewController(vc, animated: animated)
	}
	
	func popViewController(animated: Bool = true) {
		self.navigationController?.popViewController(animated: animated)
	}
	
	func setNaviLeftBtn(image: UIImage, title: String, handler: Selector){
		let leftBtn = UIBarButtonItem(image: image, style: .plain, target: self, action: handler)
		self.navigationController?.navigationItem.title = title
		self.navigationItem.leftBarButtonItem = leftBtn
	}
	
	func setNaviRightBtn(image: UIImage, title: String, handler: Selector){
		let rightBtn = UIBarButtonItem(image: image, style: .plain, target: self, action: handler)
		self.navigationController?.navigationItem.title = title
		self.navigationItem.rightBarButtonItem = rightBtn
	}
	
	func registerNoti(name:String,selector: Selector){
		NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name(name), object: nil)
	}
	
}

extension String {
    var hasValue: Bool {
        return self.count > 0
    }
	
    var isEmail: Bool {
        let emailRegExpression = "\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}\\b"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegExpression)
        return emailPredicate.evaluate(with: self)
    }
    
    var isPassword: Bool {
        let regExpression = "(?!^[0-9]*$)(?!^[a-zA-Z]*$)^([a-zA-Z0-9]{8,999})$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regExpression)
        return predicate.evaluate(with: self)
    }

    var isPhoneNumber: Bool {
        let regExpression = "^[+]?[0-9.*#,;\\(\\) ]{0,20}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regExpression)
        return predicate.evaluate(with: self)
    }
    
    static func isEmpty(s: String?) -> Bool {
        return s?.isEmpty ?? true
    }
    
    func trimAllSpace() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
}

enum RoundType {
    case top
    case none
    case bottom
    case both
}

extension UIView{
    func cornerFormat(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
	
	func addBorders(color:UIColor,width:CGFloat){
		self.layer.borderColor = color.cgColor
		self.layer.borderWidth = width
	}
	
	func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
		layer.masksToBounds = false
		layer.shadowOffset = offset
		layer.shadowColor = color.cgColor
		layer.shadowRadius = radius
		layer.shadowOpacity = opacity
		
		let backgroundCGColor = backgroundColor?.cgColor
		backgroundColor = nil
		layer.backgroundColor =  backgroundCGColor
	}
    
    func round(with type: RoundType, radius: CGFloat = 3.0) {
        var corners: UIRectCorner
        
        switch type {
        case .top:
            corners = [.topLeft, .topRight]
        case .none:
            corners = []
        case .bottom:
            corners = [.bottomLeft, .bottomRight]
        case .both:
            corners = [.allCorners]
        }
        
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

extension UIButton {
    func setCornerAndShadow(color: UIColor = kColor32A8A8){
        layer.cornerRadius = bounds.height/2
        layer.masksToBounds = false
        layer.applySketchShadow(color: color, alpha: 0.35, x: 0, y: 2, blur: 4, spread: 0)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgba: String) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if rgba.hasPrefix("#") {
            let index = rgba.index(rgba.startIndex, offsetBy: 1)
            let hex = String(rgba[index...])
            let scanner = Scanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexInt64(&hexValue) {
                switch hex.count {
                case 3:
                    red = CGFloat((hexValue & 0xF00) >> 8) / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
                    blue = CGFloat(hexValue & 0x00F) / 15.0
                case 4:
                    red = CGFloat((hexValue & 0xF000) >> 12) / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8) / 15.0
                    blue = CGFloat((hexValue & 0x00F0) >> 4) / 15.0
                    alpha = CGFloat(hexValue & 0x000F) / 15.0
                case 6:
                    red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
                    blue = CGFloat(hexValue & 0x0000FF) / 255.0
                case 8:
                    red = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF) / 255.0
                default:
                   print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8")
                }
            } else {
                print("Scan hex error")
            }
        } else {
            print("Invalid RGB string, missing '#' as prefix")
        }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(netHex: Int) {
        self.init(red: (netHex >> 16) & 0xff, green: (netHex >> 8) & 0xff, blue: netHex & 0xff)
    }
    
    convenience init(netHex: Int, alpha: CGFloat) {
        let red = (netHex >> 16) & 0xff
        let green = (netHex >> 8) & 0xff
        let blue = netHex & 0xff
        
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if alpha {
            return String(format: "#%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255),
                          lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}

extension UIStoryboard {
	class func vcFrom(storyboard:String,identifier:String?) -> UIViewController?{
		let sb = UIStoryboard(name: storyboard, bundle: nil)
		if let id = identifier, id.hasValue{
			return sb.instantiateViewController(withIdentifier: id)
		}else{
			return sb.instantiateInitialViewController()
		}
		
	}
}

extension UITextField{
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UILabel{
    func setHighlightText(fullString: String, hightLightString: String, hightLightColor: UIColor, hightLightFont: UIFont?) {
        let range = (fullString as NSString).range(of: hightLightString)
        
        let attribute = NSMutableAttributedString.init(string: fullString)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: hightLightColor, range: range)
        if let hlFont = hightLightFont{
            attribute.addAttribute(NSAttributedString.Key.font, value: hlFont, range: range)
        }

        self.attributedText = attribute
    }
    
    func addCharacterSpacing(kernValue: Double = 1.15) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}

extension JVFloatLabeledTextField{
	func configUITextFiledWith(placeholderText: String = "") {
		let padding : CGFloat = 8.0
		self.floatingLabelYPadding = padding
		self.floatingLabelActiveTextColor = kColor969696
		self.floatingLabelFont = Fonts.Roboto.medium.toFontWith(size: 12.0)
		self.placeholderColor = kColor969696
		self.round(with: .both, radius: 6.0)
		self.setLeftPaddingPoints(padding)
		self.borderStyle = .none
		self.textColor = kColor2D2D2D
		self.font = Fonts.Roboto.regular.toFontWith(size: 16.0)
		self.placeholder = placeholderText
		self.backgroundColor = kColor969696Alpha12
	}
}

extension UITableView {
	func scrollToBottomRow() {
		DispatchQueue.main.async {
			guard self.numberOfSections > 0 else { return }
			var section = max(self.numberOfSections - 1, 0)
			var row = max(self.numberOfRows(inSection: section) - 1, 0)
			var indexPath = IndexPath(row: row, section: section)
			
			while !self.indexPathIsValid(indexPath) {
				section = max(section - 1, 0)
				row = max(self.numberOfRows(inSection: section) - 1, 0)
				indexPath = IndexPath(row: row, section: section)
				
				// If we're down to the last section, attempt to use the first row
				if indexPath.section == 0 {
					indexPath = IndexPath(row: 0, section: 0)
					break
				}
			}
			guard self.indexPathIsValid(indexPath) else { return }
			
			self.scrollToRow(at: indexPath, at: .bottom, animated: true)
		}
	}
	
	func indexPathIsValid(_ indexPath: IndexPath) -> Bool {
		let section = indexPath.section
		let row = indexPath.row
		return section < self.numberOfSections && row < self.numberOfRows(inSection: section)
	}
}

extension Date{
	func formatChatDateToTime() -> String{
		//2019-04-09 03:21:21 +0000
		let fm = DateFormatter()
		fm.dateFormat = "hh:mm a"
		fm.amSymbol = "am"
		fm.pmSymbol = "pm"
		return fm.string(from:self)
	}
	
	func formatChatDateToDate() -> String{
		let fm = DateFormatter()
		if abs(self.timeIntervalSinceNow) > 24*3600{
			fm.dateFormat = "dd-MM-YYYY"
			return fm.string(from: self)
		}
		fm.dateFormat = "hh:mm a"
		fm.amSymbol = "am"
		fm.pmSymbol = "pm"
		return fm.string(from:self)
	}
	
	func reduceToMonthDayYear() -> Date {
		let calendar = Calendar.current
		let month = calendar.component(.month, from: self)
		let day = calendar.component(.day, from: self)
		let year = calendar.component(.year, from: self)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/YYYY"
		return dateFormatter.date(from: "\(day)/\(month)/\(year)") ?? Date()
	}
}

