//
//  CardViewController.swift
//  UIViewPropertyAnimatorExample
//
//  Created by Arvind Ravi on 13/10/17.
//  Copyright © 2017 Arvind Ravi. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

  // MARK: - IBOutlets
  @IBOutlet weak var titleBar: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var expandedLabel: UILabel!
  
  // MARK: - Properties
  var initialTitleBarFrameY: CGFloat = 0.0
  
  // MARK: - Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    expandedLabel.alpha = 0
    initialTitleBarFrameY = titleBar.frame.origin.y
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animateTitleBar()
  }
  
  private func animateTitleBarUp() {
    UIView.animate(withDuration: 0.4,
                   delay: 0,
                   usingSpringWithDamping: 0.8,
                   initialSpringVelocity: 0.5,
                   options: .curveEaseInOut,
                   animations: {
                    self.titleBar.frame.origin.y = self.initialTitleBarFrameY - 30
    }, completion: { _ in
      self.animateTitleBarDown()
    })
  }
  
  private func animateTitleBarDown() {
    UIView.animate(withDuration: 0.4,
                   delay: 0,
                   usingSpringWithDamping: 0.8,
                   initialSpringVelocity: 0.5,
                   options: .curveEaseOut,
                   animations: {
                    self.titleBar.frame.origin.y = self.initialTitleBarFrameY + 30 },
                   completion: nil)
  }
  
  private func animateTitleBar() {
    animateTitleBarUp()
  }
}
