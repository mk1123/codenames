//
//  Storage.swift
//  codenames-solver
//
//  Created by Manan Khattar on 1/11/19.
//  Copyright © 2019 Manan Khattar. All rights reserved.
//

import UIKit

class Storage {
    
    var savedImage: UIImage
    var words: [String] = []
    
    init( incomingImage: UIImage) {
        self.savedImage = incomingImage
    }

}
