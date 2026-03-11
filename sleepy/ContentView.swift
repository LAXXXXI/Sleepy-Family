import SwiftUI
import Combine
import UIKit

struct ContentView: View {
    @State private var tab: AppTab = .family
    @StateObject private var alarmStore = AlarmStore()

    var body: some View {
        ZStack(alignment: .bottom) {
            AppPalette.appBackground
                .ignoresSafeArea()

            // Keep both screens mounted so Family state doesn't reset when switching tabs.
            ZStack {
                FamilyView(alarmStore: alarmStore)
                    .opacity(tab == .family ? 1 : 0)
                    .allowsHitTesting(tab == .family)

                AlarmSettingsView(alarmStore: alarmStore)
                    .opacity(tab == .alarm ? 1 : 0)
                    .allowsHitTesting(tab == .alarm)
            }

            BottomTabBar(selected: $tab)
        }
        .font(AppTypography.pixel(14))
        .preferredColorScheme(.light)
    }
}

private enum AppTypography {
    static func pixel(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
}

private enum AppRadius {
    static let micro: CGFloat = 8
    static let control: CGFloat = 16
    static let card: CGFloat = 18
    static let panel: CGFloat = 20
    static let room: CGFloat = 20
}

private enum AppStroke {
    static let subtle: CGFloat = 1.4
    static let standard: CGFloat = 3.4
    static let emphasis: CGFloat = 3.4
}

private enum AppPixel {
    static let step: CGFloat = 1
}

private enum AppPalette {
    static let appBackground = Color(hex: 0xF5EDDF)
    static let fieldBackground = Color(hex: 0xF5EDDF)
    static let grass = Color(hex: 0x9EDC2E)
    static let vibrantOrange = Color(hex: 0xD59048)
    static let electricBlue = Color(hex: 0xCAD6F0)
    static let hotPink = Color(hex: 0xDAA9C3)
    static let brightYellow = Color(hex: 0xEEBC30)
    static let punchGreen = Color(hex: 0x53CBCC)
    static let blockOrange = Color(hex: 0xF57D5E)
    static let blockYellow = Color(hex: 0xEEBC30)
    static let blockPink = Color(hex: 0xD4A1BB)
    static let blockGray = Color(hex: 0xE6E6E9)
    static let blockGreen = Color(hex: 0x54B18B)
    static let white = Color(hex: 0xFFFFFF)
    static let inkPrimary = Color(hex: 0x2C2C2C)
    static let inkSecondary = Color(hex: 0x717171)
    static let inkMuted = Color(hex: 0x9A9A9A)
    static let accentPrimary = vibrantOrange
    static let accentSecondary = electricBlue
    static let accentBlue = electricBlue
    static let accentYellow = brightYellow
    static let flatShadow = Color(hex: 0xBAB5A9).opacity(0.55)

    static let roomBoundary = Color(hex: 0x9A9A9A)
    static let roomWall = Color(hex: 0xEEEDEB)
    static let roomFloor = Color(hex: 0xF2EFEB)
    static let floorWashA = Color(hex: 0xF2EFEB)
    static let floorWashB = Color(hex: 0xEDEAE5)
    static let floorWashC = Color(hex: 0xF3F1ED)
    static let roomTeal = Color(hex: 0x53CBCC)
    static let roomSage = Color(hex: 0xB6DABD)
    static let roomMustard = Color(hex: 0xEEBC30)
    static let roomCoral = Color(hex: 0xFA8768)
    static let roomMistBlue = Color(hex: 0xABC3E3)
    static let roomLavender = Color(hex: 0xD4A1BB)

    static let boardWood = Color(hex: 0xDEC691)
    static let boardPaper = Color(hex: 0xFBF9F4)
    static let bedBlanket = Color(hex: 0xB6D0E7)
    static let bedHeadboard = Color(hex: 0xBFC3CA)
    static let bedShell = Color(hex: 0xE2E4E8)
    static let tvFrame = Color(hex: 0xAEB1B7)
    static let tvScreen = Color(hex: 0xFFFFFF)
    static let alarmShell = Color(hex: 0xE9E9E9)

    static let statusAwake = Color(hex: 0xECF3EF)
    static let statusSleep = Color(hex: 0xF2EFEB)
    static let statusLate = Color(hex: 0xF6E9E2)
    static let tabBarBackground = Color(hex: 0x1C1C1C)
}

private enum AppTab: String, CaseIterable {
    case family
    case alarm

    var title: String {
        switch self {
        case .family: return "Family"
        case .alarm: return "Alarm"
        }
    }

    var icon: String {
        switch self {
        case .family: return "house"
        case .alarm: return "alarm"
        }
    }
}

private struct BottomTabBar: View {
    @Binding var selected: AppTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.rawValue) { tab in
                Button {
                    selected = tab
                } label: {
                    VStack(spacing: 2) {
                        Image(systemName: tab.icon)
                            .font(AppTypography.pixel(19, weight: .semibold))
                        Text(tab.title)
                            .font(AppTypography.pixel(10, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .foregroundStyle(
                        selected == tab
                            ? AppPalette.vibrantOrange
                            : AppPalette.inkSecondary
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            Capsule(style: .continuous)
                .fill(AppPalette.white)
                .shadow(color: AppPalette.flatShadow.opacity(0.18), radius: 6, x: 0, y: 4)
        )
        .padding(.horizontal, 48)
        .padding(.bottom, 8)
    }
}

private struct PixelTabIcon: View {
    let tab: AppTab
    let isActive: Bool

    private var tone: Color {
        AppPalette.inkPrimary
    }

    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height

            ZStack {
                switch tab {
                case .family:
                    Path { path in
                        path.move(to: CGPoint(x: w * 0.10, y: h * 0.52))
                        path.addLine(to: CGPoint(x: w * 0.50, y: h * 0.16))
                        path.addLine(to: CGPoint(x: w * 0.90, y: h * 0.52))
                        path.addLine(to: CGPoint(x: w * 0.82, y: h * 0.52))
                        path.addLine(to: CGPoint(x: w * 0.82, y: h * 0.88))
                        path.addLine(to: CGPoint(x: w * 0.18, y: h * 0.88))
                        path.addLine(to: CGPoint(x: w * 0.18, y: h * 0.52))
                        path.closeSubpath()
                    }
                    .stroke(tone, lineWidth: 2)

                    Rectangle()
                        .fill(tone)
                        .frame(width: w * 0.12, height: h * 0.20)
                        .offset(y: h * 0.17)
                case .alarm:
                    Circle()
                        .stroke(tone, lineWidth: 2)
                        .frame(width: w * 0.72, height: h * 0.72)

                    Rectangle()
                        .fill(tone)
                        .frame(width: w * 0.08, height: h * 0.24)
                        .offset(y: -h * 0.10)
                    Rectangle()
                        .fill(tone)
                        .frame(width: w * 0.24, height: h * 0.08)
                        .offset(x: w * 0.10, y: h * 0.03)

                    Rectangle()
                        .fill(tone)
                        .frame(width: w * 0.18, height: h * 0.08)
                        .rotationEffect(.degrees(25))
                        .offset(x: -w * 0.24, y: -h * 0.40)
                    Rectangle()
                        .fill(tone)
                        .frame(width: w * 0.18, height: h * 0.08)
                        .rotationEffect(.degrees(-25))
                        .offset(x: w * 0.24, y: -h * 0.40)
                }
            }
            .drawingGroup(opaque: false)
        }
    }
}

private struct PaperGrainOverlay: View {
    var body: some View {
        Canvas { context, size in
            let step: CGFloat = 14
            for y in stride(from: 0, through: size.height, by: step) {
                for x in stride(from: 0, through: size.width, by: step) {
                    let patternSeed = Int((x + y) / step)
                    if patternSeed % 17 == 0 {
                        let dotRect = CGRect(x: x, y: y, width: 0.7, height: 0.7)
                        context.fill(
                            Path(ellipseIn: dotRect),
                            with: .color(AppPalette.inkPrimary.opacity(0.025))
                        )
                    }
                }
            }
        }
        .blendMode(.multiply)
        .allowsHitTesting(false)
    }
}

private struct GrassPatternLayer: View {
    var body: some View {
        GeometryReader { proxy in
            let points: [CGPoint] = [
                CGPoint(x: 0.14, y: 0.08), CGPoint(x: 0.30, y: 0.10), CGPoint(x: 0.52, y: 0.11),
                CGPoint(x: 0.73, y: 0.09), CGPoint(x: 0.88, y: 0.07), CGPoint(x: 0.92, y: 0.20),
                CGPoint(x: 0.06, y: 0.31), CGPoint(x: 0.18, y: 0.44), CGPoint(x: 0.92, y: 0.48),
                CGPoint(x: 0.30, y: 0.58), CGPoint(x: 0.08, y: 0.66), CGPoint(x: 0.26, y: 0.74),
                CGPoint(x: 0.88, y: 0.78), CGPoint(x: 0.16, y: 0.86), CGPoint(x: 0.58, y: 0.88),
                CGPoint(x: 0.84, y: 0.93), CGPoint(x: 0.12, y: 0.95), CGPoint(x: 0.44, y: 0.96)
            ]
            ZStack {
                ForEach(Array(points.enumerated()), id: \.offset) { _, point in
                    HStack(spacing: 4) {
                        Capsule().fill(AppPalette.grass)
                        Capsule().fill(AppPalette.grass)
                        Capsule().fill(AppPalette.grass)
                    }
                    .frame(width: 30, height: 14)
                    .position(x: proxy.size.width * point.x, y: proxy.size.height * point.y)
                }
            }
        }
        .allowsHitTesting(false)
    }
}

private struct AlarmEntry: Identifiable, Equatable {
    let id: UUID
    var hour: Int
    var minute: Int
    var label: String
    var repeatSummary: String
    var sound: String
    var isSnoozeEnabled: Bool
    var snoozeDurationMinutes: Int
    var isEnabled: Bool
    let isPrimary: Bool

    init(
        id: UUID = UUID(),
        hour: Int,
        minute: Int,
        label: String,
        repeatSummary: String = "Never",
        sound: String = "Wake up",
        isSnoozeEnabled: Bool = true,
        snoozeDurationMinutes: Int = 9,
        isEnabled: Bool = true,
        isPrimary: Bool
    ) {
        self.id = id
        self.hour = hour
        self.minute = minute
        self.label = label
        self.repeatSummary = repeatSummary
        self.sound = sound
        self.isSnoozeEnabled = isSnoozeEnabled
        self.snoozeDurationMinutes = snoozeDurationMinutes
        self.isEnabled = isEnabled
        self.isPrimary = isPrimary
    }

    var displayTime: String {
        String(format: "%02d:%02d", hour, minute)
    }
}

private final class AlarmStore: ObservableObject {
    @Published var primaryAlarm: AlarmEntry
    @Published var otherAlarms: [AlarmEntry]
    @Published var worldModeConsentEnabled: Bool = false

    init(
        primaryAlarm: AlarmEntry = AlarmEntry(
            hour: 8,
            minute: 40,
            label: "Sleep | Wake Up",
            sound: "Crush on (Acoustic version)",
            isEnabled: true,
            isPrimary: true
        ),
        otherAlarms: [AlarmEntry] = [
            AlarmEntry(hour: 0, minute: 0, label: "Alarm", isEnabled: false, isPrimary: false),
            AlarmEntry(hour: 0, minute: 15, label: "Alarm", isEnabled: false, isPrimary: false),
            AlarmEntry(hour: 0, minute: 21, label: "Alarm", isEnabled: false, isPrimary: false),
            AlarmEntry(hour: 0, minute: 30, label: "Alarm", isEnabled: false, isPrimary: false)
        ]
    ) {
        self.primaryAlarm = primaryAlarm
        self.otherAlarms = otherAlarms
    }

    var allAlarms: [AlarmEntry] {
        [primaryAlarm] + otherAlarms
    }

    func alarm(id: UUID) -> AlarmEntry? {
        if primaryAlarm.id == id { return primaryAlarm }
        return otherAlarms.first(where: { $0.id == id })
    }

    func upsert(_ alarm: AlarmEntry) {
        if alarm.isPrimary {
            primaryAlarm = alarm
            return
        }

        if let index = otherAlarms.firstIndex(where: { $0.id == alarm.id }) {
            otherAlarms[index] = alarm
        }
    }

    func toggle(id: UUID, isOn: Bool) {
        if primaryAlarm.id == id {
            primaryAlarm.isEnabled = isOn
            return
        }

        guard let index = otherAlarms.firstIndex(where: { $0.id == id }) else { return }
        otherAlarms[index].isEnabled = isOn
    }

    func addOtherAlarm() -> AlarmEntry {
        let alarm = AlarmEntry(
            hour: 7,
            minute: 0,
            label: "Alarm",
            isEnabled: false,
            isPrimary: false
        )
        otherAlarms.append(alarm)
        return alarm
    }

    func remove(id: UUID) {
        guard let index = otherAlarms.firstIndex(where: { $0.id == id }) else { return }
        otherAlarms.remove(at: index)
    }

    func nearestEnabledAlarm(reference: Date = Date()) -> AlarmEntry? {
        allAlarms
            .filter(\.isEnabled)
            .compactMap { alarm -> (AlarmEntry, Date)? in
                guard let nextDate = nextTriggerDate(for: alarm, from: reference) else { return nil }
                return (alarm, nextDate)
            }
            .min(by: { $0.1 < $1.1 })?
            .0
    }

    func nextTriggerDate(for alarm: AlarmEntry, from reference: Date) -> Date? {
        let calendar = Calendar.current
        guard let today = calendar.date(
            bySettingHour: alarm.hour,
            minute: alarm.minute,
            second: 0,
            of: reference
        ) else {
            return nil
        }

        if today > reference {
            return today
        }

        return calendar.date(byAdding: .day, value: 1, to: today)
    }

    func triggerSummary(for alarm: AlarmEntry, reference: Date = Date()) -> String {
        guard let next = nextTriggerDate(for: alarm, from: reference) else {
            return "No schedule"
        }

        let calendar = Calendar.current
        if calendar.isDateInToday(next) {
            return "Today"
        }
        if calendar.isDateInTomorrow(next) {
            return "Tomorrow"
        }
        return next.formatted(.dateTime.weekday(.abbreviated))
    }
}

// MARK: - Family

private struct FamilyView: View {
    @ObservedObject var alarmStore: AlarmStore
    @State private var members = FamilySample.members
    @State private var wakeBanner: String?
    @State private var wakeMission: WakeMission?
    @State private var wakeActionMemberID: UUID?
    @State private var wakeReactionMemberID: UUID?
    @State private var now = Date()
    @State private var showMemberEditorSheet = false
    @State private var memberEditorMode: MemberEditorMode = .add
    @State private var memberEditorDraft = MemberEditorDraft(name: "", shape: .roundedSquare, colorHex: 0x42B9BB)
    @State private var showRankingScreen = false
    @State private var showWakeScheduleScreen = false
    @State private var showWorldAlarmScreen = false
    @State private var worldSleepers: [WorldSleeper] = []
    @State private var wakeComposeDraft: WakeComposeDraft?
    @State private var wakeComposeMessage = ""
    @State private var memberSlotByID: [UUID: Int] = [:]
    @State private var movementTokenByID: [UUID: UUID] = [:]
    @State private var lastWanderTargetByID: [UUID: CGPoint] = [:]
    @State private var didSeedDemoScenario = false
    @State private var mapZoom: CGFloat = 1.0
    @State private var mapOffset: CGSize = .zero
    @GestureState private var mapDrag: CGSize = .zero
    @GestureState private var mapPinch: CGFloat = 1

    private let ticker = Timer.publish(every: 0.8, on: .main, in: .common).autoconnect()
    private let minMapZoom: CGFloat = 0.75
    private let maxMapZoom: CGFloat = 2.5
    private let defaultMapZoom: CGFloat = 1.38

    private var floorLayout: FloorLayout {
        buildFloorLayout(memberCount: max(members.count, 4))
    }

    private var mapUnitHeight: CGFloat {
        floorLayout.planHeight
    }

    private var awakeCount: Int {
        members.filter { $0.status == .awake }.count
    }

    private var sleepingCount: Int {
        members.count - awakeCount
    }

    private var lateCount: Int {
        members.filter { isOverdue($0) }.count
    }

    private var nearestAlarm: AlarmEntry? {
        alarmStore.nearestEnabledAlarm(reference: now)
    }

    private var sortedWakeRows: [FamilyMember] {
        members.sorted { lhs, rhs in
            let lhsLate = isOverdue(lhs)
            let rhsLate = isOverdue(rhs)
            if lhsLate != rhsLate {
                return lhsLate && !rhsLate
            }

            let lhsMinutes = wakeMinutes(for: lhs) ?? Int.max
            let rhsMinutes = wakeMinutes(for: rhs) ?? Int.max
            if lhsMinutes != rhsMinutes {
                return lhsMinutes < rhsMinutes
            }
            return lhs.name < rhs.name
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 12) {
                FamilySceneHeader(
                    onAddTap: { openAddMemberSheet() },
                    onEditMeTap: { openMyAvatarEditor() }
                )

                GeometryReader { proxy in
                    let viewport = proxy.size
                    let layout = floorLayout
                    let worldSize = CGSize(width: 560, height: 560 * layout.planHeight)
                    let fitScale = min(viewport.width / worldSize.width, viewport.height / worldSize.height)
                    let liveZoom = clamp(mapZoom * mapPinch, lower: minMapZoom, upper: maxMapZoom)
                    let composedScale = fitScale * liveZoom
                    let baseOffset = centeredFloorBaseOffset(
                        for: worldSize,
                        viewport: viewport,
                        scale: composedScale
                    )
                    let transientOffset = CGSize(
                        width: mapOffset.width + mapDrag.width,
                        height: mapOffset.height + mapDrag.height
                    )
                    let liveOffset = clampedMapOffset(
                        transientOffset,
                        viewport: viewport,
                        world: worldSize,
                        fitScale: fitScale,
                        zoom: liveZoom
                    )
                    ZStack {
                        Rectangle()
                            .fill(AppPalette.fieldBackground)
                        GrassPatternLayer()

                        ZStack {
                            RoomBackground(
                                layout: layout
                            )

                            RoomFurnitureLayer(
                                layout: layout,
                                awakeCount: awakeCount,
                                sleepingCount: sleepingCount,
                                lateCount: lateCount,
                                onBoardTap: {
                                    handleFurnitureTap(.bulletin, anchor: layout.furniture.bulletin)
                                },
                                onAlarmTap: {
                                    handleFurnitureTap(.alarm, anchor: layout.furniture.alarm)
                                },
                                onWorldAlarmTap: {
                                    handleFurnitureTap(.worldAlarm, anchor: layout.furniture.worldAlarm)
                                }
                            )

                            ForEach(members) { member in
                                if let slot = bedSlot(for: member.id) {
                                    BedSlotView(
                                        isSleeping: member.status == .sleeping,
                                        orientation: slot.bedOrientation
                                    )
                                        .position(mapPoint(slot.bedPoint, in: worldSize))
                                }
                            }

                            ForEach(members) { member in
                                if let slot = bedSlot(for: member.id) {
                                    AvatarNode(
                                        member: member,
                                        isOverdue: isOverdue(member),
                                        isWakeAction: wakeActionMemberID == member.id,
                                        isWakeReaction: wakeReactionMemberID == member.id
                                    )
                                    .position(mapPoint(visualPoint(for: member, bedPoint: slot.bedPoint), in: worldSize))
                                    .onTapGesture {
                                        if member.isMe {
                                            openMyAvatarEditor()
                                        } else {
                                            openComposeForFamilyTarget(memberID: member.id)
                                        }
                                    }
                            }
                            }
                        }
                        .frame(width: worldSize.width, height: worldSize.height)
                        .scaleEffect(composedScale, anchor: .center)
                        .offset(
                            x: baseOffset.width + liveOffset.width,
                            y: baseOffset.height + liveOffset.height
                        )
                    }
                    .contentShape(Rectangle())
                    .gesture(dragGesture(viewport: viewport, world: worldSize, fitScale: fitScale), including: .all)
                    .simultaneousGesture(magnificationGesture(viewport: viewport, world: worldSize, fitScale: fitScale), including: .all)
                    .onTapGesture(count: 2) {
                        withAnimation(.spring(response: 0.26, dampingFraction: 0.9)) {
                            mapZoom = defaultMapZoom
                            mapOffset = .zero
                        }
                    }
                    .clipped()
                }
            }
            .padding(.horizontal, 14)
            .padding(.top, 12)
            .padding(.bottom, 76)

            if let wakeBanner {
                Text(wakeBanner)
                    .font(AppTypography.pixel(13, weight: .semibold))
                    .foregroundStyle(AppPalette.inkPrimary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(AppPalette.white)
                            .overlay(
                                Capsule()
                                    .stroke(AppPalette.inkPrimary, lineWidth: AppStroke.standard)
                            )
                    )
                    .padding(.bottom, 88)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .onAppear {
            mapZoom = defaultMapZoom // FIX 2 keep default centered scale on open
            mapOffset = .zero // FIX 2 prevent stale drag offset on reopen
            ensureMemberSlots()
            if !didSeedDemoScenario {
                configureDemoScenario()
                didSeedDemoScenario = true
            }
            placeSleepersOnBeds()
            now = Date()
            wanderAwakeMembers()
            seedWorldSleepersIfNeeded()
        }
        .onChange(of: members.count) { _, _ in
            ensureMemberSlots()
            mapOffset = .zero
        }
        .onReceive(ticker) { _ in
            now = Date()
            wanderAwakeMembers()
        }
        .sheet(isPresented: $showMemberEditorSheet) {
            MemberEditorSheet(
                mode: memberEditorMode,
                draft: $memberEditorDraft,
                shapeOptions: AvatarBodyShape.allCases,
                colorOptions: FamilySample.editableColorHexes,
                onCancel: {
                    resetMemberEditorDraft()
                    showMemberEditorSheet = false
                },
                onConfirm: {
                    submitMemberEditor()
                    showMemberEditorSheet = false
                }
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $showRankingScreen) {
            RankingView {
                showRankingScreen = false
            }
        }
        .fullScreenCover(isPresented: $showWakeScheduleScreen) {
            WakeScheduleFullScreenView(
                members: sortedWakeRows,
                isOverdue: { isOverdue($0) },
                onWakeTap: { openComposeForFamilyTarget(memberID: $0) },
                formatWake: { formatWakeTime($0) },
                onBack: {
                    showWakeScheduleScreen = false
                }
            )
        }
        .fullScreenCover(isPresented: $showWorldAlarmScreen) {
            WorldWakeFullScreenView(
                sleepers: $worldSleepers,
                wakeComposeDraft: $wakeComposeDraft,
                wakeComposeMessage: $wakeComposeMessage,
                onSendWakeDraft: { draft, message in
                    sendWakeDraft(draft: draft, message: message)
                },
                onBack: { showWorldAlarmScreen = false }
            )
        }
        .overlay(
            WakeSendOverlay(
                draft: wakeComposeDraft,
                message: $wakeComposeMessage,
                onCancel: {
                    withAnimation(.easeOut(duration: 0.2)) {
                        resetComposeStateAfterDismiss()
                    }
                },
                onSend: {
                    guard let draft = wakeComposeDraft else { return }
                    sendWakeDraft(draft: draft, message: wakeComposeMessage)
                    resetComposeStateAfterDismiss()
                }
            )
        )
    }

    private var entryPoint: CGPoint {
        CGPoint(
            x: floorLayout.commonRect.midX,
            y: floorLayout.commonRect.midY
        )
    }

    private var floorPlanBounds: CGRect {
        floorLayout.floorBounds
    }

    private var activeBedroomSlots: [BedroomSlot] {
        floorLayout.slots
    }

    private func visualPoint(for member: FamilyMember, bedPoint: CGPoint) -> CGPoint {
        if member.status == .sleeping {
            return CGPoint(x: bedPoint.x, y: bedPoint.y + 0.012)
        }
        return member.position
    }

    private func submitMemberEditor() {
        let trimmed = memberEditorDraft.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        switch memberEditorMode {
        case .add:
            guard members.count < FamilySample.maxMembers else {
                wakeBanner = "Member limit reached (max \(FamilySample.maxMembers))."
                clearBannerLater()
                return
            }
            let avatar = makeAvatarTheme(
                shape: memberEditorDraft.shape,
                colorHex: memberEditorDraft.colorHex,
                defaultFace: .classic
            )

            let newMember = FamilyMember(
                id: UUID(),
                name: trimmed,
                avatar: avatar,
                status: .awake,
                wakeSchedule: WakeSchedule(hour: 8, minute: 0),
                position: entryPoint,
                isMe: false,
                activity: "Entering room"
            )

            members.append(newMember)
            ensureMemberSlots(prioritize: newMember.id)
            placeSleepersOnBeds()

            if let newIndex = members.firstIndex(where: { $0.id == newMember.id }),
               let slot = bedSlot(for: newMember.id) {
                withAnimation(.easeInOut(duration: 1.5)) {
                    members[newIndex].position = randomRoamPoint(in: slot, excluding: newMember.id)
                    members[newIndex].activity = "Walking"
                }
                startWanderIfIdle(memberID: newMember.id)
            }

            wakeBanner = "\(trimmed) joined the family."
            clearBannerLater()

        case .editMe:
            guard let meIndex = members.firstIndex(where: { $0.isMe }) else { return }
            members[meIndex].name = trimmed
            members[meIndex].avatar = makeAvatarTheme(
                shape: memberEditorDraft.shape,
                colorHex: memberEditorDraft.colorHex,
                defaultFace: members[meIndex].avatar.faceStyle
            )
            wakeBanner = "Profile updated."
            clearBannerLater()
        }

        resetMemberEditorDraft()
    }

    private func openComposeForFamilyTarget(memberID: UUID) {
        guard let targetIndex = members.firstIndex(where: { $0.id == memberID }) else { return }
        if members[targetIndex].status == .awake {
            wakeBanner = "\(members[targetIndex].name) is already awake."
            clearBannerLater()
            return
        }

        if !isOverdue(members[targetIndex]) {
            wakeBanner = "\(members[targetIndex].name) is not overdue yet."
            clearBannerLater()
            return
        }

        guard let meIndex = members.firstIndex(where: { $0.isMe }) else { return }
        guard members[meIndex].status == .awake else {
            wakeBanner = "You need to wake up first."
            clearBannerLater()
            return
        }
        guard wakeMission == nil, wakeComposeDraft == nil else { return }
        guard let targetSlot = bedSlot(for: memberID) else { return }

        let meID = members[meIndex].id
        let meCurrent = members[meIndex].position
        let meRoom = roomContaining(meCurrent)
        let targetRoom = roomForMember(memberID)
        let startPoint = meRoom == nil
            ? clampedToCommon(meCurrent, inset: 0.10)
            : clampedToRoom(meCurrent, room: meRoom!.rect, inset: 0.10)
        let horizontalOffset: CGFloat = targetSlot.isLeftColumn ? 0.12 : -0.12
        let approachPoint = clampedToRoom(
            CGPoint(
                x: targetSlot.bedPoint.x + horizontalOffset,
                y: targetSlot.bedPoint.y + 0.05
            ),
            room: targetSlot.roomRect,
            inset: 0.12
        )
        let approachRoute = routeBetween(
            start: startPoint,
            startRoom: meRoom,
            end: approachPoint,
            endRoom: targetRoom
        )

        moveMember(
            memberID: meID,
            along: approachRoute,
            movingActivity: "Walking",
            speedPerSecond: 0.23
        ) {
            guard let refreshedTarget = members.first(where: { $0.id == memberID }) else { return }
            guard refreshedTarget.status == .sleeping, isOverdue(refreshedTarget) else {
                wakeBanner = "\(refreshedTarget.name) is already handled."
                clearBannerLater()
                return
            }
            wakeComposeMessage = ""
            withAnimation(.easeInOut(duration: 0.2)) {
                wakeComposeDraft = WakeComposeDraft(
                    target: .family(memberID: memberID),
                    targetTitle: refreshedTarget.name
                )
            }
        }
    }

    private func configureDemoScenario() {
        guard !members.isEmpty else { return }
        let calendar = Calendar.current
        let nowDate = Date()

        if let meIndex = members.firstIndex(where: { $0.isMe }) {
            members[meIndex].status = .awake
            members[meIndex].activity = "Walking"
        }

        if members.indices.contains(1) {
            members[1].status = .sleeping
            if let future = calendar.date(byAdding: .minute, value: 25, to: nowDate) {
                members[1].wakeSchedule = WakeSchedule(
                    hour: calendar.component(.hour, from: future),
                    minute: calendar.component(.minute, from: future)
                )
            }
            members[1].activity = "Sleeping"
        }

        if members.indices.contains(2) {
            members[2].status = .sleeping
            if let past = calendar.date(byAdding: .minute, value: -20, to: nowDate) {
                members[2].wakeSchedule = WakeSchedule(
                    hour: calendar.component(.hour, from: past),
                    minute: calendar.component(.minute, from: past)
                )
            }
            members[2].activity = "Sleeping"
        }

        for idx in members.indices where idx > 2 {
            members[idx].status = .awake
            members[idx].activity = "Walking"
        }
    }

    private func handleFurnitureTap(_ target: FurnitureActionTarget, anchor: CGPoint) {
        guard let meIndex = members.firstIndex(where: { $0.isMe }) else {
            presentFurnitureTarget(target)
            return
        }

        guard members[meIndex].status == .awake, wakeMission == nil else {
            presentFurnitureTarget(target)
            return
        }

        let meID = members[meIndex].id
        let meStart = members[meIndex].position
        let meRoom = roomContaining(meStart)

        let furnitureStop = clampedToCommon(furnitureApproachPoint(for: target, anchor: anchor), inset: 0.09)
        let route = routeBetween(
            start: meStart,
            startRoom: meRoom,
            end: furnitureStop,
            endRoom: nil
        )

        moveMember(
            memberID: meID,
            along: route,
            movingActivity: "Walking",
            speedPerSecond: 0.23
        ) {
            if let latestMe = members.firstIndex(where: { $0.id == meID }),
               members[latestMe].status == .awake {
                members[latestMe].activity = "Walking"
            }
            presentFurnitureTarget(target)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                startWanderIfIdle(memberID: meID)
            }
        }
    }

    private func furnitureApproachPoint(for target: FurnitureActionTarget, anchor: CGPoint) -> CGPoint {
        switch target {
        case .bulletin:
            return CGPoint(x: anchor.x - 0.11, y: anchor.y + 0.008)
        case .alarm:
            return CGPoint(x: anchor.x - 0.11, y: anchor.y + 0.004)
        case .worldAlarm:
            return CGPoint(x: anchor.x - 0.11, y: anchor.y + 0.004)
        }
    }

    private func presentFurnitureTarget(_ target: FurnitureActionTarget) {
        switch target {
        case .bulletin:
            showRankingScreen = true
        case .alarm:
            showWakeScheduleScreen = true
        case .worldAlarm:
            showWorldAlarmScreen = true
        }
    }

    private func performWake(memberID: UUID) {
        guard let targetIndex = members.firstIndex(where: { $0.id == memberID }) else { return }

        if members[targetIndex].status == .awake {
            wakeBanner = "\(members[targetIndex].name) is already awake."
            clearBannerLater()
            return
        }
        if !isOverdue(members[targetIndex]) {
            wakeBanner = "\(members[targetIndex].name) is not overdue yet."
            clearBannerLater()
            return
        }

        guard let meIndex = members.firstIndex(where: { $0.isMe }) else { return }
        guard members[meIndex].status == .awake else {
            wakeBanner = "You need to wake up first."
            clearBannerLater()
            return
        }
        guard wakeMission == nil else { return }

        let targetID = memberID
        wakeActionMemberID = nil
        wakeReactionMemberID = nil

        wakeMission = WakeMission(targetID: targetID)
        let targetName = members[targetIndex].name
        withAnimation(.easeInOut(duration: 0.16).repeatCount(4, autoreverses: true)) {
            wakeActionMemberID = members[meIndex].id
            members[meIndex].activity = "Calling \(targetName)"
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.52) {
            guard let wakeTarget = members.firstIndex(where: { $0.id == targetID }) else {
                wakeActionMemberID = nil
                wakeMission = nil
                return
            }

            let wokeName = members[wakeTarget].name
            if let slot = bedSlot(for: targetID) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    members[wakeTarget].status = .awake
                    members[wakeTarget].position = randomRoamPoint(in: slot, excluding: targetID)
                    members[wakeTarget].activity = "Whoa!"
                    wakeReactionMemberID = targetID
                }
            }

            wakeBanner = "You woke \(wokeName)!"

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
                wakeReactionMemberID = nil
                if let settled = members.firstIndex(where: { $0.id == targetID }),
                   members[settled].status == .awake {
                    members[settled].activity = FamilySample.randomActivity()
                    startWanderIfIdle(memberID: targetID)
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                wakeActionMemberID = nil
                if let me = members.firstIndex(where: { $0.isMe }) {
                    members[me].activity = "Walking"
                    startWanderIfIdle(memberID: members[me].id)
                }
                wakeMission = nil
            }

            clearBannerLater()
        }
    }

    private func wanderAwakeMembers() {
        for index in members.indices {
            guard let slot = bedSlot(for: members[index].id) else { continue }

            if members[index].status == .sleeping {
                members[index].position = slot.bedPoint
                continue
            }

            if !isPointWalkable(members[index].position) {
                members[index].position = nearestWalkablePoint(to: members[index].position)
            }

            startWanderIfIdle(memberID: members[index].id)
        }
    }

    private func startWanderIfIdle(memberID: UUID) {
        guard movementTokenByID[memberID] == nil else { return }
        guard let index = members.firstIndex(where: { $0.id == memberID }) else { return }
        guard members[index].status == .awake else { return }

        if members[index].isMe && wakeMission != nil {
            return
        }

        let start = members[index].position
        let startRoom = roomContaining(start)
        let target = pickWanderTarget(
            memberID: memberID,
            from: start,
            startRoom: startRoom
        )
        let route = routeBetween(
            start: start,
            startRoom: startRoom,
            end: target.point,
            endRoom: target.room
        )

        moveMember(memberID: memberID, along: route, movingActivity: "Walking") {
            lastWanderTargetByID[memberID] = target.point

            // Keep avatars in a continuous slow motion loop with near-zero idle gap.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                startWanderIfIdle(memberID: memberID)
            }
        }
    }

    private func placeSleepersOnBeds() {
        let presetAwakePoints: [String: CGPoint] = [
            "Laxxi": CGPoint(x: 0.18, y: 0.66),
            "Will": CGPoint(x: 0.62, y: 0.82),
            "Mason": CGPoint(x: 0.49, y: 0.90),
            "Eric": CGPoint(x: 0.48, y: 1.10)
        ]

        for index in members.indices {
            guard let slot = bedSlot(for: members[index].id) else { continue }
            if members[index].status == .sleeping {
                members[index].position = slot.bedPoint
            } else {
                if let preset = presetAwakePoints[members[index].name], isPointWalkable(preset) {
                    members[index].position = nearestWalkablePoint(to: preset)
                } else {
                    members[index].position = randomRoamPoint(in: slot, excluding: members[index].id)
                }
                members[index].activity = "Walking"
            }
        }
    }

    private func clearBannerLater() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            withAnimation(.easeOut(duration: 0.25)) {
                wakeBanner = nil
            }
        }
    }

    private func ensureMemberSlots(prioritize memberID: UUID? = nil) {
        let slots = activeBedroomSlots
        guard !slots.isEmpty else {
            memberSlotByID = [:]
            return
        }

        var mapping: [UUID: Int] = [:]
        var used: Set<Int> = []

        // 4人預設對齊手稿: top-left(empty bed), top-middle(Ruby), left-middle(Will), bottom-right(Eric)
        // 新增成員優先使用右/下/左外擴房，最後才補右上房。
        let preferredOrder = [0, 1, 3, 4, 5, 6, 7, 2]

        for member in members {
            if let old = memberSlotByID[member.id], slots.indices.contains(old), !used.contains(old) {
                mapping[member.id] = old
                used.insert(old)
                continue
            }

            if let candidate = preferredOrder.first(where: { slots.indices.contains($0) && !used.contains($0) }) {
                mapping[member.id] = candidate
                used.insert(candidate)
                continue
            }

            if let fallback = slots.indices.first(where: { !used.contains($0) }) {
                mapping[member.id] = fallback
                used.insert(fallback)
            }
        }

        if let memberID,
           let preferred = mapping[memberID] {
            // Keep mapping stable but ensure prioritized member owns a valid slot.
            mapping[memberID] = preferred
        }

        memberSlotByID = mapping
    }

    private func bedSlot(for memberID: UUID) -> BedroomSlot? {
        let slots = activeBedroomSlots
        guard let index = memberSlotByID[memberID], slots.indices.contains(index) else {
            return nil
        }
        return slots[index]
    }

    private func nearestAvailableSlot(from point: CGPoint, slots: [BedroomSlot], used: Set<Int>) -> Int? {
        slots.indices
            .filter { !used.contains($0) }
            .min { lhs, rhs in
                let left = distanceSquared(point, slots[lhs].bedPoint)
                let right = distanceSquared(point, slots[rhs].bedPoint)
                return left < right
            }
    }

    private func distanceSquared(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let dx = a.x - b.x
        let dy = a.y - b.y
        return (dx * dx) + (dy * dy)
    }

    private func buildFloorLayout(memberCount: Int) -> FloorLayout {
        struct RoomTemplate {
            let rect: CGRect
            let door: RoomDoor
            let bedPoint: CGPoint
            let washIndex: Int
            let orientation: BedOrientation
        }

        struct TemplateSpec {
            let rooms: [RoomTemplate]
            let outlinePoints: [CGPoint]
            let furniture: FurnitureAnchors
            let commonRect: CGRect
            let planHeight: CGFloat
            let innerWalls: [InnerWallSegment]
        }

        let total = min(max(memberCount, 4), FamilySample.maxMembers)
        let doorWidth: CGFloat = 0.22

        let topLeft = RoomTemplate(
            rect: CGRect(x: 0.08, y: 0.30, width: 0.30, height: 0.24),
            door: RoomDoor(edge: .bottom, center: 0.23, width: doorWidth),
            bedPoint: CGPoint(x: 0.23, y: 0.40),
            washIndex: 0,
            orientation: .horizontal
        )
        let topMiddle = RoomTemplate(
            rect: CGRect(x: 0.38, y: 0.30, width: 0.30, height: 0.24),
            door: RoomDoor(edge: .bottom, center: 0.53, width: doorWidth),
            bedPoint: CGPoint(x: 0.53, y: 0.40),
            washIndex: 1,
            orientation: .horizontal
        )
        let rightTop = RoomTemplate(
            rect: CGRect(x: 0.68, y: 0.42, width: 0.22, height: 0.30),
            door: RoomDoor(edge: .left, center: 0.57, width: doorWidth),
            bedPoint: CGPoint(x: 0.79, y: 0.57),
            washIndex: 2,
            orientation: .vertical
        )
        let leftMiddle = RoomTemplate(
            rect: CGRect(x: 0.08, y: 0.80, width: 0.34, height: 0.25),
            door: RoomDoor(edge: .right, center: 0.92, width: doorWidth),
            bedPoint: CGPoint(x: 0.25, y: 0.92),
            washIndex: 3,
            orientation: .horizontal
        )
        let bottomRight = RoomTemplate(
            rect: CGRect(x: 0.42, y: 1.04, width: 0.48, height: 0.30),
            door: RoomDoor(edge: .top, center: 0.64, width: doorWidth),
            bedPoint: CGPoint(x: 0.66, y: 1.20),
            washIndex: 4,
            orientation: .horizontal
        )
        let rightExtension = RoomTemplate(
            rect: CGRect(x: 0.90, y: 0.88, width: 0.22, height: 0.28),
            door: RoomDoor(edge: .left, center: 1.02, width: doorWidth),
            bedPoint: CGPoint(x: 1.01, y: 1.02),
            washIndex: 5,
            orientation: .horizontal
        )
        let bottomExtension = RoomTemplate(
            rect: CGRect(x: 0.50, y: 1.34, width: 0.30, height: 0.24),
            door: RoomDoor(edge: .top, center: 0.65, width: doorWidth),
            bedPoint: CGPoint(x: 0.65, y: 1.46),
            washIndex: 6,
            orientation: .horizontal
        )
        let leftExtension = RoomTemplate(
            rect: CGRect(x: -0.14, y: 1.06, width: 0.22, height: 0.28),
            door: RoomDoor(edge: .right, center: 1.20, width: doorWidth),
            bedPoint: CGPoint(x: -0.03, y: 1.20),
            washIndex: 7,
            orientation: .horizontal
        )

        let baseFurniture = FurnitureAnchors(
            bulletin: CGPoint(x: 0.78, y: 0.96),
            tv: CGPoint(x: 0.50, y: 0.70),
            alarm: CGPoint(x: 0.78, y: 0.62),
            worldAlarm: CGPoint(x: 0.78, y: 0.77)
        )

        func wall(_ x1: CGFloat, _ y1: CGFloat, _ x2: CGFloat, _ y2: CGFloat) -> InnerWallSegment {
            InnerWallSegment(start: CGPoint(x: x1, y: y1), end: CGPoint(x: x2, y: y2))
        }

        // Hand-authored inner walls to avoid branch artifacts from auto-generated segments.
        let baseInnerWalls: [InnerWallSegment] = [
            wall(0.38, 0.30, 0.38, 0.58),  // top split
            wall(0.18, 0.58, 0.68, 0.58),  // upper corridor divider (connected)
            wall(0.68, 0.58, 0.68, 0.72),  // right divider (kept away from outer corner)
            wall(0.08, 0.80, 0.42, 0.80),  // left room top (connected)
            wall(0.42, 0.80, 0.42, 0.96),  // left room right boundary (with door gap below)
            wall(0.55, 1.05, 0.90, 1.05)   // lower right room top
        ]

        let template4 = TemplateSpec(
            rooms: [topLeft, topMiddle, rightTop, leftMiddle, bottomRight],
            outlinePoints: [
                CGPoint(x: 0.08, y: 0.30),
                CGPoint(x: 0.68, y: 0.30),
                CGPoint(x: 0.68, y: 0.42),
                CGPoint(x: 0.90, y: 0.42),
                CGPoint(x: 0.90, y: 1.04),
                CGPoint(x: 0.90, y: 1.34),
                CGPoint(x: 0.42, y: 1.34),
                CGPoint(x: 0.42, y: 1.05),
                CGPoint(x: 0.08, y: 1.05)
            ],
            furniture: baseFurniture,
            commonRect: CGRect(x: 0.16, y: 0.58, width: 0.66, height: 0.54),
            planHeight: 1.42,
            innerWalls: baseInnerWalls
        )

        let template5 = TemplateSpec(
            rooms: template4.rooms + [rightExtension],
            outlinePoints: [
                CGPoint(x: 0.08, y: 0.30),
                CGPoint(x: 0.68, y: 0.30),
                CGPoint(x: 0.68, y: 0.42),
                CGPoint(x: 0.90, y: 0.42),
                CGPoint(x: 0.90, y: 0.88),
                CGPoint(x: 1.12, y: 0.88),
                CGPoint(x: 1.12, y: 1.16),
                CGPoint(x: 0.90, y: 1.16),
                CGPoint(x: 0.90, y: 1.34),
                CGPoint(x: 0.42, y: 1.34),
                CGPoint(x: 0.42, y: 1.05),
                CGPoint(x: 0.08, y: 1.05)
            ],
            furniture: baseFurniture,
            commonRect: CGRect(x: 0.16, y: 0.58, width: 0.78, height: 0.56),
            planHeight: 1.42,
            innerWalls: baseInnerWalls + [
                wall(0.90, 0.96, 0.90, 1.10) // extension separator (door preserved by partial segment)
            ]
        )

        let template6 = TemplateSpec(
            rooms: template5.rooms + [bottomExtension],
            outlinePoints: [
                CGPoint(x: 0.08, y: 0.30),
                CGPoint(x: 0.68, y: 0.30),
                CGPoint(x: 0.68, y: 0.42),
                CGPoint(x: 0.90, y: 0.42),
                CGPoint(x: 0.90, y: 0.88),
                CGPoint(x: 1.12, y: 0.88),
                CGPoint(x: 1.12, y: 1.16),
                CGPoint(x: 0.90, y: 1.16),
                CGPoint(x: 0.90, y: 1.34),
                CGPoint(x: 0.80, y: 1.34),
                CGPoint(x: 0.80, y: 1.58),
                CGPoint(x: 0.50, y: 1.58),
                CGPoint(x: 0.50, y: 1.34),
                CGPoint(x: 0.42, y: 1.34),
                CGPoint(x: 0.42, y: 1.05),
                CGPoint(x: 0.08, y: 1.05)
            ],
            furniture: baseFurniture,
            commonRect: CGRect(x: 0.16, y: 0.58, width: 0.78, height: 0.70),
            planHeight: 1.66,
            innerWalls: baseInnerWalls + [
                wall(0.90, 0.96, 0.90, 1.10),
                wall(0.58, 1.34, 0.72, 1.34) // bottom extension separator
            ]
        )

        let template7 = TemplateSpec(
            rooms: template6.rooms + [leftExtension],
            outlinePoints: [
                CGPoint(x: 0.08, y: 0.30),
                CGPoint(x: 0.68, y: 0.30),
                CGPoint(x: 0.68, y: 0.42),
                CGPoint(x: 0.90, y: 0.42),
                CGPoint(x: 0.90, y: 0.88),
                CGPoint(x: 1.12, y: 0.88),
                CGPoint(x: 1.12, y: 1.16),
                CGPoint(x: 0.90, y: 1.16),
                CGPoint(x: 0.90, y: 1.34),
                CGPoint(x: 0.80, y: 1.34),
                CGPoint(x: 0.80, y: 1.58),
                CGPoint(x: 0.50, y: 1.58),
                CGPoint(x: 0.50, y: 1.34),
                CGPoint(x: 0.08, y: 1.34),
                CGPoint(x: -0.14, y: 1.34),
                CGPoint(x: -0.14, y: 1.06),
                CGPoint(x: 0.08, y: 1.06),
                CGPoint(x: 0.08, y: 1.05)
            ],
            furniture: baseFurniture,
            commonRect: CGRect(x: 0.02, y: 0.58, width: 0.92, height: 0.70),
            planHeight: 1.66,
            innerWalls: baseInnerWalls + [
                wall(0.90, 0.96, 0.90, 1.10),
                wall(0.58, 1.34, 0.72, 1.34),
                wall(0.08, 1.12, 0.08, 1.28) // left extension separator
            ]
        )

        let spec: TemplateSpec
        switch total {
        case 4:
            spec = template4
        case 5:
            spec = template5
        case 6:
            spec = template6
        default:
            spec = template7
        }

        let rooms = spec.rooms.enumerated().map { index, template in
            FloorRoom(id: index, rect: template.rect, door: template.door, washIndex: template.washIndex)
        }

        let slots = spec.rooms.enumerated().map { index, template in
            makeBedroomSlot(
                id: index,
                roomID: index,
                roomRect: template.rect,
                door: template.door,
                bedPoint: template.bedPoint,
                isLeft: template.rect.midX < spec.commonRect.midX,
                orientation: template.orientation
            )
        }

        let minX = spec.outlinePoints.map(\.x).min() ?? 0.08
        let maxX = spec.outlinePoints.map(\.x).max() ?? 0.90
        let topY = spec.outlinePoints.map(\.y).min() ?? 0.30
        let bottomY = spec.outlinePoints.map(\.y).max() ?? 1.34

        return FloorLayout(
            planHeight: spec.planHeight,
            floorBounds: CGRect(x: minX, y: topY, width: maxX - minX, height: bottomY - topY),
            commonRect: spec.commonRect,
            rooms: rooms,
            slots: slots,
            outlinePoints: spec.outlinePoints,
            furniture: spec.furniture,
            innerWalls: spec.innerWalls
        )
    }
    private func makeBedroomSlot(
        id: Int,
        roomID: Int,
        roomRect: CGRect,
        door: RoomDoor,
        bedPoint: CGPoint,
        isLeft: Bool,
        orientation: BedOrientation
    ) -> BedroomSlot {
        let roamInsetX = min(max(0.075, roomRect.width * 0.20), roomRect.width * 0.30)
        let roamInsetY = min(max(0.08, roomRect.height * 0.22), roomRect.height * 0.30)
        let roamRect = roomRect.insetBy(dx: roamInsetX, dy: roamInsetY)
        return BedroomSlot(
            id: id,
            roomID: roomID,
            roomRect: roomRect,
            door: door,
            doorPoint: door.point(in: roomRect, inset: 0.13),
            bedPoint: bedPoint,
            roamRect: roamRect,
            isLeftColumn: isLeft,
            bedOrientation: orientation
        )
    }

    private func randomRoamPoint(in slot: BedroomSlot, excluding memberID: UUID? = nil) -> CGPoint {
        let fallback = CGPoint(
            x: clamp(slot.roamRect.midX, lower: floorPlanBounds.minX, upper: floorPlanBounds.maxX),
            y: clamp(slot.roamRect.midY, lower: floorPlanBounds.minY, upper: floorPlanBounds.maxY)
        )

        for _ in 0..<36 {
            let candidate = CGPoint(
                x: clamp(.random(in: slot.roamRect.minX...slot.roamRect.maxX), lower: floorPlanBounds.minX, upper: floorPlanBounds.maxX),
                y: clamp(.random(in: slot.roamRect.minY...slot.roamRect.maxY), lower: floorPlanBounds.minY, upper: floorPlanBounds.maxY)
            )
            if !isPointWalkable(candidate) { continue }
            if collidesFurniture(candidate) { continue }
            if collidesBedSpace(candidate) { continue }
            if let memberID, collidesAvatarSpace(candidate, for: memberID) { continue }
            return candidate
        }

        return nearestWalkablePoint(to: fallback)
    }

    private var walkableZones: [CGRect] {
        let roomInsetX: CGFloat = 0.062
        let roomInsetY: CGFloat = 0.070
        let commonInsetX: CGFloat = 0.060
        let commonInsetY: CGFloat = 0.066
        let corridorPadding: CGFloat = 0.028

        var zones: [CGRect] = [floorLayout.commonRect.insetBy(dx: commonInsetX, dy: commonInsetY)]
        zones.append(contentsOf: floorLayout.rooms.map { $0.rect.insetBy(dx: roomInsetX, dy: roomInsetY) })

        // Bridge each room door to common corridor so routes do not "hit an invisible wall".
        for room in floorLayout.rooms {
            let roomDoor = room.door.point(in: room.rect, inset: 0.09)
            let commonDoor = commonDoorPoint(for: room, inset: 0.09)
            let corridor = CGRect(
                x: min(roomDoor.x, commonDoor.x) - corridorPadding,
                y: min(roomDoor.y, commonDoor.y) - corridorPadding,
                width: abs(roomDoor.x - commonDoor.x) + corridorPadding * 2,
                height: abs(roomDoor.y - commonDoor.y) + corridorPadding * 2
            )
            zones.append(corridor)
        }

        return zones.filter { $0.width > 0.02 && $0.height > 0.02 }
    }

    private func isPointWalkable(_ point: CGPoint) -> Bool {
        let safety: CGFloat = 0.020
        let samples = [
            point,
            CGPoint(x: point.x + safety, y: point.y),
            CGPoint(x: point.x - safety, y: point.y),
            CGPoint(x: point.x, y: point.y + safety),
            CGPoint(x: point.x, y: point.y - safety)
        ]
        guard samples.allSatisfy({ isInsideFloorOutline($0) }) else { return false }
        return samples.allSatisfy { sample in
            walkableZones.contains { $0.contains(sample) }
        }
    }

    private func nearestWalkablePoint(to point: CGPoint) -> CGPoint {
        if isPointWalkable(point) { return point }
        let clampedCandidates: [CGPoint] = walkableZones.map { zone in
            CGPoint(
                x: clamp(point.x, lower: zone.minX, upper: zone.maxX),
                y: clamp(point.y, lower: zone.minY, upper: zone.maxY)
            )
        }
        let validCandidates = clampedCandidates.filter {
            isPointWalkable($0) && !collidesFurniture($0) && !collidesBedSpace($0)
        }
        guard let nearest = validCandidates.min(by: { distanceSquared($0, point) < distanceSquared($1, point) }) else {
            return clampedToCommon(entryPoint, inset: 0.12)
        }
        return nearest
    }

    private struct WalkTarget {
        let point: CGPoint
        let room: FloorRoom?
    }

    private func roomContaining(_ point: CGPoint) -> FloorRoom? {
        floorLayout.rooms.first(where: { $0.rect.insetBy(dx: -0.003, dy: -0.003).contains(point) })
    }

    private func roomForMember(_ memberID: UUID) -> FloorRoom? {
        guard let slot = bedSlot(for: memberID) else { return nil }
        return floorLayout.rooms.first(where: { $0.id == slot.roomID })
    }

    private func randomWalkTarget(
        for memberID: UUID,
        includeAllRooms: Bool,
        includeCommon: Bool
    ) -> WalkTarget {
        var zones: [WalkTarget] = []

        let common = floorLayout.commonRect.insetBy(dx: 0.07, dy: 0.08)
        if includeCommon, common.width > 0.05, common.height > 0.05 {
            zones.append(
                WalkTarget(
                    point: CGPoint(
                        x: .random(in: common.minX...common.maxX),
                        y: .random(in: common.minY...common.maxY)
                    ),
                    room: nil
                )
            )
        }

        if let ownSlot = bedSlot(for: memberID),
           let ownRoom = floorLayout.rooms.first(where: { $0.id == ownSlot.roomID }) {
            let roam = ownRoom.rect.insetBy(dx: 0.07, dy: 0.08)
            if roam.width > 0.05, roam.height > 0.05 {
                zones.append(
                    WalkTarget(
                        point: CGPoint(
                            x: .random(in: roam.minX...roam.maxX),
                            y: .random(in: roam.minY...roam.maxY)
                        ),
                        room: ownRoom
                    )
                )
            }
        }

        if includeAllRooms {
            for room in floorLayout.rooms {
                let roam = room.rect.insetBy(dx: 0.07, dy: 0.08)
                guard roam.width > 0.05, roam.height > 0.05 else { continue }
                zones.append(
                    WalkTarget(
                        point: CGPoint(
                            x: .random(in: roam.minX...roam.maxX),
                            y: .random(in: roam.minY...roam.maxY)
                        ),
                        room: room
                    )
                )
            }
        }

        if let pick = zones.randomElement() {
            return pick
        }
        return WalkTarget(point: clampedToCommon(entryPoint, inset: 0.14), room: nil)
    }

    private func randomWalkTarget() -> WalkTarget {
        var zones: [WalkTarget] = []

        let common = floorLayout.commonRect.insetBy(dx: 0.07, dy: 0.08)
        if common.width > 0.05, common.height > 0.05 {
            zones.append(
                WalkTarget(
                    point: CGPoint(
                        x: .random(in: common.minX...common.maxX),
                        y: .random(in: common.minY...common.maxY)
                    ),
                    room: nil
                )
            )
        }

        for room in floorLayout.rooms {
            let roam = room.rect.insetBy(dx: 0.07, dy: 0.08)
            guard roam.width > 0.05, roam.height > 0.05 else { continue }
            zones.append(
                WalkTarget(
                    point: CGPoint(
                        x: .random(in: roam.minX...roam.maxX),
                        y: .random(in: roam.minY...roam.maxY)
                    ),
                    room: room
                )
            )
        }

        if let pick = zones.randomElement() {
            return pick
        }
        return WalkTarget(point: clampedToCommon(entryPoint), room: nil)
    }

    private func furnitureAvoidRects() -> [CGRect] {
        let anchors = floorLayout.furniture
        return [
            CGRect(x: anchors.tv.x - 0.056, y: anchors.tv.y - 0.034, width: 0.112, height: 0.068),
            CGRect(x: anchors.alarm.x - 0.022, y: anchors.alarm.y - 0.018, width: 0.044, height: 0.036),
            CGRect(x: anchors.worldAlarm.x - 0.022, y: anchors.worldAlarm.y - 0.018, width: 0.044, height: 0.036),
            CGRect(x: anchors.bulletin.x - 0.028, y: anchors.bulletin.y - 0.036, width: 0.056, height: 0.072)
        ]
    }

    private func collidesFurniture(_ point: CGPoint) -> Bool {
        furnitureAvoidRects().contains(where: { $0.contains(point) })
    }

    private func collidesAvatarSpace(_ point: CGPoint, for movingMemberID: UUID) -> Bool {
        let awakeDistanceSq: CGFloat = 0.096 * 0.096
        let sleepingDistanceSq: CGFloat = 0.088 * 0.088

        for member in members where member.id != movingMemberID {
            if member.status == .awake {
                if distanceSquared(point, member.position) < awakeDistanceSq {
                    return true
                }
            } else if let slot = bedSlot(for: member.id) {
                if distanceSquared(point, slot.bedPoint) < sleepingDistanceSq {
                    return true
                }
            }
        }
        return false
    }

    private func collidesBedSpace(_ point: CGPoint) -> Bool {
        let bedDistanceSq: CGFloat = 0.098 * 0.098
        for slot in activeBedroomSlots {
            if distanceSquared(point, slot.bedPoint) < bedDistanceSq {
                return true
            }
        }
        return false
    }

    private func isInsideFloorOutline(_ point: CGPoint) -> Bool {
        let polygon = floorLayout.outlinePoints
        guard polygon.count > 2 else { return false }
        var inside = false
        var j = polygon.count - 1
        for i in 0..<polygon.count {
            let pi = polygon[i]
            let pj = polygon[j]
            let intersects = ((pi.y > point.y) != (pj.y > point.y))
                && (point.x < (pj.x - pi.x) * (point.y - pi.y) / max(0.000001, (pj.y - pi.y)) + pi.x)
            if intersects {
                inside.toggle()
            }
            j = i
        }
        return inside
    }

    private func pickWanderTarget(
        memberID: UUID,
        from start: CGPoint,
        startRoom: FloorRoom?
    ) -> WalkTarget {
        let isMe = members.first(where: { $0.id == memberID })?.isMe == true
        let last = lastWanderTargetByID[memberID]
        let minMoveDistanceSq: CGFloat = 0.035 * 0.035

        var fallback = randomWalkTarget(
            for: memberID,
            includeAllRooms: false,
            includeCommon: isMe
        )
        for _ in 0..<10 {
            let includeAllRooms = Int.random(in: 0..<100) < 48
            let includeCommon = true
            let candidate = randomWalkTarget(
                for: memberID,
                includeAllRooms: includeAllRooms,
                includeCommon: includeCommon
            )
            if collidesFurniture(candidate.point) {
                continue
            }
            if collidesBedSpace(candidate.point) {
                continue
            }
            if collidesAvatarSpace(candidate.point, for: memberID) {
                continue
            }
            let distanceNow = distanceSquared(start, candidate.point)
            if distanceNow < minMoveDistanceSq {
                continue
            }
            if let last, distanceSquared(last, candidate.point) < minMoveDistanceSq {
                continue
            }
            if let room = startRoom,
               let endRoom = candidate.room,
               room.id == endRoom.id,
               distanceNow < (0.06 * 0.06) {
                continue
            }
            return candidate
        }

        if distanceSquared(start, fallback.point) < minMoveDistanceSq {
            fallback = randomWalkTarget(
                for: memberID,
                includeAllRooms: false,
                includeCommon: true
            )
        }
        if collidesFurniture(fallback.point) {
            fallback = randomWalkTarget(
                for: memberID,
                includeAllRooms: false,
                includeCommon: true
            )
        }
        if collidesBedSpace(fallback.point) {
            fallback = randomWalkTarget(
                for: memberID,
                includeAllRooms: false,
                includeCommon: false
            )
        }
        if collidesAvatarSpace(fallback.point, for: memberID) {
            fallback = randomWalkTarget(
                for: memberID,
                includeAllRooms: false,
                includeCommon: false
            )
        }
        return fallback
    }

    private func routeBetween(
        start: CGPoint,
        startRoom: FloorRoom?,
        end: CGPoint,
        endRoom: FloorRoom?
    ) -> [CGPoint] {
        let resolvedStartRoom = startRoom ?? roomContaining(start)
        let resolvedEndRoom = endRoom ?? roomContaining(end)

        let roomInset: CGFloat = 0.09
        let commonInset: CGFloat = 0.09
        let cleanStart = resolvedStartRoom == nil
            ? clampedToCommon(start, inset: commonInset)
            : clampedToRoom(start, room: resolvedStartRoom!.rect, inset: roomInset)
        let cleanEnd = resolvedEndRoom == nil
            ? clampedToCommon(end, inset: commonInset)
            : clampedToRoom(end, room: resolvedEndRoom!.rect, inset: roomInset)

        if let s = resolvedStartRoom, let e = resolvedEndRoom, s.id == e.id {
            let sameRoomRoute = simplifyRoute(compactRoute([cleanStart, cleanEnd]))
            if routeCrossesFurniture(sameRoomRoute) {
                return simplifyRoute(compactRoute(rerouteThroughCommonLane(sameRoomRoute)))
            }
            return sameRoomRoute
        }

        var route: [CGPoint] = [cleanStart]

        if let s = resolvedStartRoom {
            let roomDoor = s.door.point(in: s.rect, inset: roomInset)
            let commonDoor = commonDoorPoint(for: s, inset: roomInset)
            route.append(CGPoint(x: cleanStart.x, y: roomDoor.y))
            route.append(roomDoor)
            route.append(commonDoor)
        }

        if let e = resolvedEndRoom {
            let targetCommonDoor = commonDoorPoint(for: e, inset: roomInset)
            if let last = route.last {
                route.append(CGPoint(x: targetCommonDoor.x, y: last.y))
            }
            route.append(targetCommonDoor)
            let targetRoomDoor = e.door.point(in: e.rect, inset: roomInset)
            route.append(targetRoomDoor)
            route.append(CGPoint(x: cleanEnd.x, y: targetRoomDoor.y))
        } else {
            if let last = route.last {
                route.append(CGPoint(x: cleanEnd.x, y: last.y))
            }
        }

        route.append(cleanEnd)
        let baseRoute = simplifyRoute(compactRoute(route))
        if routeLeavesWalkableArea(baseRoute) {
            return simplifyRoute(compactRoute(rerouteThroughCommonLane(baseRoute)))
        }
        return baseRoute
    }

    private func routeCrossesFurniture(_ route: [CGPoint]) -> Bool {
        guard route.count > 1 else { return false }
        for idx in 0..<(route.count - 1) {
            if segmentIntersectsFurniture(from: route[idx], to: route[idx + 1]) {
                return true
            }
        }
        return false
    }

    private func routeLeavesWalkableArea(_ route: [CGPoint]) -> Bool {
        guard route.count > 1 else { return false }
        for idx in 0..<(route.count - 1) {
            let sampled = sampledRoute([route[idx], route[idx + 1]], stepLength: 0.01)
            if sampled.contains(where: { !isPointWalkable($0) }) {
                return true
            }
        }
        return false
    }

    private func segmentIntersectsFurniture(from: CGPoint, to: CGPoint) -> Bool {
        sampledRoute([from, to], stepLength: 0.01).contains { point in
            collidesFurniture(point)
        }
    }

    private func rerouteThroughCommonLane(_ route: [CGPoint]) -> [CGPoint] {
        guard route.count > 1 else { return route }
        let common = floorLayout.commonRect
        let laneX = common.minX + min(common.width * 0.16, 0.12)
        let lowerY = common.minY + 0.08
        let upperY = common.maxY - 0.08

        var redirected: [CGPoint] = [route[0]]
        for point in route.dropFirst() {
            guard let last = redirected.last else { continue }
            if segmentIntersectsFurniture(from: last, to: point) {
                redirected.append(
                    CGPoint(
                        x: laneX,
                        y: clamp(last.y, lower: lowerY, upper: upperY)
                    )
                )
                redirected.append(
                    CGPoint(
                        x: laneX,
                        y: clamp(point.y, lower: lowerY, upper: upperY)
                    )
                )
            }
            redirected.append(point)
        }
        return redirected
    }

    private func compactRoute(_ route: [CGPoint], epsilon: CGFloat = 0.003) -> [CGPoint] {
        guard !route.isEmpty else { return [] }
        var compacted: [CGPoint] = [route[0]]
        for point in route.dropFirst() {
            if distanceSquared(point, compacted.last!) > (epsilon * epsilon) {
                compacted.append(point)
            }
        }
        return compacted
    }

    private func simplifyRoute(_ route: [CGPoint], epsilon: CGFloat = 0.0015) -> [CGPoint] {
        guard !route.isEmpty else { return [] }
        var result: [CGPoint] = []

        func isBetween(_ value: CGFloat, _ a: CGFloat, _ b: CGFloat, tol: CGFloat) -> Bool {
            value >= min(a, b) - tol && value <= max(a, b) + tol
        }

        for point in route {
            result.append(point)

            while result.count >= 3 {
                let c = result[result.count - 1]
                let b = result[result.count - 2]
                let a = result[result.count - 3]

                if distanceSquared(a, c) <= (epsilon * epsilon) {
                    result.remove(at: result.count - 2)
                    continue
                }

                let horizontal = abs(a.y - b.y) <= epsilon && abs(b.y - c.y) <= epsilon
                let vertical = abs(a.x - b.x) <= epsilon && abs(b.x - c.x) <= epsilon

                if horizontal || vertical {
                    let middleOnSegment = isBetween(b.x, a.x, c.x, tol: epsilon) && isBetween(b.y, a.y, c.y, tol: epsilon)
                    if middleOnSegment {
                        result.remove(at: result.count - 2)
                        continue
                    }
                }
                break
            }
        }

        return result
    }

    private func sampledRoute(_ route: [CGPoint], stepLength: CGFloat) -> [CGPoint] {
        guard route.count > 1 else { return route }
        var points: [CGPoint] = [route[0]]
        for i in 0..<(route.count - 1) {
            let a = route[i]
            let b = route[i + 1]
            let dx = b.x - a.x
            let dy = b.y - a.y
            let distance = sqrt((dx * dx) + (dy * dy))
            let steps = max(1, Int(ceil(distance / stepLength)))
            for s in 1...steps {
                let t = CGFloat(s) / CGFloat(steps)
                points.append(CGPoint(x: a.x + (dx * t), y: a.y + (dy * t)))
            }
        }
        return points
    }

    private func moveMember(
        memberID: UUID,
        along route: [CGPoint],
        movingActivity: String,
        speedPerSecond: CGFloat = 0.1,
        completion: (() -> Void)? = nil
    ) {
        let points = compactRoute(route, epsilon: 0.0015)
        guard points.count > 1 else {
            completion?()
            return
        }

        let token = UUID()
        movementTokenByID[memberID] = token

        func step(_ index: Int) {
            guard movementTokenByID[memberID] == token else { return }
            guard let memberIndex = members.firstIndex(where: { $0.id == memberID }) else {
                movementTokenByID[memberID] = nil
                return
            }
            guard members[memberIndex].status == .awake else {
                movementTokenByID[memberID] = nil
                completion?()
                return
            }

            if index >= points.count {
                movementTokenByID[memberID] = nil
                completion?()
                return
            }

            let current = members[memberIndex].position
            let target = nearestWalkablePoint(to: points[index])
            let distance = sqrt(distanceSquared(current, target))
            let duration = max(0.03, distance / speedPerSecond)

            if members[memberIndex].status == .awake {
                members[memberIndex].activity = movingActivity
            }

            withAnimation(.linear(duration: duration)) {
                members[memberIndex].position = target
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                step(index + 1)
            }
        }

        step(1)
    }

    private func clampedToRoom(_ point: CGPoint, room: CGRect, inset: CGFloat = 0.115) -> CGPoint {
        let capInset = min(inset, min(room.width, room.height) * 0.32)
        return CGPoint(
            x: clamp(point.x, lower: room.minX + capInset, upper: room.maxX - capInset),
            y: clamp(point.y, lower: room.minY + capInset, upper: room.maxY - capInset)
        )
    }

    private func clampedToFloor(_ point: CGPoint) -> CGPoint {
        return CGPoint(
            x: clamp(point.x, lower: floorPlanBounds.minX + 0.03, upper: floorPlanBounds.maxX - 0.03),
            y: clamp(point.y, lower: floorPlanBounds.minY + 0.03, upper: floorPlanBounds.maxY - 0.03)
        )
    }

    private func clampedToCommon(_ point: CGPoint, inset: CGFloat = 0.115) -> CGPoint {
        let capInset = min(inset, min(floorLayout.commonRect.width, floorLayout.commonRect.height) * 0.32)
        return CGPoint(
            x: clamp(point.x, lower: floorLayout.commonRect.minX + capInset, upper: floorLayout.commonRect.maxX - capInset),
            y: clamp(point.y, lower: floorLayout.commonRect.minY + capInset, upper: floorLayout.commonRect.maxY - capInset)
        )
    }

    private func commonDoorPoint(for room: FloorRoom, inset: CGFloat) -> CGPoint {
        let door = room.door.point(in: room.rect, inset: inset)
        let commonCenter = CGPoint(x: floorLayout.commonRect.midX, y: floorLayout.commonRect.midY)
        let dx = commonCenter.x - door.x
        let dy = commonCenter.y - door.y
        let length = max(0.0001, sqrt((dx * dx) + (dy * dy)))
        let step: CGFloat = 0.032
        let nudged = CGPoint(
            x: door.x + (dx / length) * step,
            y: door.y + (dy / length) * step
        )
        return clampedToCommon(nudged, inset: 0.055)
    }

    private func mapPoint(_ normalized: CGPoint, in size: CGSize) -> CGPoint {
        CGPoint(
            x: normalized.x * size.width,
            y: (normalized.y / mapUnitHeight) * size.height
        )
    }

    private func centeredFloorBaseOffset(for world: CGSize, viewport: CGSize, scale: CGFloat) -> CGSize {
        let floorCenterX = floorPlanBounds.midX * world.width
        let floorCenterY = (floorPlanBounds.midY / mapUnitHeight) * world.height
        let worldCenterX = world.width * 0.5
        let worldCenterY = world.height * 0.5
        let scaledCenterX = worldCenterX + ((floorCenterX - worldCenterX) * scale)
        let scaledCenterY = worldCenterY + ((floorCenterY - worldCenterY) * scale)
        return CGSize(
            width: (viewport.width * 0.5) - scaledCenterX,
            height: (viewport.height * 0.5) - scaledCenterY
        )
    }

    private func clampedMapOffset(
        _ offset: CGSize,
        viewport: CGSize,
        world: CGSize,
        fitScale: CGFloat,
        zoom: CGFloat
    ) -> CGSize {
        let floorWidth = floorPlanBounds.width * world.width
        let floorHeight = (floorPlanBounds.height / mapUnitHeight) * world.height
        let scaledWidth = floorWidth * fitScale * zoom
        let scaledHeight = floorHeight * fitScale * zoom
        // Keep generous pan bounds so users can freely drag around like a map.
        let extraPanX = viewport.width * 0.65
        let extraPanY = viewport.height * 0.65
        let maxX = max((scaledWidth - viewport.width) * 0.5 + extraPanX, extraPanX)
        let maxY = max((scaledHeight - viewport.height) * 0.5 + extraPanY, extraPanY)
        return CGSize(
            width: clamp(offset.width, lower: -maxX, upper: maxX),
            height: clamp(offset.height, lower: -maxY, upper: maxY)
        )
    }

    private func dragGesture(viewport: CGSize, world: CGSize, fitScale: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 1)
            .updating($mapDrag) { value, state, _ in
                state = value.translation
            }
            .onEnded { value in
                let proposed = CGSize(
                    width: mapOffset.width + value.translation.width,
                    height: mapOffset.height + value.translation.height
                )
                mapOffset = clampedMapOffset(
                    proposed,
                    viewport: viewport,
                    world: world,
                    fitScale: fitScale,
                    zoom: mapZoom
                )
            }
    }

    private func magnificationGesture(viewport: CGSize, world: CGSize, fitScale: CGFloat) -> some Gesture {
        MagnificationGesture(minimumScaleDelta: 0.01)
            .updating($mapPinch) { value, state, _ in
                state = value
            }
            .onEnded { value in
                mapZoom = clamp(mapZoom * value, lower: minMapZoom, upper: maxMapZoom)
                mapOffset = clampedMapOffset(
                    mapOffset,
                    viewport: viewport,
                    world: world,
                    fitScale: fitScale,
                    zoom: mapZoom
                )
            }
    }

    private func isOverdue(_ member: FamilyMember) -> Bool {
        guard member.status == .sleeping else { return false }
        guard let schedule = wakeTime(for: member) else { return false }

        let calendar = Calendar.current
        guard let wakeTimeToday = calendar.date(
            bySettingHour: schedule.hour,
            minute: schedule.minute,
            second: 0,
            of: now
        ) else {
            return false
        }

        return now >= wakeTimeToday
    }

    private func formatWakeTime(_ member: FamilyMember) -> String {
        guard let schedule = wakeTime(for: member) else {
            return "No alarm"
        }
        return String(format: "%02d:%02d", schedule.hour, schedule.minute)
    }

    private func wakeTime(for member: FamilyMember) -> WakeSchedule? {
        if member.isMe {
            guard let alarm = nearestAlarm else { return nil }
            return WakeSchedule(hour: alarm.hour, minute: alarm.minute)
        }
        return member.wakeSchedule
    }

    private func wakeMinutes(for member: FamilyMember) -> Int? {
        guard let schedule = wakeTime(for: member) else { return nil }
        return schedule.hour * 60 + schedule.minute
    }

    private func openAddMemberSheet() {
        memberEditorMode = .add
        memberEditorDraft = MemberEditorDraft(
            name: "",
            shape: .roundedSquare,
            colorHex: FamilySample.editableColorHexes.first ?? 0x42B9BB
        )
        showMemberEditorSheet = true
    }

    private func openMyAvatarEditor() {
        guard let me = members.first(where: { $0.isMe }) else { return }
        memberEditorMode = .editMe
        memberEditorDraft = MemberEditorDraft(
            name: me.name,
            shape: me.avatar.bodyShape,
            colorHex: me.avatar.fillHex
        )
        showMemberEditorSheet = true
    }

    private func resetMemberEditorDraft() {
        memberEditorDraft = MemberEditorDraft(
            name: "",
            shape: .roundedSquare,
            colorHex: FamilySample.editableColorHexes.first ?? 0x42B9BB
        )
    }

    private func makeAvatarTheme(shape: AvatarBodyShape, colorHex: Int, defaultFace: AvatarFaceStyle) -> AvatarTheme {
        AvatarTheme(
            id: "custom-\(UUID().uuidString.prefix(8))",
            fillHex: colorHex,
            bodyShape: shape,
            faceStyle: defaultFace
        )
    }

    private func seedWorldSleepersIfNeeded() {
        guard worldSleepers.isEmpty else { return }
        worldSleepers = makeWorldSleeperSamples()
    }

    private func makeWorldSleeperSamples() -> [WorldSleeper] {
        let samples: [(String, String, Int)] = [
            ("Luca", "IT", 18),
            ("Mina", "KR", 12),
            ("Noah", "US", 7),
            ("Aya", "JP", 25),
            ("Lena", "DE", 9),
            ("Rui", "BR", 14),
            ("Eli", "FR", 11)
        ]

        let picks = Array(samples.shuffled().prefix(Int.random(in: 3...5)))
        var result = picks.map { sample in
            WorldSleeper(
                id: UUID(),
                name: sample.0,
                country: sample.1,
                lateMinutes: sample.2,
                isAwake: false,
                avatarHex: FamilySample.editableColorHexes.randomElement() ?? 0x45BFC0
            )
        }
        if result.allSatisfy({ $0.isAwake || $0.lateMinutes <= 0 }),
           let first = result.indices.first {
            result[first].isAwake = false
            result[first].lateMinutes = 16
        }
        return result
    }

    private func sendWakeDraft(draft: WakeComposeDraft, message: String) {
        switch draft.target {
        case .family(let memberID):
            if !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                wakeBanner = "Late alarm sent to \(draft.targetTitle)."
                clearBannerLater()
            }
            performWake(memberID: memberID)
        case .world(let worldID):
            guard let index = worldSleepers.firstIndex(where: { $0.id == worldID }) else { return }
            worldSleepers[index].isAwake = true
            worldSleepers[index].lateMinutes = 0
            wakeBanner = "Late alarm sent to \(worldSleepers[index].name)."
            clearBannerLater()
        }
    }

    private func resetComposeStateAfterDismiss() {
        wakeComposeDraft = nil
        wakeComposeMessage = ""
        if let meIndex = members.firstIndex(where: { $0.isMe }),
           members[meIndex].status == .awake {
            members[meIndex].activity = "Walking"
            startWanderIfIdle(memberID: members[meIndex].id)
        }
    }

    private func clamp(_ value: CGFloat, lower: CGFloat, upper: CGFloat) -> CGFloat {
        min(max(value, lower), upper)
    }
}

private struct BedroomSlot: Identifiable {
    let id: Int
    let roomID: Int
    let roomRect: CGRect
    let door: RoomDoor
    let doorPoint: CGPoint
    let bedPoint: CGPoint
    let roamRect: CGRect
    let isLeftColumn: Bool
    let bedOrientation: BedOrientation
}

private enum BedOrientation {
    case horizontal
    case vertical
}

private struct WakeMission {
    let targetID: UUID
}

private enum MemberEditorMode {
    case add
    case editMe

    var title: String {
        switch self {
        case .add: return "Add Member"
        case .editMe: return "Edit Profile"
        }
    }

    var confirmTitle: String {
        switch self {
        case .add: return "Add"
        case .editMe: return "Save"
        }
    }
}

private struct MemberEditorDraft {
    var name: String
    var shape: AvatarBodyShape
    var colorHex: Int
}

private struct WorldSleeper: Identifiable, Equatable {
    let id: UUID
    var name: String
    var country: String
    var lateMinutes: Int
    var isAwake: Bool
    var avatarHex: Int
}

private enum WakeTarget: Equatable {
    case family(memberID: UUID)
    case world(worldID: UUID)
}

private enum FurnitureActionTarget {
    case bulletin
    case alarm
    case worldAlarm
}

private struct WakeComposeDraft: Identifiable, Equatable {
    let id = UUID()
    let target: WakeTarget
    let targetTitle: String
}

private struct FurnitureAnchors {
    let bulletin: CGPoint
    let tv: CGPoint
    let alarm: CGPoint
    let worldAlarm: CGPoint
}

private enum DoorEdge {
    case left
    case right
    case top
    case bottom
}

private struct RoomDoor {
    let edge: DoorEdge
    let center: CGFloat
    let width: CGFloat

    func point(in rect: CGRect, inset: CGFloat = 0.095) -> CGPoint {
        switch edge {
        case .left:
            return CGPoint(x: rect.minX + inset, y: center)
        case .right:
            return CGPoint(x: rect.maxX - inset, y: center)
        case .top:
            return CGPoint(x: center, y: rect.minY + inset)
        case .bottom:
            return CGPoint(x: center, y: rect.maxY - inset)
        }
    }
}

private struct FloorRoom: Identifiable {
    let id: Int
    let rect: CGRect
    let door: RoomDoor
    let washIndex: Int
}

private struct FloorLayout {
    let planHeight: CGFloat
    let floorBounds: CGRect
    let commonRect: CGRect
    let rooms: [FloorRoom]
    let slots: [BedroomSlot]
    let outlinePoints: [CGPoint]
    let furniture: FurnitureAnchors
    let innerWalls: [InnerWallSegment]
}

private struct InnerWallSegment {
    let start: CGPoint
    let end: CGPoint
}

private struct FamilySceneHeader: View {
    let onAddTap: () -> Void
    let onEditMeTap: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Text("Sleepy Family")
                .font(AppTypography.pixel(16, weight: .semibold))
                .foregroundStyle(AppPalette.inkPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: AppRadius.control, style: .continuous)
                        .fill(AppPalette.blockGray)
                )

            Button {
                onEditMeTap()
            } label: {
                Text("Edit Me")
                    .font(AppTypography.pixel(15, weight: .semibold))
                    .foregroundStyle(AppPalette.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: AppRadius.control, style: .continuous)
                            .fill(AppPalette.accentBlue)
                    )
            }
            .buttonStyle(.plain)

            Button {
                onAddTap()
            } label: {
                Text("Add Member")
                    .font(AppTypography.pixel(15, weight: .semibold))
                    .foregroundStyle(AppPalette.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: AppRadius.control, style: .continuous)
                            .fill(AppPalette.vibrantOrange)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 2)
    }
}

private struct PixelHeaderIcon: View {
    enum Kind {
        case person
        case plus
    }

    let kind: Kind

    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height

            ZStack {
                switch kind {
                case .person:
                    Rectangle()
                        .fill(AppPalette.inkPrimary)
                        .frame(width: w * 0.34, height: h * 0.34)
                        .offset(y: -h * 0.24)
                    Rectangle()
                        .fill(AppPalette.inkPrimary)
                        .frame(width: w * 0.62, height: h * 0.38)
                        .offset(y: h * 0.24)
                case .plus:
                    Rectangle()
                        .fill(AppPalette.white)
                        .frame(width: w * 0.78, height: h * 0.16)
                    Rectangle()
                        .fill(AppPalette.white)
                        .frame(width: w * 0.16, height: h * 0.78)
                }
            }
            .drawingGroup(opaque: false)
        }
    }
}

private struct RoomFurnitureLayer: View {
    let layout: FloorLayout
    let awakeCount: Int
    let sleepingCount: Int
    let lateCount: Int
    let onBoardTap: () -> Void
    let onAlarmTap: () -> Void
    let onWorldAlarmTap: () -> Void

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let mapY: (CGFloat) -> CGFloat = { y in (y / layout.planHeight) * size.height }
            let tvAnchor = layout.furniture.tv
            let alarmAnchor = layout.furniture.alarm
            let worldAnchor = layout.furniture.worldAlarm
            let boardAnchor = layout.furniture.bulletin
            let rightMinY = mapY(layout.commonRect.minY) + 34
            let rightMaxY = mapY(layout.commonRect.maxY) - 26
            let desiredRight = [mapY(alarmAnchor.y), mapY(worldAnchor.y), mapY(boardAnchor.y)]
            let rightY = clampedVerticalLayout(
                desired: desiredRight,
                minY: rightMinY,
                maxY: rightMaxY,
                minGap: 80
            )

            ZStack {
                VStack(spacing: 2) {
                    TVObject(
                        awakeCount: awakeCount,
                        sleepingCount: sleepingCount,
                        lateCount: lateCount
                    )
                    furnitureLabel("TV")
                }
                .position(
                    x: size.width * tvAnchor.x,
                    y: mapY(tvAnchor.y)
                )

                VStack(spacing: 2) {
                    AlarmClockObject(onTap: onAlarmTap)
                    furnitureLabel("Alarm")
                }
                .position(
                    x: size.width * alarmAnchor.x,
                    y: rightY[0]
                )

                VStack(spacing: 2) {
                    WorldAlarmObject(onTap: onWorldAlarmTap)
                    furnitureLabel("World Alarm")
                }
                .position(
                    x: size.width * worldAnchor.x,
                    y: rightY[1]
                )

                VStack(spacing: 2) {
                    BulletinBoardObject(onTap: onBoardTap)
                    furnitureLabel("Bulletin")
                }
                .position(
                    x: size.width * boardAnchor.x,
                    y: rightY[2]
                )
            }
        }
    }

    private func clampedVerticalLayout(
        desired: [CGFloat],
        minY: CGFloat,
        maxY: CGFloat,
        minGap: CGFloat
    ) -> [CGFloat] {
        guard !desired.isEmpty else { return [] }
        let neededSpan = minGap * CGFloat(max(0, desired.count - 1))
        let highestStart = max(minY, maxY - neededSpan)
        let start = min(max(desired[0], minY), highestStart)
        return desired.indices.map { index in
            start + CGFloat(index) * minGap
        }
    }

    private func furnitureLabel(_ title: String) -> some View {
        Text(title)
            .font(AppTypography.pixel(10, weight: .semibold))
            .foregroundStyle(AppPalette.inkPrimary)
            .padding(.horizontal, 7)
            .padding(.vertical, 2.5)
            .background(
                Capsule()
                    .fill(AppPalette.white)
            )
    }
}

private struct PixelRugDecor: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(AppPalette.flatShadow.opacity(0.55))
                .frame(width: 116, height: 42)
                .offset(x: 3, y: 3)

            Rectangle()
                .fill(AppPalette.roomMistBlue.opacity(0.75))
                .frame(width: 116, height: 42)
                .overlay(
                    Rectangle()
                        .stroke(AppPalette.inkPrimary.opacity(0.75), lineWidth: AppStroke.standard)
                )

            HStack(spacing: 6) {
                ForEach(0..<8, id: \.self) { _ in
                    Rectangle()
                        .fill(AppPalette.roomFloor.opacity(0.85))
                        .frame(width: 8, height: 4)
                }
            }
            .offset(y: 9)
        }
        .frame(width: 126, height: 52)
    }
}

private struct PixelPlantDecor: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(AppPalette.flatShadow.opacity(0.4))
                .frame(width: 34, height: 5)
                .offset(y: 16)

            Rectangle()
                .fill(AppPalette.roomCoral.opacity(0.92))
                .frame(width: 20, height: 12)
                .overlay(
                    Rectangle()
                        .stroke(AppPalette.inkPrimary, lineWidth: AppStroke.standard)
                )
                .offset(y: 8)

            HStack(spacing: 3) {
                Rectangle().fill(AppPalette.punchGreen).frame(width: 5, height: 14)
                Rectangle().fill(AppPalette.punchGreen).frame(width: 5, height: 18)
                Rectangle().fill(AppPalette.punchGreen).frame(width: 5, height: 13)
            }
            .offset(y: -3)
        }
        .frame(width: 34, height: 34)
    }
}

private struct PixelCrateDecor: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(AppPalette.flatShadow.opacity(0.42))
                .frame(width: 34, height: 5)
                .offset(y: 16)

            Rectangle()
                .fill(AppPalette.roomMustard.opacity(0.9))
                .frame(width: 28, height: 20)
                .overlay(
                    Rectangle()
                        .stroke(AppPalette.inkPrimary, lineWidth: AppStroke.standard)
                )

            Rectangle()
                .fill(AppPalette.roomFloor.opacity(0.8))
                .frame(width: 20, height: 2)
                .offset(y: -3)
        }
        .frame(width: 34, height: 34)
    }
}

private struct BulletinBoardObject: View {
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(AppPalette.flatShadow)
                    .frame(width: 56, height: 74)
                    .offset(x: 2, y: 2)

                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(AppPalette.boardWood)
                    .frame(width: 58, height: 76)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(AppPalette.roomBoundary, lineWidth: AppStroke.subtle)
                    )

                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(AppPalette.boardPaper)
                    .frame(width: 41, height: 50)

                Capsule()
                    .fill(AppPalette.roomTeal.opacity(0.9))
                    .frame(width: 24, height: 8.5)
                    .offset(x: -6, y: -16)

                Capsule()
                    .fill(AppPalette.roomMustard.opacity(0.9))
                    .frame(width: 19, height: 8.5)
                    .offset(x: 8, y: 1.5)

                Capsule()
                    .fill(AppPalette.accentPrimary.opacity(0.85))
                    .frame(width: 17, height: 7.5)
                    .offset(y: 18)
            }
            .frame(width: 66, height: 82)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Ranking Board")
    }
}

private struct TVObject: View {
    let awakeCount: Int
    let sleepingCount: Int
    let lateCount: Int

    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppPalette.flatShadow)
                .frame(width: 120, height: 76)
                .offset(x: 3, y: 3)

            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(AppPalette.alarmShell)
                .frame(width: 120, height: 76)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(AppPalette.roomBoundary, lineWidth: AppStroke.subtle)
                )

            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppPalette.tvScreen)
                .frame(width: 92, height: 48)
                .overlay {
                    VStack(spacing: 4) {
                        statusChip(title: "Awake", value: awakeCount, tone: AppPalette.statusAwake)
                        statusChip(title: "Sleep", value: sleepingCount, tone: AppPalette.statusSleep)
                        statusChip(title: "Late", value: lateCount, tone: AppPalette.statusLate)
                    }
                    .padding(.vertical, 4)
                }
                .offset(y: -6)

            Path { path in
                path.move(to: CGPoint(x: 22, y: 12))
                path.addLine(to: CGPoint(x: 10, y: 0))
                path.move(to: CGPoint(x: 22, y: 12))
                path.addLine(to: CGPoint(x: 34, y: 0))
            }
            .stroke(AppPalette.roomBoundary, lineWidth: AppStroke.subtle)
            .frame(width: 44, height: 12)
            .offset(y: -80)
            .zIndex(5)
        }
        .frame(width: 124, height: 84)
    }

    private func statusChip(title: String, value: Int, tone: Color) -> some View {
        Text("\(title) \(value)")
            .font(AppTypography.pixel(9.4, weight: .semibold))
            .foregroundStyle(AppPalette.inkPrimary)
            .lineLimit(1)
            .minimumScaleFactor(0.9)
            .frame(width: 80, height: 14)
            .background(
                Capsule()
                    .fill(tone)
            )
    }
}

private struct AlarmClockObject: View {
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(AppPalette.flatShadow)
                    .frame(width: 46, height: 6)
                    .offset(y: 16)

                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(AppPalette.alarmShell)
                    .frame(width: 43, height: 34)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(AppPalette.roomBoundary, lineWidth: AppStroke.standard)
                    )

                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(AppPalette.white)
                    .frame(width: 24, height: 17)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(AppPalette.roomBoundary, lineWidth: AppStroke.standard)
                    )
                    .overlay {
                        Capsule()
                            .fill(AppPalette.inkPrimary)
                            .frame(width: 3.4, height: 9.5)
                            .offset(y: -3.2)
                        Capsule()
                            .fill(AppPalette.inkPrimary)
                            .frame(width: 9.5, height: 3.4)
                            .offset(x: 4, y: 1.5)
                    }
                    .offset(y: 0.6)

                HStack(spacing: 19) {
                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .fill(AppPalette.roomMustard.opacity(0.86))
                        .frame(width: 5.4, height: 3.6)
                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .fill(AppPalette.roomMustard.opacity(0.86))
                        .frame(width: 5.4, height: 3.6)
                }
                .offset(y: -14.5)
            }
            .frame(width: 53, height: 43)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Open Wake Schedule")
    }
}

private struct WorldAlarmObject: View {
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(AppPalette.alarmShell)
                    .frame(width: 43, height: 34)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(AppPalette.blockOrange, lineWidth: AppStroke.standard)
                    )

                Image(systemName: "clock")
                    .font(AppTypography.pixel(16, weight: .bold))
                    .foregroundStyle(AppPalette.inkPrimary)
            }
            .frame(width: 53, height: 43)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Open World Alarm")
    }
}

private struct RoomBackground: View {
    let layout: FloorLayout
    private let wallLineWidth: CGFloat = AppStroke.standard + 0.4
    private let innerWallLineWidth: CGFloat = AppStroke.standard + 0.4

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let mainOutline = floorOutlinePath(in: size)

            ZStack {
                mainOutline
                    .fill(AppPalette.roomFloor)

                ForEach(layout.rooms) { room in
                    RoundedRectangle(cornerRadius: AppRadius.room, style: .continuous)
                        .path(in: normalizedRect(room.rect, in: size))
                        .fill(AppPalette.roomWall.opacity(0.95))
                }

                innerWallsPath(in: size)
                    .stroke(
                        AppPalette.roomBoundary,
                        style: StrokeStyle(
                            lineWidth: innerWallLineWidth,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )

                mainOutline
                    .stroke(
                        AppPalette.roomBoundary,
                        style: StrokeStyle(
                            lineWidth: wallLineWidth,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
            }
        }
    }

    private func normalizedY(_ y: CGFloat, in size: CGSize) -> CGFloat {
        (y / layout.planHeight) * size.height
    }

    private func normalizedRect(_ rect: CGRect, in size: CGSize) -> CGRect {
        CGRect(
            x: rect.minX * size.width,
            y: normalizedY(rect.minY, in: size),
            width: rect.width * size.width,
            height: (rect.height / layout.planHeight) * size.height
        )
    }

    private func floorOutlinePath(in size: CGSize) -> Path {
        roundedClosedPath(points: normalizedOutlinePoints(in: size), radius: AppRadius.room)
    }

    private func normalizedOutlinePoints(in size: CGSize) -> [CGPoint] {
        var points = layout.outlinePoints.map { point($0, in: size) }
        if points.count > 1, pointDistanceSquared(points.first!, points.last!) < 0.5 {
            points.removeLast()
        }
        return sanitizedOrthogonalPoints(points)
    }

    private struct LineSegment {
        let horizontal: Bool
        let fixed: CGFloat
        let start: CGFloat
        let end: CGFloat
    }

    private struct AxisInterval {
        let start: CGFloat
        let end: CGFloat

        var normalized: AxisInterval {
            AxisInterval(start: min(start, end), end: max(start, end))
        }
    }

    private struct BoundaryKey: Hashable {
        let horizontal: Bool
        let fixedQuantized: Int

        var fixed: CGFloat { CGFloat(fixedQuantized) / 10_000.0 }

        init(horizontal: Bool, fixed: CGFloat) {
            self.horizontal = horizontal
            self.fixedQuantized = Int((fixed * 10_000.0).rounded())
        }
    }

    private func innerWallsPath(in size: CGSize) -> Path {
        var path = Path()
        if !layout.innerWalls.isEmpty {
            let pixelSegments: [(CGPoint, CGPoint)] = layout.innerWalls.map { segment in
                (point(segment.start, in: size), point(segment.end, in: size))
            }
            for chain in connectedPointChains(from: pixelSegments) {
                guard let first = chain.first else { continue }
                path.move(to: first)
                for point in chain.dropFirst() {
                    path.addLine(to: point)
                }
            }
        } else {
            for segment in deduplicatedInnerSegments(in: size) {
                if segment.horizontal {
                    path.move(to: CGPoint(x: segment.start, y: segment.fixed))
                    path.addLine(to: CGPoint(x: segment.end, y: segment.fixed))
                } else {
                    path.move(to: CGPoint(x: segment.fixed, y: segment.start))
                    path.addLine(to: CGPoint(x: segment.fixed, y: segment.end))
                }
            }
        }
        return path
    }

    private func connectedPointChains(
        from segments: [(CGPoint, CGPoint)],
        tolerance: CGFloat = 1.2
    ) -> [[CGPoint]] {
        guard !segments.isEmpty else { return [] }
        var remaining = segments
        var chains: [[CGPoint]] = []

        while !remaining.isEmpty {
            let seed = remaining.removeFirst()
            var chain: [CGPoint] = [seed.0, seed.1]
            var didExtend = true

            while didExtend {
                didExtend = false
                guard let head = chain.first, let tail = chain.last else { break }

                if let idx = remaining.firstIndex(where: {
                    endpointsMatch($0.0, head, tolerance: tolerance) || endpointsMatch($0.1, head, tolerance: tolerance)
                }) {
                    let segment = remaining.remove(at: idx)
                    let nextPoint = endpointsMatch(segment.0, head, tolerance: tolerance) ? segment.1 : segment.0
                    chain.insert(nextPoint, at: 0)
                    didExtend = true
                    continue
                }

                if let idx = remaining.firstIndex(where: {
                    endpointsMatch($0.0, tail, tolerance: tolerance) || endpointsMatch($0.1, tail, tolerance: tolerance)
                }) {
                    let segment = remaining.remove(at: idx)
                    let nextPoint = endpointsMatch(segment.0, tail, tolerance: tolerance) ? segment.1 : segment.0
                    chain.append(nextPoint)
                    didExtend = true
                }
            }

            chains.append(chain)
        }

        return chains
    }

    private func endpointsMatch(_ lhs: CGPoint, _ rhs: CGPoint, tolerance: CGFloat) -> Bool {
        pointDistanceSquared(lhs, rhs) <= (tolerance * tolerance)
    }

    private func deduplicatedInnerSegments(in size: CGSize) -> [LineSegment] {
        var wallBuckets: [BoundaryKey: [AxisInterval]] = [:]
        var gapBuckets: [BoundaryKey: [AxisInterval]] = [:]

        func appendWall(horizontal: Bool, fixed: CGFloat, start: CGFloat, end: CGFloat) {
            let key = BoundaryKey(horizontal: horizontal, fixed: fixed)
            wallBuckets[key, default: []].append(AxisInterval(start: start, end: end).normalized)
        }

        func appendGap(horizontal: Bool, fixed: CGFloat, start: CGFloat, end: CGFloat) {
            let key = BoundaryKey(horizontal: horizontal, fixed: fixed)
            gapBuckets[key, default: []].append(AxisInterval(start: start, end: end).normalized)
        }

        for room in layout.rooms {
            let leftX = room.rect.minX
            let rightX = room.rect.maxX
            let topY = room.rect.minY
            let bottomY = room.rect.maxY
            let doorHalf = room.door.width * 0.5

            if !isEdgeOnOutline(horizontal: true, fixed: topY, start: leftX, end: rightX) {
                appendWall(horizontal: true, fixed: topY, start: leftX, end: rightX)
                if room.door.edge == .top {
                    appendGap(horizontal: true, fixed: topY, start: room.door.center - doorHalf, end: room.door.center + doorHalf)
                }
            }

            if !isEdgeOnOutline(horizontal: true, fixed: bottomY, start: leftX, end: rightX) {
                appendWall(horizontal: true, fixed: bottomY, start: leftX, end: rightX)
                if room.door.edge == .bottom {
                    appendGap(horizontal: true, fixed: bottomY, start: room.door.center - doorHalf, end: room.door.center + doorHalf)
                }
            }

            if !isEdgeOnOutline(horizontal: false, fixed: leftX, start: topY, end: bottomY) {
                appendWall(horizontal: false, fixed: leftX, start: topY, end: bottomY)
                if room.door.edge == .left {
                    appendGap(horizontal: false, fixed: leftX, start: room.door.center - doorHalf, end: room.door.center + doorHalf)
                }
            }

            if !isEdgeOnOutline(horizontal: false, fixed: rightX, start: topY, end: bottomY) {
                appendWall(horizontal: false, fixed: rightX, start: topY, end: bottomY)
                if room.door.edge == .right {
                    appendGap(horizontal: false, fixed: rightX, start: room.door.center - doorHalf, end: room.door.center + doorHalf)
                }
            }
        }

        var output: [LineSegment] = []
        for (key, wallIntervals) in wallBuckets {
            let mergedWalls = mergeIntervals(wallIntervals)
            let mergedGaps = mergeIntervals(gapBuckets[key] ?? [])

            for wall in mergedWalls {
                for trimmed in subtractIntervals(wall, by: mergedGaps) where (trimmed.end - trimmed.start) > 0.035 {
                    if key.horizontal {
                        let startX = trimmed.start * size.width
                        let endX = trimmed.end * size.width
                        if abs(endX - startX) < 18 { continue }
                        output.append(
                            LineSegment(
                                horizontal: true,
                                fixed: normalizedY(key.fixed, in: size),
                                start: startX,
                                end: endX
                            )
                        )
                    } else {
                        let startY = normalizedY(trimmed.start, in: size)
                        let endY = normalizedY(trimmed.end, in: size)
                        if abs(endY - startY) < 18 { continue }
                        output.append(
                            LineSegment(
                                horizontal: false,
                                fixed: key.fixed * size.width,
                                start: startY,
                                end: endY
                            )
                        )
                    }
                }
            }
        }

        let cornerPoints = normalizedOutlinePoints(in: size)
        let cleaned = output.filter { segment in
            let length = abs(segment.end - segment.start)
            // Force-remove short spur branches near outer corners.
            guard length < 44 else { return true }

            let p1: CGPoint
            let p2: CGPoint
            if segment.horizontal {
                p1 = CGPoint(x: segment.start, y: segment.fixed)
                p2 = CGPoint(x: segment.end, y: segment.fixed)
            } else {
                p1 = CGPoint(x: segment.fixed, y: segment.start)
                p2 = CGPoint(x: segment.fixed, y: segment.end)
            }

            let cornerThreshold: CGFloat = 16
            let nearCorner = cornerPoints.contains { corner in
                pointDistanceSquared(corner, p1) < cornerThreshold * cornerThreshold
                    || pointDistanceSquared(corner, p2) < cornerThreshold * cornerThreshold
            }
            return !nearCorner
        }

        return cleaned.sorted {
            if $0.horizontal != $1.horizontal {
                return $0.horizontal && !$1.horizontal
            }
            if abs($0.fixed - $1.fixed) > 0.01 {
                return $0.fixed < $1.fixed
            }
            return $0.start < $1.start
        }
    }

    private func mergeIntervals(_ intervals: [AxisInterval], epsilon: CGFloat = 0.0008) -> [AxisInterval] {
        let ordered = intervals
            .map(\.normalized)
            .sorted { lhs, rhs in
                if abs(lhs.start - rhs.start) > epsilon {
                    return lhs.start < rhs.start
                }
                return lhs.end < rhs.end
            }
        guard var current = ordered.first else { return [] }

        var merged: [AxisInterval] = []
        for interval in ordered.dropFirst() {
            if interval.start <= current.end + epsilon {
                current = AxisInterval(start: current.start, end: max(current.end, interval.end))
            } else {
                merged.append(current)
                current = interval
            }
        }
        merged.append(current)
        return merged
    }

    private func subtractIntervals(_ base: AxisInterval, by gaps: [AxisInterval], epsilon: CGFloat = 0.0008) -> [AxisInterval] {
        guard !gaps.isEmpty else { return [base] }
        var fragments: [AxisInterval] = [base]

        for gap in gaps {
            var next: [AxisInterval] = []
            for fragment in fragments {
                let overlapStart = max(fragment.start, gap.start)
                let overlapEnd = min(fragment.end, gap.end)

                if overlapEnd <= overlapStart + epsilon {
                    next.append(fragment)
                    continue
                }

                if overlapStart > fragment.start + epsilon {
                    next.append(AxisInterval(start: fragment.start, end: overlapStart))
                }
                if overlapEnd < fragment.end - epsilon {
                    next.append(AxisInterval(start: overlapEnd, end: fragment.end))
                }
            }
            fragments = next
            if fragments.isEmpty { break }
        }

        return fragments
    }

    private struct AxisSegment {
        let horizontal: Bool
        let fixed: CGFloat
        let start: CGFloat
        let end: CGFloat
    }

    private func isEdgeOnOutline(
        horizontal: Bool,
        fixed: CGFloat,
        start: CGFloat,
        end: CGFloat
    ) -> Bool {
        // Be more tolerant to tiny floating-point drift so outline edges are not redrawn as inner walls.
        let tolerance: CGFloat = 0.0035
        let targetStart = min(start, end)
        let targetEnd = max(start, end)
        let targetLength = targetEnd - targetStart

        guard targetLength > 0.001 else { return false }

        for segment in outlineAxisSegments() where segment.horizontal == horizontal {
            if abs(segment.fixed - fixed) > tolerance {
                continue
            }
            if segment.start - tolerance <= targetStart,
               segment.end + tolerance >= targetEnd {
                return true
            }
            let overlap = max(0, min(targetEnd, segment.end + tolerance) - max(targetStart, segment.start - tolerance))
            if overlap >= targetLength - 0.004 {
                return true
            }
        }
        return false
    }

    private func outlineAxisSegments() -> [AxisSegment] {
        let points = layout.outlinePoints
        guard points.count > 1 else { return [] }
        var segments: [AxisSegment] = []

        for i in 0..<(points.count - 1) {
            let a = points[i]
            let b = points[i + 1]
            if abs(a.y - b.y) < 0.0001 {
                segments.append(
                    AxisSegment(horizontal: true, fixed: a.y, start: min(a.x, b.x), end: max(a.x, b.x))
                )
            } else if abs(a.x - b.x) < 0.0001 {
                segments.append(
                    AxisSegment(horizontal: false, fixed: a.x, start: min(a.y, b.y), end: max(a.y, b.y))
                )
            }
        }
        return segments
    }

    private func roundedClosedPath(points: [CGPoint], radius: CGFloat) -> Path {
        guard points.count > 2 else { return polygonPath(points: points) }
        var path = Path()

        for i in 0..<points.count {
            let prev = points[(i - 1 + points.count) % points.count]
            let current = points[i]
            let next = points[(i + 1) % points.count]

            let v1 = CGVector(dx: current.x - prev.x, dy: current.y - prev.y)
            let v2 = CGVector(dx: next.x - current.x, dy: next.y - current.y)
            let len1 = sqrt((v1.dx * v1.dx) + (v1.dy * v1.dy))
            let len2 = sqrt((v2.dx * v2.dx) + (v2.dy * v2.dy))
            guard len1 > 0.01, len2 > 0.01 else { continue }

            let trim = min(radius, min(len1, len2) * 0.4)
            let p1 = CGPoint(x: current.x - (v1.dx / len1) * trim, y: current.y - (v1.dy / len1) * trim)
            let p2 = CGPoint(x: current.x + (v2.dx / len2) * trim, y: current.y + (v2.dy / len2) * trim)

            if i == 0 {
                path.move(to: p1)
            } else {
                path.addLine(to: p1)
            }
            path.addQuadCurve(to: p2, control: current)
        }

        path.closeSubpath()
        return path
    }

    private func polygonPath(points: [CGPoint]) -> Path {
        return Path { path in
            guard let first = points.first else { return }
            path.move(to: first)
            for point in points.dropFirst() {
                path.addLine(to: point)
            }
            path.closeSubpath()
        }
    }

    private func pointDistanceSquared(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let dx = a.x - b.x
        let dy = a.y - b.y
        return (dx * dx) + (dy * dy)
    }

    private func sanitizedOrthogonalPoints(_ points: [CGPoint]) -> [CGPoint] {
        guard points.count > 2 else { return points }
        let epsilon: CGFloat = 0.8
        let minEdgeLength: CGFloat = 10

        var deduped: [CGPoint] = []
        for point in points {
            if let last = deduped.last, pointDistanceSquared(last, point) < (epsilon * epsilon) {
                continue
            }
            deduped.append(point)
        }
        if deduped.count > 2,
           let first = deduped.first,
           let last = deduped.last,
           pointDistanceSquared(first, last) < (epsilon * epsilon) {
            deduped.removeLast()
        }

        guard deduped.count > 2 else { return deduped }
        var simplified: [CGPoint] = deduped
        var changed = true
        while changed && simplified.count > 2 {
            changed = false
            var next: [CGPoint] = []
            let count = simplified.count
            for i in 0..<count {
                let prev = simplified[(i - 1 + count) % count]
                let current = simplified[i]
                let nxt = simplified[(i + 1) % count]

                // Drop tiny jog corners that create visible branch artifacts on rounded strokes.
                let prevLen = sqrt(pointDistanceSquared(prev, current))
                let nextLen = sqrt(pointDistanceSquared(current, nxt))
                if prevLen < minEdgeLength || nextLen < minEdgeLength {
                    changed = true
                    continue
                }

                let isVertical = abs(prev.x - current.x) < epsilon && abs(current.x - nxt.x) < epsilon
                let isHorizontal = abs(prev.y - current.y) < epsilon && abs(current.y - nxt.y) < epsilon

                if isVertical || isHorizontal {
                    changed = true
                    continue
                }
                next.append(current)
            }
            if !next.isEmpty {
                simplified = next
            } else {
                break
            }
        }

        return simplified
    }

    private func point(_ normalized: CGPoint, in size: CGSize) -> CGPoint {
        CGPoint(
            x: normalized.x * size.width,
            y: normalizedY(normalized.y, in: size)
        )
    }

    private func normalizedDoorCenter(_ door: RoomDoor, roomRect: CGRect, in size: CGSize) -> CGPoint {
        switch door.edge {
        case .left:
            return CGPoint(x: roomRect.minX * size.width, y: normalizedY(door.center, in: size))
        case .right:
            return CGPoint(x: roomRect.maxX * size.width, y: normalizedY(door.center, in: size))
        case .top:
            return CGPoint(x: door.center * size.width, y: normalizedY(roomRect.minY, in: size))
        case .bottom:
            return CGPoint(x: door.center * size.width, y: normalizedY(roomRect.maxY, in: size))
        }
    }

    private var pixelStep: CGFloat { 1 }
}

private struct BedSlotView: View {
    let isSleeping: Bool
    let orientation: BedOrientation

    var body: some View {
        ZStack {
            if orientation == .horizontal {
                horizontalBed
            } else {
                verticalBed
            }
        }
    }

    private var horizontalBed: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppPalette.flatShadow.opacity(0.50))
                .frame(width: 117, height: 70)
                .offset(x: 3, y: 3)

            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppPalette.bedShell)
                .frame(width: 117, height: 70)

            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(AppPalette.white)
                    .frame(width: 19, height: 29)
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(isSleeping ? AppPalette.bedBlanket.opacity(0.72) : AppPalette.bedBlanket)
                    .frame(width: 77, height: 42)
            }
            .overlay(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(AppPalette.bedHeadboard)
                    .frame(width: 5, height: 26)
                    .offset(x: 9)
            }
        }
        .frame(width: 117, height: 70)
    }

    private var verticalBed: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppPalette.flatShadow.opacity(0.50))
                .frame(width: 70, height: 117)
                .offset(x: 3, y: 3)

            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppPalette.bedShell)
                .frame(width: 70, height: 117)

            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(AppPalette.white)
                    .frame(width: 29, height: 19)
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(isSleeping ? AppPalette.bedBlanket.opacity(0.72) : AppPalette.bedBlanket)
                    .frame(width: 42, height: 77)
            }
            .overlay(alignment: .top) {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(AppPalette.bedHeadboard)
                    .frame(width: 26, height: 5)
                    .offset(y: 9)
            }
        }
        .frame(width: 70, height: 117)
    }
}

private struct JoinRoomSheet: View {
    @Binding var code: String
    let onCancel: () -> Void
    let onJoin: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Join Room")
                .font(AppTypography.pixel(20, weight: .black))
                .foregroundStyle(AppPalette.inkPrimary)

            TextField("6-digit code", text: $code)
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
                .font(AppTypography.pixel(16, weight: .semibold))
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: AppRadius.control)
                        .fill(AppPalette.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppRadius.control)
                                .stroke(AppPalette.inkPrimary, lineWidth: AppStroke.standard)
                        )
                )

            HStack {
                Button("Cancel") {
                    onCancel()
                }
                .buttonStyle(.plain)
                .font(AppTypography.pixel(14, weight: .semibold))
                .foregroundStyle(AppPalette.inkPrimary)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: AppRadius.control)
                        .fill(AppPalette.blockYellow)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppRadius.control)
                                .stroke(AppPalette.inkPrimary, lineWidth: AppStroke.standard)
                        )
                )

                Spacer()

                Button("Join") {
                    onJoin()
                }
                .buttonStyle(.plain)
                .font(AppTypography.pixel(14, weight: .black))
                .foregroundStyle(AppPalette.inkPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: AppRadius.control)
                        .fill(AppPalette.electricBlue)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppRadius.control)
                                .stroke(AppPalette.inkPrimary, lineWidth: AppStroke.standard)
                        )
                )
            }
        }
        .padding(16)
        .presentationBackground(AppPalette.appBackground)
    }
}

private struct AvatarNode: View {
    let member: FamilyMember
    let isOverdue: Bool
    let isWakeAction: Bool
    let isWakeReaction: Bool

    var body: some View {
        VStack(spacing: 2) {
            ZStack(alignment: .topTrailing) {
                StickerAvatar(member: member, isWakeReaction: isWakeReaction)

                if member.status == .sleeping && isOverdue {
                    LateSleeperBadge()
                        .offset(x: 10, y: -12)
                } else if member.status == .sleeping {
                    Text("zzz")
                        .font(AppTypography.pixel(9, weight: .bold))
                        .foregroundStyle(AppPalette.inkMuted)
                        .offset(x: 8, y: -10)
                }

                if isWakeAction {
                    WakeActionBadge()
                        .offset(x: 10, y: -24)
                        .transition(.scale.combined(with: .opacity))
                }

                if isWakeReaction {
                    Text("!?")
                        .font(AppTypography.pixel(10, weight: .black))
                        .foregroundStyle(AppPalette.inkPrimary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(
                            RoundedRectangle(cornerRadius: AppRadius.control)
                                .fill(AppPalette.hotPink)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppRadius.control)
                                        .stroke(AppPalette.inkPrimary, lineWidth: AppStroke.standard)
                                )
                        )
                        .offset(x: 10, y: -24)
                        .transition(.scale.combined(with: .opacity))
                }
            }

            Text(member.name)
                .font(AppTypography.pixel(10, weight: .semibold))
                .foregroundStyle(AppPalette.inkPrimary)
                .padding(.horizontal, 7)
                .padding(.vertical, 2.5)
                .background(
                    Capsule()
                        .fill(AppPalette.white)
                )
        }
        .offset(x: isWakeAction ? 1.5 : 0, y: isWakeAction ? -0.5 : 0)
        .rotationEffect(.degrees(isWakeAction ? 2.6 : 0))
        .animation(
            isWakeAction
                ? .easeInOut(duration: 0.14).repeatCount(6, autoreverses: true)
                : .easeOut(duration: 0.2),
            value: isWakeAction
        )
    }
}

private struct LateSleeperBadge: View {
    @State private var shake = false

    var body: some View {
        Text("LATE")
            .font(AppTypography.pixel(9, weight: .bold))
            .foregroundStyle(AppPalette.inkPrimary)
            .padding(.horizontal, 7)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(AppPalette.vibrantOrange)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(AppPalette.inkPrimary, lineWidth: AppStroke.standard)
                    )
            )
            .rotationEffect(.degrees(shake ? 6 : -6))
            .onAppear {
                withAnimation(.easeInOut(duration: 0.12).repeatForever(autoreverses: true)) {
                    shake = true
                }
            }
    }
}

private struct StickerAvatar: View {
    let member: FamilyMember
    let isWakeReaction: Bool

    var body: some View {
        ZStack {
            avatarShape
                .fill(member.avatar.fillColor)
                .frame(width: 52, height: 52)
                .shadow(color: AppPalette.flatShadow.opacity(0.36), radius: 0, x: 2, y: 3)

            if member.status == .sleeping {
                sleepingEyes
                    .offset(y: -2)
            } else {
                normalEyes
                    .offset(y: -1)
            }
        }
        .frame(width: 60, height: 60)
    }

    private var avatarShape: AnyShape {
        member.avatar.bodyShape.view
    }

    private var normalEyes: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(AppPalette.white)
                .frame(width: 11, height: 11)
                .overlay(Circle().fill(AppPalette.inkPrimary).frame(width: 7, height: 7))
            Circle()
                .fill(AppPalette.white)
                .frame(width: 11, height: 11)
                .overlay(Circle().fill(AppPalette.inkPrimary).frame(width: 7, height: 7))
        }
    }

    private var sleepingEyes: some View {
        HStack(spacing: 8) {
            Capsule()
                .fill(AppPalette.inkPrimary)
                .frame(width: 9, height: 2.5)
            Capsule()
                .fill(AppPalette.inkPrimary)
                .frame(width: 9, height: 2.5)
        }
    }
}

private struct AnyShape: Shape {
    private let builder: @Sendable (CGRect) -> Path

    init<S: Shape>(_ shape: S) {
        self.builder = { rect in
            shape.path(in: rect)
        }
    }

    func path(in rect: CGRect) -> Path {
        builder(rect)
    }
}

private extension AvatarBodyShape {
    var view: AnyShape {
        AnyShape(AvatarSilhouetteShape(style: self))
    }
}

private struct AvatarSilhouetteShape: Shape {
    let style: AvatarBodyShape

    func path(in rect: CGRect) -> Path {
        switch style {
        case .coralCircle:
            return Circle().path(in: rect)
        case .archPill:
            var path = Path()
            let bottomRadius = rect.width * 0.15
            path.move(to: CGPoint(x: rect.minX + bottomRadius, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX - bottomRadius, y: rect.maxY))
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRadius),
                control: CGPoint(x: rect.maxX, y: rect.maxY)
            )
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addQuadCurve(
                to: CGPoint(x: rect.midX, y: rect.minY),
                control: CGPoint(x: rect.maxX, y: rect.minY)
            )
            path.addQuadCurve(
                to: CGPoint(x: rect.minX, y: rect.midY),
                control: CGPoint(x: rect.minX, y: rect.minY)
            )
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - bottomRadius))
            path.addQuadCurve(
                to: CGPoint(x: rect.minX + bottomRadius, y: rect.maxY),
                control: CGPoint(x: rect.minX, y: rect.maxY)
            )
            path.closeSubpath()
            return path
        case .fourBlob:
            var path = Path()
            let r = min(rect.width, rect.height) * 0.30
            path.addEllipse(in: CGRect(x: rect.midX - r * 1.15, y: rect.minY, width: r * 2, height: r * 2))
            path.addEllipse(in: CGRect(x: rect.midX - r * 0.85, y: rect.minY, width: r * 2, height: r * 2))
            path.addEllipse(in: CGRect(x: rect.midX - r * 1.15, y: rect.midY - r * 0.15, width: r * 2, height: r * 2))
            path.addEllipse(in: CGRect(x: rect.midX - r * 0.85, y: rect.midY - r * 0.15, width: r * 2, height: r * 2))
            path.addRoundedRect(
                in: CGRect(x: rect.midX - r * 1.08, y: rect.minY + r * 0.55, width: r * 2.16, height: r * 1.3),
                cornerSize: CGSize(width: r * 0.9, height: r * 0.9)
            )
            return path
        case .pentagon:
            var path = Path()
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.10, y: rect.minY + rect.height * 0.40))
            path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.22, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.22, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.10, y: rect.minY + rect.height * 0.40))
            path.closeSubpath()
            return path
        case .roundedSquare:
            return RoundedRectangle(cornerRadius: rect.width * 0.24, style: .continuous).path(in: rect)
        case .mintDroplet:
            var path = Path()
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX - rect.width * 0.10, y: rect.midY),
                control: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.16)
            )
            path.addQuadCurve(
                to: CGPoint(x: rect.midX, y: rect.maxY),
                control: CGPoint(x: rect.maxX - rect.width * 0.06, y: rect.maxY)
            )
            path.addQuadCurve(
                to: CGPoint(x: rect.minX + rect.width * 0.10, y: rect.midY),
                control: CGPoint(x: rect.minX + rect.width * 0.06, y: rect.maxY)
            )
            path.addQuadCurve(
                to: CGPoint(x: rect.midX, y: rect.minY),
                control: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.16)
            )
            path.closeSubpath()
            return path
        case .lavenderCloud:
            var path = Path()
            let w = rect.width
            let h = rect.height
            path.addEllipse(in: CGRect(x: rect.minX + w * 0.03, y: rect.minY + h * 0.30, width: w * 0.42, height: h * 0.44))
            path.addEllipse(in: CGRect(x: rect.minX + w * 0.28, y: rect.minY + h * 0.15, width: w * 0.42, height: h * 0.48))
            path.addEllipse(in: CGRect(x: rect.minX + w * 0.55, y: rect.minY + h * 0.32, width: w * 0.40, height: h * 0.42))
            path.addRoundedRect(
                in: CGRect(x: rect.minX + w * 0.14, y: rect.minY + h * 0.40, width: w * 0.72, height: h * 0.46),
                cornerSize: CGSize(width: w * 0.28, height: w * 0.28)
            )
            return path
        case .apricotRoundedRect:
            return RoundedRectangle(cornerRadius: rect.width * 0.20, style: .continuous).path(in: rect)
        }
    }
}

private struct WakeActionBadge: View {
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "hand.tap.fill")
                .font(AppTypography.pixel(9, weight: .bold))
            Text("tap")
                .font(AppTypography.pixel(8, weight: .bold))
        }
        .foregroundStyle(AppPalette.inkPrimary)
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.control)
                .fill(AppPalette.brightYellow)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.control)
                        .stroke(AppPalette.inkPrimary, lineWidth: AppStroke.standard)
                )
        )
    }
}

private struct WakeScheduleListView: View {
    let members: [FamilyMember]
    let isOverdue: (FamilyMember) -> Bool
    let onWakeTap: (UUID) -> Void
    let formatWake: (FamilyMember) -> String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(members) { member in
                let overdue = isOverdue(member)

                HStack(spacing: 10) {
                    Circle()
                        .fill(overdue ? AppPalette.inkPrimary : AppPalette.inkMuted.opacity(0.28))
                        .frame(width: 8, height: 8)

                    Text(member.name)
                        .font(AppTypography.pixel(14, weight: .semibold))
                        .foregroundStyle(AppPalette.inkPrimary)
                        .lineLimit(1)

                    Spacer()

                    Text(formatWake(member))
                        .font(AppTypography.pixel(12, weight: .regular))
                        .foregroundStyle(AppPalette.inkSecondary)

                    if overdue && !member.isMe {
                        Button {
                            onWakeTap(member.id)
                        } label: {
                            Text("Awake")
                                .font(AppTypography.pixel(12, weight: .semibold))
                                .foregroundStyle(AppPalette.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(AppPalette.vibrantOrange)
                                )
                        }
                        .buttonStyle(.plain)
                    } else if member.isMe && formatWake(member) == "No alarm" {
                        Text("Off")
                            .font(AppTypography.pixel(10, weight: .semibold))
                            .foregroundStyle(AppPalette.inkMuted)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(AppPalette.white)
                )
            }
        }
    }
}

private struct WakeScheduleFullScreenView: View {
    let members: [FamilyMember]
    let isOverdue: (FamilyMember) -> Bool
    let onWakeTap: (UUID) -> Void
    let formatWake: (FamilyMember) -> String
    let onBack: () -> Void

    var body: some View {
        ZStack {
            AppPalette.appBackground.ignoresSafeArea()

            VStack(spacing: 12) {
                HStack {
                    Button {
                        onBack()
                    } label: {
                        Label("Back", systemImage: "chevron.left")
                            .font(AppTypography.pixel(14, weight: .semibold))
                            .foregroundStyle(AppPalette.inkPrimary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 9)
                            .background(
                                Capsule()
                                    .fill(AppPalette.white)
                            )
                    }
                    .buttonStyle(.plain)

                    Spacer()
                    Text("Wake Schedule")
                        .font(AppTypography.pixel(24, weight: .semibold))
                        .foregroundStyle(AppPalette.inkPrimary)
                    Spacer()
                    Color.clear.frame(width: 66, height: 1)
                }

                ScrollView(showsIndicators: false) {
                    WakeScheduleListView(
                        members: members,
                        isOverdue: isOverdue,
                        onWakeTap: onWakeTap,
                        formatWake: formatWake
                    )
                    .padding(.bottom, 24)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
        }
    }
}

private struct WakeSendOverlay: View {
    let draft: WakeComposeDraft?
    @Binding var message: String
    let onCancel: () -> Void
    let onSend: () -> Void

    var body: some View {
        if let draft {
            ZStack {
                Color.black.opacity(0.24)
                    .ignoresSafeArea()
                    .onTapGesture { onCancel() }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Send Late Alarm")
                        .font(AppTypography.pixel(20, weight: .semibold))
                        .foregroundStyle(AppPalette.inkPrimary)

                    Text("Send a late wake alarm to \(draft.targetTitle)")
                        .font(AppTypography.pixel(13, weight: .regular))
                        .foregroundStyle(AppPalette.inkSecondary)

                    TextField("Leave a message (optional)", text: $message)
                        .font(AppTypography.pixel(14, weight: .regular))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(AppPalette.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(AppPalette.roomBoundary.opacity(0.45), lineWidth: 1.2)
                                )
                        )

                    HStack(spacing: 10) {
                        Button("Cancel", action: onCancel)
                            .font(AppTypography.pixel(14, weight: .semibold))
                            .foregroundStyle(AppPalette.inkPrimary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(AppPalette.blockGray)
                            )

                        Spacer()

                        Button("Send", action: onSend)
                            .font(AppTypography.pixel(14, weight: .semibold))
                            .foregroundStyle(AppPalette.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(AppPalette.vibrantOrange)
                            )
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: AppRadius.panel, style: .continuous)
                        .fill(AppPalette.white)
                        .shadow(color: Color.black.opacity(0.14), radius: 14, x: 0, y: 8)
                )
                .padding(.horizontal, 24)
            }
        }
    }
}

private struct WorldWakeFullScreenView: View {
    @Binding var sleepers: [WorldSleeper]
    @Binding var wakeComposeDraft: WakeComposeDraft?
    @Binding var wakeComposeMessage: String
    let onSendWakeDraft: (WakeComposeDraft, String) -> Void
    let onBack: () -> Void

    private var overdueSleepers: [WorldSleeper] {
        sleepers.filter { !$0.isAwake && $0.lateMinutes > 0 }
    }

    var body: some View {
        ZStack {
            AppPalette.appBackground.ignoresSafeArea()

            VStack(spacing: 12) {
                HStack {
                    Button {
                        onBack()
                    } label: {
                        Label("Back", systemImage: "chevron.left")
                            .font(AppTypography.pixel(14, weight: .semibold))
                            .foregroundStyle(AppPalette.inkPrimary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 9)
                            .background(
                                Capsule()
                                    .fill(AppPalette.white)
                            )
                    }
                    .buttonStyle(.plain)

                    Spacer()
                    Text("World Alarm")
                        .font(AppTypography.pixel(24, weight: .semibold))
                        .foregroundStyle(AppPalette.inkPrimary)
                    Spacer()
                    Color.clear.frame(width: 66, height: 1)
                }

                if overdueSleepers.isEmpty {
                    Spacer()
                    Text("No overdue sleepers right now")
                        .font(AppTypography.pixel(14, weight: .regular))
                        .foregroundStyle(AppPalette.inkSecondary)
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 10) {
                            ForEach(overdueSleepers) { sleeper in
                                HStack(spacing: 10) {
                                    Circle()
                                        .fill(Color(hex: UInt(sleeper.avatarHex)))
                                        .frame(width: 22, height: 22)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(sleeper.name)
                                            .font(AppTypography.pixel(14, weight: .semibold))
                                            .foregroundStyle(AppPalette.inkPrimary)
                                        Text(sleeper.country)
                                            .font(AppTypography.pixel(12, weight: .regular))
                                            .foregroundStyle(AppPalette.inkSecondary)
                                    }
                                    Spacer()
                                    Text("Late \(sleeper.lateMinutes)m")
                                        .font(AppTypography.pixel(12, weight: .regular))
                                        .foregroundStyle(AppPalette.inkSecondary)
                                    Button {
                                        wakeComposeMessage = ""
                                        wakeComposeDraft = WakeComposeDraft(
                                            target: .world(worldID: sleeper.id),
                                            targetTitle: "\(sleeper.name) (\(sleeper.country))"
                                        )
                                    } label: {
                                        Text("Awake")
                                            .font(AppTypography.pixel(12, weight: .semibold))
                                            .foregroundStyle(AppPalette.white)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(
                                                Capsule().fill(AppPalette.vibrantOrange)
                                            )
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(AppPalette.white)
                                )
                            }
                        }
                        .padding(.bottom, 24)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)

            WakeSendOverlay(
                draft: wakeComposeDraft,
                message: $wakeComposeMessage,
                onCancel: {
                    wakeComposeDraft = nil
                    wakeComposeMessage = ""
                },
                onSend: {
                    guard let draft = wakeComposeDraft else { return }
                    onSendWakeDraft(draft, wakeComposeMessage)
                    wakeComposeDraft = nil
                    wakeComposeMessage = ""
                }
            )
        }
    }
}

private struct MemberEditorSheet: View {
    let mode: MemberEditorMode
    @Binding var draft: MemberEditorDraft
    let shapeOptions: [AvatarBodyShape]
    let colorOptions: [Int]
    let onCancel: () -> Void
    let onConfirm: () -> Void

    private var canConfirm: Bool {
        !draft.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var previewMember: FamilyMember {
        FamilyMember(
            id: UUID(),
            name: draft.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Preview" : draft.name,
            avatar: AvatarTheme(
                id: "preview",
                fillHex: draft.colorHex,
                bodyShape: draft.shape,
                faceStyle: .classic
            ),
            status: .awake,
            wakeSchedule: WakeSchedule(hour: 8, minute: 0),
            position: .zero,
            isMe: true,
            activity: "Preview"
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(mode.title)
                .font(AppTypography.pixel(20, weight: .semibold))
                .foregroundStyle(AppPalette.inkPrimary)

            HStack(spacing: 10) {
                StickerAvatar(member: previewMember, isWakeReaction: false)
                    .frame(width: 72, height: 72)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppPalette.blockGray.opacity(0.7))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(AppPalette.inkPrimary.opacity(0.16), lineWidth: AppStroke.standard)
                            )
                    )

                TextField("Name", text: $draft.name)
                    .font(AppTypography.pixel(16, weight: .semibold))
                    .foregroundStyle(AppPalette.inkPrimary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(AppPalette.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(AppPalette.inkPrimary.opacity(0.25), lineWidth: AppStroke.standard)
                            )
                    )
            }

            Text("Shape")
                .font(AppTypography.pixel(13, weight: .semibold))
                .foregroundStyle(AppPalette.inkSecondary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 8) {
                ForEach(shapeOptions, id: \.self) { shape in
                    ShapeOptionCell(
                        shape: shape,
                        colorHex: draft.colorHex,
                        isSelected: draft.shape == shape
                    )
                    .onTapGesture { draft.shape = shape }
                }
            }

            Text("Color")
                .font(AppTypography.pixel(13, weight: .semibold))
                .foregroundStyle(AppPalette.inkSecondary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 6), spacing: 8) {
                ForEach(colorOptions, id: \.self) { hex in
                    Circle()
                        .fill(Color(hex: UInt(hex)))
                        .frame(width: 30, height: 30)
                        .overlay(
                            Circle()
                                .stroke(AppPalette.inkPrimary, lineWidth: draft.colorHex == hex ? 2.4 : 1.2)
                        )
                        .onTapGesture { draft.colorHex = hex }
                }
            }

            Spacer(minLength: 8)

            HStack {
                Button("Cancel") { onCancel() }
                    .font(AppTypography.pixel(14, weight: .semibold))
                    .foregroundStyle(AppPalette.inkPrimary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: AppRadius.control)
                            .fill(AppPalette.blockYellow.opacity(0.55))
                            .overlay(
                                RoundedRectangle(cornerRadius: AppRadius.control)
                                    .stroke(AppPalette.inkPrimary, lineWidth: AppStroke.standard)
                            )
                    )

                Spacer()

                Button(mode.confirmTitle) { onConfirm() }
                    .font(AppTypography.pixel(14, weight: .bold))
                    .foregroundStyle(AppPalette.inkPrimary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: AppRadius.control)
                            .fill(AppPalette.vibrantOrange)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppRadius.control)
                                    .stroke(AppPalette.inkPrimary, lineWidth: AppStroke.standard)
                            )
                    )
                    .disabled(!canConfirm)
                    .opacity(canConfirm ? 1 : 0.5)
            }
        }
        .padding(16)
        .presentationBackground(AppPalette.appBackground)
    }
}

private struct ShapeOptionCell: View {
    let shape: AvatarBodyShape
    let colorHex: Int
    let isSelected: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppRadius.control)
                .fill(AppPalette.white)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.control)
                        .stroke(AppPalette.inkPrimary, lineWidth: isSelected ? 2.2 : 1.1)
                )

            shape.view
                .fill(Color(hex: UInt(colorHex)))
                .frame(width: 24, height: 24)
        }
        .frame(height: 42)
    }
}

private struct AvatarSelectionCell: View {
    let avatar: AvatarTheme
    let isSelected: Bool

    private var demoMember: FamilyMember {
        FamilyMember(
            id: UUID(),
            name: "",
            avatar: avatar,
            status: .awake,
            wakeSchedule: WakeSchedule(hour: 8, minute: 0),
            position: .zero,
            isMe: false,
            activity: ""
        )
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppRadius.control)
                .fill(isSelected ? AppPalette.brightYellow : AppPalette.white)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.control)
                        .stroke(AppPalette.inkPrimary, lineWidth: isSelected ? 2.2 : 1.4)
                )

            StickerAvatar(member: demoMember, isWakeReaction: false)
                .scaleEffect(0.78)
                .offset(y: 2)
        }
        .frame(height: 56)
    }
}

private struct FamilyMember: Identifiable {
    let id: UUID
    var name: String
    var avatar: AvatarTheme
    var status: FamilyStatus
    var wakeSchedule: WakeSchedule
    var position: CGPoint
    var isMe: Bool
    var activity: String
}

private struct WakeSchedule {
    let hour: Int
    let minute: Int
}

private enum FamilyStatus {
    case awake
    case sleeping
}

private struct AvatarTheme {
    let id: String
    let fillHex: Int
    var fillColor: Color { Color(hex: UInt(fillHex)) }
    let bodyShape: AvatarBodyShape
    let faceStyle: AvatarFaceStyle
}

private enum AvatarBodyShape: CaseIterable {
    case coralCircle
    case archPill
    case fourBlob
    case pentagon
    case roundedSquare
    case mintDroplet
    case lavenderCloud
    case apricotRoundedRect
}

private enum AvatarFaceStyle {
    case classic
}

private enum FamilySample {
    static let maxMembers = 7

    static let editableColorHexes: [Int] = [
        0xEF6E50,
        0x7692CC,
        0xE2AF26,
        0xCC95AE,
        0x42B9BB,
        0x6EC9B1,
        0xB8AFE0,
        0xE8B27B,
        0x9CB9D9,
        0xAFCDBA
    ]

    static let avatarCatalog: [AvatarTheme] = [
        AvatarTheme(id: "shape-teal-square", fillHex: 0x42B9BB, bodyShape: .roundedSquare, faceStyle: .classic),
        AvatarTheme(id: "shape-pink-pentagon", fillHex: 0xCC95AE, bodyShape: .pentagon, faceStyle: .classic),
        AvatarTheme(id: "shape-coral-circle", fillHex: 0xEF6E50, bodyShape: .coralCircle, faceStyle: .classic),
        AvatarTheme(id: "shape-yellow-four", fillHex: 0xE2AF26, bodyShape: .fourBlob, faceStyle: .classic),
        AvatarTheme(id: "shape-blue-arch", fillHex: 0x7692CC, bodyShape: .archPill, faceStyle: .classic),
        AvatarTheme(id: "shape-mint-drop", fillHex: 0x6EC9B1, bodyShape: .mintDroplet, faceStyle: .classic),
        AvatarTheme(id: "shape-lav-cloud", fillHex: 0xB8AFE0, bodyShape: .lavenderCloud, faceStyle: .classic),
        AvatarTheme(id: "shape-apricot-rect", fillHex: 0xE8B27B, bodyShape: .apricotRoundedRect, faceStyle: .classic)
    ]

    static func avatarTheme(with id: String) -> AvatarTheme {
        avatarCatalog.first(where: { $0.id == id }) ?? avatarCatalog[0]
    }

    static let members: [FamilyMember] = [
        FamilyMember(
            id: UUID(),
            name: "Laxxi",
            avatar: avatarTheme(with: "shape-teal-square"),
            status: .awake,
            wakeSchedule: WakeSchedule(hour: 7, minute: 30),
            position: CGPoint(x: 0.56, y: 0.71),
            isMe: true,
            activity: "Walking"
        ),
        FamilyMember(
            id: UUID(),
            name: "Ruby",
            avatar: avatarTheme(with: "shape-pink-pentagon"),
            status: .sleeping,
            wakeSchedule: WakeSchedule(hour: 7, minute: 45),
            position: CGPoint(x: 0.50, y: 0.30),
            isMe: false,
            activity: "Sleeping"
        ),
        FamilyMember(
            id: UUID(),
            name: "Will",
            avatar: avatarTheme(with: "shape-coral-circle"),
            status: .sleeping,
            wakeSchedule: WakeSchedule(hour: 6, minute: 30),
            position: CGPoint(x: 0.20, y: 0.71),
            isMe: false,
            activity: "Sleeping"
        ),
        FamilyMember(
            id: UUID(),
            name: "Eric",
            avatar: avatarTheme(with: "shape-blue-arch"),
            status: .awake,
            wakeSchedule: WakeSchedule(hour: 8, minute: 30),
            position: CGPoint(x: 0.45, y: 0.95),
            isMe: false,
            activity: "Walking"
        )
    ]

    static func avatarTheme(for index: Int) -> AvatarTheme {
        avatarCatalog[index % avatarCatalog.count]
    }

    static func randomActivity() -> String {
        let activities = [
            "Walking",
            "Drinking water",
            "Stretching",
            "Checking phone",
            "Making coffee"
        ]
        return activities.randomElement() ?? "Walking"
    }
}

private struct RoomSnapshot {
    let code: String
    var members: [FamilyMember]
    var updatedAt: Date
}

private enum RoomServiceError: LocalizedError {
    case roomNotFound

    var errorDescription: String? {
        switch self {
        case .roomNotFound:
            return "Room code not found."
        }
    }
}

private final class InMemoryRoomRealtimeService {
    static let shared = InMemoryRoomRealtimeService()

    private var rooms: [String: RoomSnapshot] = [:]
    private var roomStreams: [String: CurrentValueSubject<RoomSnapshot, Never>] = [:]

    private init() {}

    func createRoom(seedMembers: [FamilyMember]) -> RoomSnapshot {
        let code = makeUniqueCode()
        let snapshot = RoomSnapshot(code: code, members: seedMembers, updatedAt: Date())
        rooms[code] = snapshot
        roomStreams[code] = CurrentValueSubject(snapshot)
        return snapshot
    }

    func joinRoom(code: String, joiningMember: FamilyMember) throws -> RoomSnapshot {
        let normalized = normalize(code)
        guard var snapshot = rooms[normalized] else {
            throw RoomServiceError.roomNotFound
        }

        if let index = snapshot.members.firstIndex(where: { $0.id == joiningMember.id }) {
            snapshot.members[index] = joiningMember
        } else {
            snapshot.members.append(joiningMember)
        }

        snapshot.updatedAt = Date()
        rooms[normalized] = snapshot
        if let stream = roomStreams[normalized] {
            stream.send(snapshot)
        } else {
            roomStreams[normalized] = CurrentValueSubject(snapshot)
        }

        return snapshot
    }

    func leaveRoom(code: String, memberID: UUID) -> RoomSnapshot? {
        let normalized = normalize(code)
        guard var snapshot = rooms[normalized] else { return nil }
        snapshot.members.removeAll { $0.id == memberID }
        snapshot.updatedAt = Date()
        rooms[normalized] = snapshot
        roomStreams[normalized]?.send(snapshot)
        return snapshot
    }

    func updateRoom(code: String, members: [FamilyMember]) {
        let normalized = normalize(code)
        guard rooms[normalized] != nil else { return }
        let snapshot = RoomSnapshot(code: normalized, members: members, updatedAt: Date())
        rooms[normalized] = snapshot
        roomStreams[normalized]?.send(snapshot)
    }

    func snapshot(code: String) -> RoomSnapshot? {
        rooms[normalize(code)]
    }

    func stream(code: String) -> AnyPublisher<RoomSnapshot, Never>? {
        roomStreams[normalize(code)]?.eraseToAnyPublisher()
    }

    private func makeUniqueCode() -> String {
        var code = makeCode()
        while rooms[code] != nil {
            code = makeCode()
        }
        return code
    }

    private func makeCode() -> String {
        let alphabet = Array("ABCDEFGHJKLMNPQRSTUVWXYZ23456789")
        return String((0..<6).map { _ in alphabet.randomElement() ?? "A" })
    }

    private func normalize(_ code: String) -> String {
        code.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    }
}

// MARK: - Ranking

private struct RankingView: View {
    let onBack: () -> Void

    private let sections: [RankSection] = [
        RankSection(
            title: "Most Late Wake-ups",
            tint: AppPalette.blockGray,
            rows: [
                RankRow(rank: 1, name: "Koi", score: "12 times"),
                RankRow(rank: 2, name: "Kai", score: "9 times"),
                RankRow(rank: 3, name: "Alex", score: "7 times")
            ]
        ),
        RankSection(
            title: "Longest Sleep",
            tint: AppPalette.blockGray,
            rows: [
                RankRow(rank: 1, name: "Kai", score: "Avg 9h 42m"),
                RankRow(rank: 2, name: "Koi", score: "Avg 8h 55m"),
                RankRow(rank: 3, name: "Yara", score: "Avg 8h 20m")
            ]
        ),
        RankSection(
            title: "Most Consistent Schedule",
            tint: AppPalette.blockGray,
            rows: [
                RankRow(rank: 1, name: "You", score: "16-day streak"),
                RankRow(rank: 2, name: "Yara", score: "12-day streak"),
                RankRow(rank: 3, name: "Alex", score: "9-day streak")
            ]
        )
    ]

    var body: some View {
        ZStack {
            AppPalette.appBackground.ignoresSafeArea()

            VStack(spacing: 12) {
                HStack {
                    Button {
                        onBack()
                    } label: {
                        Label("Back", systemImage: "chevron.left")
                            .font(AppTypography.pixel(14, weight: .semibold))
                            .foregroundStyle(AppPalette.inkPrimary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 9)
                            .background(
                                Capsule()
                                    .fill(AppPalette.white)
                            )
                    }
                    .buttonStyle(.plain)

                    Spacer()
                    Text("Ranking")
                        .font(AppTypography.pixel(24, weight: .semibold))
                        .foregroundStyle(AppPalette.inkPrimary)
                    Spacer()
                    Color.clear.frame(width: 66, height: 1)
                }

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(sections) { section in
                            Text(section.title)
                                .font(AppTypography.pixel(14, weight: .semibold))
                                .foregroundStyle(AppPalette.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 7)
                                .background(
                                    Capsule()
                                        .fill(AppPalette.vibrantOrange)
                                )
                                .padding(.top, 2)

                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(section.rows) { row in
                                    HStack(spacing: 10) {
                                        Circle()
                                            .fill(AppPalette.inkMuted.opacity(0.28))
                                            .frame(width: 8, height: 8)

                                        Text("#\(row.rank)")
                                            .font(AppTypography.pixel(12, weight: .regular))
                                            .foregroundStyle(AppPalette.inkSecondary)
                                            .frame(width: 26, alignment: .leading)

                                        Text(row.name)
                                            .font(AppTypography.pixel(14, weight: .semibold))
                                            .foregroundStyle(AppPalette.inkPrimary)
                                            .lineLimit(1)

                                        Spacer()

                                        Text(row.score)
                                            .font(AppTypography.pixel(12, weight: .regular))
                                            .foregroundStyle(AppPalette.inkSecondary)
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                                            .fill(AppPalette.white)
                                    )
                                }
                            }
                        }
                    }
                    .padding(.bottom, 24)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
        }
    }
}

private struct RankSection: Identifiable {
    let id = UUID()
    let title: String
    let tint: Color
    let rows: [RankRow]
}

private struct RankRow: Identifiable {
    let id = UUID()
    let rank: Int
    let name: String
    let score: String
}

// MARK: - Alarm Settings

private enum AlarmPalette {
    static let canvas = AppPalette.appBackground
    static let card = Color(hex: 0xF9F3E9)
    static let sectionHeader = AppPalette.inkSecondary
    static let separator = AppPalette.inkPrimary.opacity(0.25)
    static let action = AppPalette.vibrantOrange
    static let dialFaceLeft = AppPalette.vibrantOrange
    static let dialFaceRight = AppPalette.electricBlue
    static let dialCore = Color(hex: 0xF8F1E6)
    static let ink = AppPalette.inkPrimary
    static let inkMuted = AppPalette.inkSecondary
    static let pill = AppPalette.blockGray
}

private struct AlarmSettingsView: View {
    @ObservedObject var alarmStore: AlarmStore
    @State private var editingAlarm: AlarmEntry?

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Button("Edit") {}
                        .font(AppTypography.pixel(16, weight: .semibold))
                        .foregroundStyle(AlarmPalette.inkMuted)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(AlarmPalette.pill)
                                .overlay(
                                    Capsule().stroke(AppPalette.inkPrimary, lineWidth: AppStroke.standard)
                                )
                        )

                    Spacer()

                    Button {
                        editingAlarm = alarmStore.addOtherAlarm()
                    } label: {
                        Image(systemName: "plus")
                            .font(AppTypography.pixel(18, weight: .bold))
                            .foregroundStyle(AlarmPalette.ink)
                            .frame(width: 48, height: 48)
                            .background(
                                Circle()
                                    .fill(AlarmPalette.pill)
                                    .overlay(
                                        Circle().stroke(AppPalette.inkPrimary, lineWidth: AppStroke.standard)
                                    )
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 10)

                Text("Alarms")
                    .font(AppTypography.pixel(42, weight: .black))
                    .foregroundStyle(AlarmPalette.ink)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Sleep | Wake Up")
                        .font(AppTypography.pixel(18, weight: .black))
                        .foregroundStyle(AlarmPalette.sectionHeader)

                    AlarmPrimaryRow(
                        alarm: alarmStore.primaryAlarm,
                        triggerText: alarmStore.triggerSummary(for: alarmStore.primaryAlarm),
                        isOn: bindingForToggle(id: alarmStore.primaryAlarm.id),
                        onChangeTap: {
                            openEditor(for: alarmStore.primaryAlarm)
                        }
                    )
                }
                .padding(.top, 4)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Other")
                        .font(AppTypography.pixel(18, weight: .black))
                        .foregroundStyle(AlarmPalette.sectionHeader)

                    ForEach(alarmStore.otherAlarms) { alarm in
                        AlarmListRow(
                            alarm: alarm,
                            isOn: bindingForToggle(id: alarm.id),
                            onTap: {
                                openEditor(for: alarm)
                            }
                        )
                    }
                }
                .padding(.bottom, 100)
            }
            .padding(.horizontal, 16)
        }
        .background(
            AlarmPalette.canvas
                .ignoresSafeArea()
        )
        .sheet(item: $editingAlarm) { alarm in
            AlarmEditView(
                draft: alarm,
                worldConsent: $alarmStore.worldModeConsentEnabled,
                onSave: { edited in
                    alarmStore.upsert(edited)
                },
                onDelete: alarm.isPrimary ? nil : {
                    alarmStore.remove(id: alarm.id)
                }
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }

    private func openEditor(for alarm: AlarmEntry) {
        guard let latest = alarmStore.alarm(id: alarm.id) else { return }
        editingAlarm = latest
    }

    private func bindingForToggle(id: UUID) -> Binding<Bool> {
        Binding(
            get: { alarmStore.alarm(id: id)?.isEnabled ?? false },
            set: { isOn in
                alarmStore.toggle(id: id, isOn: isOn)
            }
        )
    }
}

private struct AlarmPrimaryRow: View {
    let alarm: AlarmEntry
    let triggerText: String
    @Binding var isOn: Bool
    let onChangeTap: () -> Void

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            Button {
                onChangeTap()
            } label: {
                VStack(alignment: .leading, spacing: 2) {
                    Text(alarm.displayTime)
                        .font(AppTypography.pixel(62, weight: .regular))
                        .foregroundStyle(AppPalette.inkPrimary)
                    Text(triggerText)
                        .font(AppTypography.pixel(14, weight: .semibold))
                        .foregroundStyle(AppPalette.inkSecondary)
                }
            }
            .buttonStyle(.plain)

            Spacer()

            VStack(alignment: .trailing, spacing: 12) {
                Button("Change") {
                    onChangeTap()
                }
                .font(AppTypography.pixel(16, weight: .black))
                .foregroundStyle(AlarmPalette.action)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(AlarmPalette.pill)
                        .overlay(
                            Capsule().stroke(AppPalette.inkPrimary, lineWidth: AppStroke.standard)
                        )
                )

                Toggle("", isOn: $isOn)
                    .labelsHidden()
                    .tint(AppPalette.punchGreen)
            }
        }
        .padding(.horizontal, 4)
        .padding(.bottom, 6)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(AlarmPalette.separator)
                .frame(height: 1)
        }
    }
}

private struct AlarmListRow: View {
    let alarm: AlarmEntry
    @Binding var isOn: Bool
    let onTap: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Button {
                onTap()
            } label: {
                VStack(alignment: .leading, spacing: 1) {
                    Text(alarm.displayTime)
                        .font(AppTypography.pixel(58, weight: .regular))
                        .foregroundStyle(isOn ? AppPalette.inkPrimary : AppPalette.inkMuted.opacity(0.7))
                    Text(alarm.label)
                        .font(AppTypography.pixel(15, weight: .semibold))
                        .foregroundStyle(AppPalette.inkMuted)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(AppPalette.punchGreen)
        }
        .padding(.horizontal, 4)
        .padding(.bottom, 8)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(AlarmPalette.separator)
                .frame(height: 1)
        }
    }
}

private struct AlarmEditView: View {
    @Environment(\.dismiss) private var dismiss
    @State var draft: AlarmEntry
    @Binding var worldConsent: Bool
    let onSave: (AlarmEntry) -> Void
    let onDelete: (() -> Void)?

    private let repeatOptions = ["Never", "Every day", "Weekdays", "Weekends"]
    private let soundOptions = ["Wake up", "Bell", "Chime", "Crush on (Acoustic version)"]
    private let snoozeOptions = [5, 9, 10, 15, 20]

    var body: some View {
        ZStack {
            AlarmPalette.canvas
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    HStack {
                        circleButton(symbol: "xmark", fill: AlarmPalette.pill) {
                            dismiss()
                        }

                        Spacer()

                        Text("Edit Alarm")
                            .font(AppTypography.pixel(30, weight: .black))
                            .foregroundStyle(AppPalette.inkPrimary)

                        Spacer()

                        circleButton(symbol: "checkmark", fill: AppPalette.vibrantOrange) {
                            onSave(draft)
                            dismiss()
                        }
                    }
                    .padding(.top, 6)

                    IOSWheelTimePicker(
                        hour: $draft.hour,
                        minute: $draft.minute
                    )
                    .frame(height: 228)

                    VStack(spacing: 0) {
                        rowContainer {
                            valueMenuRow(
                                title: "Repeat",
                                value: draft.repeatSummary
                            ) {
                                ForEach(repeatOptions, id: \.self) { option in
                                    Button(option) {
                                        draft.repeatSummary = option
                                    }
                                }
                            }
                        }

                        dividerLine

                        rowContainer {
                            HStack {
                                Text("Label")
                                    .font(AppTypography.pixel(19, weight: .semibold))
                                    .foregroundStyle(AppPalette.inkPrimary)
                                Spacer()
                                TextField("Alarm", text: $draft.label)
                                    .multilineTextAlignment(.trailing)
                                    .font(AppTypography.pixel(19, weight: .semibold))
                                    .foregroundStyle(AppPalette.inkSecondary)
                                    .frame(minWidth: 120, maxWidth: 220)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.75)
                            }
                        }

                        dividerLine

                        rowContainer {
                            valueMenuRow(
                                title: "Sound",
                                value: draft.sound
                            ) {
                                ForEach(soundOptions, id: \.self) { option in
                                    Button(option) {
                                        draft.sound = option
                                    }
                                }
                            }
                        }

                        dividerLine

                        rowContainer {
                            HStack {
                                Text("Snooze")
                                    .font(AppTypography.pixel(19, weight: .semibold))
                                    .foregroundStyle(AppPalette.inkPrimary)
                                Spacer()
                                Toggle("", isOn: $draft.isSnoozeEnabled)
                                    .labelsHidden()
                                    .tint(AppPalette.punchGreen)
                            }
                        }

                        dividerLine

                        rowContainer {
                            valueMenuRow(
                                title: "Snooze Duration",
                                value: "\(draft.snoozeDurationMinutes) min"
                            ) {
                                ForEach(snoozeOptions, id: \.self) { option in
                                    Button("\(option) min") {
                                        draft.snoozeDurationMinutes = option
                                    }
                                }
                            }
                        }

                        dividerLine

                        rowContainer {
                            HStack {
                                Text("World Mode Consent")
                                    .font(AppTypography.pixel(19, weight: .semibold))
                                    .foregroundStyle(AppPalette.inkPrimary)
                                Spacer()
                                Toggle("", isOn: $worldConsent)
                                    .labelsHidden()
                                    .tint(AppPalette.punchGreen)
                            }
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: AppRadius.panel)
                            .fill(AlarmPalette.card)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppRadius.panel)
                                    .stroke(AppPalette.inkPrimary, lineWidth: 2)
                            )
                    )

                    if let onDelete {
                        Button {
                            onDelete()
                            dismiss()
                        } label: {
                            Text("Delete Alarm")
                                .font(AppTypography.pixel(20, weight: .semibold))
                                .foregroundStyle(AppPalette.inkPrimary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: AppRadius.card)
                                        .fill(AlarmPalette.card)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: AppRadius.card)
                                                .stroke(AppPalette.inkPrimary, lineWidth: 2)
                                        )
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 30)
            }
        }
    }

    private var dividerLine: some View {
        Rectangle()
            .fill(AlarmPalette.separator)
            .frame(height: 1)
            .padding(.horizontal, 14)
    }

    private func circleButton(symbol: String, fill: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(AppTypography.pixel(17, weight: .bold))
                .foregroundStyle(AppPalette.inkPrimary)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(fill)
                        .overlay(
                            Circle().stroke(AppPalette.inkPrimary, lineWidth: 2)
                        )
                )
        }
        .buttonStyle(.plain)
    }

    private func rowContainer<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        HStack {
            content()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 12)
    }

    private func valueMenuRow<MenuContent: View>(
        title: String,
        value: String,
        @ViewBuilder menuContent: () -> MenuContent
    ) -> some View {
        HStack {
            Text(title)
                .font(AppTypography.pixel(19, weight: .semibold))
                .foregroundStyle(AppPalette.inkPrimary)
            Spacer()
            Menu {
                menuContent()
            } label: {
                HStack(spacing: 4) {
                    Text(value)
                        .font(AppTypography.pixel(17, weight: .semibold))
                        .foregroundStyle(AppPalette.inkSecondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.65)
                        .allowsTightening(true)
                        .layoutPriority(1)
                    Image(systemName: "chevron.right")
                        .font(AppTypography.pixel(12, weight: .bold))
                        .foregroundStyle(AppPalette.inkMuted)
                }
                .frame(minWidth: 112, maxWidth: 230, alignment: .trailing)
            }
            .buttonStyle(.plain)
        }
    }
}

private struct IOSWheelTimePicker: View {
    @Binding var hour: Int
    @Binding var minute: Int

    var body: some View {
        GeometryReader { proxy in
            let pickerWidth = max((proxy.size.width - 56) / 2, 118)

            ZStack {
                HStack(spacing: 0) {
                    Picker("Hour", selection: $hour) {
                        ForEach(0..<24, id: \.self) { value in
                            Text(String(format: "%02d", value))
                                .font(AppTypography.pixel(34, weight: .regular))
                                .tag(value)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.wheel)
                    .frame(width: pickerWidth)
                    .clipped()

                    Text(":")
                        .font(AppTypography.pixel(36, weight: .semibold))
                        .foregroundStyle(AppPalette.inkPrimary)
                        .frame(width: 20)

                    Picker("Minute", selection: $minute) {
                        ForEach(0..<60, id: \.self) { value in
                            Text(String(format: "%02d", value))
                                .font(AppTypography.pixel(34, weight: .regular))
                                .tag(value)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.wheel)
                    .frame(width: pickerWidth)
                    .clipped()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(.horizontal, 2)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.panel, style: .continuous)
                .fill(AlarmPalette.card)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.panel, style: .continuous)
                        .stroke(AppPalette.inkPrimary, lineWidth: 2)
                )
        )
        .clipped()
    }
}

private extension Color {
    init(hex: UInt) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: 1.0
        )
    }
}

#Preview {
    ContentView()
}
