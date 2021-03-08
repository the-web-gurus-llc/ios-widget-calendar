import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mBackBtn: CustomOctagonal!
    @IBOutlet weak var homeBtn: CustomOctagonal!
    @IBOutlet weak var lBackBtn: CustomOctagonal!
    @IBOutlet weak var calendarBtn: CustomOctagonal!

    
    @IBOutlet weak var settingBtn: UIButton!
    
    @IBOutlet weak var calendarContainer: UIView!
    @IBOutlet weak var lBackContainer: UIView!
    @IBOutlet weak var mBackContainer: UIView!
    @IBOutlet weak var settingContainer: UIView!
    @IBOutlet weak var homeContainer: UIView!
    
    @IBOutlet weak var mBackImg: UIImageView!
    @IBOutlet weak var homeImg: UIImageView!
    @IBOutlet weak var lBackImg: UIImageView!
    @IBOutlet weak var calendarImg: UIImageView!
    
    var selIndex = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSettingBtn()
        congiureImages()
        configureUI()
        configureEvents()
    }
    
    func configureEvents() {
        let mBackGesture = UITapGestureRecognizer(target: self, action: #selector (self.mBackBtnClicked))
        self.mBackBtn.addGestureRecognizer(mBackGesture)
        let homeGesture = UITapGestureRecognizer(target: self, action: #selector (self.homeBtnClicked))
        self.homeBtn.addGestureRecognizer(homeGesture)
        let lBackGesture = UITapGestureRecognizer(target: self, action: #selector (self.lBackBtnClicked))
        self.lBackBtn.addGestureRecognizer(lBackGesture)
        let calendarGesture = UITapGestureRecognizer(target: self, action: #selector (self.calendarBtnClicked))
        self.calendarBtn.addGestureRecognizer(calendarGesture)
    }
    
    @objc func mBackBtnClicked(_ sender: UITapGestureRecognizer) {
        self.selIndex = 0
        self.configureUI()
    }
    
    @objc func homeBtnClicked(_ sender: UITapGestureRecognizer) {
        self.selIndex = 1
        self.configureUI()
    }
    
    @objc func lBackBtnClicked(_ sender: UITapGestureRecognizer) {
        self.selIndex = 2
        self.configureUI()
    }
    
    @objc func calendarBtnClicked(_ sender: UITapGestureRecognizer) {
        self.selIndex = 3
        self.configureUI()
    }
    
    @IBAction func onClickSetting(_ sender: Any) {
        self.selIndex = 4
        self.configureUI()
    }
    
    func configureUI() {
        
        // Set Custom Font to Bottom Labels
//         mBLb.font = .myFont1()
        // homeLb.font = .myFont1()
        // lBLb.font = .myFont1()
        // calendarLb.font = .myFont1()
        
        // Configure Button Background colors
//        mBackBtn.backgroundColor = .mainColor
        mBackBtn.fillColor = .mainColor
        // mBLb.textColor = .mainColor
        homeBtn.fillColor = .mainColor
        // homeLb.textColor = .mainColor
        lBackBtn.fillColor = .mainColor
        // lBLb.textColor = .mainColor
        calendarBtn.fillColor = .mainColor
        // calendarLb.textColor = .mainColor
        
        mBackBtn.type = .Right
        homeBtn.type = .LeftRight
        lBackBtn.type = .LeftRight
        calendarBtn.type = .Left
        
        mBackImg.tintColor = .calendarBackColor
        homeImg.tintColor = .calendarBackColor
        lBackImg.tintColor = .calendarBackColor
        calendarImg.tintColor = .calendarBackColor
        
        // Configure Containers
        calendarContainer.alpha = 0.0
        lBackContainer.alpha = 0.0
        mBackContainer.alpha = 0.0
        settingContainer.alpha = 0.0
        homeContainer.alpha = 0.0
        
        // Configure Setting
        settingBtn.tintColor = .black
        
        // configure selected btn
        switch selIndex {
        case 0:
//            mBackBtn.backgroundColor = .calendarBackColor
            mBackBtn.fillColor = .calendarBackColor
            mBackImg.tintColor = .mainColor
            // mBLb.textColor = .selColor
            mBackContainer.alpha = 1.0
        case 1:
            homeBtn.fillColor = .calendarBackColor
            homeImg.tintColor = .mainColor
            // homeLb.textColor = .selColor
            homeContainer.alpha = 1.0
        case 2:
            lBackBtn.fillColor = .calendarBackColor
            // lBLb.textColor = .selColor
            lBackImg.tintColor = .mainColor
            lBackContainer.alpha = 1.0
        case 3:
            calendarBtn.fillColor = .calendarBackColor
            calendarImg.tintColor = .mainColor
            // calendarLb.textColor = .selColor
            calendarContainer.alpha = 1.0
        case 4:
            settingBtn.tintColor = .white
            settingContainer.alpha = 1.0
        default:
            calendarBtn.backgroundColor = .calendarBackColor
            // calendarLb.textColor = .selColor
            calendarContainer.alpha = 1.0
        }
        
        mBackBtn.setNeedsDisplay()
        homeBtn.setNeedsDisplay()
        lBackBtn.setNeedsDisplay()
        calendarBtn.setNeedsDisplay()
        
    }
    
    func configureSettingBtn() {
        let img = UIImage(named: "ic_setting")
        let tintedImage = img?.withRenderingMode(.alwaysTemplate)
        settingBtn.setImage(tintedImage, for: .normal)
    }
    
    func congiureImages() {
        configureImageBtn(name: "ic_mback", imgView: mBackImg)
        configureImageBtn(name: "ic_home", imgView: homeImg)
        configureImageBtn(name: "ic_lback", imgView: lBackImg)
        configureImageBtn(name: "ic_editcal", imgView: calendarImg)
    }
    
    func configureImageBtn(name: String, imgView: UIImageView) {
        let img = UIImage(named: name)
        let tintedImage = img?.withRenderingMode(.alwaysTemplate)
        imgView.image = tintedImage
    }

}



