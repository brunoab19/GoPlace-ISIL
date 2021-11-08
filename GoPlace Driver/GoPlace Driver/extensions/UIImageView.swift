//
//  UIImageView.swift
//  GoPlace Driver
//
//  Created by Bruno Aburto on 6/11/21.
//

import UIKit

// MARK: - Image Remote
extension UIImageView {
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        self?.contentMode = .scaleToFill
                    }
                }
            }
        }
    }
    
}
