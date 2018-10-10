//
//  RootViewController.swift
//  Folio
//
//  Created by Arvind Ravi on 26/09/18.
//  Copyright © 2018 Arvind Ravi. All rights reserved.
//

import UIKit

class RootViewController: UIPageViewController {
  private(set) lazy var pages: [UIViewController] = {
    return [viewController(for: "HelloViewController"),
            viewController(for: "IntroductionViewController"),
            viewController(for: "FillerViewControllerOne"),
            viewController(for: "RecipeTableViewController"),
            viewController(for: "FillerViewControllerTwo")]
  }()
  
  private func viewController(for title: String) -> UIViewController {
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: title)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dataSource = self
    
    if let firstVC = pages.first {
      setViewControllers([firstVC],
                         direction: .forward,
                         animated: true,
                         completion: nil)
    }
    
    let pageControl = UIPageControl.appearance()
    pageControl.pageIndicatorTintColor = .black
    pageControl.currentPageIndicatorTintColor = .lightGray
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    for view in self.view.subviews {
      if view is UIScrollView {
        view.frame = UIScreen.main.bounds
      } else if view is UIPageControl {
        view.backgroundColor = UIColor.clear
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

extension RootViewController: UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
    
    let previousIndex = viewControllerIndex - 1
    
    guard previousIndex >= 0 else { return nil }
    
    guard pages.count > previousIndex else { return nil }
    
    return pages[previousIndex]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
    
    let nextIndex = viewControllerIndex + 1
    
    guard pages.count != nextIndex else { return nil }
    
    guard pages.count > nextIndex else { return nil }
    
    return pages[nextIndex]
  }
  
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return pages.count
  }
  
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    return 0
  }
}
