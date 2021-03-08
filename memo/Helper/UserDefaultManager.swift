import Foundation

class UserDefaultManager {
    static let share = UserDefaultManager()
    private init() {}
    
    private func dateToString(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: date)
    }
    
    func getMyID() -> String {
        var id = ""
        if let userDefaults = UserDefaults(suiteName: GROUPNAME) {
            id = userDefaults.string(forKey: FIREBASE_ID) ?? ""
            if id == "" {
                id = UUID().uuidString
                userDefaults.setValue(id, forKey: FIREBASE_ID)
            }
        }
        return id
    }
    
    func saveMemoTextIndex(index: Int) {
        if let userDefaults = UserDefaults(suiteName: GROUPNAME) {
            userDefaults.setValue(index, forKey: MEMOSTEXTINDEX)
        }
    }
    
    func getMemoTextIndex() -> Int {
        if let userDefaults = UserDefaults(suiteName: GROUPNAME) {
            return userDefaults.integer(forKey: MEMOSTEXTINDEX)
        }
        return 0
    }
    
    func saveMemo(date: Date, memo: String) {
        if let userDefaults = UserDefaults(suiteName: GROUPNAME) {
            userDefaults.setValue(memo, forKey: dateToString(date: date))
        }
    }
    
    func getMemo(date: Date) -> String {
        if let userDefaults = UserDefaults(suiteName: GROUPNAME) {
            return userDefaults.string(forKey: dateToString(date: date)) ?? ""
        }
        return ""
    }
    
    func saveWColor(colorName: String) {
        if let userDefaults = UserDefaults(suiteName: GROUPNAME) {
            userDefaults.setValue(colorName, forKey: WCOLOR)
        }
    }
    
    func getWColor() -> String {
        if let userDefaults = UserDefaults(suiteName: GROUPNAME) {
            return userDefaults.string(forKey: WCOLOR) ?? WCOLOR1
        }
        return WCOLOR1
    }
    
    func saveTopMediumImage(imageUrl: String) {
        saveImageUrl(imageUrl: imageUrl, key: TOPMEDIUMIMAGE)
    }
    
    func saveMiddleMediumImage(imageUrl: String) {
        saveImageUrl(imageUrl: imageUrl, key: MIDDLEMEDIUMIMAGE)
    }
    
    func saveBottomMediumImage(imageUrl: String) {
        saveImageUrl(imageUrl: imageUrl, key: BOTTOMMEDIUMIMAGE)
    }
    
    func saveTopLargeImage(imageUrl: String) {
        saveImageUrl(imageUrl: imageUrl, key: TOPLARGEIMAGE)
    }
    
    func saveBottomLargeImage(imageUrl: String) {
        saveImageUrl(imageUrl: imageUrl, key: BOTTOMLARGEIMAGE)
    }
    
    func getTopLargeImage() -> String {
        return getImageUrl(key: TOPLARGEIMAGE)
    }
    
    func getBottomLargeImage() -> String {
        return getImageUrl(key: BOTTOMLARGEIMAGE)
    }
    
    func getTopMediumImage() -> String {
        return getImageUrl(key: TOPMEDIUMIMAGE)
    }
    
    func getMiddleMediumImage() -> String {
        return getImageUrl(key: MIDDLEMEDIUMIMAGE)
    }
    
    func getBottomMediumImage() -> String {
        return getImageUrl(key: BOTTOMMEDIUMIMAGE)
    }
    
    func getMediumImage() -> String {
        return getImageUrl(key: MEDIUMIMAGE)
    }
    
    func getLargeImage() -> String {
        return getImageUrl(key: LARGEIMAGE)
    }
    
    func saveLargeImage(imageUrl: String) {
        saveImageUrl(imageUrl: imageUrl, key: LARGEIMAGE)
    }
    
    func saveMediumImage(imageUrl: String) {
        saveImageUrl(imageUrl: imageUrl, key: MEDIUMIMAGE)
    }
    
    func saveImageUrl(imageUrl: String, key: String) {
        if let userDefaults = UserDefaults(suiteName: GROUPNAME) {
            userDefaults.setValue(imageUrl, forKey: key)
        }
    }
    
    private func getImageUrl(key: String) -> String {
        if let userDefaults = UserDefaults(suiteName: GROUPNAME) {
            return userDefaults.string(forKey: key) ?? ""
        }
        return ""
    }
}
