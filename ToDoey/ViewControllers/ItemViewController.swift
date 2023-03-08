//
//  ViewController.swift
//  ToDoey
//
//  Created by Nuradinov Adil on 04/03/23.
//

import UIKit
import SnapKit

final class ItemViewController: UIViewController {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var models = [ToDoeyItem]()
    private var section: ToDoeySection

    private lazy var itemTableView : UITableView = {
       let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(DataTableViewCell.self, forCellReuseIdentifier: DataTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var sectionSearchBar: UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    init(section: ToDoeySection) {
            self.section = section
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        ItemManager.shared.delegate = self
        ItemManager.shared.fetchItems(for: section)
        
        itemTableView.dataSource = self
        itemTableView.delegate = self
        
        sectionSearchBar.delegate = self
        
        configureNavBar()
        setupViews()
        setupConstraints()
    }
}

extension ItemViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DataTableViewCell.identifier, for: indexPath) as! DataTableViewCell
        cell.selectionStyle = .none
        cell.configure(with: models[indexPath.row].name!)
        return cell
    }
}

extension ItemViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height * 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let controller = ItemsViewController()
//        navigationController?.pushViewController(controller, animated: true)
        let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Update", style: .default, handler: { _ in
            let alert = UIAlertController(title: "Edit Item", message: "Update your item", preferredStyle: .alert)
            alert.addTextField()
            alert.textFields?.first?.text = self.models[indexPath.row].name
            alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { _ in
                guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty
                else { return }
                ItemManager.shared.updateItem(item: self.models[indexPath.row], newName: text)
            }))
            self.present(alert, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            ItemManager.shared.deleteItem(item: self.models[indexPath.row])
        }))
        present(sheet, animated: true)
    }
}

private extension ItemViewController {
    func configureNavBar() {
        navigationItem.title = "Todoey"
        navigationController?.navigationBar.prefersLargeTitles = true
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationController?.navigationBar.tintColor = .label
        navigationItem.rightBarButtonItem = add
    }
    
    @objc func addButtonPressed() {
        let alert = UIAlertController(title: "New Item", message: "Create new item", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty
            else { return }
            ItemManager.shared.createItem(for: self.section, with: text)
        }))
        present(alert, animated: true)
    }
}

extension ItemViewController: ItemManagerDelegate {
    func didUpdateItems(with models: [ToDoeyItem]) {
        self.models = models
        DispatchQueue.main.async {
            self.itemTableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print("Following error appeared: ", error)
    }
}

extension ItemViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        ItemManager.shared.fetchItems(for: section, with: searchText)
    }
}

private extension ItemViewController {
    func setupViews() {
        view.addSubview(sectionSearchBar)
        view.addSubview(itemTableView)
    }
    
    func setupConstraints(){
        sectionSearchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        sectionSearchBar.searchTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(7)
        }
        itemTableView.snp.makeConstraints { make in
            make.top.equalTo(sectionSearchBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

