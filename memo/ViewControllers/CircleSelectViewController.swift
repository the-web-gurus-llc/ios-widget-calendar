import UIKit
import ImageScrollView
import PhotosUI
import WidgetKit

class CircleSelectViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var roundedView: UIView!
    
    @IBOutlet weak var btnView: UIView!
    
    var spinnerView: UIView?
    
    var choosedImage: UIImage? = nil
    var isTopImage = true
    
    @IBOutlet weak var okBtn: CustomOval!
    @IBOutlet weak var upBtn: UIButton!
    @IBOutlet weak var downBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let choosedImage = choosedImage {
            self.imgView.image = choosedImage
//            self.imgView.image = loadImageFromDiskWith(fileName: LARGEIMAGE)
        }
        
        setupPictureWithZoom()
        
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
    
    @IBAction func onClickUp(_ sender: Any) {

    }
    
    @IBAction func onClickDown(_ sender: Any) {

    }
    
    @IBAction func onCropBtnClicked(_ sender: Any) {
        let bottomBounds = roundedView.frame
    
        self.roundedView.isHidden = true
        let bottomCroppedImage = self.getImage(with: mainView, bounds: bottomBounds)
        self.roundedView.isHidden = false
        
        self.uploadImages(croppedImage: bottomCroppedImage)
    }
    
    func uploadImages(croppedImage: UIImage?) {
        uploadImage(image: croppedImage)
    }
    
    func uploadImage(image: UIImage?) {
        self.showWaitDialog(parentView: mainView)
        uploadImageToFireStore(image: image, name: CIRCLEIMAGE, onResult: {
            (isSuccess, imageUrl) in
            self.closeWaitDialog()
            if isSuccess {
                UserDefaultManager.share.saveImageUrl(imageUrl: imageUrl ?? "", key: CIRCLEIMAGE)
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
        roundedView.layer.cornerRadius = roundedView.layer.bounds.height / 2
        roundedView.layer.borderWidth = borderWidth
        roundedView.layer.borderColor = UIColor.black.cgColor
        
        btnView.layer.masksToBounds = true
        btnView.layer.cornerRadius = cornerRadius
        
    }
    
    override func viewDidLayoutSubviews() {
        configureMainView()
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
