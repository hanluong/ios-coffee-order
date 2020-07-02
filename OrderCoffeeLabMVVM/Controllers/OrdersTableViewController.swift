//
//  OrdersTableViewController.swift
//  OrderCoffeeLabMVVM
//
//  Created by Han Luong on 1/14/20.
//  Copyright © 2020 Han Luong. All rights reserved.
//

import UIKit

class OrdersTableViewController: UITableViewController, AddNewOrderDelegate {
    
    // Variable
    var orderListViewModel = OrderListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateOrders()
    }
    
    private func populateOrders() {
        Webservice().load(resource: Order.all) { [weak self] (result) in
            switch result {
            case.success(let orders):
                self?.orderListViewModel.orderListViewModel = orders.map(OrderViewModel.init)
                self?.tableView.reloadData()
            case.failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Conform AddNewOrderDelegate
    func addNewOrderViewControllerDidClose(controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addNewOrderViewControllerDidSave(order: Order, controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
        let orderVM = OrderViewModel(order: order)
        self.orderListViewModel.orderListViewModel.append(orderVM)
        self.tableView.insertRows(at: [IndexPath.init(row: self.orderListViewModel.orderListViewModel.count - 1, section: 0)], with: .automatic)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.orderListViewModel.orderListViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = self.orderListViewModel.orderListViewModel[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderTableViewCell", for: indexPath)
        cell.textLabel?.text = vm.type
        cell.detailTextLabel?.text = vm.size
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController, let addNewOrderVC = navC.viewControllers.first as? AddNewOrderViewController else {
            fatalError("ERROR performing segue")
        }
        addNewOrderVC.delegate = self
    }
}
