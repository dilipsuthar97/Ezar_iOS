//
//  SelectBroadCastVC.swift
//  EZAR
//
//  Created by Volkoff on 18/08/23.
//  Copyright © 2023 Thoab App. All rights reserved.
//

import UIKit
import PanModal

protocol SelectBrodCastViewDelegate {
    func onClickBrodCastView(_ type: Bool)
}

class SelectBroadCastVC: UIViewController {

    var delegate: SelectBrodCastViewDelegate?
    var listArray = ["customer_my_previous_measurement",
                     "customer_scan_body",
                     "customer_tailor_measurement",
    ]
    
    // MARK: - IBOutlet
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var requestButton: ActionButton!
    @IBOutlet var chooseListButton: ActionButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configureUI() {
        titleLbl.text = "customer_chooseOptions".localized.uppercased()
        requestButton.setTitle("customer_broadCast_request".localized, for: .normal)
        chooseListButton.setTitle("customer_ChooseList".localized, for: .normal)
        
        requestButton.touchUp = { button in
            self.delay(0) {
                self.dismiss(animated: true, completion: nil)
                self.delegate?.onClickBrodCastView(true)
            }
        }
        
        chooseListButton.touchUp = { button in
            self.delay(0) {
                self.dismiss(animated: true, completion: nil)
                self.delegate?.onClickBrodCastView(false)
            }
        }
    }
}

// MARK: - PanModalPresentable
extension SelectBroadCastVC: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(180)
    }

    var showDragIndicator: Bool {
        return false
    }
}

