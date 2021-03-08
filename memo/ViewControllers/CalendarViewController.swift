import UIKit
import CVCalendar
import WidgetKit
import PhotosUI

class CalendarViewController: UIViewController, UITextViewDelegate, PHPickerViewControllerDelegate {
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var circleView: UIView!
    
    @IBOutlet weak var memoView: UIView!
    @IBOutlet weak var memoTv: UITextView!
    @IBOutlet weak var memoLb: UILabel!
    @IBOutlet weak var memoSaveBtn: UIButton!
    
    @IBOutlet weak var firstCircle: UIView!
    @IBOutlet weak var secondCircle: UIView!
    
    @IBOutlet weak var circleIV: UIImageView!
    var selelctedImage: UIImage? = nil
    
    private var shouldShowDaysOut = false
    private var animationFinished = false
    private var selectedDay: DayView!
    private var selectedDate = Date()
    private var currentCalendar: Calendar?
    
    private let DOT = "・"
    private let MAXLENGTH = 5
    
    override func awakeFromNib() {
        let timeZoneBias = 540
        currentCalendar = Calendar(identifier: .gregorian)
        currentCalendar?.locale = Locale(identifier: "ja_JP")
        if let timeZone = TimeZone(secondsFromGMT: timeZoneBias * 60) {
            currentCalendar?.timeZone = timeZone
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menuView.menuViewDelegate = self
        self.calendarView.calendarAppearanceDelegate = self
        self.calendarView.calendarDelegate = self
        
        if let currentCalendar = currentCalendar {
            monthLabel.text = String(CVDate(date: Date(), calendar: currentCalendar).month)
        }
        
        circleView.layer.masksToBounds = true
        circleView.layer.cornerRadius = circleView.bounds.height / 2
        
        configureMemoView()
        memoSaveBtn.tag = 0
        changeSaveBtn()
        
//        memoTv.textContainer.maximumNumberOfLines = 5
//        memoTv.textContainer.lineBreakMode = .byTruncatingTail
        
        memoTv.tintColor = UIColor.white
        memoTv.tintColorDidChange()
        memoTv.delegate = self
        
        changeDay(nDate: Date() as NSDate)
        showMemo()
        configureCircleViews()
    }
    
    func showMemo() {
        memoTv.text = UserDefaultManager.share.getMemo(date: selectedDate)
        if let currentCalendar = self.currentCalendar {
            let y = currentCalendar.component(.year, from: selectedDate)
            let m = currentCalendar.component(.month, from: selectedDate)
            let d = currentCalendar.component(.day, from: selectedDate)
            
            let ty = currentCalendar.component(.year, from: Date())
            let tm = currentCalendar.component(.month, from: Date())
            let td = currentCalendar.component(.day, from: Date())
//            memoLb.text = "⚪ \(m)月\(d)日のメモ ⚪"
            if y == ty && m == tm && d == td {
                memoLb.text = "今日のメモ"
            } else {
                memoLb.text = "\(m)月\(d)日のメモ"
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
        configureCircleIV()
    }
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text
        
        let layoutManager = textView.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var lineRange: NSRange = NSMakeRange(0, 1)
        var index = 0
        var numberOfLines = 0
        
        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        
        if (numberOfLines > MAXLENGTH) {
            textView.text.removeLast()
        }
        
        self.memoSaveBtn.tag = 1
        self.changeSaveBtn()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let numLines = textView.text.components(separatedBy:"\n")
        if (numLines.count == MAXLENGTH && text == "\n")
        {
            return false
        }
        
        
        
        if (textView.text.count == 0) {
            textView.text = "\(DOT)\(textView.text!)"
        }
        
        if text == "\n" {
            textView.text = "\(textView.text!)\n\(DOT)"
            return false
        }
        
        return true
    }
    
    @IBAction func onClickSaveMemo(_ sender: Any) {
        self.memoSaveBtn.tag = 0
        self.changeSaveBtn()
        UserDefaultManager.share.saveMemo(date: selectedDate, memo: memoTv.text)
        WidgetCenter.shared.reloadAllTimelines()
        self.memoTv.resignFirstResponder()
    }
    @IBAction func actionPrevious(_ sender: Any) {
        calendarView.loadPreviousView()
    }
    
    @IBAction func actionNext(_ sender: Any) {
        calendarView.loadNextView()
    }
    
    func changeSaveBtn() {
        if memoSaveBtn.tag == 0 {
            memoSaveBtn.tintColor = .white
        } else {
            memoSaveBtn.tintColor = .red
        }
    }
    
    func configureMemoView() {
        memoView.layer.masksToBounds = true
        memoView.layer.cornerRadius = 20
        memoView.layer.borderWidth = 4
        memoView.layer.borderColor = UIColor.selColor.cgColor
        
        let img = UIImage(named: "ic_save")
        let tintedImage = img?.withRenderingMode(.alwaysTemplate)
        memoSaveBtn.setImage(tintedImage, for: .normal)
        
//        memoTv.textContainerInset = UIEdgeInsets(top: 8,left: 8,bottom: 8,right: 8)
    }
    
    func configureCircleViews() {
        firstCircle.layer.masksToBounds = true
        firstCircle.layer.cornerRadius = firstCircle.layer.bounds.height / 2
        secondCircle.layer.masksToBounds = true
        secondCircle.layer.cornerRadius = firstCircle.layer.bounds.height / 2
        
        let circleIVGesture = UITapGestureRecognizer(target: self, action: #selector (self.circleIVClicked))
        self.circleIV.addGestureRecognizer(circleIVGesture)
    }
    
    func configureCircleIV() {
        circleIV.layer.masksToBounds = true
        circleIV.layer.cornerRadius = circleIV.layer.bounds.height / 2
    }
    
    @objc func circleIVClicked(_ sender: UITapGestureRecognizer) {
        let photoLibrary = PHPhotoLibrary.shared()
        let configuration = PHPickerConfiguration(photoLibrary: photoLibrary)
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CircleSelectViewController {
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
                            self.performSegue(withIdentifier: "CircleSelect", sender: self)
                        } else {
                            AlertDialog.share.showAlert(vc: self, title: AlertDialog.ERROR, message: CANNOT_USE_IMAGE)
                        }
                    }
                }
            }
        }
    }
    
}

// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate
extension CalendarViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    func changeDay(nDate:NSDate) {
        calendarView.toggleViewWithDate(nDate as Date)
    }
    
    func presentationMode() -> CalendarMode { return .monthView }
    
    func firstWeekday() -> Weekday { return .monday }
    
    func calendar() -> Calendar? { return currentCalendar }
    
    func dayOfWeekTextColor(by weekday: Weekday) -> UIColor {
        return UIColor.calendarLColor
    }
    
    func shouldShowWeekdaysOut() -> Bool { return shouldShowDaysOut }
    
    func shouldAnimateResizing() -> Bool { return false }
    
    private func shouldSelectDayView(dayView: DayView) -> Bool {
        return true
    }
    
    func shouldAutoSelectDayOnMonthChange() -> Bool { return false }
    
    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        selectedDay = dayView
        selectedDate = dayView.date.convertedDate() ?? Date()
        calendarView.contentController.refreshPresentedMonth()
        showMemo()
        print("selected day change: \(selectedDay.date.day)")
    }
    
    func shouldSelectRange() -> Bool { return false }
    
    func didSelectRange(from startDayView: DayView, to endDayView: DayView) {
        print("RANGE SELECTED: \(startDayView.date.commonDescription) to \(endDayView.date.commonDescription)")
    }
    
    func presentedDateUpdated(_ date: CVDate) {
        print("presentedDateUpdated -> ", date.month)
        print("presentedDateUpdated -> ", date.day)
        calendarView.contentController.refreshPresentedMonth()
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool { return false }
    
    func shouldHideTopMarkerOnPresentedView() -> Bool {
        return true
    }
    
    func weekdaySymbolType() -> WeekdaySymbolType { return .short }
    
    func selectionViewPath() -> ((CGRect) -> (UIBezierPath)) {
        return { UIBezierPath(rect: CGRect(x: 0, y: 0, width: $0.width, height: $0.height)) }
    }
    
    func shouldShowCustomSingleSelection() -> Bool { return false }
    
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
//        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: CVShape.circle)
//        circleView.fillColor = UIColor.calendarBackColor
//        circleView.strokeColor = ColorsConfig.text
//        return circleView
        
        dayView.setNeedsLayout()
        dayView.layoutIfNeeded()
        
        let π = Double.pi
        
        let ringLayer1 = CAShapeLayer()
        
        let newView = UIView(frame: dayView.frame)
        
        let diameter1 = (min(newView.bounds.width, newView.bounds.height))
        let radius1 = diameter1 / 2.0 - 2
        
        newView.layer.addSublayer(ringLayer1)
        
        ringLayer1.fillColor = UIColor.calendarBackColor.cgColor
        ringLayer1.strokeColor = ColorsConfig.text.cgColor
        
        let centrePoint1 = CGPoint(x: newView.bounds.width/2.0, y: newView.bounds.height/2.0)
        let startAngle1 = CGFloat(-π/2.0)
        let endAngle1 = CGFloat(π * 2.0) + startAngle1
        let ringPath1 = UIBezierPath(arcCenter: centrePoint1,
                                    radius: radius1,
                                    startAngle: startAngle1,
                                    endAngle: endAngle1,
                                    clockwise: true)
        
        ringLayer1.path = ringPath1.cgPath
        ringLayer1.frame = newView.layer.bounds
        
        return newView
        
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (dayView.isCurrentDay) {
            return true
        }
        return false
    }
    
    func supplementaryView(viewOnDayView dayView: DayView) -> UIView {
        
        dayView.setNeedsLayout()
        dayView.layoutIfNeeded()
        
        let π = Double.pi
        
        let ringLayer = CAShapeLayer()
        
        let newView = UIView(frame: dayView.frame)
        
        let diameter = (min(newView.bounds.width, newView.bounds.height))
        let radius = diameter / 2.0 - 2
        
        newView.layer.addSublayer(ringLayer)
        
        ringLayer.fillColor = ColorsConfig.selectionBackground.cgColor
        
        let centrePoint = CGPoint(x: newView.bounds.width/2.0, y: newView.bounds.height/2.0)
        let startAngle = CGFloat(-π/2.0)
        let endAngle = CGFloat(π * 2.0) + startAngle
        let ringPath = UIBezierPath(arcCenter: centrePoint,
                                    radius: radius,
                                    startAngle: startAngle,
                                    endAngle: endAngle,
                                    clockwise: true)
        
        ringLayer.path = ringPath.cgPath
        ringLayer.frame = newView.layer.bounds
        
        return newView
    }
    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        guard let currentCalendar = currentCalendar else { return false }
        
        let components = Manager.componentsForDate(selectedDate, calendar: currentCalendar)
        
        var shouldDisplay = false
        if dayView.date.year == components.year &&
            dayView.date.month == components.month {
            
            if (dayView.date.day == components.day)  {
                print("Circle should appear on " + dayView.date.commonDescription)
                shouldDisplay = true
            }
        }
        
        return shouldDisplay
    }
    
    func dayOfWeekBackGroundColor() -> UIColor { return .calendarBackColor }
    
    func maxSelectableRange() -> Int { return 14 }
}


// MARK: - CVCalendarViewAppearanceDelegate
extension CalendarViewController: CVCalendarViewAppearanceDelegate {
    
    func dayLabelWeekdayDisabledColor() -> UIColor { return .lightGray }
    
    func dayLabelPresentWeekdayInitallyBold() -> Bool { return false }
    
    func spaceBetweenDayViews() -> CGFloat { return 0 }
    
    func dayLabelFont(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIFont { return UIFont(name: WidgetUI.fontName, size: 22)! }
    
    func dayLabelColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
//        print("dayLableColor -> ", weekDay.rawValue, status.rawValue, present.rawValue)
        
        switch (weekDay, status, present) {
        case (_, .selected, _), (_, .highlighted, _): return UIColor.calendarBackColor
        case (.sunday, .in, _): return ColorsConfig.sundayText
        case (.sunday, _, _): return ColorsConfig.sundayTextDisabled
        case (_, .in, _): return ColorsConfig.text
        default: return ColorsConfig.textDisabled
        }
    }
    
    func dayLabelBackgroundColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
//        print("dayLabelBackgroundColor -> ", weekDay.rawValue, status.rawValue, present.rawValue)
        switch (weekDay, status, present) {
        case (.sunday, .selected, _), (.sunday, .highlighted, _): return ColorsConfig.sundaySelectionBackground
        case (_, .selected, _), (_, .highlighted, _): return ColorsConfig.selectionBackground
        default: return nil
        }
    }
}


extension CalendarViewController {
//    func toggleMonthViewWithMonthOffset(offset: Int) {
//        guard let currentCalendar = currentCalendar else { return }
//
//        var components = Manager.componentsForDate(Date(), calendar: currentCalendar) // from today
//
//        components.month! += offset
//
//        let resultDate = currentCalendar.date(from: components)!
//
//        self.calendarView.toggleViewWithDate(resultDate)
//    }
    
    
    func didShowNextMonthView(_ date: Date) {
        changedMonth(date)
    }
    
    func didShowPreviousMonthView(_ date: Date) {
        changedMonth(date)
    }
    
    func didShowNextWeekView(from startDayView: DayView, to endDayView: DayView) {
        print("Showing Week: from \(startDayView.date.day) to \(endDayView.date.day)")
    }
    
    func didShowPreviousWeekView(from startDayView: DayView, to endDayView: DayView) {
        print("Showing Week: from \(startDayView.date.day) to \(endDayView.date.day)")
    }
    
    func changedMonth(_ date: Date) {
        guard let currentCalendar = currentCalendar else { return }
        
        let components = Manager.componentsForDate(date, calendar: currentCalendar) // from today
        let selComponents = Manager.componentsForDate(selectedDate, calendar: currentCalendar) // from today
        
        if let month = components.month {
            monthLabel.text = String(month)
            if month == selComponents.month {
                let selDate = selectedDate
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd"
                let noon = currentCalendar.date(bySettingHour: 12, minute: 0, second: 0, of: selDate)!
//                changeDay(nDate: currentCalendar.date(byAdding: .day, value: -1, to: noon)! as NSDate)
                changeDay(nDate: dateFormatterGet.date(from: "2020-11-01")! as NSDate)
                changeDay(nDate: selDate as NSDate)
            }
        }
    
//        calendarView.contentController.refreshPresentedMonth()
    }
    
}
