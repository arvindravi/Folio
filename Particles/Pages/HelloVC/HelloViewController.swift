//
//  ViewController.swift
//  Particles
//
//  Created by Arvind Ravi on 20/08/18.
//  Copyright © 2018 Arvind Ravi. All rights reserved.
//

import UIKit
import SceneKit

class HelloViewController: UIViewController {
  
  // MARK: - IBOutlets
  @IBOutlet weak var sceneView: SCNView!
  
  // MARK: - Properties
  var particlesNode: SCNNode?
  let colors: [String] = ["#FEA47F", "#25CCF7", "#EAB543", "#55E6C1", "#CAD3C8", "#F97F51", "#1B9CFC", "#F8EFBA", "#58B19F", "#2C3A47", "#B33771", "#3B3B98", "#FD7272", "#9AECDB", "#D6A2E8", "#6D214F", "#182C61", "#FC427B", "#BDC581", "#82589F"]

  // MARK: - Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  // MARK: - Setup Methods
  func setup() {
    setupMask()
    setupScene()
    setupParticles()
  }
  
  /*
   * Setup Bending Spoons Mask
   */
  private func setupMask() {
    let image = UIImage(named: "Mask")!
    let imageView = UIImageView(image: image)
    imageView.frame = view.frame
    imageView.contentMode = .scaleAspectFill
    sceneView.mask = imageView
  }
  
  private func setupScene() {
    sceneView.autoenablesDefaultLighting = true
    if let camera = sceneView.pointOfView?.camera {
      camera.wantsHDR = true
      camera.wantsExposureAdaptation = true
      camera.exposureOffset = -1
      camera.minimumExposure = -1
      camera.maximumExposure = 3
    }
    
    let scene = SCNScene(named: "sphere.scn")
    sceneView.scene = scene
  }
  
  /*
   * Setup Particles: Initialize SceneKit Particles System and Run Rotation
   */
  private func setupParticles() {
    guard let particlesNode = sceneView.scene?.rootNode.childNode(withName: "particles", recursively: true) else { return }
    guard let particlesSystem = particlesNode.particleSystems?.first else { return }
    
    self.particlesNode = particlesNode
    
    let rotateBy = 360 * (CGFloat.pi / 180)
    let rotateAround = SCNVector3(0, 1, 0)
    let rotateAction = SCNAction.rotate(by: rotateBy, around: rotateAround, duration: 5)
    let rotateForever = SCNAction.repeatForever(rotateAction)
    
    particlesSystem.emitterShape = SCNSphere(radius: 1)
    particlesNode.runAction(rotateForever)
  }
  
  // MARK: - IBAction
  
  /*
   * Change Particles Color when Button is Tapped
   */
  @IBAction func changeColor(_ sender: Any) {
    guard let particlesNode = particlesNode else { return }
    guard let particlesSystem = particlesNode.particleSystems?.first else { return }
    particlesSystem.particleColor = UIColor(hexString: colors[Int.random(in: 0..<colors.count)])
  }
}
