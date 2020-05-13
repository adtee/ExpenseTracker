//
//  AddExpenseViewController.swift
//  ExpenseTracker
//
//  Created by Aditi Pancholi on 12/05/20.
//  Copyright © 2020 Aditi Mehta. All rights reserved.
//

import UIKit

class AddExpenseViewController: UIViewController {
    
    //MARK: Outlates
    
    @IBOutlet weak var textFieldExpenseTitle: UITextField!
    @IBOutlet weak var textFieldExpenseAmount: UITextField!
    @IBOutlet weak var textFieldExpenseDate: UITextField!
    @IBOutlet weak var textViewExpenseNote: UITextView!
    @IBOutlet weak var collectionViewExpenseCategory: UICollectionView!
    
    let datePicker = UIDatePicker()
    
    //MARK: ViewController Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        /// ask for password  if user has setup before - dont allow to use app untill adds password
        if UserDefaults.standard.string(forKey: "password") != nil{
            askForPassword()
        }
    }
    
    //MARK: Outlate Actions
    
    @IBAction func buttonAddPasswordAction(_ sender: Any) {
        self.showInputDialog(title: "Expense Tracker", subtitle: "Add Password to protect your data.", actionTitle: "Save", cancelTitle: "Cancel", inputPlaceholder: "Enter Password",inputTypeSecure: true, inputKeyboardType: .default, cancelHandler: { (action) in
            //do nothing
        }) { (passwordString) in
            UserDefaults.standard.set(passwordString, forKey: "password")
            self.showAlertDialog(title: nil, Message: "Password saved.", actiontitle: "okay")
        }
    }
    
    @IBAction func buttonAddExpenseAction(_ sender: Any) {
        saveDataToDatabase()
    }
    
    @IBAction func buttonExpenseReportAction(_ sender: Any) {
        let vc : ExpenseReportViewController = ExpenseReportViewController.instantiate(appStoryboard: .report)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: UI setup
    func setupUI(){
        textViewExpenseNote.layer.borderColor = UIColor.gray.withAlphaComponent(0.6).cgColor
        textViewExpenseNote.layer.borderWidth = 1
        textViewExpenseNote.layer.cornerRadius = 5
        collectionViewExpenseCategory.allowsMultipleSelection = true
        linkDatePicker()
    }
    
    
    //MARK: database interaction
    func saveDataToDatabase(){
        let categoryString : [String] = collectionViewExpenseCategory.indexPathsForSelectedItems?.compactMap({ (indexpath) -> String in
            return "\(DatabaseManager.shared.categories[indexpath.row].categoryId)"
        }) ?? []
        
        //validate text inputs
        if textFieldExpenseTitle.text?.isOnlyWhiteSpaces() ?? false{
            self.showAlertDialog(title: nil, Message: "Please enter title", actiontitle: "Okay") { (action) in
                self.textFieldExpenseTitle.becomeFirstResponder()
            }
        }else if textFieldExpenseAmount.text?.isOnlyWhiteSpaces() ?? false{
            self.showAlertDialog(title: nil, Message: "Please enter Amount", actiontitle: "Okay"){ (action) in
                 self.textFieldExpenseAmount.becomeFirstResponder()
            }
        }else if categoryString.count == 0{
            self.showAlertDialog(title: nil, Message: "Please select category", actiontitle: "Okay")
        }else if textFieldExpenseDate.text?.isOnlyWhiteSpaces() ?? false{
            self.showAlertDialog(title: nil, Message: "Please select expense date", actiontitle: "Okay")
        }else{
            
            let success = DatabaseManager.shared.insertExpense(timestamp: "\(Date.currentTimeStamp)", title: textFieldExpenseTitle.text ?? "", amount: Double(textFieldExpenseAmount.text ?? "0") ?? 0.0, date: textFieldExpenseDate.text?.getTimeStempFromString() ?? 0.0, notes: textViewExpenseNote.text ?? "", category: categoryString.joined(separator: ","))
            
            self.showAlertDialog(title: nil , Message: "\(success ? "Entery added Successfully"  : "Failed to save Expenses")", actiontitle: "okay") { (action) in
                DispatchQueue.main.async {
                    self.deselectAllItems(animated: true)
                    self.textViewExpenseNote.text = ""
                    self.textFieldExpenseDate.text = ""
                    self.textFieldExpenseTitle.text = ""
                    self.textFieldExpenseAmount.text = ""
                }
            }
        }
    }
    
    //MARK: Password
    func askForPassword(){
        self.showInputDialog(title: "Expense Tracker", subtitle: "Add Password to unlock your data.", actionTitle: "Submit", cancelTitle: "Cancel", inputPlaceholder: "Enter Password",inputTypeSecure: true, inputKeyboardType: .default, cancelHandler: { (action) in
            //Ask for password again
            self.askForPassword()
        }) { (passwordString) in
            if passwordString == UserDefaults.standard.string(forKey: "password"){
                self.showAlertDialog(title: nil, Message: "Welcome back to Expense Tracker", actiontitle: "okay")
            }else{
                self.showAlertDialog(title: nil, Message: "Incorect password", actiontitle: "Try again") { (action) in
                    self.askForPassword()
                }
            }
        }
    }
}

//MARK: Date picker for Expense date
extension AddExpenseViewController{
    func linkDatePicker(){
        
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: view.frame.size.width, height: CGFloat(44))))
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolbar.sizeToFit()
        textFieldExpenseDate.inputAccessoryView = toolbar
        textFieldExpenseDate.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        textFieldExpenseDate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
}

//MARK: Collectionview delegate and datasource for Category
extension AddExpenseViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DatabaseManager.shared.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell : CategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        cell.categoryInfo = DatabaseManager.shared.categories[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell : CategoryCell = collectionView.cellForItem(at: indexPath) as? CategoryCell else{
            return
        }
        cell.viewWrapper.backgroundColor =  UIColor.yellow.withAlphaComponent(0.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell : CategoryCell = collectionView.cellForItem(at: indexPath) as? CategoryCell else{
            return
        }
        cell.viewWrapper.backgroundColor =  UIColor.white
    }
    
    func deselectAllItems(animated: Bool) {
        guard let selectedItems = collectionViewExpenseCategory.indexPathsForSelectedItems else { return }
        for indexPath in selectedItems { collectionViewExpenseCategory.deselectItem(at: indexPath, animated: animated) }
        collectionViewExpenseCategory.reloadData()
    }
    
}
