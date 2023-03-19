//
//  CreateItemViewController.swift
//  ToDoey
//
//  Created by Nuradinov Adil on 15/03/23.
//

import UIKit

final class CreateItemViewController: UIViewController {

    private lazy var contentView = UIView()
    private lazy var nameView = UIView()
    private lazy var selectedPriority: Int = 1
    private var selectedSection: ToDoeySection?
    private var isCreating: Bool = true
    private var isBeingUpdatedItme: ToDoeyItem?
    
    private lazy var nameTextField: ViewTextField = {
       let viewTextField = ViewTextField()
        viewTextField.textField.placeholder = "Name"
        return viewTextField
    }()
    
    private lazy var descTextField: ViewTextField = {
       let viewTextField = ViewTextField()
        viewTextField.textField.placeholder = "Description"
        return viewTextField
    }()
    
    private lazy var submitButton: UIButton = {
       let button = UIButton()
        button.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.layer.cornerRadius = 13
        button.backgroundColor = .systemBlue
        return button
    }()
    
    private lazy var priorityPickerView: UIPickerView = {
       let pickerView = UIPickerView()
        return pickerView
    }()
    
    private lazy var selectedImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var selectImageButton: UIButton = {
       let button = UIButton()
        button.setTitle("Select Image", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.layer.cornerRadius = 10
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(selectImageButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupViews()
        setupConstraints()
        configureNavBar()
        priorityPickerView.dataSource = self
        priorityPickerView.delegate = self
    }
    
    func configure(section: ToDoeySection, item: ToDoeyItem? = nil) {
        selectedSection = section
        if let item {
            DispatchQueue.main.async {
                self.nameTextField.textField.text = item.name
                self.descTextField.textField.text = item.desc
                self.priorityPickerView.selectRow(Int(item.priority - 1), inComponent: 1, animated: true)
            }
            
        }
    }
}

private extension CreateItemViewController {
    func configureNavBar() {
        navigationItem.title = "Create Item"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .label
    }
    
    @objc func submitButtonPressed() {
        let selectedImage = selectedImageView.image?.pngData()
        if let name = nameTextField.textField.text, name != "", let desc = descTextField.textField.text, desc != "", let selectedSection {
            ItemManager.shared.createItem(for: selectedSection, with: name, desc: desc, priority: Int16(selectedPriority), image: selectedImage)
            navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Nil data found", message: "Please fill all the gaps", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Return", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
    @objc func selectImageButtonPressed() {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = self
        controller.allowsEditing = true
        present(controller, animated: true)
    }
}

extension CreateItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            selectedImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CreateItemViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        Priority.allCases.count
    }
}

extension CreateItemViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(Priority.allCases[row].rawValue)"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPriority = Priority.allCases[row].rawValue
    }
}

private extension CreateItemViewController {
    func setupViews() {
        view.addSubview(contentView)
        contentView.addSubview(nameTextField)
        contentView.addSubview(submitButton)
        contentView.addSubview(descTextField)
        contentView.addSubview(priorityPickerView)
        contentView.addSubview(selectedImageView)
        contentView.addSubview(selectImageButton)
    }
    
    func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(7)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        descTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.22)
        }
        priorityPickerView.snp.makeConstraints { make in
            make.top.equalTo(descTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.12)
        }
        selectedImageView.snp.makeConstraints { make in
            make.top.equalTo(priorityPickerView.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.45)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        selectImageButton.snp.makeConstraints { make in
            make.leading.equalTo(selectedImageView.snp.trailing).offset(5)
            make.trailing.equalToSuperview()
            make.bottom.equalTo(selectedImageView.snp.bottom)
            make.height.equalToSuperview().multipliedBy(0.06)
        }
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(selectedImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        }
    }
}

final class ViewTextField: UIView {
    var textField: UITextField = {
        let textField = UITextField()
         textField.font = UIFont.systemFont(ofSize: 25)
         textField.textColor = .label
         textField.placeholder = "Description"
         return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(7)
        }
        
        layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        layer.cornerRadius = 13
        layer.borderWidth = 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
