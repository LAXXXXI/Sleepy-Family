import SwiftUI
import UIKit

struct ContentView: View {
    @State private var selectedDayIndex = 0
    @State private var wakeUpTarget: WakeUpRequest?
    @State private var showAddSheet = false

    private let days = DaySampleData.demo
    private let leaderboard = LeaderboardSample.demo
    private let group = GroupSample.demo
    private let alarms = AlarmSample.demo
    private let wakeUp = WakeUpSample.demo

    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()

            ClockSectionView(
                members: group.members
            )
            .padding(.top, 100)
            .allowsHitTesting(false)

            ScrollView {
                VStack(spacing: 24) {
                    HeaderView()

                    GroupHeaderView(group: group)

                    Color.clear
                        .frame(height: 300)

                    WakeUpSectionView(request: wakeUp) { request in
                        wakeUpTarget = request
                    }

                    AlarmSettingsSectionView(alarms: alarms)

                    LeaderboardSectionView(sections: leaderboard)

                    DateSelectorView(
                        days: days,
                        selectedIndex: $selectedDayIndex
                    )
                    .padding(.bottom, 16)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
            }
            .refreshable {
                // Placeholder for pull-to-refresh animation
                try? await Task.sleep(nanoseconds: 250_000_000)
            }

            FloatingActionButton {
                showAddSheet = true
            }
        }
        .alert(item: $wakeUpTarget) { request in
            Alert(
                title: Text("已送出提醒"),
                message: Text("已通知 \(request.member.name) 起床"),
                dismissButton: .default(Text("OK"))
            )
        }
        .sheet(isPresented: $showAddSheet) {
            AddEventSheet()
        }
    }
}

private struct BackgroundView: View {
    var body: some View {
        ZStack {
            Color(hex: 0xF7F7F7)
            DotPattern()
                .opacity(0.12)
        }
    }
}

private struct HeaderView: View {
    private let today = Date()

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Your morning")
                    .font(AppFont.display(34, weight: .semibold))
                    .foregroundStyle(Color.black)

                HStack(spacing: 10) {
                    DayBadge(date: today)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(today.formatted(.dateTime.weekday(.wide)))
                            .font(AppFont.text(15, weight: .semibold))
                            .foregroundStyle(Color(hex: 0x8E8E93))

                        HStack(spacing: 6) {
                            Image(systemName: "sun.max.fill")
                                .font(AppFont.text(14, weight: .semibold))
                                .foregroundStyle(Color(hex: 0x8E8E93))

                            Text(today.formatted(.dateTime.month().day()))
                                .font(AppFont.text(14, weight: .medium))
                                .foregroundStyle(Color(hex: 0x8E8E93))
                        }
                    }
                }
            }

            Spacer()

            Text("SLEEP")
                .font(AppFont.text(10, weight: .bold))
                .foregroundStyle(Color(hex: 0x8E8E93))
                .strikethrough()
        }
    }
}

private struct DayBadge: View {
    let date: Date

    var body: some View {
        VStack(spacing: 4) {
            Text(date.formatted(.dateTime.day()))
                .font(AppFont.display(22, weight: .bold))
                .foregroundStyle(Color.black)

            Text(date.formatted(.dateTime.weekday(.abbreviated)).uppercased())
                .font(AppFont.text(10, weight: .bold))
                .foregroundStyle(Color(hex: 0x8E8E93))
        }
        .frame(width: 52, height: 60)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
    }
}

private struct GroupHeaderView: View {
    let group: GroupInfo

    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 2) {
                Text(group.name)
                    .font(AppFont.text(14, weight: .semibold))
                    .foregroundStyle(Color.black)

                Text("\(group.awakeCount) awake · \(group.members.count) people")
                    .font(AppFont.text(11, weight: .medium))
                    .foregroundStyle(Color(hex: 0x8E8E93))
            }

            Spacer()

            HStack(spacing: 6) {
                Image(systemName: "person.3.fill")
                    .font(AppFont.text(12, weight: .semibold))
                    .foregroundStyle(Color(hex: 0xFF8A3D))
                Text("\(group.members.count)")
                    .font(AppFont.text(12, weight: .bold))
                    .foregroundStyle(Color(hex: 0xFF8A3D))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
            )
        }
        .padding(.horizontal, 4)
    }
}

private struct ClockSectionView: View {
    let members: [GroupMember]

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let clockSize = width * 1.5
            let containerHeight: CGFloat = 320

            TimelineView(.animation) { context in
                ZStack {
                    ClockFaceView(date: context.date)
                    UserStatusRingView(members: members, date: context.date)
                    ClockHandsView(date: context.date)
                }
                .frame(width: clockSize, height: clockSize)
                .offset(x: width * 0.28, y: -clockSize * 0.14)
            }
            .frame(width: width, height: containerHeight, alignment: .topLeading)
        }
        .frame(height: 320)
    }
}

private struct ClockFaceView: View {
    let date: Date

    var body: some View {
        let arcStart = Angle.degrees(-210)
        let arcEnd = Angle.degrees(30)
        let arcSpan = arcSpanDegrees(start: arcStart, end: arcEnd)

        ZStack {
            ArcMask(startAngle: arcStart, endAngle: arcEnd, innerRadiusFraction: 0.55)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)

            ArcRing(startAngle: arcStart, endAngle: arcEnd)
                .stroke(Color(hex: 0xE6E6E6), style: StrokeStyle(lineWidth: 34, lineCap: .round))
                .padding(26)

            TickMarksView()
                .padding(34)
                .mask(
                    ArcMask(startAngle: arcStart, endAngle: arcEnd, innerRadiusFraction: 0.62)
                )

            Circle()
                .fill(Color.white)
                .scaleEffect(0.58)
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)

            ProgressArcView(date: date, startAngle: arcStart, spanDegrees: arcSpan)
                .padding(12)
        }
    }

    private func arcSpanDegrees(start: Angle, end: Angle) -> Double {
        let span = end.degrees - start.degrees
        return span >= 0 ? span : span + 360
    }
}

private struct UserStatusRingView: View {
    let members: [GroupMember]
    let date: Date

    var body: some View {
        GeometryReader { proxy in
            let size = min(proxy.size.width, proxy.size.height)
            let center = CGPoint(x: size / 2, y: size / 2)
            let radius = size / 2 - 16
            let angle = timeAngle(for: date)
            let basePoint = pointOnCircle(center: center, radius: radius, angle: angle)
            let offsetStep: CGFloat = 16
            let tangentAngle = Angle.degrees(angle.degrees + 90)

            ZStack {
                ForEach(Array(members.enumerated()), id: \.element.id) { index, member in
                    let offset = CGFloat(index) * offsetStep
                    let badgePoint = pointOnCircle(center: basePoint, radius: offset, angle: tangentAngle)

                    UserStatusBadge(member: member)
                        .position(badgePoint)
                }
            }
        }
    }

    private func pointOnCircle(center: CGPoint, radius: CGFloat, angle: Angle) -> CGPoint {
        let radians = CGFloat(angle.radians)
        return CGPoint(
            x: center.x + cos(radians) * radius,
            y: center.y + sin(radians) * radius
        )
    }

    private func timeAngle(for date: Date) -> Angle {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = Double(components.hour ?? 0) + Double(components.minute ?? 0) / 60.0
        return Angle.degrees((hour / 12.0) * 360 - 90)
    }
}

private struct UserStatusBadge: View {
    let member: GroupMember

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(member.isAwake ? Color(hex: 0xFF8A3D) : Color(hex: 0xD8D8D8))
                .frame(width: 12, height: 12)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 1)
                )

            Text(member.initials)
                .font(AppFont.text(11, weight: .bold))
                .foregroundStyle(member.isAwake ? Color.black : Color(hex: 0x8E8E93))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
    }
}

private struct TickMarksView: View {
    var body: some View {
        GeometryReader { proxy in
            let size = min(proxy.size.width, proxy.size.height)
            ZStack {
                ForEach(0..<12) { index in
                    Rectangle()
                        .fill(Color(hex: 0xBDBDBD))
                        .frame(width: 2, height: 10)
                        .offset(y: -size / 2 + 10)
                        .rotationEffect(.degrees(Double(index) * 30))
                }
            }
            .frame(width: size, height: size)
        }
    }
}

private struct ArcRing: Shape {
    let startAngle: Angle
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        var path = Path()
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        return path
    }
}

private struct ArcMask: Shape {
    let startAngle: Angle
    let endAngle: Angle
    let innerRadiusFraction: CGFloat

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let innerRadius = radius * innerRadiusFraction

        var path = Path()
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.addArc(center: center, radius: innerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: true)
        path.closeSubpath()
        return path
    }
}

private struct ProgressArcView: View {
    let date: Date
    let startAngle: Angle
    let spanDegrees: Double

    var body: some View {
        GeometryReader { proxy in
            let size = min(proxy.size.width, proxy.size.height)
            let center = CGPoint(x: size / 2, y: size / 2)
            let radius = size / 2 - 6
            let endAngle = progressAngle(for: date)

            Path { path in
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false
                )
            }
            .stroke(Color(hex: 0xFF8A3D), style: StrokeStyle(lineWidth: 6, lineCap: .round))
        }
    }

    private func progressAngle(for date: Date) -> Angle {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = Double(components.hour ?? 0) + Double(components.minute ?? 0) / 60.0
        let progress = (hour.truncatingRemainder(dividingBy: 12)) / 12.0
        return Angle.degrees(startAngle.degrees + spanDegrees * progress)
    }
}

private struct ClockHandsView: View {
    let date: Date

    var body: some View {
        GeometryReader { proxy in
            let size = min(proxy.size.width, proxy.size.height)
            let center = CGPoint(x: size / 2, y: size / 2)
            let components = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
            let hour = Double(components.hour ?? 0) + Double(components.minute ?? 0) / 60.0
            let minute = Double(components.minute ?? 0) + Double(components.second ?? 0) / 60.0
            let second = Double(components.second ?? 0)

            let hourAngle = Angle.degrees((hour / 12.0) * 360 - 90)
            let minuteAngle = Angle.degrees((minute / 60.0) * 360 - 90)
            let secondAngle = Angle.degrees((second / 60.0) * 360 - 90)

            ZStack {
                HandView(length: size * 0.32, width: 5, color: Color.black)
                    .rotationEffect(hourAngle)

                HandView(length: size * 0.44, width: 3, color: Color.black)
                    .rotationEffect(minuteAngle)

                HandView(length: size * 0.5, width: 2, color: Color(hex: 0xFF8A3D))
                    .rotationEffect(secondAngle)

                Circle()
                    .fill(Color(hex: 0xFF8A3D))
                    .frame(width: 12, height: 12)

                DigitalTimeLabel(date: date)
                    .position(pointOnCircle(center: center, radius: size * 0.38, angle: minuteAngle))
            }
            .frame(width: size, height: size)
        }
    }

    private func pointOnCircle(center: CGPoint, radius: CGFloat, angle: Angle) -> CGPoint {
        let radians = CGFloat(angle.radians)
        return CGPoint(
            x: center.x + cos(radians) * radius,
            y: center.y + sin(radians) * radius
        )
    }
}

private struct HandView: View {
    let length: CGFloat
    let width: CGFloat
    let color: Color

    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: width, height: length)
            .cornerRadius(width / 2)
            .offset(y: -length / 2)
            .shadow(color: color.opacity(0.16), radius: 3, x: 0, y: 2)
    }
}

private struct DigitalTimeLabel: View {
    let date: Date

    var body: some View {
        Text(date.formatted(.dateTime.hour().minute()))
            .font(AppFont.text(12, weight: .semibold))
            .foregroundStyle(Color(hex: 0xFF8A3D))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 3)
            )
    }
}

 

private struct LeaderboardSectionView: View {
    let sections: [RankingSection]

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("排行榜")
                .font(AppFont.display(20, weight: .semibold))
                .foregroundStyle(Color.black)

            ForEach(sections) { section in
                RankingSectionCard(section: section)
            }
        }
        .padding(.horizontal, 4)
    }
}

private struct RankingSectionCard: View {
    let section: RankingSection

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("\(section.title)：\(section.winner)")
                    .font(AppFont.text(15, weight: .semibold))
                    .foregroundStyle(Color.black)

                Spacer()
                Text(section.unitLabel)
                    .font(AppFont.text(11, weight: .medium))
                    .foregroundStyle(Color(hex: 0x8E8E93))
            }

            ForEach(section.rows) { row in
                HStack {
                    Text(row.name)
                        .font(AppFont.text(13, weight: .medium))
                        .foregroundStyle(Color.black)

                    Spacer()

                    Text(row.value)
                        .font(AppFont.text(13, weight: .semibold))
                        .foregroundStyle(row.isWinner ? Color(hex: 0xFF8A3D) : Color(hex: 0x8E8E93))
                }
                .padding(.vertical, 4)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
    }
}

private struct AlarmSettingsSectionView: View {
    let alarms: [AlarmEntry]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Alarm Settings")
                .font(AppFont.display(20, weight: .semibold))
                .foregroundStyle(Color.black)

            ForEach(alarms) { alarm in
                AlarmCard(alarm: alarm)
            }
        }
        .padding(.horizontal, 4)
    }
}

private struct AlarmCard: View {
    let alarm: AlarmEntry

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(alarm.time)
                    .font(AppFont.display(22, weight: .bold))
                    .foregroundStyle(Color.black)

                Text(alarm.label)
                    .font(AppFont.text(12, weight: .medium))
                    .foregroundStyle(Color(hex: 0x8E8E93))
            }

            Spacer()

            Toggle("", isOn: .constant(alarm.isOn))
                .labelsHidden()
                .tint(Color(hex: 0xFF8A3D))
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
    }
}

private struct WakeUpSectionView: View {
    let request: WakeUpRequest?
    let onNotify: (WakeUpRequest) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Please wake me up")
                .font(AppFont.display(22, weight: .semibold))
                .foregroundStyle(Color.white)

            if let request {
                WakeUpCard(request: request, onNotify: onNotify)
            } else {
                Text("Everyone is on time.")
                    .font(AppFont.text(13, weight: .medium))
                    .foregroundStyle(Color.white.opacity(0.9))
            }
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color(hex: 0xFF6B4A))
                .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 8)
        )
        .padding(.horizontal, 4)
    }
}

private struct WakeUpCard: View {
    let request: WakeUpRequest
    let onNotify: (WakeUpRequest) -> Void

    var body: some View {
        HStack(spacing: 14) {
            Circle()
                .fill(Color.white.opacity(0.18))
                .frame(width: 52, height: 52)
                .overlay(
                    Text(request.member.initials)
                        .font(AppFont.text(16, weight: .bold))
                        .foregroundStyle(Color.white)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text("\(request.member.name) · \(request.targetTime)")
                    .font(AppFont.text(15, weight: .semibold))
                    .foregroundStyle(Color.white)

                Text("\(request.minutesLate) min late")
                    .font(AppFont.text(12, weight: .medium))
                    .foregroundStyle(Color.white.opacity(0.85))
            }

            Spacer()

            Button {
                onNotify(request)
            } label: {
                Text("Wake")
                    .font(AppFont.text(12, weight: .bold))
                    .foregroundStyle(Color(hex: 0xFF6B4A))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 9)
                    .background(
                        Capsule()
                            .fill(Color.white)
                    )
            }
        }
    }
}

private struct DateSelectorView: View {
    let days: [DayEntry]
    @Binding var selectedIndex: Int

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(days.indices, id: \.self) { index in
                    let day = days[index]
                    DayCircle(
                        day: day,
                        isSelected: selectedIndex == index
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            selectedIndex = index
                        }
                    }
                }
            }
            .padding(.horizontal, 6)
        }
    }
}

private struct DayCircle: View {
    let day: DayEntry
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 4) {
            Text(day.label)
                .font(AppFont.text(10, weight: .semibold))
                .foregroundStyle(isSelected ? Color.white : Color(hex: 0x8E8E93))

            Text(day.day)
                .font(AppFont.display(16, weight: .bold))
                .foregroundStyle(isSelected ? Color.white : Color.black)
        }
        .frame(width: 56, height: 56)
        .background(
            Circle()
                .fill(isSelected ? Color.black : Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 4)
        )
        .overlay(
            Circle()
                .stroke(
                    Color(hex: 0xC7C7CC).opacity(day.progress),
                    lineWidth: 3
                )
                .padding(4)
        )
    }
}

private struct FloatingActionButton: View {
    let action: () -> Void

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: action) {
                    Image(systemName: "calendar.badge.plus")
                        .font(AppFont.text(18, weight: .semibold))
                        .foregroundStyle(Color.white)
                        .frame(width: 56, height: 56)
                        .background(
                            Circle()
                                .fill(Color(hex: 0xFF8A3D))
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 6)
                        )
                }
                .padding(.trailing, 22)
                .padding(.bottom, 26)
            }
        }
    }
}

private struct AddEventSheet: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Add Event")
                .font(AppFont.display(20, weight: .semibold))

            Text("Prototype only.")
                .font(AppFont.text(14))
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding()
        .presentationDetents([.medium])
    }
}

// MARK: - Sample Data

private struct RankingSection: Identifiable {
    let id = UUID()
    let title: String
    let winner: String
    let unitLabel: String
    let rows: [RankingRow]
}

private struct RankingRow: Identifiable {
    let id = UUID()
    let name: String
    let value: String
    let isWinner: Bool
}

private struct DayEntry {
    let label: String
    let day: String
    let progress: Double
}

private struct GroupInfo {
    let name: String
    let members: [GroupMember]
    let awakeCount: Int
}

private struct GroupMember: Identifiable {
    let id = UUID()
    let name: String
    let initials: String
    let isAwake: Bool
}

private struct AlarmEntry: Identifiable {
    let id = UUID()
    let time: String
    let label: String
    let isOn: Bool
}

private struct WakeUpRequest: Identifiable {
    let id = UUID()
    let member: GroupMember
    let targetTime: String
    let minutesLate: Int
}

private enum LeaderboardSample {
    static let demo: [RankingSection] = [
        RankingSection(
            title: "賴床王",
            winner: "阿哲",
            unitLabel: "次數",
            rows: [
                RankingRow(name: "阿哲", value: "8 次", isWinner: true),
                RankingRow(name: "小葵", value: "4 次", isWinner: false),
                RankingRow(name: "阿凱", value: "2 次", isWinner: false),
                RankingRow(name: "Yara", value: "1 次", isWinner: false)
            ]
        ),
        RankingSection(
            title: "睡最久",
            winner: "小葵",
            unitLabel: "睡眠",
            rows: [
                RankingRow(name: "小葵", value: "9 小時", isWinner: true),
                RankingRow(name: "阿凱", value: "6 小時", isWinner: false),
                RankingRow(name: "阿哲", value: "5 小時", isWinner: false),
                RankingRow(name: "Yara", value: "4 小時", isWinner: false)
            ]
        ),
        RankingSection(
            title: "最晚睡",
            winner: "阿凱",
            unitLabel: "時間",
            rows: [
                RankingRow(name: "阿凱", value: "02:18", isWinner: true),
                RankingRow(name: "阿哲", value: "01:50", isWinner: false),
                RankingRow(name: "小葵", value: "01:20", isWinner: false),
                RankingRow(name: "Yara", value: "00:58", isWinner: false)
            ]
        )
    ]
}

private enum GroupSample {
    static let demo = GroupInfo(
        name: "懶蟲一家",
        members: [
            GroupMember(name: "Yara", initials: "YA", isAwake: true),
            GroupMember(name: "Lax", initials: "LX", isAwake: false),
            GroupMember(name: "Kris", initials: "KC", isAwake: true),
            GroupMember(name: "Abe", initials: "AB", isAwake: false)
        ],
        awakeCount: 2
    )
}

private enum WakeUpSample {
    static let demo = WakeUpRequest(
        member: GroupSample.demo.members[1],
        targetTime: "08:00",
        minutesLate: 40
    )
}

private enum AlarmSample {
    static let demo: [AlarmEntry] = [
        AlarmEntry(time: "07:00", label: "Weekdays · Group alarm", isOn: true),
        AlarmEntry(time: "08:30", label: "Weekend · Chill mode", isOn: false)
    ]
}

private enum DaySampleData {
    static let demo: [DayEntry] = [
        DayEntry(label: "MON", day: "18", progress: 0.9),
        DayEntry(label: "TUE", day: "19", progress: 0.6),
        DayEntry(label: "WED", day: "20", progress: 0.4),
        DayEntry(label: "THU", day: "21", progress: 0.7),
        DayEntry(label: "FRI", day: "22", progress: 0.3)
    ]
}

// MARK: - Utilities

private enum AppFont {
    static func display(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        customFont("FuturaPT-Medium", size: size, weight: weight)
    }

    static func text(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        customFont("FuturaPT-Book", size: size, weight: weight)
    }

    private static func customFont(_ name: String, size: CGFloat, weight: Font.Weight) -> Font {
        if UIFont(name: name, size: size) != nil {
            return .custom(name, size: size)
        }
        return .system(size: size, weight: weight)
    }
}

private struct DotPattern: View {
    var body: some View {
        GeometryReader { proxy in
            let spacing: CGFloat = 12
            let columns = Int(proxy.size.width / spacing)
            let rows = Int(proxy.size.height / spacing)

            Path { path in
                for row in 0...rows {
                    for col in 0...columns {
                        let x = CGFloat(col) * spacing
                        let y = CGFloat(row) * spacing
                        path.addEllipse(in: CGRect(x: x, y: y, width: 2, height: 2))
                    }
                }
            }
            .fill(Color.black)
        }
    }
}

private extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: alpha
        )
    }
}
