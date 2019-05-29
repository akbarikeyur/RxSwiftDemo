//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by Keyur on 29/05/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import DropDown
import FirebaseFirestore

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tripTblView: UITableView!
    @IBOutlet weak var noDataLbl: UILabel!
    
 
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(dataSetUp), name: NSNotification.Name.init(NOTIFICATION.UPDATE_DATA), object: nil)
        
        noDataLbl.isHidden = true
    }
    
    @objc func dataSetUp()  {
        tripTblView.reloadData()
        noDataLbl.isHidden = AppModel.shared.TripArr.count == 0 ? false : true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppModel.shared.TripArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tripTblView.dequeueReusableCell(withIdentifier: "TripTVC", for: indexPath) as! TripTVC
        let dict : TripModel = AppModel.shared.TripArr[indexPath.row]
        
        cell.nameLbl.text = dict.name
        cell.startDateLbl.text = dict.startDate
        cell.endDateLbl.text = dict.endDate
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let dict : TripModel = AppModel.shared.TripArr[indexPath.row]
            
            showAlertWithOption("Confirmation", message: "Are you sure you want to delete this Trip data.", completionConfirm: {
                let db = Firestore.firestore()
                db.collection("User").document(dict.id).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                        displayToast("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                        self.tripTblView.reloadData()
                    }
                }
            }) {
                
            }
        }
    }
    
    @IBAction func clickToAddTripData(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddTripVC") as! AddTripVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


class TripTVC: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var endDateLbl: UILabel!
    
}

