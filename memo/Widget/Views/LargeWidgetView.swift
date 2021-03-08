import Foundation

import SwiftUI
import WidgetKit

let configureDates = [
    "2020/10",
    "2020/11",
    "2020/12",
]

struct WidgetUI {
    
    static let bigCircleSizeScale: CGFloat = 0.178
    static let bigCircleTextSizeScale: CGFloat = 0.084
    static let bigCircleTopPadding: CGFloat = 0.015
    static let bigCircleTextTopPadding: CGFloat = 0.007
    
    static let middleCircleSizeScale: CGFloat = 0.086
    static let middleCircleTextSizeScale: CGFloat = 0.058
    static let middleCircleBottomPadding: CGFloat = 0.007
    static let middleCircleTrailingPadding: CGFloat = 0.0056
    
    static let bmSpacePadingScale: CGFloat = 0.04
    static let bmSpacePadingLeadingScale: CGFloat = 0.034
    
    static let circleSizeScale: CGFloat = 0.08
    
    static let smallTextSizeScale: CGFloat = middleCircleTextSizeScale
    static let dayTextSizeScale: CGFloat = 0.045
    static let emojiTextSizeScale: CGFloat = 0.082
    static let emojiTextPaddingScale: CGFloat = 0.005
    
    static let bigCircleVScale: CGFloat = 0.024
    
    static let circleVScale_7: CGFloat = 0.0344
    static let circleHScale_7: CGFloat = 0.034
    
    static let circleVScale_6: CGFloat = 0.0574
    static let circleHScale_6: CGFloat = 0.034
    
    static let fontName = "Hiragino Sans W7"
}

struct LargeWidgetView: View {

    let calendarGroup: CalendarGroup
    var calendar = Calendar(identifier: .gregorian)
    
    let dayOfW = ["月","火","水","木","金","土","日"]
    let formatter = DateFormatter.month
    let yearFormatter = DateFormatter.year
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                ZStack(alignment: .bottomTrailing) {
                    VStack {
                        Text(memoArray[calendarGroup.memoTextIndex])
                            .font(.system(size: geo.size.height * WidgetUI.bigCircleSizeScale ))
                            //                            .frame(width: geo.size.height * WidgetUI.bigCircleSizeScale , height: geo.size.height * WidgetUI.bigCircleSizeScale, alignment: .center)
                            //                            .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color(calendarGroup.wColor), Color(calendarGroup.wColor)]), startPoint: .top, endPoint: .bottom))
                            .overlay(
                                Text(formatter.string(from: Date()))
                                    .font(.custom(WidgetUI.fontName, size: geo.size.height * WidgetUI.bigCircleTextSizeScale))
                                    .padding(.top, geo.size.height * WidgetUI.bigCircleTextTopPadding)
                                    .foregroundColor(Color.white)
                            )
                        //                            .overlay(
                        //                                Circle()
                        //                                    .stroke(Color("MEMOSTEXTINDEX-\(calendarGroup.memoTextIndex)"), lineWidth: 2)
                        //                            )
                    }
                    .padding(.trailing, geo.size.height * WidgetUI.bmSpacePadingScale)
                    .padding(.top, -geo.size.height * WidgetUI.bigCircleTopPadding)
                    Text(memoArray[calendarGroup.memoTextIndex])
                        .font(.system(size: geo.size.height * WidgetUI.middleCircleSizeScale))
                        //                        .frame(width: geo.size.height * WidgetUI.middleCircleSizeScale , height: geo.size.height * WidgetUI.middleCircleSizeScale, alignment: .center)
                        //                        .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color(calendarGroup.wColor), Color(calendarGroup.wColor)]), startPoint: .top, endPoint: .bottom))
                        //                        .foregroundColor(Color.white)
                        .overlay(
                            Text("月")
                                .font(.custom(WidgetUI.fontName, size: geo.size.height * WidgetUI.middleCircleTextSizeScale))
                                .foregroundColor(Color.white)
                        )
                        .padding(.bottom, geo.size.height * WidgetUI.middleCircleBottomPadding)
                        .padding(.trailing, -geo.size.height * WidgetUI.middleCircleTrailingPadding)
                    //                        .clipShape(Circle())
                    //                        .padding(.vertical, 0)
                    //                        .overlay(
                    //                            Circle()
                    //                                .stroke(Color(calendarGroup.wColor), lineWidth: 1)
                    //                        )
                }
                .padding(.leading, geo.size.height * WidgetUI.bmSpacePadingLeadingScale)
                
                HStack(spacing: formatter.string(from: Date()) == "11" ? geo.size.height * WidgetUI.circleHScale_7 : geo.size.height * WidgetUI.circleHScale_6) {
                    ForEach(dayOfW, id: \.self) { dow in
                        Text("30")
                            .hidden()
                            .frame(width: geo.size.height * WidgetUI.circleSizeScale , height: geo.size.height * WidgetUI.circleSizeScale, alignment: .center)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color.black, Color.black]), startPoint: .top, endPoint: .bottom))
                            .clipShape(Circle())
                            .overlay(
                                Text(dow)
                                    .font(.custom(WidgetUI.fontName, size: geo.size.height * WidgetUI.smallTextSizeScale))
                                    .foregroundColor(Color.white)
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.black, lineWidth: 2.5)
                            )
                    }
                }
                .padding(.bottom, formatter.string(from: Date()) == "11" ? geo.size.height * WidgetUI.circleVScale_7 : geo.size.height * WidgetUI.circleVScale_6)
                .padding(.top, geo.size.height * WidgetUI.bigCircleVScale)
        
                CalendarView(wh: geo.size.height, wColor: calendarGroup.wColor) { date in
                    if configureDates.contains(yearFormatter.string(from: Date())) {
                        if Calendar.current.isDateInToday(date) {
                            Text("30")
                                .frame(width: geo.size.height * WidgetUI.circleSizeScale, height: geo.size.height * WidgetUI.circleSizeScale, alignment: .center)
                                .clipShape(Circle())
                                .overlay(
                                    Text(memoArray[calendarGroup.memoTextIndex])
                                        .font(.system(size: geo.size.height * WidgetUI.emojiTextSizeScale))
                                        .padding(.leading, -geo.size.height * WidgetUI.emojiTextPaddingScale)
                                )
                                .overlay(
                                    Text(String(self.calendar.component(.day, from: date)))
                                        .font(.custom(WidgetUI.fontName, size: geo.size.height * WidgetUI.dayTextSizeScale))
                                        .foregroundColor(Color.white)
                                )
                        } else {
                            Text("30")
                                .hidden()
                                .frame(width: geo.size.height * WidgetUI.circleSizeScale , height: geo.size.height * WidgetUI.circleSizeScale, alignment: .center)
    //                            .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color("DayColor"), Color("DayColor")]), startPoint: .top, endPoint: .bottom))
                                .background(Color.white)
                                .clipShape(Circle())
                                .overlay(
                                    Text(String(self.calendar.component(.day, from: date)))
                                        .font(.custom(WidgetUI.fontName, size: geo.size.height * WidgetUI.dayTextSizeScale))
                                        .foregroundColor(Color.black)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 1)
                                )
                        }
                    }
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )
            }
            .padding(.trailing, 1)
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
//            .background(Color.blue)
            
        }
        
    }
}

struct MonthView<DateView>: View where DateView: View {
    var calendar = Calendar(identifier: .gregorian)
    var wh: CGFloat = 0
    let wColor: String

    let content: (Date) -> DateView
    let formatter = DateFormatter.month

    init(wh: CGFloat, wColor: String, @ViewBuilder content: @escaping (Date) -> DateView) {
        self.calendar.firstWeekday = 2
        self.content = content
        self.wh = wh
        self.wColor = wColor
    }

    private var weeks: [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: Date())
            else { return [] }
        return calendar.generateDates(
            inside: monthInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: calendar.firstWeekday)
        )
    }

    var body: some View {
        VStack(spacing: formatter.string(from: Date()) == "11" ? wh * WidgetUI.circleVScale_7 : wh * WidgetUI.circleVScale_6) {
            ForEach(weeks, id: \.self) { week in
                WeekView(wh: self.wh, week: week, content: self.content)
            }
            Spacer()
        }
//        .background(Color.red)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
    }
}

struct CalendarView<DateView>: View where DateView: View {
    let content: (Date) -> DateView
    var wh: CGFloat = 0
    let wColor: String

    init(wh: CGFloat, wColor: String, @ViewBuilder content: @escaping (Date) -> DateView) {
        self.content = content
        self.wh = wh
        self.wColor = wColor
    }

    var body: some View {
        VStack() {
            MonthView(wh: self.wh, wColor: wColor, content: self.content)
//                .background(Color.yellow)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
    }
}

struct WeekView<DateView>: View where DateView: View {
    var calendar = Calendar(identifier: .gregorian)

    let week: Date
    let content: (Date) -> DateView
    var wh: CGFloat = 0

    let formatter = DateFormatter.month

    init(wh: CGFloat, week: Date, @ViewBuilder content: @escaping (Date) -> DateView) {
        self.week = week
        self.content = content
        self.calendar.firstWeekday = 2
        self.wh = wh
    }

    private var days: [Date] {
        guard
            let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week)
            else { return [] }
        return calendar.generateDates(
            inside: weekInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }

    var body: some View {
        HStack(spacing: formatter.string(from: Date()) == "11" ? wh * WidgetUI.circleHScale_7 : wh * WidgetUI.circleHScale_6) {
            ForEach(days, id: \.self) { date in
                HStack {
                    if self.calendar.isDate(self.week, equalTo: date, toGranularity: .month) {
                        self.content(date)
                    } else {
                        self.content(date).hidden()
                    }
                }
            }
        }
    }
}

fileprivate extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)

        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }

        return dates
    }
}

fileprivate extension DateFormatter {
    static var month: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        return formatter
    }
    
    static var year: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM"
        return formatter
    }
}
