//
//  CGFloat+Extensions.swift
//  Particles
//
//  Created by Arvind Ravi on 09/10/18.
//  Copyright © 2018 Arvind Ravi. All rights reserved.
//

import CoreGraphics

public extension CGFloat {
  /// Returns a random floating point number between 0.0 and 1.0, inclusive.
  public static var random: CGFloat {
    return CGFloat(arc4random()) / 0xFFFFFFFF
  }
  
  /// Random float between 0 and n-1.
  ///
  /// - Parameter n:  Interval max
  /// - Returns:      Returns a random float point number between 0 and n max
  public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return CGFloat.random * (max - min) + min
  }
}
