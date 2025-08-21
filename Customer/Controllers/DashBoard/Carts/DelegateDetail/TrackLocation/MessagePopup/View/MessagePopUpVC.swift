//
//  ToDoPopUpViewController.swift
//  GIS-Agent
//
//  Created by Priyanka Jagtap on 19/09/18.
//  Copyright © 2017 Thoab. All rights reserved.
//

import UIKit
import STPopup

class MessagePopUpVC: UIViewController {

    @IBOutlet weak var messageTxtView: UITextView!
    @IBOutlet weak var sendMessageBtn: ActionButton!
    @IBOutlet weak var closeBtn: ActionButton!
    let viewModel : MessageViewModel = MessageViewModel()
    @IBOutlet weak var titleLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.popupController?.navigationBarHidden = true
        
       titleLbl.text = TITLE.customer_your_message.localized
   
    sendMessageBtn.setTitle(TITLE.customer_send_message.localized, for: .normal)
        

        sendMessageBtn?.touchUp = { button in
            
            if self.messageTxtView.hasText {
            
            self.viewModel.message = self.messageTxtView.text?.trimmingCharacters() ?? ""
            self.viewModel.sendMessageWS {
                self.dismiss(animated: true, completion: nil)
                
            }
            }else{
                  INotifications.show(message: TITLE.customer_error_empty_message.localized)
            }
        }

        closeBtn?.touchUp = { button in
            self.dismiss(animated: true, completion: nil)
        }
    }
}




