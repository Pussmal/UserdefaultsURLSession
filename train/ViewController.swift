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
        
        mytextField.delegate = self
        network.delegate = self
        
        view.addSubview(activity)
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        activity.isHidden = true
        
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
        
        guard let dataImage = dataImage else { return }
        guard let image = UIImage(data: dataImage) else { return }
        UserDefaults.standard.set(SaveLoadManager.saveImage(image: image), forKey: key)
        
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
        
        guard let dataImage = dataImage else { return }
        
        activity.isHidden = false
        activity.startAnimating()
        
        guard let image = UIImage(data: dataImage) else { return }
        
        DispatchQueue.main.async {
            self.activity.isHidden = false
            self.activity.stopAnimating()
            self.imageView.image = image
        }
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
