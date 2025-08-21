//
//  PDFViewController.swift
//  EZAR
//
//  Created by Shruti Gupta on 4/25/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import UIKit
import PDFKit

@available(iOS 11.0, *)
class PDFViewController: UIViewController {
    
    //MARK:- Veriable declaration
    
    //var pdfView = PDFView()
    var pdfURL: URL!
    
    @IBOutlet weak var closeBtn: ActionButton!
    @IBOutlet weak var bgView: ShaddowView!
    
    //MARK:- View lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.view.backgroundColor = UIColor.white
            let pdfView = PDFView(frame: self.view.bounds)
            pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           self.bgView.addSubview(pdfView)
            
            pdfView.autoScales = true
            if let document = PDFDocument(url: self.pdfURL) {
                pdfView.document = document
            }
        }
        
        closeBtn.touchUp = { button in
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
}
