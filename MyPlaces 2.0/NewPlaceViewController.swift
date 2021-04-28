//
//  NewPlaceViewController.swift
//  MyPlaces 2.0
//
//  Created by Олеся Егорова on 28.04.2021.
//

import UIKit

class NewPlaceViewController: UITableViewController {
    
    @IBOutlet weak var newName: UITextField!
    @IBOutlet weak var newLocation: UITextField!
    @IBOutlet weak var newType: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //уберем разлиновку пустых строк
        tableView.tableFooterView = UIView()

        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            //вызываем меню для загрузки фото
        } else {
            view.endEditing(true)
        }
    }

}

// Скрываем клаву по Done
extension NewPlaceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
