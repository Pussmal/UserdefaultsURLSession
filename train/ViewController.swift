//
//  ViewController.swift
//  train
//
//  Created by Алексей Моторин on 04.07.2022.
//

import UIKit

class ViewController: UIViewController {
    
    enum SettingsKey: String {
        case image
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mytextField: UITextField!
    
    let activity = UIActivityIndicatorView()
    
    var network = NetWork()
    var dataImage: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharedImage))
        title = "Tap imageView to change image"
        
        mytextField.delegate = self
        network.delegate = self
        
        view.addSubview(activity)
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        activity.isHidden = true
        
        creatGestureForImageView()
        
    }
    
    @IBAction func showImageButtonPressed(_ sender: UIButton) {
        showImage()
    }
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        saveData()
    }
    
    @IBAction func loadButtonPressed(_ sender: UIButton) {
        loadData()
    }
    
    private func saveData() {
        let key = SettingsKey.image.rawValue
        guard let dataImage = dataImage else {
            showAlert(title: "Error", message: "add url image for save", handler: nil)
            return
        }
        guard let image = UIImage(data: dataImage) else { return }
        if let nameImage = SaveLoadManager.saveImage(image: image) {
            UserDefaults.standard.set(nameImage, forKey: key)
            showAlert(title: "Image Saved", message: nil, handler: nil)
        }
    }
    
    private func loadData() {
        let key = SettingsKey.image.rawValue
        
        guard let imageName = UserDefaults.standard.value(forKey: key) as? String else { return }
        guard let image = SaveLoadManager.loadImage(fileName: imageName) else { return }
        
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
    
    private func showImage() {
        
        guard let dataImage = dataImage else {
            showAlert(title: "Error", message: "No image", handler: nil)
            return
        }
        
        activity.isHidden = false
        activity.startAnimating()
        
        guard let image = UIImage(data: dataImage) else { return }
        
        DispatchQueue.main.async {
            self.activity.isHidden = false
            self.activity.stopAnimating()
            self.imageView.image = image
        }
    }
    
    private func creatGestureForImageView() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(showAlertForChange))
        recognizer.numberOfTapsRequired = 1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(recognizer)
    }
    
    @objc private func showAlertForChange() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let libraryAction = UIAlertAction(title: "Photos", style: .default) { _ in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true)
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true)
        }
        
        let cameraIcon = UIImage(systemName: "camera")
        let photoIcon = UIImage(systemName: "photo")
        
        libraryAction.setValue(photoIcon, forKey: "image")
        libraryAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        cameraAction.setValue(cameraIcon, forKey: "image")
        cameraAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        alert.addAction(libraryAction)
        alert.addAction(cameraAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc private func sharedImage() {
        guard let image = imageView.image?.jpegData(compressionQuality: 1) else {
            showAlert(title: "Error" , message: "No image for shared", handler: nil)
            return }
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: [])
        activityVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activityVC, animated: true)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        network.getData(urlString: textField.text)
        textField.resignFirstResponder()
        return true
    }
}

extension ViewController: NetWorkDelegate {
    func getData(_ data: Data) {
        dataImage = data
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var chosenImage = UIImage()
        
        if let image = info[.editedImage] as? UIImage {
            chosenImage = image
        } else if let image = info[.originalImage] as? UIImage {
            chosenImage = image
        }
        
        imageView.image = chosenImage
        picker.dismiss(animated: true)
    }
    
}
