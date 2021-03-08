import UIKit
import PhotosUI

class LargeBGTutorialViewController: UIViewController, PHPickerViewControllerDelegate {

    @IBOutlet weak var continueBtn: UIButton!
    var selelctedImage: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        continueBtn.layer.masksToBounds = true
        continueBtn.layer.cornerRadius = continueBtn.bounds.height / 2
    }
    
    @IBAction func onSelectImage(_ sender: Any) {
        let photoLibrary = PHPhotoLibrary.shared()
        let configuration = PHPickerConfiguration(photoLibrary: photoLibrary)
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LargeBGSelectViewController {
            destination.choosedImage = self.selelctedImage
        }
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for result in results {
            let provider = result.itemProvider
     
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, error in
                    // ... save or display the image, if we got one
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if let image = image as? UIImage {
                            self.selelctedImage = image
                            self.performSegue(withIdentifier: "LargeBGSelect", sender: self)
                        } else {
                            AlertDialog.share.showAlert(vc: self, title: AlertDialog.ERROR, message: CANNOT_USE_IMAGE)
                        }
                    }
                }
            }
        }
    }
    
}
