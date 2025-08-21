//
//  RewardViewController.swift
//  Customer
//
//  Created by Priyanka Jagtap on 26/03/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class RewardViewController: BaseViewController {

    @IBOutlet weak var rewardPointLabel: UILabel!
    @IBOutlet weak var expiryDateLabel: UILabel!
    var viewModel : RewardViewModel = RewardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getRewardPoints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupUI(){
        setNavigationBarHidden(hide: false)
        setLeftButton()
        navigationItem.title = TITLE.rewardPoints.localized
    }
    
    func getRewardPoints()
    {
        self.viewModel.getRewardPoints {
            self.rewardPointLabel.text = self.viewModel.rewards?.reward_point ?? "0"
            self.expiryDateLabel.text = String(format: "%@ = %d %@", "1 \(self.viewModel.rewards?.currency ?? "")", self.viewModel.rewards?.conversion_rate ?? 0, TITLE.customer_points.localized)
        }
    }
    
    @IBAction func onClickRedeem(_ sender: ActionButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
