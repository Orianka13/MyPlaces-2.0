//
//  NewPlaceViewController.swift
//  MyPlaces 2.0
//
//  Created by Олеся Егорова on 28.04.2021.
//

import UIKit
import RealmSwift

class NewPlaceViewController: UITableViewController {
    
    var currentPlace: Place?
    var imageIsChanged = false
    
    @IBOutlet weak var newName: UITextField!
    @IBOutlet weak var newLocation: UITextField!
    @IBOutlet weak var newType: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //уберем разлиновку пустых строк
        tableView.tableFooterView = UIView()

        //отключаем кнопку Save
        saveButton.isEnabled = false
        newName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen()
        
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
            
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon = #imageLiteral(resourceName: "photo")
            //вызываем меню для загрузки фото
            //определяем сам алерт контроллер
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            // определяем пользовательские действия
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
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
    
    //Сохраним значения полей в свойства модели
    func savePlace() {
        
        var image: UIImage?
        
        if imageIsChanged {
            image = imageView.image
        } else {
            image = #imageLiteral(resourceName: "imagePlaceholder")
        }
        
        let imageData = image?.pngData()
        
        let newPlace = Place(name: newName.text!,
                             location: newLocation.text,
                             type: newType.text,
                             imageData: imageData)
        
        
        if currentPlace != nil {
            try! realm.write {
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
            }
        } else {
            StorageManager.saveObject(newPlace)
        }
    }
    
    //передадим значение currentPlace в аутлеты
    private func setupEditScreen(){
        if currentPlace != nil {
            setupNavigationBar()
            imageIsChanged = true
            guard let data = currentPlace?.imageData, let image = UIImage(data: data) else { return }
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            
            newName.text = currentPlace?.name
            newLocation.text = currentPlace?.location
            newType.text = currentPlace?.type
        }
    }
    
    //изменяем NavigationBar чтобы он отображал название редактируемого заведения
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
        
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
       
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
}

// Скрываем клаву по Done
extension NewPlaceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc private func textFieldChanged() {
        if newName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
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
        imageIsChanged = true
        dismiss(animated: true)
    }
}
