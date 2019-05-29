//
//  AddTripVC.swift
//  RxSwiftDemo
//
//  Created by Keyur on 29/05/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit
import FirebaseFirestore
//import RxFirebaseFirestore

class AddTripVC: UIViewController {

    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var startDateTxt: UITextField!
    @IBOutlet weak var endDateTxt: UITextField!
    
    var selectedDate : Date!
    var tripData : TripModel = TripModel()
    let db = Firestore.firestore()
     
    override func viewDidLoad() {
        super.viewDidLoad()
      

    }
    
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToDatePicker(_ sender: UIButton) {
        if selectedDate == nil
        {
            selectedDate = Date()
        }
        DatePickerManager.shared.showPicker(title: "select_dob", selected: selectedDate, min: Date(), max: nil) { (date, cancel) in
            if !cancel && date != nil {
                self.selectedDate = date!
                
                let date1 = getDateStringFromDate(date: self.selectedDate, format: "dd-MM-yyyy")
                if sender.tag == 1 {
                    self.startDateTxt.text = date1
                } else {
                    self.endDateTxt.text = date1
                }
            }
        }
    }
    
    @IBAction func clickToSubmit(_ sender: Any) {
        if (nameTxt.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            displayToast("Please enter name of object")
        }
        else if (startDateTxt.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            displayToast("Please enter description")
        }
        else if (endDateTxt.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            displayToast("Please enter location")
        }
        else {
            tripData.name = nameTxt.text?.trimmed
            tripData.startDate = startDateTxt.text?.trimmed
            tripData.endDate = endDateTxt.text?.trimmed
            
            AppDelegate().sharedDelegate().ref = db.collection("User")
                .rx
                .base
                .addDocument(data: tripData.dictionary()){ err in
                    if let err = err {
                        displayToast("Error removing document: \(err)")
                    } else {
                        print("Document added with ID: \(AppDelegate().sharedDelegate().ref!.documentID)")
                        self.tripData.id = AppDelegate().sharedDelegate().ref!.documentID
                        
                        self.db.collection("User").rx.base.document(self.tripData.id).updateData(["id" : self.tripData.id]) { err in
                                if let err = err {
                                    displayToast("Error removing document: \(err)")
                                } else {
                                    print("Document successfully updated")
                                }
                        }
                    }
                }
            delay(0.2) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
