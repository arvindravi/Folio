//
//  RecipeDetailViewController.swift
//  Particles
//
//  Created by Arvind Ravi on 05/10/18.
//  Copyright © 2018 Arvind Ravi. All rights reserved.
//

import UIKit
import Hero

class RecipeDetailViewController: UIViewController {
  
  // MARK: - Outlets
  @IBOutlet weak var tableHeaderClippingView: UIView! {
    didSet {
      styleClippingView()
    }
  }
  
  @IBOutlet weak var recipeTitleLabel: UILabel! {
    didSet {
      styleLabel()
    }
  }
  @IBOutlet weak var ingredientsTableView: UITableView!
  
  // MARK: - Properties
  var recipeTitle: String?
  var ingredients: [String]?
  
  // MARK: - Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupUI()
  }
  
  // MARK: - Setup Methods
  func setup() {
    setupTableView()
  }
  
  func setupTableView() {
    ingredientsTableView.dataSource = self
    ingredientsTableView.delegate = self
  }
  
  func setupUI() {
    navigationController?.navigationBar.prefersLargeTitles = false
    navigationItem.largeTitleDisplayMode = .never
    guard let title = recipeTitle else { return }
    self.title = title
  }
  
  fileprivate func styleLabel() {
    recipeTitleLabel.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
    recipeTitleLabel.layer.shadowRadius = 8.0
    recipeTitleLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
    recipeTitleLabel.layer.shadowOpacity = 0.8
    recipeTitleLabel.layer.cornerRadius = 5.0

  }
  
  func styleClippingView() {
    tableHeaderClippingView.layer.cornerRadius = 5.0
    tableHeaderClippingView.layer.masksToBounds = true
    tableHeaderClippingView.layer.shadowOffset = CGSize(width: 0, height: 10)
  }
}

extension RecipeDetailViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let ingredients = ingredients else { return 0 }
    return ingredients.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: CardCell.reuseIdentifier, for: indexPath) as? CardCell else { return UITableViewCell() }
    if let ingredient = ingredients?[indexPath.row] {
      cell.configure(withIngredient: ingredient)
    }
    return cell
  }
}

extension RecipeDetailViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 75
  }
}
