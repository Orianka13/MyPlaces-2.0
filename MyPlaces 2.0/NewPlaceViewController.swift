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
    @IBOutlet weak var imageView: UIImageView!
    

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
            //определяем сам алерт контроллер
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            // определяем пользовательские действия
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                //TODO: Choose image picker
                self.chooseImagePicker(source: .camera)
            }
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                //TODO: Choose image picker
                self.chooseImagePicker(source: .photoLibrary)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            //добавлЯем все пользовательские действия в алерт контроллер
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            //вызываем алерт контроллер
            present(actionSheet, animated: true)
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

//Работа с изображением
extension NewPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
   func chooseImagePicker(source: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(source){
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
            imagePicker.delegate = self
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        dismiss(animated: true)
    }
}
