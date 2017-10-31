//
//  StyleSheet.swift
//  DemoCPSC599
//
//  Created by Nabil Muthanna on 2017-10-30.
//  Copyright © 2017 Victoria Lappas. All rights reserved.
//

import UIKit

struct StyleSheet {
    
    static var defaultTheme = Theme.demo
    
    enum Theme {
        case demo
        
        var mainColor: UIColor  {
            switch self {
            case .demo:
                return UIColor.init(colorWithHexValue: 0xEF5552)
            }
        }
        
        var secondaryColor: UIColor {
            switch self {
            case .demo:
                return UIColor.init(colorWithHexValue: 0xE4A18F)
            }
        }
        
        var incomingMessageColor: UIColor  {
            switch self {
            case .demo:
                return UIColor.init(colorWithHexValue: 0xEF5552)
            }
        }
        
        var incomingMessageTextColor: UIColor  {
            switch self {
            case .demo:
                return UIColor.white
            }
        }
        
        var outGoingMessageColor: UIColor  {
            switch self {
            case .demo:
                return UIColor.init(colorWithHexValue: 0xD4D3D3).withAlphaComponent(0.4)
            }
        }
        
        var outGoingMessageTextColor: UIColor  {
            switch self {
            case .demo:
                return UIColor.black
            }
        }
        
        
        var backgroundColor: UIColor {
            switch self {
            case .demo:
                return UIColor.rgb(r: 240, g: 240, b: 240)
            }
        }
        
        var contentBackgroundColor: UIColor {
            switch self {
            case .demo:
                return UIColor.white
            }
        }
    }
}

