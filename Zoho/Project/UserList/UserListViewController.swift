//
//  UserListViewController.swift
//  Zoho
//
//  Created by Jai on 25/09/21.
//

import UIKit
import Hero

class UserListViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var serachTxt: UITextField!
    @IBOutlet weak var userListTableView: UITableView!
    var cellHeights = [IndexPath: CGFloat]()

    private var viewModel: UsersViewModelData!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.font = UIFont.appGiloryBoldFontWith(size: 20)
        serachTxt.font = UIFont.appGiloryMediumFontWith(size: 16)
        viewModel = UsersViewModel(dataSource: UserDataSource())
        titleLbl.text = ZohoStrings.UserProfile.title
        viewBind()
        setTableViewData()
        serachTxt.addTarget(self, action: #selector(UserListViewController.textFieldDidChange(_:)), for: .editingChanged)
        hero.isEnabled = true
    }
    
    // MARK: - Binding

    private func viewBind() {
        
        viewModel.refreshData = {
                [unowned self] result in
                switch result {
                case .success:
                    self.userListTableView.reloadData()
                    self.userListTableView.tableFooterView = nil
                break;
                case .failure(let error):
                    self.userListTableView.tableFooterView = nil
                    self.showAlertError(messageStr: error)
                break;
            }
        }
    }
    
    // MARK: - Methods
    
    private func setTableViewData()
    {
        userListTableView?.register(UserListTableViewCell.nib, forCellReuseIdentifier: UserListTableViewCell.identifier)
        userListTableView.separatorStyle = .none
        userListTableView.dataSource = self
        userListTableView.delegate = self
        userListTableView.showsHorizontalScrollIndicator = false
        userListTableView.showsVerticalScrollIndicator = false
        userListTableView.contentInset = UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 0)
        userListTableView.keyboardDismissMode = .onDrag
    }
    
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        self.viewModel.searchByName(searchText: textField.text!)
    }

}

// MARK: - TableView DataSource & Delegate

extension UserListViewController : UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.viewModel.getUserListCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserListTableViewCell.identifier, for: indexPath) as! UserListTableViewCell
        cell.bindData(modal: self.viewModel.getUserDataByIndex(index: indexPath.row)!)
        cell.profileImageView.hero.id = "\(indexPath.row)"
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let vc = UserDetailsViewController.instantiate(fromAppStoryboard: .Main)
        vc.dataSource = self.viewModel.viewUserDetails(index: indexPath.row)
        self.navigationController?.hero.isEnabled = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if ConstantManager.appConstant.internetStatus {
            if !viewModel.isListSearch {
                if (scrollView.contentOffset.y + 1) >= (scrollView.contentSize.height - scrollView.frame.size.height)
                {
                    if !viewModel.isLoadingList
                    {
                        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
                        spinner.frame = CGRect(x: 0.0, y: 0.0, width: userListTableView.bounds.width, height: 70)
                        spinner.startAnimating()
                        userListTableView.tableFooterView = spinner
                        
                        viewModel.isLoadingList = true
                        self.viewModel.getUserList()
                        
                        }
                    }
                }
        } else {
            if viewModel.getUserListCount() == 0 {
                self.viewModel.getUserList()
            }
        }
    }
}
