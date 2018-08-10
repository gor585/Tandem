//
//  ChangeUserImageNotification .swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 10.08.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

extension AccountSettingsViewController {
    
    func sendChangedUserImageNotification() {
        NotificationCenter.default.post(name: USER_IMAGE_IS_CHANGED, object: nil)
    }
}
