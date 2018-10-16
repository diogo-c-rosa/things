//
//  NewThingTableViewController.swift
//  things
//
//  Created by Diogo Rosa on 16/10/18.
//  Copyright © 2018 Diogo. All rights reserved.
//

import UIKit

class NewThingTableViewController: UITableViewController {

    let dateFormatter = DateFormatter()
    
    var startDatePicker = UIDatePicker()
    var endDatePicker = UIDatePicker()
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var store: UITextField!
    @IBOutlet weak var notify: UISwitch!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        dateFormatter.dateFormat = "dd MMM yyyy"
        startDate.text = dateFormatter.string(from: Date())
        
        startDatePicker.datePickerMode = .date
        startDatePicker.addTarget(self, action: #selector(self.startDatePickerValueChanged(datePicker:)), for: .valueChanged)
        startDate.inputView = startDatePicker

        endDatePicker.datePickerMode = .date
        endDatePicker.addTarget(self, action: #selector(self.endDatePickerValueChanged(datePicker:)), for: .valueChanged)
        endDate.inputView = endDatePicker
    }
    
    @objc func startDatePickerValueChanged(datePicker: UIDatePicker) {
        startDate.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func endDatePickerValueChanged(datePicker: UIDatePicker) {
        endDate.text = dateFormatter.string(from: datePicker.date)
    }

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
    }
}
