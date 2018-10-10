//
//  GradientLayer.swift
//  Particles
//
//  Created by Arvind Ravi on 27/09/18.
//  Copyright © 2018 Arvind Ravi. All rights reserved.
//

import UIKit

class GradientLayer: CALayer {
  required override init() {
    super.init()
    needsDisplayOnBoundsChange = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  required override init(layer: Any) {
    super.init(layer: layer)
  }
  
  public var colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
  
  override func draw(in ctx: CGContext) {
    ctx.saveGState()
    
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    var locations = [CGFloat]()
    
    for i in 0...colors.count-1 {
      locations.append(CGFloat(i) / CGFloat(colors.count))
    }
    
    let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)
    let center = CGPoint(x: bounds.width / 2.0, y: bounds.height + 450)
    
    let startRadius = min(bounds.width * 3.5, bounds.height)
    let endRadius = CGFloat(0.0)
    
    ctx.drawRadialGradient(gradient!, startCenter: center, startRadius: startRadius, endCenter: center, endRadius: endRadius, options: CGGradientDrawingOptions.drawsAfterEndLocation)
  }
}
