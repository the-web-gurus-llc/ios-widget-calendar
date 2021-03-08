import WidgetKit
import SwiftUI

//struct Provider: IntentTimelineProvider {
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), calendarGroup: CalendarGroup(content: "", wColor: WCOLOR1, memoTextIndex: 0, largeBackground: nil, mediumBackground: nil, circleBackground: nil))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), calendarGroup: CalendarGroup(content: "", wColor: WCOLOR1, memoTextIndex: 0, largeBackground: nil, mediumBackground: nil, circleBackground: nil))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let content = UserDefaultManager.share.getMemo(date: Date())
//        var content = UserDefaultManager.share.getMemo(date: Date())
//        let dot = "・"
//        if content != "" {
//            content = " \(dot)\(content)"
//        }
//        content = content.replacingOccurrences(of: "\n", with: "\n \(dot)")
        let wColor = UserDefaultManager.share.getWColor()
        let memoTextIndex = UserDefaultManager.share.getMemoTextIndex()
        
//        let dispatchGroup = DispatchGroup()
//        dispatchGroup.enter()
//        dispatchGroup.enter()
//
//        var largeBackGroundImage: UIImage?
//        var mediumBackGroundImage: UIImage?
//
//        let mediumImage = UserDefaultManager.share.getMediumImage()
//        let largeImage = UserDefaultManager.share.getLargeImage()
//
//        if largeImage != "" {
//            URLSession.shared.dataTask(with: URL(string: largeImage)!) { data, _, _ in
//                if let data = data {
//                    largeBackGroundImage = UIImage(data: data)
//                }
//                dispatchGroup.leave()
//            }.resume()
//        } else {
//            dispatchGroup.leave()
//        }
//
//
//        if mediumImage != "" {
//            URLSession.shared.dataTask(with: URL(string: mediumImage)!) { data, _, _ in
//                if let data = data {
//                    mediumBackGroundImage = UIImage(data: data)
//                }
//
//                dispatchGroup.leave()
//            }.resume()
//        } else {
//            dispatchGroup.leave()
//        }
        
//        let dispatchGroup = DispatchGroup()
//        dispatchGroup.enter()
        
        let largeBackGroundImage: UIImage? = loadImageFromDiskWith(fileName: LARGEIMAGE)
        let mediumBackGroundImage: UIImage? = loadImageFromDiskWith(fileName: MEDIUMIMAGE)
        let circleBackGroundImage: UIImage? = loadImageFromDiskWith(fileName: CIRCLEIMAGE)
        
//        dispatchGroup.notify(queue: DispatchQueue.main) {
        var largeImage: Image? = nil
        if let largeBackGroundImage = largeBackGroundImage {
            largeImage = Image(uiImage: largeBackGroundImage)
        }
        
        var mediumImage: Image? = nil
        if let mediumBackGroundImage = mediumBackGroundImage {
            mediumImage = Image(uiImage: mediumBackGroundImage)
        }
        
        var circleImage: Image? = nil
        if let circleBackGroundImage = circleBackGroundImage {
            circleImage = Image(uiImage: circleBackGroundImage)
        }
        
        let date = Calendar.current.date(byAdding: .second, value: 5, to: Date())!
        let entry = SimpleEntry(date: date, calendarGroup: CalendarGroup(content: content, wColor: wColor, memoTextIndex: memoTextIndex, largeBackground: largeImage, mediumBackground: mediumImage, circleBackground: circleImage))
        
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
//        }
        
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let calendarGroup: CalendarGroup
}

struct cwidgetEntryView : View {
    @Environment(\.widgetFamily) private var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        Group {
            switch widgetFamily {
            case .systemSmall:
                SmallWidgetView(calendarGroup: entry.calendarGroup)

            case .systemMedium:
//                if entry.calendarGroup.mediumBackground != nil {
//                    MediumWidgetView(calendarGroup: entry.calendarGroup)
//                        .background(entry.calendarGroup.mediumBackground?.resizable().scaledToFill().clipped())
//                } else {
//                    MediumWidgetView(calendarGroup: entry.calendarGroup)
//                        .background(Color(entry.calendarGroup.wColor))
//                }
                MediumWidgetView(calendarGroup: entry.calendarGroup)
                    .background(Color("MEMOSTEXTINDEX-\(entry.calendarGroup.memoTextIndex)"))

            case .systemLarge:
//                if entry.calendarGroup.largeBackground != nil {
//                    LargeWidgetView(calendarGroup: entry.calendarGroup)
//                        .background(entry.calendarGroup.largeBackground?.resizable().scaledToFill().clipped())
//                } else {
//                    LargeWidgetView(calendarGroup: entry.calendarGroup)
//                        .background(Color(entry.calendarGroup.wColor))
//                }
                LargeWidgetView(calendarGroup: entry.calendarGroup)
                    .background(entry.calendarGroup.largeBackground?.resizable().scaledToFill().clipped())
            @unknown default:
                fatalError()
            }
        }
    }
}

@main
struct cwidget: Widget {
    let kind: String = "cwidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
//        IntentConfiguration(
//          kind: kind,
//          intent: SelectWidgetIntent.self,
//          provider: Provider()
//        ) { entry in
            cwidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Kind 1")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}
