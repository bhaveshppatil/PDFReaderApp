//
//  PDFCollectionViewCell.swift
//  PDFLibrary
//
//  Created by Perennial Macbook on 10/10/22.
//

import UIKit

protocol PDFCellDelegate: AnyObject {
    func performPDFDownloadAction(_ tag: Int)
}

class PDFCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var percLabel: UILabel!
    @IBOutlet weak var downloadImageView: UIImageView!
    @IBOutlet weak var btnDownlaodPDF: UIButton!
    @IBOutlet weak var pdfImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var downloadContainer: UIView!
    var delegate: PDFCellDelegate?
    
    override func prepareForReuse() {
        btnDownlaodPDF.isHidden = false
        progressBar.isHidden = true
        percLabel.isHidden = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    @IBAction func performDownloadAction(_ sender: UIButton) {
        progressBar.isHidden = false
        btnDownlaodPDF.backgroundColor = .clear
        percLabel.isHidden = false
        delegate?.performPDFDownloadAction(sender.tag)
        
    }
    func setupViews(){
        btnDownlaodPDF.isHidden = false
        downloadContainer.backgroundColor = .clear
        downloadContainer.addViewBorder(borderColor: UIColor.white.cgColor, borderWith: 1, borderCornerRadius: 15)
        percLabel.isHidden = true
        downloadImageView.tintColor = .white
        containerView.backgroundColor = .clear
    }
    
    func configureCell(data: PDFModel){
        dateLabel.text = data.date
        pdfImageView.image = UIImage.init(named: data.image!)
        btnDownlaodPDF.setTitle(data.buttonTitle, for: .normal)
    }
}
