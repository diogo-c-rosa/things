//
//  NewThingTableViewController.swift
//  things
//
//  Created by Diogo Rosa on 16/10/18.
//  Copyright © 2018 Diogo. All rights reserved.
//

import UIKit

extension UITextField {
    var isEmpty: Bool {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
    }
}

class NewThingTableViewController: UITableViewController {
    let dateFormatter = DateFormatter()
    
    var startDatePicker = UIDatePicker()
    var endDatePicker = UIDatePicker()
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var start: UITextField!
    @IBOutlet weak var end: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var store: UITextField!
    @IBOutlet weak var notify: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        name.inputAccessoryView = inputToolbar(action: #selector(self.nameDone))
        
        start.text = dateFormatter.string(from: Date())
        start.inputAccessoryView = inputToolbar(action: #selector(self.dateDone))
        startDatePicker.datePickerMode = .date
        startDatePicker.addTarget(self, action: #selector(self.startDatePickerValueChanged(datePicker:)), for: .valueChanged)
        start.inputView = startDatePicker

        end.inputAccessoryView = inputToolbar(action: #selector(self.dateDone))
        endDatePicker.datePickerMode = .date
        endDatePicker.addTarget(self, action: #selector(self.endDatePickerValueChanged(datePicker:)), for: .valueChanged)
        end.inputView = endDatePicker
        
        price.inputAccessoryView = inputToolbar(action: #selector(self.priceDone))
        
        store.inputAccessoryView = inputToolbar(action: #selector(self.storeDone))
        
        name.becomeFirstResponder()
    }
    
    func inputToolbar(action: Selector) -> UIToolbar {
        let toolBar = UIToolbar()
        
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Next", style: UIBarButtonItem.Style.done, target: self, action: action)
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        return toolBar
    }
    
    @objc func nameDone() {
        start.becomeFirstResponder()
    }
    
    @objc func startDatePickerValueChanged(datePicker: UIDatePicker) {
        start.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func endDatePickerValueChanged(datePicker: UIDatePicker) {
        end.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func dateDone() {
        price.becomeFirstResponder()
    }
    
    @objc func priceDone() {
        store.becomeFirstResponder()
    }
    
    @objc func storeDone() {
        store.resignFirstResponder()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        var canSave = false
        if name.isEmpty {
            name.becomeFirstResponder()
        }
        else if price.isEmpty {
            price.becomeFirstResponder()
        }
        else if store.isEmpty {
            store.becomeFirstResponder()
        }
        else {
            canSave = true
        }
        
        if !canSave {
            return
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext
        
        let thing = Thing(context: context)
        thing.name = name.text
        thing.start = dateFormatter.date(from: start.text!)
        if let endValue = dateFormatter.date(from: end.text!) {
            thing.end = endValue
        }
        if let priceValue = Int16(price.text!) {
            thing.price = priceValue
        }
        thing.store = store.text
        thing.notify = notify.isOn
        
        do {
            try context.save()
        } catch {
        }
        
        dismiss(animated: true, completion: nil)
    }
}
