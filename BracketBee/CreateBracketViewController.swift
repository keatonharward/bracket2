//
//  CreateBracketViewController.swift
//  BracketBee
//
//  Created by Keaton Harward on 3/6/17.
//  Copyright © 2017 Keaton Harward. All rights reserved.
//

import UIKit

class CreateBracketViewController: UIViewController {
    
    var participants: [String] = []
    var bracketName: String? = nil
    var seeded = true
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var bracketNameTextField: UITextField!
    @IBOutlet weak var seedingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var addParticipantButton: UIButton!
    @IBOutlet weak var createBracketButton: UIButton!
    @IBOutlet weak var participantTableView: UITableView!
    @IBOutlet weak var tableviewBackgroundView: UIView!
    
    // MARK: - Actions
    
    @IBAction func createBracketButtonTapped(_ sender: Any) {
        guard let name = bracketNameTextField.text, !name.isEmpty,
           !participants.isEmpty else {
                presentAddUserError()
                return }
        if seedingSegmentedControl.selectedSegmentIndex == 0 {
            seeded = true
        } else {
            seeded = false
        }
        
        BracketController.shared.addBracket(name: name, seeded: seeded, teams: participants)
    }
    
    @IBAction func seedingToggled(_ sender: Any) {
        participantTableView.reloadData()
    }
    
    @IBAction func addParticipantButtonTapped(_ sender: Any) {
        presentAddParticipant()
    }
    
    
    // Helper functions
    
    func presentAddParticipant() {
        var addMessage: String?
        
        if seedingSegmentedControl.selectedSegmentIndex == 0 {
            addMessage = "Enter names in seed order"
        }
        let addParticipantAlert = UIAlertController(title: "Enter Participant Names", message: addMessage, preferredStyle: .alert)
        
        var participantTextField: UITextField?
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let addAnotherAction = UIAlertAction(title: "Add Another", style: .default) { (_) in
            guard let team = participantTextField?.text, !team.isEmpty else { return }
            self.participants.append(team)
            self.participantTableView.reloadData()
            self.presentAddParticipant()
        }
        
        let addAndComplete = UIAlertAction(title: "Add & Dismiss", style: .default) { (_) in
            guard let team = participantTextField?.text, !team.isEmpty else { return }
            self.participants.append(team)
            self.participantTableView.reloadData()
            
        }
        
        addParticipantAlert.addAction(cancelAction)
        addParticipantAlert.addAction(addAnotherAction)
        addParticipantAlert.addAction(addAndComplete)
        addParticipantAlert.addTextField { (textField) in
            textField.placeholder = "Participant Name..."
            participantTextField = textField
        }
        present(addParticipantAlert, animated: false)
    }
    
    func presentAddUserError() {
        let missingInfoAlert = UIAlertController(title: "Missing Bracket Information", message: "Make sure you gave your Bracket a name and at least 4 participants and try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        missingInfoAlert.addAction(okAction)
        
        present(missingInfoAlert, animated: true)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Setup view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Keys.shared.background
        
        // Set up bracketNameTextField & add icon
        bracketNameTextField.backgroundColor = Keys.shared.alternateBackground
        bracketNameTextField.textColor = Keys.shared.fontColor
        bracketNameTextField.rightViewMode = UITextFieldViewMode.always
        let textFieldIconView = UIImageView(frame: CGRect(x: 275, y: bracketNameTextField.frame.origin.y + (bracketNameTextField.frame.height), width: 55, height: 53))
        textFieldIconView.contentMode = UIViewContentMode.bottomRight
        textFieldIconView.image = #imageLiteral(resourceName: "nametag")
        bracketNameTextField.rightView = textFieldIconView
        if bracketName != nil {
            bracketNameTextField.text = bracketName
        }
        
        // set up segmented control for seeding
        seedingSegmentedControl.tintColor = Keys.shared.accent
        seedingSegmentedControl.backgroundColor = Keys.shared.alternateBackground
        if !seeded {
            seedingSegmentedControl.selectedSegmentIndex = 1
        }
        
        // set up tableView
        // TODO: - round the corners of this tableView with a mask on the views frame
//        participantTableView.superview?.layer.cornerRadius = 5.0
        participantTableView.separatorColor = Keys.shared.accent
        participantTableView.backgroundColor = Keys.shared.alternateBackground
        tableviewBackgroundView.backgroundColor = Keys.shared.alternateBackground
        
        // set up add bracket & add participant buttons
        createBracketButton.backgroundColor = Keys.shared.accent
        createBracketButton.titleLabel?.textColor = Keys.shared.fontColor
        createBracketButton.layer.cornerRadius = 5.0

        
        addParticipantButton.backgroundColor = Keys.shared.accent
        addParticipantButton.titleLabel?.textColor = Keys.shared.fontColor
        addParticipantButton.layer.cornerRadius = 5.0
        
        // Dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateBracketViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromCreateBracket" {
            if let destinationVC = segue.destination as? BracketCollectionViewController {
                let bracket = BracketController.shared.brackets.last
                destinationVC.bracket = bracket
                destinationVC.title = bracket?.name
            }
        }
     }
}

// TableView stuff
extension CreateBracketViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participants.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "participantCell", for: indexPath) as? ParticipantTableViewCell else { return ParticipantTableViewCell() }
        if seedingSegmentedControl.selectedSegmentIndex == 0 {
            cell.seed = (indexPath.row + 1)
        } else {
            cell.seed = nil
        }
        cell.participant = participants[indexPath.row]
        return cell
    }
}


// To get rid of the border on the segmented control
extension UISegmentedControl {
    func removeBorders() {
        setBackgroundImage(imageWithColor(color: backgroundColor!), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}
