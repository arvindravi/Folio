//
//  IntroductionViewController.swift
//  Particles
//
//  Created by Arvind Ravi on 26/09/18.
//  Copyright © 2018 Arvind Ravi. All rights reserved.
//

import UIKit
import SceneKit

class IntroductionViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var batteryPercentageLabel: UILabel!
  @IBOutlet weak var textView: UITextView!
  
  enum BatteryState {
    case low, medium, full
  }
  var batteryLevel: BatteryState = .low
  
  // MARK: - Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  func setup() {
    view.backgroundColor = .black
    textView.textContainer.lineFragmentPadding = 0
    
    setBatteryLevel()
    setupGradientLayer()
    createParticles()
  }
  
  private func setBatteryLevel() {
    UIDevice.current.isBatteryMonitoringEnabled = true
    let percentage = Int(UIDevice.current.batteryLevel * 100)
    if  percentage > 60 {
      batteryLevel = .full
    } else if percentage < 75 && percentage > 35 {
      batteryLevel = .medium
    } else {
      batteryLevel = .low
    }
    self.batteryPercentageLabel.text = "\(Int(UIDevice.current.batteryLevel * 100))%"
  }
  
  private func color(for batterLevel: BatteryState) -> UIColor {
    switch batteryLevel {
    case .full: return UIColor.green
    case .medium: return UIColor.yellow
    case .low: return UIColor.red
    }
  }
  
  private func setupGradientLayer() {
    let gradientLayer = GradientLayer()
    gradientLayer.frame = view.bounds
    view.layer.addSublayer(gradientLayer)
    
    gradientLayer.opacity = 0.8
    let black = UIColor.black.cgColor
    let color = self.color(for: batteryLevel).cgColor
    
    CATransaction.begin()
    CATransaction.disableActions()
    gradientLayer.colors = [black, color]
    CATransaction.commit()
  }

  
  /*
   * Use CAEmitterLayer to Create Particles
   */
  func createParticles() {
    let particleEmitter = CAEmitterLayer()
    
    particleEmitter.emitterPosition = CGPoint(x: view.center.x, y: view.bounds.height + 50)
    particleEmitter.emitterShape = .point
    particleEmitter.emitterSize = view.bounds.size
    particleEmitter.emitterSize = CGSize(width: 320, height: view.bounds.height)
    
    particleEmitter.beginTime = CACurrentMediaTime()
    particleEmitter.contentsGravity = .top
    
    let color = makeEmitterCell(color: self.color(for: batteryLevel))
    
    particleEmitter.emitterCells = [color]
    
    view.layer.addSublayer(particleEmitter)
  }
  
  func makeEmitterCell(color: UIColor) -> CAEmitterCell {
    let cell = CAEmitterCell()
    cell.birthRate = 10
    cell.lifetime = 17
    cell.lifetimeRange = 0
    cell.color = color.cgColor
    cell.velocity = 15
    cell.velocityRange = 25
    cell.emissionLatitude = -CGFloat.pi / 4
    cell.emissionLongitude = -CGFloat.pi / 2
    cell.emissionRange = .pi
    cell.spin = -0.5
    cell.spinRange = 1.0
    
    cell.alphaSpeed = -1.0/17
    
    // Scale
    cell.scale = 0.1
    cell.scaleRange = 0.3
    cell.scaleSpeed = -0.01
    
    // Direction
    cell.yAcceleration = -5
    
    cell.contents = UIImage(named: "spark")?.cgImage
    return cell
  }
}
