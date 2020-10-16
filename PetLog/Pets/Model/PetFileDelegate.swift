//
//  PetFileDelegate.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 17/09/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import Foundation
protocol PetFileDelegate {
    
    func updatePets(_ petManager: PetManager, pets: [Pet])
    func didFailWithError(error: Error)
    func updatePhoto(_ petManager: PetManager, photos: [PetPhoto])
}
