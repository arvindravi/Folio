//
//  ResponsiveButton.swift
//  Particles
//
//  Created by Arvind Ravi on 08/10/18.
//  Copyright © 2018 Arvind Ravi. All rights reserved.
//

import UIKit

class ResponsiveButton: UIButton {
  
  private var animator = UIViewPropertyAnimator()
  
  private let normalColor = UIColor(hexString: "000")
  private let highlightedColor = UIColor(hexString: "0x737373")
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    sharedInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    sharedInit()
  }
  
  private func sharedInit() {
    
    titleLabel?.textColor = normalColor
    
    addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter])
    addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
  }
  
  @objc private func touchDown() {
    animator.stopAnimation(true)
    titleLabel?.textColor = highlightedColor
  }
  
  @objc private func touchUp() {
    animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut, animations: {
      self.titleLabel?.textColor = self.normalColor
    })
    animator.startAnimation()
  }
}
