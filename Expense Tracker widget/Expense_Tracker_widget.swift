//
//  Expense_Tracker_widget.swift
//  Expense Tracker widget
//
//  Created by Nisal Padukka on 2022-08-09.
//

import WidgetKit
import SwiftUI
import Intents


struct Provider: IntentTimelineProvider {
    
    

    let defaults = UserDefaults.standard

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), text:"", configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), text:"", configuration: configuration)
        var dbHandler = DBHandler()
        dbHandler.open()
        dbHandler.createTable()
        UserDefaults(suiteName:"group.ca.georgian.nisalpadukka.Expense-Tracker")?.set(String(dbHandler.getTotal(type: "Income")), forKey: "income")
        UserDefaults(suiteName:"group.ca.georgian.nisalpadukka.Expense-Tracker")?.set(String(dbHandler.getTotal(type: "Expense")), forKey: "expense")
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
 
            var value1:String = ""
            if let userDefaults = UserDefaults(suiteName: "group.ca.georgian.nisalpadukka.Expense-Tracker") {
                value1 = userDefaults.string(forKey: "income") ?? "0.0"
            }
            let entry = SimpleEntry(date: entryDate, text:"$ " +  value1 , configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let text: String
    let configuration: ConfigurationIntent
}

struct Expense_Tracker_widgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text("Expense Tracker")
        Text("Income : " + entry.text)
        Text("Expense : " + entry.text)
    }
}

@main
struct Expense_Tracker_widget: Widget {
    let kind: String = "Expense_Tracker_widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            Expense_Tracker_widgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct Expense_Tracker_widget_Previews: PreviewProvider {
    static var previews: some View {
        Expense_Tracker_widgetEntryView(entry: SimpleEntry(date: Date(), text:"", configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
