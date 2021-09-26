//
//  UserViewModel.swift
//  Zoho
//
//  Created by Jai on 25/09/21.
//

import Foundation
import CoreData

enum UserRefresh {
    case success
    case failure(String)
}

// MARK: - Protocol

protocol UsersLocalStorage: AnyObject {
    func saveUsers(userList: [UserDetailsModal])
}

protocol UsersViewModelData: UsersLocalStorage {
    var pageCount: Int { get set }
    var userList: [UserDetailsModal]? { get set }
    var serachUserList: [UserDetailsModal]? { get set }
    var isLoadingList: Bool { get set }
    var isListSearch: Bool { get set }
    var refreshData: ((_ state: UserRefresh) -> Void)! { get set }

    func getUserDataByIndex(index: Int) -> UserDetailsModal?
    func getUserList()
    func getUserListCount() -> Int
    func searchByName(searchText: String)
    func viewUserDetails(index: Int) -> UserDetailsModal?
}

class UsersViewModel: UsersViewModelData {
  
    // MARK: - Declaration
    
    var isListSearch: Bool
    var isLoadingList: Bool
    var refreshData: ((UserRefresh) -> Void)!

    var serachUserList: [UserDetailsModal]?
    var userList: [UserDetailsModal]?
    var pageCount: Int
    let dataSource: UserDataSourceType

    // MARK: - Init

    init(dataSource: UserDataSourceType) {
        self.dataSource = dataSource
        pageCount = 1
        isLoadingList = false
        isListSearch = false
        serachUserList = []
        userList = []
    }

    private func getEachUserData(_ data: ResultData) -> UserDetailsModal{
        return (UserDetailsModal.init(name: "\(data.name?.first ?? "") \(data.name?.last ?? "")", latitude: (data.location?.coordinates?.latitude ?? "0.0"), longitude: (data.location?.coordinates?.longitude ?? "0.0"), email: data.email ?? "", phone: data.phone ?? "", picture: data.picture?.thumbnail ?? "", age: "\(data.dob?.age ?? 0)", heroID: "", gender: data.gender?.rawValue ?? ""))
    }
    
    func getUserList() {
        
        if ConstantManager.appConstant.internetStatus {
            getUserListFromServer()
        } else {
            self.isLoadingList = false
            getUserListFromDataBase()
        }
    }
    
    // MARK: - Fetch Data
    
    private func getUserListFromServer() {
        let fetchURL = URL.init(string: "\(APIList.BASE_URL)?page=\(pageCount)&results=25")!
        dataSource.fetchUsers(url: fetchURL, httpMethod: .get) { response in
            switch response {
                case .success(let result):
                        result.results?.forEach({ data in
                            self.userList?.append(self.getEachUserData(data))
                        })
                    
                    if let hasUserList = self.userList {
                        if self.pageCount == 1 {
                            let queue = DispatchQueue(label: "save.data", attributes: .concurrent)
                            queue.sync(flags: .barrier) {
                                self.saveUsers(userList: hasUserList)
                            }
                        }
                    }
                
                    self.pageCount = ((result.info?.page ?? 0) + 1)
                    self.isLoadingList = false
                    self.refreshData(.success)
                break
                case .failure(let error):
                    self.refreshData(.failure(error.localizedDescription))
                break
            }
            
        }
    }

    // MARK: - Methods

    func getUserListCount() -> Int {
        return isListSearch ? (serachUserList?.count ?? 0) : (userList?.count ?? 0)
    }

    func getUserDataByIndex(index: Int) -> UserDetailsModal? {
        return isListSearch ? (serachUserList?[index]) : (userList?[index])
    }
    
    // MARK: - Search 
    
    func searchByName(searchText: String)
    {
        if !searchText.isEmpty
        {
                if (userList?.count ?? 0) > 0
                {
                    if let list = userList
                    {
                        isListSearch = true
                        self.serachUserList = list.filter { object in
                            return object.name.lowercased().contains(searchText.lowercased())
                        }
                        
                        self.refreshData(.success)
                    }
                    else
                    {
                        resetSearch()
                    }
                }
                else
                {
                    resetSearch()
                }
            }
            else
            {
                resetSearch()
            }
    }
    
    func resetSearch() {
        isListSearch = false
        self.refreshData(.success)
    }
    
    func viewUserDetails(index: Int) -> UserDetailsModal? {
        var data = getUserDataByIndex(index: index)
        data?.heroID = "\(index)"
        return data
    }

    // MARK: - Core Data
    
    private func getUserListFromDataBase() {
        
        let managedContext = DatabaseController.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")

        do
        {
            let result = try managedContext.fetch(fetchRequest)
            
            print("Array  count = ",result.count)
            for data in result as! [NSManagedObject]
            {
                self.userList!.append(UserDetailsModal.init(name: data.value(forKey: "name") as! String , latitude: data.value(forKey: "latitude") as! String, longitude: data.value(forKey: "longitude") as! String, email: data.value(forKey: "email") as! String, phone: data.value(forKey: "phone") as! String, picture: data.value(forKey: "imageURL") as! String, age: data.value(forKey: "age") as! String, heroID: "", gender: data.value(forKey: "gender") as! String))
            }
            
            self.refreshData(.success)
        }
        catch
        {
            print("Failed")
        }
    }
    
    func saveUsers(userList: [UserDetailsModal]) {
        
        for (index, item) in userList.enumerated() {
            
            let managedContext = DatabaseController.persistentContainer.viewContext
            managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
            let userTable = NSManagedObject(entity: userEntity, insertInto: managedContext)
            
            userTable.setValue(index, forKeyPath: "uid")
            userTable.setValue("\(item.age)", forKeyPath: "age")
            userTable.setValue((item.email), forKey: "email")
            userTable.setValue(item.gender, forKey: "gender")
            userTable.setValue((item.picture), forKey: "imageURL")
            userTable.setValue((item.latitude), forKey: "latitude")
            userTable.setValue((item.longitude), forKey: "longitude")
            userTable.setValue((item.name), forKey: "name")
            userTable.setValue((item.phone), forKey: "phone")
            
            do
            {
                try managedContext.save()
            }
            catch let error as NSError
            {
                print("Could not save. \(error), \(error.userInfo)")
                break
            }
        }
        
    }
    
    
}
