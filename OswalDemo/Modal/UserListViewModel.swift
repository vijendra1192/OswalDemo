//
//  UserListViewModel.swift
//  OswalDemo
//
//  Created by Vijendra Yadav on 09/07/21.
//

import Foundation

enum TableType {
    case TableData
    case SwipeFunction
}


// @VIJENDRA Observer for data binding
class Observable<T> {
    var value: T? {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T?) {
        self.value = value
    }

    private var listener: ((T?) -> Void)?

    func bind(_ listener: @escaping (T?) -> Void) {
        listener(value)
        self.listener = listener
    }

    func bindTest(_ listener: @escaping (T?) -> Void) {
        listener(value)
        self.listener = listener
    }
}
// End

protocol ViewControllerDelegate: AnyObject {
    func showTableViewData()
    func swipeDeleteActionPressed(at index: Int16)
}

extension ViewControllerDelegate {
    func showTableViewData() {}
    func swipeDeleteActionPressed(at index: Int16) {}
}

// ViewModels
class UserListViewModel {
    var usersList: Observable<[UserTableCellViewModel]> = Observable([]) // @VIJENDRA Only for data bindings
    
    var users: [UserTableCellViewModel]
    weak var delegate: ViewControllerDelegate?
    private lazy var storage = PersistentStorage.shared
    
    init(delegate: ViewControllerDelegate?, users: [UserTableCellViewModel] = []) {
        self.delegate = delegate
        self.users = users
    }
    
    func employeeListApiCall() {
        let employees = fetchEmployee()
        
        // Checking if employee count is zero then call api otherwise fetch data from locally
        if employees.count <= 0 {
            self.employeeListApiCallWithResponse { results in
                // This function will save as local database
                self.saveAndShowData(model: results)
            }
        } else {
            self.users = employees.compactMap({
                UserTableCellViewModel(name: $0.name ?? "", id: $0.id )
            })
            
            self.usersList.value = employees.compactMap({
                UserTableCellViewModel(name: $0.name ?? "", id: $0.id )
            })
            delegate?.showTableViewData()
        }
    }
    
    func employeeListApiCallWithResponse(result: @escaping (([UserProtocol]) -> Void) ) {
        guard let url = URL(string: AppConstant.USERS_LISTS_API) else {
            // Handle case if url is not proper
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return  }
            
            do {
                let userModel = try JSONDecoder().decode([User].self, from: data)
                
                // @VIJENDRA For binding
//                usersList = userModel.compactMap({UserTableCellViewModel(name: $0.name, id: $0.id)})
                result(userModel)
            } catch {
                print("error in handling json-->> \(error.localizedDescription)")
                // Handle if response is invalid
            }
        }
        task.resume()
    }
    
    private func saveAndShowData(model: [UserProtocol]) {
        _ = saveData(model: model)
        delegate?.showTableViewData()
    }
    
    func saveData(model: [UserProtocol]) -> [UserTableCellViewModel] {
        if model.count <= 0 {
            PersistentStorage.shared.deleteRecordBasesOnEntity(entityName: AppConstant.ENTITY_NAME)
            return []
        }
        
        model.forEach({[unowned self] user in
            let emp = Employee(context: self.storage.context)
            emp.name = user.name
            emp.id = user.id
            self.storage.saveContext()
        })
        self.users = model.compactMap({
            UserTableCellViewModel(name: $0.name, id: $0.id )
        })
        
        
        self.usersList.value = model.compactMap({
            UserTableCellViewModel(name: $0.name, id: $0.id )
        })
        
        return users
    }
    
    func fetchEmployee() -> [Employee] {
        do {
            let context = PersistentStorage.shared.context
            guard let result = try context.fetch(Employee.fetchRequest()) as? [Employee] else {
                return []
            }
            return result
            
        } catch {
            print("error on fetching employee-->> \(error.localizedDescription)")
        }
        return []
    }
    
    func deleteEmployee(at rowIndex: Int16) {
        guard let index = users.firstIndex(where: {$0.id == rowIndex}) else { return }
        users.remove(at: index)
        _ = saveData(model: users)
        delegate?.swipeDeleteActionPressed(at: Int16(index))
    }
    
    func updateTableData() {
//        self.usersList.value?.append(contentsOf: usersList.value!)
    }
}

