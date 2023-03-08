//
//  ItemsViewController.swift
//  ToDoey
//
//  Created by Nuradinov Adil on 04/03/23.
//

import UIKit

final class SectionViewController: UIViewController {

    private var sections = [ToDoeySection]()
    
    private lazy var sectionTableView : UITableView = {
       let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(DataTableViewCell.self, forCellReuseIdentifier: DataTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        
        SectionManager.shared.delegate = self
        SectionManager.shared.fetchSections()
        
        view.backgroundColor = .systemCyan
        sectionTableView.dataSource = self
        sectionTableView.delegate = self
        setupViews()
        setupConstraints()
    }
}

private extension SectionViewController {
    func configureNavBar() {
        navigationItem.title = "Todoey"
        navigationController?.navigationBar.prefersLargeTitles = true
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationController?.navigationBar.tintColor = .label
        navigationItem.rightBarButtonItem = add
    }
    
    @objc func addButtonPressed() {
        let alert = UIAlertController(title: "New Section", message: "Create new section", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty
            else { return }
            SectionManager.shared.createSections(with: text)
        }))
        present(alert, animated: true)
    }
    
}

extension SectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DataTableViewCell.identifier, for: indexPath) as! DataTableViewCell
        cell.configure(with: sections[indexPath.row].name!)
        cell.selectionStyle = .none
        return cell
    }
}

extension SectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height * 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ItemViewController(section: sections[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [UIContextualAction(style: .destructive, title: "Delete", handler: { _, _, _ in
            SectionManager.shared.deleteSection(section: self.sections[indexPath.row])
        }), UIContextualAction(style: .normal, title: "Edit", handler: { _, _, _ in
            let alert = UIAlertController(title: "Update Section", message: "Update your section", preferredStyle: .alert)
            alert.addTextField()
            alert.textFields?.first?.text = self.sections[indexPath.row].name
            alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { _ in
                guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty
                else { return }
                SectionManager.shared.updateSection(section: self.sections[indexPath.row], newName: text)
            }))
            self.present(alert, animated: true)        })])
    }
}

extension SectionViewController: SectionManagerDelegate {
    func didUpdateSections(with models: [ToDoeySection]) {
        self.sections = models
        DispatchQueue.main.async {
            self.sectionTableView.reloadData()
        }
    }
}

private extension SectionViewController {
    func setupViews() {
        view.addSubview(sectionTableView)
    }
    func setupConstraints() {
        sectionTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
