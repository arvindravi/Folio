//
//  AboutMeViewController.swift
//  Particles
//
//  Created by Arvind Ravi on 08/10/18.
//  Copyright © 2018 Arvind Ravi. All rights reserved.
//

import UIKit

class AboutMeViewController: UIViewController {
  
  // MARK: - Properties
  
  /*
   * Card View Properties
   */
  var cardVC: CardViewController!
  var cardHeight: CGFloat = 700.0
  let cardTitleHeight: CGFloat = 200.0
  var visualEffectView: UIVisualEffectView!

  /*
   * Card State Properties
   */
  var isContainerExpanded: Bool = false
  var nextState: State {
    return isContainerExpanded ? .Collapsed : .Expanded
  }
  
  /*
   * Animator Properties
   */
  var runningAnimators = [UIViewPropertyAnimator]()
  var animationProgressWhenInterrupted: CGFloat = 0.0
  
  enum State {
    case Expanded
    case Collapsed
  }
  
  // MARK: - Animation Methods
  
  
  /*
   * Frame Animator: UIViewPropertyAnimator that animates the frame of the cardView
   */
  private func frameAnimator(for state: State, animatedFor duration: TimeInterval) -> UIViewPropertyAnimator {
    let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
      switch state {
      case .Expanded:
        self.cardVC.view.frame.origin.y = self.view.frame.height - self.cardHeight
      case .Collapsed:
        self.cardVC.view.frame.origin.y = self.view.frame.height - self.cardTitleHeight
      }
    }
    
    frameAnimator.addCompletion { _ in
      self.isContainerExpanded = !self.isContainerExpanded
      self.runningAnimators.removeAll()
    }
    
    frameAnimator.scrubsLinearly = true
    frameAnimator.isInterruptible = true
    frameAnimator.startAnimation()
    return frameAnimator
  }
  
  /*
   * Blur Animator: UIViewPropertyAnimator that animates the blur of the Visual Effects View
   */
  private func blurAnimator(for state: State, animatedFor duration: TimeInterval) -> UIViewPropertyAnimator {
    let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
      switch state {
      case .Expanded:
        self.visualEffectView.effect = UIBlurEffect(style: .light)
      case .Collapsed:
        self.visualEffectView.effect = nil
      }
    }
    
    blurAnimator.isInterruptible = true
    blurAnimator.startAnimation()
    return blurAnimator
  }
  
  private func animateTransitionIfNeeded(state: State, duration: TimeInterval) {
    if runningAnimators.isEmpty {
      
      // Animate Frame
      let frameAnimator = self.frameAnimator(for: state, animatedFor: duration)
      runningAnimators.append(frameAnimator)
      
      // Blur Animator
      let blurAnimator = self.blurAnimator(for: state, animatedFor: duration)
      runningAnimators.append(blurAnimator)
      
      // Label Animator
      let inLabel = self.cardVC.titleLabel!
      let outLabel = self.cardVC.expandedLabel!
      
      let inLabelScaleWidth = outLabel.frame.width/inLabel.frame.width
      let inLabelScaleHeight = outLabel.frame.height/inLabel.frame.height
      
      let outLabelScaleWidth = inLabel.frame.width/outLabel.frame.width
      let outLabelScaleHeight = inLabel.frame.height/outLabel.frame.height
      
      let inLabelScale = CGAffineTransform(scaleX: inLabelScaleWidth, y: inLabelScaleHeight)
      let outLabelScale = CGAffineTransform(scaleX: outLabelScaleWidth, y: outLabelScaleHeight)
      
      let transformAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
        switch state {
        case .Expanded:
          outLabel.transform = .identity
          inLabel.transform = inLabelScale
        case .Collapsed:
          inLabel.transform = .identity
          outLabel.transform = outLabelScale
        }
      }
      
      transformAnimator.addCompletion { _ in
        inLabel.transform = .identity
        outLabel.transform = .identity
      }
      
      let inLabelAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeIn) {
        switch state {
        case .Expanded:
          inLabel.alpha = 0
        case .Collapsed:
          inLabel.alpha = 1
        }
      }
      
      let outLabelAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
        switch state {
        case .Expanded:
          outLabel.alpha = 1
        case .Collapsed:
          outLabel.alpha = 0
        }
      }
      
      cardVC.view.clipsToBounds = true
      cardVC.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      let cornerAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
        switch state {
        case .Expanded:
          self.cardVC.view.layer.cornerRadius = 12
        case .Collapsed:
          self.cardVC.view.layer.cornerRadius = 0
        }
      }
      cornerAnimator.startAnimation()
      runningAnimators.append(cornerAnimator)
      
      [transformAnimator, inLabelAnimator, outLabelAnimator].forEach { animator in
        animator.isInterruptible = true
        animator.scrubsLinearly = false
        animator.startAnimation()
        runningAnimators.append(animator)
      }
      
    }
  }
  
  private func animateOrReverseRunningTransition(state: State, duration: TimeInterval) {
    if runningAnimators.isEmpty {
      animateTransitionIfNeeded(state: state, duration: duration)
    } else {
      for animator in runningAnimators {
        animator.isReversed = !animator.isReversed
      }
    }
  }
  
  /*
   * Pan Handlers (pan intended)
   */
  
  // pan .begin
  fileprivate func startInteractiveTransition(state: State, duration: TimeInterval) {
    if runningAnimators.isEmpty {
      animateOrReverseRunningTransition(state: state, duration: duration)
    }
    
    for animator in runningAnimators {
      animator.pauseAnimation()
      animationProgressWhenInterrupted = animator.fractionComplete
    }
  }
  
  // pan .changed
  fileprivate func updateInteractiveTransition(fractionComplete: CGFloat) {
    for animator in runningAnimators {
      animator.fractionComplete = fractionComplete + animationProgressWhenInterrupted
    }
  }
  
  // pan .ended
  fileprivate func continueInteractiveTransition(cancel: Bool) {
    for animator in runningAnimators {
      animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
    }
  }
  
  // MARK: - Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setupVisualEffectView()
    setupCardViewController()
  }
  
  // MARK: - Setup Methods
  private func setupVisualEffectView() {
    visualEffectView = UIVisualEffectView()
    visualEffectView.frame = view.frame
    view.addSubview(visualEffectView)
  }
  
  private func setupCardViewController() {
    cardVC = CardViewController(nibName: "CardViewController", bundle: nil)
    addChild(cardVC)
    view.addSubview(cardVC.view)
    let frame = CGRect(x: 0,
                       y: view.frame.height - cardTitleHeight,
                       width: view.bounds.width,
                       height: cardHeight)
    cardVC.view.frame = frame
    
    addGestureRecognizers()
  }
  
  private func addGestureRecognizers() {
    let tapGR = UITapGestureRecognizer(target: self, action: #selector(toggleContainerOnTap))
    let panGR = InstantPanGestureRecognizer(target: self, action: #selector(toggleContainerContinuosly(gestureRecognizer:)))
    [tapGR, panGR].forEach { (GR) in
      cardVC.titleBar.addGestureRecognizer(GR)
    }
  }
}

/*
 * Gesture Recognizer Handlers (Tap & Pan)
 */
extension AboutMeViewController {
  @objc
  func toggleContainerOnTap() {
    animateOrReverseRunningTransition(state: nextState, duration: 1)
  }
  
  @objc
  func toggleContainerContinuosly(gestureRecognizer: InstantPanGestureRecognizer) {
    switch gestureRecognizer.state {
    case .began:
      startInteractiveTransition(state: nextState, duration: 0.3)
    case .changed:
      let translation = gestureRecognizer.translation(in: cardVC.titleBar)
      var progress = translation.y / (cardHeight - cardTitleHeight)
      progress = isContainerExpanded ? progress : -progress
      updateInteractiveTransition(fractionComplete: progress)
    case .ended:
      continueInteractiveTransition(cancel: true)
    default:
      print("Default.")
    }
  }
}

/*
 * UIPanGestureRecognizer that returns immediately
 */
class InstantPanGestureRecognizer: UIPanGestureRecognizer {
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
    if (self.state == .began) { return }
    super.touchesBegan(touches, with: event)
    self.state = .began
  }
}

