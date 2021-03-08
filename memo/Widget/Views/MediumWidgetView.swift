import Foundation

import SwiftUI
import WidgetKit

struct MediumWidgetView: View {
    
    let calendarGroup: CalendarGroup
    var sPadding: CGFloat = 9
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .center, spacing: 0) {
                        Text("⚪ 今日のメモ ⚪")
                            .font(.custom(WidgetUI.fontName, size: geo.size.height / 7.5))
                            .foregroundColor(.white)
                    }
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: geo.size.height / 4.5
                    )
//                    .background(Color.red)
                    
                    GeometryReader { geometry in
                        HStack(alignment: .top, spacing: 0) {
                            Text(calendarGroup.content)
                                .font(.custom(WidgetUI.fontName, size: geo.size.height / 9.4))
                                .lineSpacing(geo.size.height / 7.3 - geo.size.height / 9.4)
                                .foregroundColor(.white)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                            if calendarGroup.circleBackground == nil {
                                Circle()
                                    .cornerRadius((geometry.size.height - geo.size.height / sPadding) / 2)
                                    .foregroundColor(.white)
                                    .frame(
                                        width: geometry.size.height - geo.size.height / sPadding,
                                        height: geometry.size.height - geo.size.height / sPadding
                                    )
                            } else {
                                calendarGroup.circleBackground?.resizable().scaledToFill().clipped()
                                    .cornerRadius((geometry.size.height - geo.size.height / sPadding) / 2)
                                    .foregroundColor(.white)
                                    .frame(
                                        width: geometry.size.height - geo.size.height / sPadding,
                                        height: geometry.size.height - geo.size.height / sPadding
                                    )
                            }
                        }
//                        .background(Color.black)
                        .padding(.trailing, geo.size.height / sPadding)
                        .padding(.leading, geo.size.height / sPadding / 2)
                    }
                    
                }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
//            .background(Color.yellow)
        }
    }
}
