//
//  mwidget.swift
//  mwidget
//
//  Created by love family on 23.10.2020.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), calendarGroup: CalendarGroup(content: "", wColor: WCOLOR1, memoTextIndex: 0, largeBackground: nil, mediumBackground: nil, circleBackground: nil))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), calendarGroup: CalendarGroup(content: "", wColor: WCOLOR1, memoTextIndex: 0, largeBackground: nil, mediumBackground: nil, circleBackground: nil))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
//        let dispatchGroup = DispatchGroup()
//        dispatchGroup.enter()
        let mediumBackGroundImage: UIImage? = loadImageFromDiskWith(fileName: MEDIUMIMAGE)
        
//        let mediumImage = UserDefaultManager.share.getMediumImage()
        
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
        
        let wColor = UserDefaultManager.share.getWColor()
        
//        dispatchGroup.notify(queue: DispatchQueue.main) {
            
            var mediumImage: Image? = nil
            if let mediumBackGroundImage = mediumBackGroundImage {
                mediumImage = Image(uiImage: mediumBackGroundImage)
            }

            let date = Calendar.current.date(byAdding: .second, value: 5, to: Date())!
        let entry = SimpleEntry(date: date, calendarGroup: CalendarGroup(content: "", wColor: wColor, memoTextIndex: 0, largeBackground: nil, mediumBackground: mediumImage, circleBackground: nil))

            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
//        }
        
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let calendarGroup: CalendarGroup
}

struct mwidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
            }
            Spacer()
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .background(entry.calendarGroup.mediumBackground?.resizable().scaledToFill().clipped())
    }
}

@main
struct mwidget: Widget {
    let kind: String = "mwidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            mwidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Kind 2")
        .supportedFamilies([.systemMedium])
    }
}
