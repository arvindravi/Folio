//
//  TableViewCell.swift
//  Particles
//
//  Created by Arvind Ravi on 28/09/18.
//  Copyright © 2018 Arvind Ravi. All rights reserved.
//

import UIKit
import CoreMotion

class CardCell: UITableViewCell {
  
  var imageData: Data?
  
  @IBOutlet weak var backgroundCardView: UIView! {
    didSet {
      styleBackgroundCardView()
    }
  }
  
  @IBOutlet weak var clippingView: UIView! {
    didSet {
      styleClippingView()
    }
  }
  
  @IBOutlet weak var primaryTextLabel: UILabel!
  @IBOutlet weak var primarySubtitleTextLabel: UILabel!
  
  var motionManager: CMMotionManager!
  static let reuseIdentifier = "CardCell"
  
  var isPressed: Bool = false
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  func setup() {
    motionManager = CMMotionManager()
    if motionManager.isDeviceMotionAvailable {
      motionManager.deviceMotionUpdateInterval = 0.02
      motionManager.startDeviceMotionUpdates(to: .main) { (motion, error) in
        if let motion = motion {
          let pitch = motion.attitude.pitch * 10
          let roll = motion.attitude.roll
          self.applyShadowToCells(width: CGFloat(pitch), height: CGFloat(roll))
        }
      }
    }
    
    configureGestureRecognizer()    
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    textLabel?.text = ""
  }
  
  private func applyShadowToCells(width: CGFloat, height: CGFloat) {
    backgroundCardView.layer.shadowOffset = CGSize(width: width, height: height)
  }
  
  private func configureGestureRecognizer() {
    // Long Press Gesture Recognizer
    let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(gestureRecognizer:)))
    longPressGestureRecognizer.minimumPressDuration = 0.1
    addGestureRecognizer(longPressGestureRecognizer)
  }
  
  @objc internal func handleLongPressGesture(gestureRecognizer: UILongPressGestureRecognizer) {
    if gestureRecognizer.state == .began {
      handleLongPressBegan()
    } else if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled {
      handleLongPressEnded()
    }
  }
  
  private func handleLongPressBegan() {
    guard !isPressed else {
      return
    }
    
    isPressed = true
    UIView.animate(withDuration: 0.5,
                   delay: 0.0,
                   usingSpringWithDamping: 0.8,
                   initialSpringVelocity: 0.2,
                   options: .beginFromCurrentState,
                   animations: {
                    self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
    }, completion: nil)
  }
  
  private func handleLongPressEnded() {
    guard isPressed else {
      return
    }
    
    UIView.animate(withDuration: 0.5,
                   delay: 0.0,
                   usingSpringWithDamping: 0.4,
                   initialSpringVelocity: 0.2,
                   options: .beginFromCurrentState,
                   animations: {
                    self.transform = CGAffineTransform.identity
    }) { (finished) in
      self.isPressed = false
    }
  }
  
  func styleBackgroundCardView() {
    backgroundCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
    backgroundCardView.layer.shadowRadius = 8.0
    backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 2)
    backgroundCardView.layer.shadowOpacity = 0.8
    backgroundCardView.layer.cornerRadius = 5.0
  }
  
  func styleClippingView() {
    clippingView.layer.cornerRadius = 5.0
    clippingView.layer.masksToBounds = true
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  /// This function is used to configure the cell using the View Model.
  ///
  /// - Parameter viewModel: Recipe View Model which conforms to RecipeItemPresentable
  func configure(withViewModel viewModel: RecipeItemViewModel) {
    selectionStyle = .none
    guard let title = viewModel.title else { return }
    self.primaryTextLabel?.text = title
    self.primarySubtitleTextLabel.text = viewModel.ingredients
  }
  
  /// This function is used to configure the cell using the Ingredient String.
  ///
  /// - Parameter ingerdient: String
  func configure(withIngredient ingredient: String) {
    selectionStyle = .none
    self.primaryTextLabel?.text = ingredient
    self.primarySubtitleTextLabel.text = ""
  }
  
}
