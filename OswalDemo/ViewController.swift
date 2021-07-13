//
//  ViewController.swift
//  OswalDemo
//
//  Created by Vijendra Yadav on 09/07/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tvLists: UITableView!
    
//    lazy var viewModel: ListViewModel = ListViewModel()
    lazy var userListViewModel: UserListViewModel = UserListViewModel(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setUpViewModel()
    }
    
    @IBAction func updateTablePressed(_ sender: Any) {
        userListViewModel.updateTableData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.userListViewModel.employeeListApiCall()
    }
    
    private func setUpViewModel() {
        
        // @VIJENDRA This is only for binding
        userListViewModel.usersList.bind { _ in
            DispatchQueue.main.async {[weak self] in
                self?.tvLists.reloadData()
            }
        }
    }
 
    private func setupTableView() {
        tvLists.register(UINib(nibName: "ListTVCell", bundle: nil), forCellReuseIdentifier: "ListTVCell")
        tvLists.delegate = self
        tvLists.dataSource = self
    }
    
    private func setUpBindings() {
        
    }
    
    @IBAction func buttonPressed(_ sender: Any) {}
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return userListViewModel.users.count
        
        return userListViewModel.usersList.value?.count ?? 0 // @VIJENDRA for binding
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstant.USERS_LIST_CELL) as? ListTVCell
        cell?.selectionStyle = .none
        cell?.nameLbl.text = userListViewModel.users[indexPath.row].name
        
        // @VIJENDRA for binding
        cell?.nameLbl.text = userListViewModel.usersList.value?[indexPath.row].name
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { action, index,status  in
            self.deletePressed(at: self.userListViewModel.users[indexPath.row].id)
        }
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func deletePressed(at index: Int16) {
        userListViewModel.deleteEmployee(at: index)
    }
}


extension ViewController: ViewControllerDelegate {
    func swipeDeleteActionPressed(at index: Int16) {
        DispatchQueue.main.async {[unowned self] in
            self.tvLists.beginUpdates()
            self.tvLists.deleteRows(at: [IndexPath(row: Int(index), section: 0)], with: .bottom)
            self.tvLists.endUpdates()
        }
    }
    
    func showTableViewData() {
        DispatchQueue.main.async {[unowned self] in
            self.tvLists.reloadData()
        }
    }
}
