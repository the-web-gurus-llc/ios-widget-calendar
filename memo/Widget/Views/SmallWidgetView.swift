import Foundation

import SwiftUI
import WidgetKit

struct SmallWidgetView: View {

    let calendarGroup: CalendarGroup
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
//                Text(calendarGroup.content)
//                    .font(.system(size: 24))
//                    .foregroundColor(.white)
//                    .padding(.all)
                Spacer()
            }
            Spacer()
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .background(LinearGradient(gradient: Gradient(colors: [Color("BackGround1"), Color("BackGround2")]), startPoint: .top, endPoint: .bottom))
//        .background(calendarGroup.background?.resizable()
//                        .scaledToFill()
//                        .clipped())
    }
}
