//
//  MediumBGSelectViewController.swift
//  memo
//
//  Created by love family on 20.10.2020.
//

import UIKit
import ImageScrollView
import PhotosUI
import WidgetKit

class MediumBGSelectViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var roundedWidth: NSLayoutConstraint!
    @IBOutlet weak var roundedHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomMargin: NSLayoutConstraint!
    @IBOutlet weak var topMargin: NSLayoutConstraint!
    @IBOutlet weak var middleMargin: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var topRoundedView: UIView!
    @IBOutlet weak var middleRoundedView: UIView!
    
    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var okBtn: CustomOval!
    @IBOutlet weak var upBtn: UIButton!
    @IBOutlet weak var downBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!

    var spinnerView: UIView?
    var choosedImage: UIImage? = nil
    var choosedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let choosedImage = choosedImage {
            self.imgView.image = choosedImage
        }
        
        setupPictureWithZoom()
        
        configureMainView()
        configureCropViews()
        congiureImages()
    }
    
    func setupPictureWithZoom() {
        imgView.clipsToBounds = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.delegate = self
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgView
    }
    
    func configureCropViews() {
        self.topRoundedView.isHidden = true
        self.roundedView.isHidden = true
        self.middleRoundedView.isHidden = true
        
        switch choosedIndex {
        case 0:
            topRoundedView.isHidden = false
        case 1:
            middleRoundedView.isHidden = false
        default:
            roundedView.isHidden = false
        }
    }
    
    @IBAction func onClickUp(_ sender: Any) {
        if self.choosedIndex >= 1 {
            self.choosedIndex = self.choosedIndex - 1
        }
        self.configureCropViews()
    }
    
    @IBAction func onClickDown(_ sender: Any) {
        if self.choosedIndex < 2 {
            self.choosedIndex = self.choosedIndex + 1
        }
        self.configureCropViews()
    }
    
    @IBAction func onCropBtnClicked(_ sender: Any) {
        let topBounds = topRoundedView.frame
        let middleBounds = middleRoundedView.frame
        let bottomBounds = roundedView.frame
    
        self.topRoundedView.isHidden = true
        self.middleRoundedView.isHidden = true
        self.roundedView.isHidden = true
        let topCroppedImage = self.getImage(with: mainView, bounds: topBounds)
        let middleCroppedImage = self.getImage(with: mainView, bounds: middleBounds)
        let bottomCroppedImage = self.getImage(with: mainView, bounds: bottomBounds)
        self.configureCropViews()
        
        
        self.uploadImages(topCroppedImage: topCroppedImage, middleCroppedImage: middleCroppedImage, bottomCroppedImage: bottomCroppedImage)
        
    }
    
    func uploadImages(topCroppedImage: UIImage?, middleCroppedImage: UIImage?, bottomCroppedImage: UIImage?) {
//        UIImageWriteToSavedPhotosAlbum(topCroppedImage!, nil, nil, nil)
        switch choosedIndex {
        case 0:
            uploadImage(image: topCroppedImage)
        case 1:
            uploadImage(image: middleCroppedImage)
        default:
            uploadImage(image: bottomCroppedImage)
        }
    }
    
    func uploadImage(image: UIImage?) {
        self.showWaitDialog(parentView: mainView)
        uploadImageToFireStore(image: image, name: MEDIUMIMAGE, onResult: {
            (isSuccess, imageUrl) in
            self.closeWaitDialog()
            if isSuccess {
                UserDefaultManager.share.saveImageUrl(imageUrl: imageUrl ?? "", key: MEDIUMIMAGE)
                WidgetCenter.shared.reloadAllTimelines()
                AlertDialog.share.showAlert(vc: self, title: AlertDialog.SUCCESS, message: IMAGE_SET_SUCCESS, handler: {_ in
                    self.dismiss(animated: true, completion: nil)
                })
            } else {
                AlertDialog.share.showAlert(vc: self, title: AlertDialog.ERROR, message: IMAGE_SET_ERROR)
            }
        })
    }
    
    @IBAction func onCancelBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showWaitDialog(parentView: UIView?) {
        if parentView == nil {
            return
        }
        
        if spinnerView != nil {
            closeWaitDialog()
        }
        
        spinnerView = UIView.init(frame: parentView!.bounds)
        spinnerView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        ai.color = .mainColor
        ai.startAnimating()
        ai.center = spinnerView!.center
        spinnerView?.addSubview(ai)
        parentView?.addSubview(spinnerView!)
    }
    
    func closeWaitDialog() {
        if spinnerView == nil {
            return
        }
        
        spinnerView?.removeFromSuperview()
        spinnerView = nil
    }
    
    func getImage(with view: UIView, bounds: CGRect) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        
        return renderer.image {
            rendererContext in
            
            view.layer.render(in: rendererContext.cgContext)
        }
    }
    
    func configureMainView() {
        
        let borderWidth: CGFloat = 2.0
        let cornerRadius: CGFloat = 16
        
        roundedView.backgroundColor = .clear
        roundedView.layer.masksToBounds = true
        roundedView.layer.cornerRadius = cornerRadius
        roundedView.layer.borderWidth = borderWidth
        roundedView.layer.borderColor = UIColor.white.cgColor
        
        topRoundedView.backgroundColor = .clear
        topRoundedView.layer.masksToBounds = true
        topRoundedView.layer.cornerRadius = cornerRadius
        topRoundedView.layer.borderWidth = borderWidth
        topRoundedView.layer.borderColor = UIColor.white.cgColor
        
        middleRoundedView.backgroundColor = .clear
        middleRoundedView.layer.masksToBounds = true
        middleRoundedView.layer.cornerRadius = cornerRadius
        middleRoundedView.layer.borderWidth = borderWidth
        middleRoundedView.layer.borderColor = UIColor.white.cgColor
        
        btnView.layer.masksToBounds = true
        btnView.layer.cornerRadius = cornerRadius
    }
    
    override func viewDidLayoutSubviews() {
        mainViewWidth.constant = UIScreen.main.bounds.width / UIScreen.main.bounds.height * mainView.frame.height
        
        print("mainView m -> ", mainView.frame)
        
        let scale = mainView.frame.height / UIScreen.main.bounds.height
        var rWidth: CGFloat = 0
        var rHeight: CGFloat = 0
        var tMargin: CGFloat = 0
        var bMargin: CGFloat = 0
        var mMargin: CGFloat = 0
        
        switch UIScreen.main.bounds.height {
        case 896:
            rWidth = WidgetUIConf.Device_896.rWidth
            rHeight = WidgetUIConf.Device_896.mrHeight
            tMargin = WidgetUIConf.Device_896.topMargin
            bMargin = WidgetUIConf.Device_896.bottomMargin
            mMargin = WidgetUIConf.Device_896.middleMargin
        case 812:
            rWidth = WidgetUIConf.Device_812.rWidth
            rHeight = WidgetUIConf.Device_812.mrHeight
            tMargin = WidgetUIConf.Device_812.topMargin
            bMargin = WidgetUIConf.Device_812.bottomMargin
            mMargin = WidgetUIConf.Device_812.middleMargin
        case 736:
            rWidth = WidgetUIConf.Device_736.rWidth
            rHeight = WidgetUIConf.Device_736.mrHeight
            tMargin = WidgetUIConf.Device_736.topMargin
            bMargin = WidgetUIConf.Device_736.bottomMargin
            mMargin = WidgetUIConf.Device_736.middleMargin
        case 667:
            rWidth = WidgetUIConf.Device_667.rWidth
            rHeight = WidgetUIConf.Device_667.mrHeight
            tMargin = WidgetUIConf.Device_667.topMargin
            bMargin = WidgetUIConf.Device_667.bottomMargin
            mMargin = WidgetUIConf.Device_667.middleMargin
        case 568:
            rWidth = WidgetUIConf.Device_568.rWidth
            rHeight = WidgetUIConf.Device_568.mrHeight
            tMargin = WidgetUIConf.Device_568.topMargin
            bMargin = WidgetUIConf.Device_568.bottomMargin
            mMargin = WidgetUIConf.Device_568.middleMargin
        default:
            rWidth = WidgetUIConf.Device_896.rWidth
            rHeight = WidgetUIConf.Device_896.mrHeight
            tMargin = WidgetUIConf.Device_896.topMargin
            bMargin = WidgetUIConf.Device_896.bottomMargin
            mMargin = WidgetUIConf.Device_896.middleMargin
        }
        
        roundedWidth.constant = rWidth * scale
        roundedHeight.constant = rHeight * scale
        bottomMargin.constant = bMargin * scale / 2
        topMargin.constant = tMargin * scale / 2
        middleMargin.constant = mMargin * scale / 2
        
    }
    
    func congiureImages() {
        configureImageBtn(name: "ic_up", btn: upBtn)
        configureImageBtn(name: "ic_down", btn: downBtn)
        configureImageBtn(name: "ic_close", btn: cancelBtn)
        
        upBtn.layer.masksToBounds = true
        upBtn.layer.cornerRadius = upBtn.bounds.height / 2
        
        downBtn.layer.masksToBounds = true
        downBtn.layer.cornerRadius = downBtn.bounds.height / 2
    }
    
    func configureImageBtn(name: String, btn: UIButton) {
        let img = UIImage(named: name)
        let tintedImage = img?.withRenderingMode(.alwaysTemplate)
        btn.setImage(tintedImage, for: .normal)
        btn.tintColor = .mainColor
    }

}
