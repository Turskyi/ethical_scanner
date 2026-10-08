import WidgetKit
import SwiftUI

enum Season {
    case winter, spring, summer, autumn

    static func current(for date: Date = Date()) -> Season {
        let month = Calendar.current.component(.month, from: date)
        switch month {
        case 12, 1, 2:
            return .winter
        case 3, 4, 5:
            return .spring
        case 6, 7, 8:
            return .summer
        case 9, 10, 11:
            return .autumn
        default:
            return .autumn
        }
    }

    var emoji: String {
        switch self {
        case .winter: return "❄️"
        case .spring: return "🌸"
        case .summer: return "🦋"
        case .autumn: return "🍁"
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let season: Season
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), season: Season.current())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), season: Season.current())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let currentDate = Date()
        let currentSeason = Season.current(for: currentDate)
        let entry = SimpleEntry(date: currentDate, season: currentSeason)

        let calendar = Calendar.current
        var entries: [SimpleEntry] = [entry]

        for dayOffset in 1...30 {
            if let futureDate = calendar.date(byAdding: .day, value: dayOffset, to: currentDate) {
                let futureSeason = Season.current(for: futureDate)
                if futureSeason != currentSeason {
                    let transitionEntry = SimpleEntry(date: calendar.startOfDay(for: futureDate), season: futureSeason)
                    entries.append(transitionEntry)
                    break
                }
            }
        }

        let nextUpdate = calendar.date(byAdding: .hour, value: 12, to: currentDate) ?? currentDate.addingTimeInterval(43200)
        let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct EthicalScannerWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    private var sunriseGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 1.0, green: 0.8, blue: 0.502),
                Color(red: 0.957, green: 0.561, blue: 0.694)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var cetaceanBlue: Color {
        Color(red: 0.0, green: 0.047, blue: 0.251)
    }

    var body: some View {
        ZStack {
            sunriseGradient

            seasonalDecoration

            if family == .systemMedium {
                mediumLayout
            } else {
                smallLayout
            }
        }
        .widgetContainerBackground(sunriseGradient)
        .accessibilityLabel("Scan a product")
    }

    private var seasonalDecoration: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            Group {
                Text(entry.season.emoji)
                    .font(.system(size: w * 0.18))
                    .opacity(0.8)
                    .position(x: w * 0.82, y: h * 0.2)
                    .rotationEffect(.degrees(12))

                Text(entry.season.emoji)
                    .font(.system(size: w * 0.14))
                    .opacity(0.6)
                    .position(x: w * 0.18, y: h * 0.8)
                    .rotationEffect(.degrees(-18))
            }
        }
    }

    private var smallLayout: some View {
        VStack(spacing: 8) {
            Spacer()

            Image(systemName: "barcode.viewfinder")
                .font(.system(size: 42, weight: .bold))
                .foregroundColor(cetaceanBlue)

            Text("Scan")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(cetaceanBlue)

            Spacer()
        }
        .padding()
    }

    private var mediumLayout: some View {
        HStack(spacing: 20) {
            Image(systemName: "barcode.viewfinder")
                .font(.system(size: 52, weight: .bold))
                .foregroundColor(cetaceanBlue)

            VStack(alignment: .leading, spacing: 4) {
                Text("Ethical Scanner")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(cetaceanBlue)

                Text("Know what you support")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(cetaceanBlue.opacity(0.85))
            }
        }
        .padding()
    }
}

extension View {
    @ViewBuilder
    func widgetContainerBackground<Background: View>(_ backgroundView: Background) -> some View {
        if #available(iOS 17.0, macOS 14.0, *) {
            self.containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            self.background(backgroundView)
        }
    }
}

struct EthicalScannerWidget: Widget {
    let kind: String = "EthicalScannerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            EthicalScannerWidgetEntryView(entry: entry)
                .widgetURL(URL(string: "ethicalscanner://scan"))
        }
        .configurationDisplayName("Ethical Scanner")
        .description("Tap to scan a product.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}