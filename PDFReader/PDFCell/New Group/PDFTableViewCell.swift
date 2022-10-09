//
//  PDFTableViewCell.swift
//  PDFReader
//
//  Created by Perennial Macbook on 06/10/22.
//

import UIKit

protocol PDFCellDelegate: AnyObject {
    func didPdfActionClick(_ tag: Int)
    func performSharePDFAction(_ tag: Int)

}

class PDFTableViewCell: UITableViewCell {
    
    @IBOutlet weak var percLabel: UILabel!
    @IBOutlet weak var pdfActionButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pdfImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var shareButton: UIButton!
    
    var delegate: PDFCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpViews()
    }
    
    @IBAction func pdfActionButtonClick(_ sender: UIButton) {
        //Show progressBar here
        progressBar.isHidden = false
        percLabel.isHidden = false
        pdfActionButton.isHidden = true
        delegate?.didPdfActionClick(sender.tag)
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        delegate?.performSharePDFAction(sender.tag)
    }
    
    func setUpViews() {
        pdfActionButton.isHidden = false
        progressBar.tintColor = CustomColor.darkSide
        NotificationCenter.default.addObserver(self, selector: #selector(downloadCompleted(_ :)) , name: NSNotification.Name("DownloadCompleted"), object: nil)
        percLabel.textAlignment = .center
        pdfActionButton.titleLabel?.text = "Download"
        containerView.layer.cornerRadius = 20
        pdfImageView.imageCornerRadius()
    }
    
    func configureCell(data: PDFModel){
        titleLabel.text = data.title
        pdfImageView.image = UIImage.init(named: data.image!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func downloadCompleted(_ notification: Notification){
        if let tag = notification.userInfo?["TAG"] as? Int {
            
        }
    }
    
}
