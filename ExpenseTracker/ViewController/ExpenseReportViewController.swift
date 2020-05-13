//
//  ExpenseReportViewController.swift
//  ExpenseTracker
//
//  Created by Aditi Pancholi on 12/05/20.
//  Copyright © 2020 Aditi Mehta. All rights reserved.
//

import UIKit

class ExpenseReportViewController: UIViewController {
    
    //MARK: Outlates
    
    @IBOutlet weak var tableViewExpenseReport: UITableView!
    @IBOutlet weak var labelNoDataFoundAlert: UILabel!
    @IBOutlet weak var textFieldStartDate: UITextField!
    @IBOutlet weak var textFieldEndDate: UITextField!
    @IBOutlet weak var textFieldCategory: UITextField!
    @IBOutlet weak var segmentControlTimelines: UISegmentedControl!
    
    var datePicker = UIDatePicker()
    var categoryPicker = UIPickerView()
    
    //MARK: Variables
    var arrExpenseRecords : [ExpenseModel] = []{
        didSet{
            labelNoDataFoundAlert.isHidden = !(arrExpenseRecords.count == 0)
            tableViewExpenseReport.reloadData()
            self.view.endEditing(true)
        }
    }
    
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewExpenseReport.tableFooterView = UIView()
        linkDatePicker()
        fetchRecordsFRomDatabase()
        linkCategoryPicker()
        // Do any additional setup after loading the view.
    }
    
    //MARK: Outlate actions
    
    @IBAction func buttonFilterByDatesAction(_ sender: Any) {
        ///validate if fields are not blank
        guard textFieldStartDate.text != "" || textFieldEndDate.text != "" else{
            self.showAlertDialog(title: nil, Message: "Please select Start and end date", actiontitle: "Okay")
            return
        }
        filterExpenses(fromStartDate: textFieldStartDate.text!.getTimeStempFromString(), toEndDate: textFieldEndDate.text!.getTimeStempFromString())
    }
    
    @IBAction func buttonFilterByTimeLineAction(_ sender: Any) {
        var fromDate = Date()
        switch segmentControlTimelines.selectedSegmentIndex {
        case 0:
            fromDate = Date().getNewDateAfterAdding(daysToAdd: -2, monthsToadd: 0, yearsToAdd: 0)
        case 1:
            fromDate = Date().getNewDateAfterAdding(daysToAdd: -7, monthsToadd: 0, yearsToAdd: 0)
        case 2:
            fromDate = Date().getNewDateAfterAdding(daysToAdd: 0, monthsToadd: -1, yearsToAdd: 0)
        default:
            break
        }
        filterExpenses(fromStartDate: fromDate.timeIntervalSince1970 , toEndDate:  Date().timeIntervalSince1970)
    }
    
    
    @IBAction func buttonFiltorByCategoryAction(_ sender: Any) {
        guard textFieldCategory.text != "" else{
            self.showAlertDialog(title: nil, Message: "Please select category", actiontitle: "Okay")
            return
        }
        filterByCategory()
    }
    
}


//MARK: Date picker for Filter dates
extension ExpenseReportViewController{
    
    func linkDatePicker(){
        
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        let toolbar = UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: view.frame.size.width, height: CGFloat(44))))
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolbar.sizeToFit()
        
        textFieldStartDate.inputAccessoryView = toolbar
        textFieldStartDate.inputView = datePicker
        textFieldEndDate.inputAccessoryView = toolbar
        textFieldEndDate.inputView = datePicker
        
    }
    
    func linkCategoryPicker(){
        categoryPicker.translatesAutoresizingMaskIntoConstraints = false
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        let toolbar = UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: view.frame.size.width, height: CGFloat(44))))
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolbar.sizeToFit()
        textFieldCategory.inputView = categoryPicker
        textFieldCategory.inputAccessoryView = toolbar
    }
    
    @objc func donedatePicker(){
        if textFieldStartDate.isFirstResponder || textFieldEndDate.isFirstResponder{
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            if self.datePicker.tag == textFieldStartDate.tag {
                textFieldStartDate.text = formatter.string(from: datePicker.date)
            }else{
                textFieldEndDate.text = formatter.string(from: datePicker.date)
            }
        }
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
}

//MARK: TextFiled Delegates for datePicker
extension ExpenseReportViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case textFieldEndDate,textFieldStartDate:
            datePicker.tag = textField.tag
        case textFieldCategory:
            textFieldCategory.text = textFieldCategory.text == "" ? DatabaseManager.shared.categories.first?.categoryName ?? "" : textFieldCategory.text
        default:
            return
        }
    }
}


//MARK: Tableview datasource and delegate for report fields
extension ExpenseReportViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrExpenseRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell : ExpenseReportDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ExpenseReportDetailTableViewCell", for: indexPath) as? ExpenseReportDetailTableViewCell else{
            return UITableViewCell()
        }
        cell.expenseObject = arrExpenseRecords[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


//MARK: PickerView delegate for category picker
extension ExpenseReportViewController : UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DatabaseManager.shared.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return DatabaseManager.shared.categories[row].categoryName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFieldCategory.text = DatabaseManager.shared.categories[row].categoryName
        textFieldCategory.tag = DatabaseManager.shared.categories[row].categoryId
    }
    
}


//MARK: Database interaction
extension ExpenseReportViewController{
    
    ///Get initial data
    func fetchRecordsFRomDatabase(){
        arrExpenseRecords = DatabaseManager.shared.fetchExpenseTableWithQuery(queryString: "SELECT * FROM \(DatabaseTable.expense.rawValue);")
    }
    
    /// Filter expense data between given dates
    func filterExpenses(fromStartDate:Double,toEndDate:Double){
        arrExpenseRecords =
            DatabaseManager.shared.fetchExpenseTableWithQuery(queryString: "SELECT * FROM \(DatabaseTable.expense.rawValue) WHERE date >= \"\(fromStartDate)\" AND date <= \"\(toEndDate)\";")
    }
    
    /// Filter data as per the category
    func filterByCategory(){
        let categoryId =  DatabaseManager.shared.categories.first { (categoryObj) -> Bool in
            return categoryObj.categoryName == textFieldCategory.text ?? ""
            }?.categoryId ?? 0
        
        arrExpenseRecords =
            DatabaseManager.shared.fetchExpenseTableWithQuery(queryString: "SELECT * FROM \(DatabaseTable.expense.rawValue) WHERE category LIKE '%\(categoryId)%';")
    }
}
