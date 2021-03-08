//
//  SettingViewController.swift
//  memo
//
//  Created by love family on 21.10.2020.
//

import UIKit
import WidgetKit
import PhotosUI

class SettingViewController: UIViewController, PHPickerViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var sel1: UIView!
    @IBOutlet weak var sel2: UIView!
    @IBOutlet weak var sel3: UIView!
    @IBOutlet weak var sel4: UIView!
    @IBOutlet weak var sel5: UIView!
    
    @IBOutlet weak var selMTBack: UITextField!
    var pickerView: UIPickerView!
    var selIndex = UserDefaultManager.share.getMemoTextIndex()
    
    var spinnerView: UIView?
    var selName: String = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createPickerView()
        configureUI()
        configureEvents()
    }
    
    func createPickerView() {
        pickerView = UIPickerView()
        pickerView.delegate = self
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(self.action))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "キャンセル", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelAction))
        toolBar.setItems([button, spaceButton, cancelButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        selMTBack.inputAccessoryView = toolBar
        selMTBack.inputView = pickerView
        pickerView.selectRow(selIndex, inComponent: 0, animated: true)
        saveMemoText()
    }
    
    func saveMemoText() {
        selMTBack.text = memoArray[selIndex]
        UserDefaultManager.share.saveMemoTextIndex(index: selIndex)
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    @objc func cancelAction() {
        view.endEditing(true)
    }
    
    @objc func action() {
        self.saveMemoText()
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // number of session
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return memoArray.count // number of dropdown items
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return memoArray[row] // dropdown item
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selIndex = row
    }
    
    func uploadImage() {
        let photoLibrary = PHPhotoLibrary.shared()
        let configuration = PHPickerConfiguration(photoLibrary: photoLibrary)
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for result in results {
            let provider = result.itemProvider
     
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, error in
                    // ... save or display the image, if we got one
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            self.continueUploadImage(image: image)
                        } else {
                            AlertDialog.share.showAlert(vc: self, title: AlertDialog.ERROR, message: IMAGE_SET_ERROR)
                        }
                    }
                }
            }
        }
    }
    
    func continueUploadImage(image: UIImage) {
        self.showWaitDialog(parentView: self.view)
        uploadImageToFireStore(image: image, name: selName, onResult: {
            (isSuccess, imageUrl) in
            self.closeWaitDialog()
            if isSuccess {
                UserDefaultManager.share.saveImageUrl(imageUrl: imageUrl ?? "", key: self.selName)
                WidgetCenter.shared.reloadAllTimelines()
                AlertDialog.share.showAlert(vc: self, title: AlertDialog.SUCCESS, message: IMAGE_SET_SUCCESS, handler: {_ in
                    
                })
            } else {
                AlertDialog.share.showAlert(vc: self, title: AlertDialog.ERROR, message: IMAGE_SET_ERROR)
            }
        })
    }
    
    @IBAction func onClickSIMW(_ sender: Any) {
        self.selName = MEDIUMIMAGE
        self.uploadImage()
    }
    
    @IBAction func onClickSILW(_ sender: Any) {
        self.selName = LARGEIMAGE
        self.uploadImage()
    }
    
    func configureUI() {
        configureBtn(selBtn: sel1, isSel: UserDefaultManager.share.getWColor() == WCOLOR1)
        configureBtn(selBtn: sel2, isSel: UserDefaultManager.share.getWColor() == WCOLOR2)
        configureBtn(selBtn: sel3, isSel: UserDefaultManager.share.getWColor() == WCOLOR3)
        configureBtn(selBtn: sel4, isSel: UserDefaultManager.share.getWColor() == WCOLOR4)
        configureBtn(selBtn: sel5, isSel: UserDefaultManager.share.getWColor() == WCOLOR5)
    }
    
    func configureBtn(selBtn: UIView, isSel: Bool) {
        selBtn.layer.masksToBounds = true
        selBtn.layer.cornerRadius = Scale.share.percentH(c: 0.1 / 2)
        if isSel {
            selBtn.layer.borderWidth = 3
            selBtn.layer.borderColor = UIColor.wColor.cgColor
        } else {
            selBtn.layer.borderWidth = 0
        }
    }
    
    @objc func sel1Clicked(_ sender: UITapGestureRecognizer) {
        UserDefaultManager.share.saveWColor(colorName: WCOLOR1)
        configureUI()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    @objc func sel2Clicked(_ sender: UITapGestureRecognizer) {
        UserDefaultManager.share.saveWColor(colorName: WCOLOR2)
        configureUI()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    @objc func sel3Clicked(_ sender: UITapGestureRecognizer) {
        UserDefaultManager.share.saveWColor(colorName: WCOLOR3)
        configureUI()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    @objc func sel4Clicked(_ sender: UITapGestureRecognizer) {
        UserDefaultManager.share.saveWColor(colorName: WCOLOR4)
        configureUI()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    @objc func sel5Clicked(_ sender: UITapGestureRecognizer) {
        UserDefaultManager.share.saveWColor(colorName: WCOLOR5)
        configureUI()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func configureEvents() {
        let sel1Gesture = UITapGestureRecognizer(target: self, action: #selector (self.sel1Clicked))
        self.sel1.addGestureRecognizer(sel1Gesture)
        let sel2Gesture = UITapGestureRecognizer(target: self, action: #selector (self.sel2Clicked))
        self.sel2.addGestureRecognizer(sel2Gesture)
        let sel3Gesture = UITapGestureRecognizer(target: self, action: #selector (self.sel3Clicked))
        self.sel3.addGestureRecognizer(sel3Gesture)
        let sel4Gesture = UITapGestureRecognizer(target: self, action: #selector (self.sel4Clicked))
        self.sel4.addGestureRecognizer(sel4Gesture)
        let sel5Gesture = UITapGestureRecognizer(target: self, action: #selector (self.sel5Clicked))
        self.sel5.addGestureRecognizer(sel5Gesture)
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
}
