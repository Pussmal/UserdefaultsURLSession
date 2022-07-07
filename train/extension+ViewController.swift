//
//  extension+ViewController.swift
//  train
//
//  Created by Алексей Моторин on 07.07.2022.
//

import UIKit

extension ViewController {
    func showAlert(title: String?, message: String?, handler: ((UIAlertAction) -> Void)? ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        present(alert, animated: true)
    }
}
