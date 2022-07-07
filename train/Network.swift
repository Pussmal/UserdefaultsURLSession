//
//  Networking.swift
//  train
//
//  Created by Алексей Моторин on 05.07.2022.
//

import Foundation

protocol NetWorkDelegate {
    func getData(_ data: Data)
}

struct NetWork {

    var delegate: NetWorkDelegate?
    
    func getData(urlString: String?) {
        guard let urlString = urlString else { return }
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, url, error in
            guard let data = data else { return }
            self.delegate?.getData(data)
        }.resume()
    }
    
}
