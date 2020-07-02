//
//  AddNewOrderViewController.swift
//  OrderCoffeeLabMVVM
//
//  Created by Han Luong on 1/14/20.
//  Copyright © 2020 Han Luong. All rights reserved.
//

import UIKit

protocol AddNewOrderDelegate {
    func addNewOrderViewControllerDidClose(controller: UIViewController)
    func addNewOrderViewControllerDidSave(order: Order, controller: UIViewController)
}

class AddNewOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Variables
    private var vm = AddCoffeeOrderViewModel()
    private var coffeeSizeSegmentedControl: UISegmentedControl!
    var delegate: AddNewOrderDelegate?

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    private func setupViews() {
        self.view.bindToKeyboard()
        self.coffeeSizeSegmentedControl = UISegmentedControl(items: self.vm.sizes)
        self.coffeeSizeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.coffeeSizeSegmentedControl)
        
        self.coffeeSizeSegmentedControl.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 30).isActive = true
        self.coffeeSizeSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }

    // MARK: - Implementing table view
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeTypeTableViewCell", for: indexPath)
        cell.textLabel?.text = self.vm.types[indexPath.row]
        return cell
    }
    
    @IBAction func closeButtonWasPressed(_ sender: Any) {
        if let delegate = self.delegate {
            delegate.addNewOrderViewControllerDidClose(controller: self)
        }
    }
    
    @IBAction func saveButtonWasPressed(_ sender: Any) {
        let name = self.nameTextField.text
        let email = self.emailTextField.text
        let selectedSize = self.coffeeSizeSegmentedControl.titleForSegment(at: self.coffeeSizeSegmentedControl.selectedSegmentIndex)
        guard let indexPath = self.tableView.indexPathForSelectedRow else { fatalError() }
        self.vm.name = name
        self.vm.email = email
        self.vm.selectedSize = selectedSize
        self.vm.selectedType = self.vm.types[indexPath.row]
        
        Webservice().load(resource: Order.create(vm: self.vm)) { (result) in
            switch result {
            case .success(let order):
                if let order = order, let delegate = self.delegate {
                    delegate.addNewOrderViewControllerDidSave(order: order, controller: self)
                }
            case .failure(let error):
                debugPrint(error as Any)
            }
        }
    }
    
}
