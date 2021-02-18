//
//  AddPollViewController.swift
//  WG-Projekt
//
//  Created by Paul Pfisterer on 15.02.21.
//  Copyright © 2021 WG-Projekt. All rights reserved.
//

import UIKit

class AddPollViewController: UIViewController {
    var optionCounter = 2

    @IBOutlet weak var pollDescription: UITextField!
    @IBOutlet weak var pollDue: UIDatePicker!
    @IBOutlet weak var pollOptions: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pollOptions.delegate = self
        pollOptions.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addOption(_ sender: Any) {
        optionCounter += 1
        pollOptions.reloadData()
    }
    @IBAction func createPoll(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



extension AddPollViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionCounter
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "pollOptionCell", for: indexPath) as? PollOptionCell else {
            fatalError("Cell could not be cast")
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            optionCounter -= 1
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
}
