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
    static let standard: CGFloat = 2.8
    static let emphasis: CGFloat = 2.8
}

private enum AppPixel {
    static let step: CGFloat = 1
}

private enum AppPalette {
    static let appBackground = Color(hex: 0xEFEFF1)
    static let vibrantOrange = Color(hex: 0xC9833A)
    static let electricBlue = Color(hex: 0xB9C8E8)
    static let hotPink = Color(hex: 0xD09AB6)
    static let brightYellow = Color(hex: 0xE2B022)
    static let punchGreen = Color(hex: 0x45BFC0)
    static let blockOrange = Color(hex: 0xEC6E4E)
    static let blockYellow = Color(hex: 0xE2B022)
    static let blockPink = Color(hex: 0xC992AE)
    static let blockGray = Color(hex: 0xD9D9DD)
    static let blockGreen = Color(hex: 0x4E9E7D)
    static let white = Color(hex: 0xFFFFFF)
    static let inkPrimary = Color(hex: 0x1F1F1F)
    static let inkSecondary = Color(hex: 0x646464)
    static let inkMuted = Color(hex: 0x8D8D8D)
    static let accentPrimary = vibrantOrange
    static let accentSecondary = electricBlue
    static let accentBlue = electricBlue
    static let accentYellow = brightYellow
    static let flatShadow = Color(hex: 0xAEA89C).opacity(0.55)

    static let roomBoundary = Color(hex: 0x8D8D8D)
    static let roomWall = Color(hex: 0xE7E3DC)
    static let roomFloor = Color(hex: 0xE7E3DC)
    static let floorWashA = Color(hex: 0xE7E3DC)
    static let floorWashB = Color(hex: 0xE2E0DD)
    static let floorWashC = Color(hex: 0xECE9E3)
    static let roomTeal = Color(hex: 0x45BFC0)
    static let roomSage = Color(hex: 0xA7CFAF)
    static let roomMustard = Color(hex: 0xE2B022)
    static let roomCoral = Color(hex: 0xF17857)
    static let roomMistBlue = Color(hex: 0x9BB6D9)
    static let roomLavender = Color(hex: 0xC79AB4)

    static let boardWood = Color(hex: 0xD4BA82)
    static let boardPaper = Color(hex: 0xF4EEE2)
    static let bedBlanket = Color(hex: 0xC9D2E3)
    static let bedHeadboard = Color(hex: 0xA7B4CC)
    static let tvFrame = Color(hex: 0xA1A4AB)
    static let tvScreen = Color(hex: 0xF4F4F2)
    static let alarmShell = Color(hex: 0xDCDCDC)

    static let statusAwake = Color(hex: 0xDDE8E2)
    static let statusSleep = Color(hex: 0xE7E3DD)
    static let statusLate = Color(hex: 0xEEDBD0)
    static let tabBarBackground = Color(hex: 0x0F0F0F)
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
        VStack(spacing: 0) {
            Rectangle()
                .fill(AppPalette.white.opacity(0.15))
                .frame(height: 1)

            HStack(spacing: 0) {
                ForEach(AppTab.allCases, id: \.rawValue) { tab in
                    Button {
                        selected = tab
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: tab.icon)
                                .font(AppTypography.pixel(28, weight: .semibold))
                            Text(tab.title)
                                .font(AppTypography.pixel(12, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 64)
                        .foregroundStyle(
                            selected == tab
                                ? AppPalette.vibrantOrange
                                : AppPalette.white.opacity(0.94)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.bottom, 8)
        }
        .background(AppPalette.tabBarBackground.ignoresSafeArea(edges: .bottom))
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
    @State private var mapZoom: CGFloat = 1.12
    @State private var mapOffset: CGSize = .zero
    @GestureState private var mapDrag: CGSize = .zero
    @GestureState private var mapPinch: CGFloat = 1

    private let ticker = Timer.publish(every: 0.8, on: .main, in: .common).autoconnect()
    private let minMapZoom: CGFloat = 0.7
    private let maxMapZoom: CGFloat = 2.5
    private let defaultMapZoom: CGFloat = 1.12

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
                        ZStack {
                            RoomBackground(
                                layout: layout
                            )

                            RoomFurnitureLayer(
                                layout: layout,
                                awakeCount: awakeCount,
                                sleepingCount: sleepingCount,
                                lateCount: lateCount,
                                onBoardTap: { showRankingScreen = true },
                                onAlarmTap: { showWakeScheduleScreen = true },
                                onWorldAlarmTap: { showWorldAlarmScreen = true }
                            )

                            ForEach(members) { member in
                                if let slot = bedSlot(for: member.id) {
                                    BedSlotView(
                                        isSleeping: member.status == .sleeping,
                                        tint: bedTint(for: slot.id)
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
            .padding(.bottom, 92)

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
                    .padding(.bottom, 106)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .onAppear {
            mapZoom = defaultMapZoom // FIX 2 keep default centered scale on open
            mapOffset = .zero // FIX 2 prevent stale drag offset on reopen
            ensureMemberSlots()
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
                        wakeComposeDraft = nil
                        wakeComposeMessage = ""
                    }
                },
                onSend: {
                    guard let draft = wakeComposeDraft else { return }
                    sendWakeDraft(draft: draft, message: wakeComposeMessage)
                    wakeComposeDraft = nil
                    wakeComposeMessage = ""
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

    private func bedTint(for slotID: Int) -> Color {
        let palette: [Color] = [
            AppPalette.blockYellow,
            AppPalette.blockOrange,
            AppPalette.blockPink,
            AppPalette.roomTeal,
            AppPalette.roomMistBlue,
            AppPalette.roomSage,
            AppPalette.roomLavender,
            AppPalette.blockYellow,
            AppPalette.blockOrange
        ]
        return palette[slotID % palette.count]
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
                    members[newIndex].position = randomRoamPoint(in: slot)
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
        wakeComposeMessage = ""
        withAnimation(.easeInOut(duration: 0.2)) {
            wakeComposeDraft = WakeComposeDraft(
                target: .family(memberID: memberID),
                targetTitle: members[targetIndex].name
            )
        }
    }

    private func handleTap(on memberID: UUID) {
        guard let targetIndex = members.firstIndex(where: { $0.id == memberID }) else { return }

        if members[targetIndex].status == .awake {
            wakeBanner = "\(members[targetIndex].name) is already awake."
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
        guard let targetSlot = bedSlot(for: memberID) else { return }

        let targetID = memberID
        wakeActionMemberID = nil
        wakeReactionMemberID = nil
        let meCurrent = members[meIndex].position
        let meRoom = roomContaining(meCurrent)
        let targetRoom = roomForMember(targetID)
        let startPoint = meRoom == nil
            ? clampedToCommon(meCurrent, inset: 0.10)
            : clampedToRoom(meCurrent, room: meRoom!.rect, inset: 0.10)
        let approachPoint = clampedToRoom(
            CGPoint(
                x: targetSlot.roomRect.midX,
                y: targetSlot.roomRect.midY + 0.03
            ),
            room: targetSlot.roomRect,
            inset: 0.10
        )

        wakeMission = WakeMission(targetID: targetID)

        let approachRoute = routeBetween(
            start: startPoint,
            startRoom: meRoom,
            end: approachPoint,
            endRoom: targetRoom
        )

        moveMember(
            memberID: members[meIndex].id,
            along: approachRoute,
            movingActivity: "Walking",
            speedPerSecond: 0.23
        ) {
            guard let safeTarget = members.firstIndex(where: { $0.id == targetID }),
                  let safeMe = members.firstIndex(where: { $0.isMe }) else {
                wakeMission = nil
                return
            }

            let targetName = members[safeTarget].name
            withAnimation(.easeInOut(duration: 0.16).repeatCount(4, autoreverses: true)) {
                wakeActionMemberID = members[safeMe].id
                members[safeMe].activity = "Calling \(targetName)"
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
                        members[wakeTarget].position = randomRoamPoint(in: slot)
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
    }

    private func wanderAwakeMembers() {
        for index in members.indices {
            guard let slot = bedSlot(for: members[index].id) else { continue }

            if members[index].status == .sleeping {
                members[index].position = slot.bedPoint
                continue
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
        for index in members.indices {
            guard let slot = bedSlot(for: members[index].id) else { continue }
            if members[index].status == .sleeping {
                members[index].position = slot.bedPoint
            } else if !floorPlanBounds.contains(members[index].position) {
                members[index].position = randomRoamPoint(in: slot)
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
        var mapping: [UUID: Int] = [:]
        var used = Set<Int>()

        // Keep prior assignments only if still valid and unique.
        for member in members {
            guard let prior = memberSlotByID[member.id], slots.indices.contains(prior), !used.contains(prior) else {
                continue
            }
            mapping[member.id] = prior
            used.insert(prior)
        }

        // Deterministic baseline for initial layout.
        if mapping.isEmpty {
            for (index, member) in members.enumerated() where slots.indices.contains(index) && !used.contains(index) {
                mapping[member.id] = index
                used.insert(index)
            }
        }

        // Fill all remaining members with nearest free slot.
        for member in members where mapping[member.id] == nil {
            let reference = member.id == memberID ? entryPoint : CGPoint(x: 0.5, y: 0.78)
            if let candidate = nearestAvailableSlot(from: reference, slots: slots, used: used) {
                mapping[member.id] = candidate
                used.insert(candidate)
            }
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
        }

        let total = min(max(memberCount, 4), FamilySample.maxMembers)
        let commonRect = CGRect(x: 0.22, y: 0.36, width: 0.46, height: 0.46)

        var templates: [RoomTemplate] = [
            // Top-left room (yellow bed)
            RoomTemplate(
                rect: CGRect(x: 0.08, y: 0.16, width: 0.28, height: 0.20),
                door: RoomDoor(edge: .bottom, center: 0.22, width: 0.17),
                bedPoint: CGPoint(x: 0.21, y: 0.24),
                washIndex: 0
            ),
            // Top-middle room (orange bed)
            RoomTemplate(
                rect: CGRect(x: 0.36, y: 0.16, width: 0.28, height: 0.20),
                door: RoomDoor(edge: .bottom, center: 0.50, width: 0.17),
                bedPoint: CGPoint(x: 0.50, y: 0.24),
                washIndex: 1
            ),
            // Mid-left room (pink bed)
            RoomTemplate(
                rect: CGRect(x: 0.08, y: 0.56, width: 0.34, height: 0.24),
                door: RoomDoor(edge: .right, center: 0.67, width: 0.17),
                bedPoint: CGPoint(x: 0.22, y: 0.66),
                washIndex: 2
            ),
            // Bottom-right room (teal bed)
            RoomTemplate(
                rect: CGRect(x: 0.42, y: 0.84, width: 0.44, height: 0.26),
                door: RoomDoor(edge: .top, center: 0.60, width: 0.19),
                bedPoint: CGPoint(x: 0.63, y: 0.95),
                washIndex: 3
            )
        ]

        let expansionTemplates: [RoomTemplate] = [
            // Expansion #1: right
            RoomTemplate(
                rect: CGRect(x: 0.64, y: 0.22, width: 0.22, height: 0.34),
                door: RoomDoor(edge: .left, center: 0.46, width: 0.17),
                bedPoint: CGPoint(x: 0.75, y: 0.33),
                washIndex: 4
            ),
            // Expansion #2: down
            RoomTemplate(
                rect: CGRect(x: 0.50, y: 1.10, width: 0.24, height: 0.22),
                door: RoomDoor(edge: .top, center: 0.62, width: 0.18),
                bedPoint: CGPoint(x: 0.62, y: 1.19),
                washIndex: 0
            ),
            // Expansion #3: left
            RoomTemplate(
                rect: CGRect(x: -0.12, y: 0.88, width: 0.20, height: 0.22),
                door: RoomDoor(edge: .right, center: 0.99, width: 0.17),
                bedPoint: CGPoint(x: -0.02, y: 0.97),
                washIndex: 1
            )
        ]

        let extraCount = min(max(0, total - 4), expansionTemplates.count)
        templates.append(contentsOf: expansionTemplates.prefix(extraCount))

        let rooms: [FloorRoom] = templates.enumerated().map { index, template in
            FloorRoom(id: index, rect: template.rect, door: template.door, washIndex: template.washIndex)
        }

        let slots: [BedroomSlot] = templates.enumerated().map { index, template in
            makeBedroomSlot(
                id: index,
                roomID: index,
                roomRect: template.rect,
                door: template.door,
                bedPoint: template.bedPoint,
                isLeft: template.rect.midX < commonRect.midX
            )
        }

        let allRects = rooms.map(\.rect) + [commonRect]
        let minX = allRects.map(\.minX).min() ?? 0.06
        let maxX = allRects.map(\.maxX).max() ?? 0.92
        let topY = allRects.map(\.minY).min() ?? 0.14
        let bottomY = allRects.map(\.maxY).max() ?? 1.10

        let rightWingBottom = max(
            commonRect.maxY,
            rooms.filter { $0.rect.minX >= commonRect.maxX - 0.001 }.map(\.rect.maxY).max() ?? commonRect.maxY
        )
        let leftWingBottom = max(
            commonRect.maxY,
            rooms.filter { $0.rect.maxX <= commonRect.minX + 0.001 }.map(\.rect.maxY).max() ?? commonRect.maxY
        )

        let outlinePoints: [CGPoint] = [
            CGPoint(x: minX, y: topY),
            CGPoint(x: maxX, y: topY),
            CGPoint(x: maxX, y: rightWingBottom),
            CGPoint(x: commonRect.maxX, y: rightWingBottom),
            CGPoint(x: commonRect.maxX, y: bottomY),
            CGPoint(x: minX, y: bottomY),
            CGPoint(x: minX, y: leftWingBottom),
            CGPoint(x: commonRect.minX, y: leftWingBottom),
            CGPoint(x: commonRect.minX, y: commonRect.maxY),
            CGPoint(x: minX, y: commonRect.maxY),
            CGPoint(x: minX, y: topY)
        ]

        let furniture = FurnitureAnchors(
            bulletin: CGPoint(x: 0.79, y: 0.77),
            tv: CGPoint(x: 0.46, y: 0.57),
            alarm: CGPoint(x: 0.79, y: 0.60),
            worldAlarm: CGPoint(x: 0.79, y: 0.69)
        )

        return FloorLayout(
            planHeight: max(1.34, bottomY + 0.16),
            floorBounds: CGRect(x: minX, y: topY, width: maxX - minX, height: bottomY - topY),
            commonRect: commonRect,
            rooms: rooms,
            slots: slots,
            outlinePoints: outlinePoints,
            furniture: furniture
        )
    }

    private func makeBedroomSlot(
        id: Int,
        roomID: Int,
        roomRect: CGRect,
        door: RoomDoor,
        bedPoint: CGPoint,
        isLeft: Bool
    ) -> BedroomSlot {
        let roamRect = roomRect.insetBy(
            dx: max(0.05, roomRect.width * 0.14),
            dy: max(0.05, roomRect.height * 0.15)
        )
        return BedroomSlot(
            id: id,
            roomID: roomID,
            roomRect: roomRect,
            door: door,
            doorPoint: door.point(in: roomRect, inset: 0.095),
            bedPoint: bedPoint,
            roamRect: roamRect,
            isLeftColumn: isLeft
        )
    }

    private func randomRoamPoint(in slot: BedroomSlot) -> CGPoint {
        CGPoint(
            x: clamp(.random(in: slot.roamRect.minX...slot.roamRect.maxX), lower: floorPlanBounds.minX, upper: floorPlanBounds.maxX),
            y: clamp(.random(in: slot.roamRect.minY...slot.roamRect.maxY), lower: floorPlanBounds.minY, upper: floorPlanBounds.maxY)
        )
    }

    private struct WalkTarget {
        let point: CGPoint
        let room: FloorRoom?
    }

    private func roomContaining(_ point: CGPoint) -> FloorRoom? {
        floorLayout.rooms.first(where: { $0.rect.contains(point) })
    }

    private func roomForMember(_ memberID: UUID) -> FloorRoom? {
        guard let slot = bedSlot(for: memberID) else { return nil }
        return floorLayout.rooms.first(where: { $0.id == slot.roomID })
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
            let roam = room.rect.insetBy(dx: 0.06, dy: 0.07)
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
            CGRect(x: anchors.tv.x - 0.14, y: anchors.tv.y - 0.09, width: 0.28, height: 0.18),
            CGRect(x: anchors.alarm.x - 0.08, y: anchors.alarm.y - 0.06, width: 0.16, height: 0.13),
            CGRect(x: anchors.worldAlarm.x - 0.08, y: anchors.worldAlarm.y - 0.06, width: 0.16, height: 0.13),
            CGRect(x: anchors.bulletin.x - 0.09, y: anchors.bulletin.y - 0.08, width: 0.18, height: 0.17)
        ]
    }

    private func collidesFurniture(_ point: CGPoint) -> Bool {
        furnitureAvoidRects().contains(where: { $0.contains(point) })
    }

    private func pickWanderTarget(
        memberID: UUID,
        from start: CGPoint,
        startRoom: FloorRoom?
    ) -> WalkTarget {
        let last = lastWanderTargetByID[memberID]
        let minMoveDistanceSq: CGFloat = 0.035 * 0.035

        var fallback = randomWalkTarget()
        for _ in 0..<10 {
            let candidate = randomWalkTarget()
            if collidesFurniture(candidate.point) {
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
            fallback = WalkTarget(point: clampedToCommon(entryPoint), room: nil)
        }
        if collidesFurniture(fallback.point) {
            fallback = WalkTarget(point: clampedToCommon(entryPoint), room: nil)
        }
        return fallback
    }

    private func routeBetween(
        start: CGPoint,
        startRoom: FloorRoom?,
        end: CGPoint,
        endRoom: FloorRoom?
    ) -> [CGPoint] {
        let cleanStart = startRoom == nil
            ? clampedToCommon(start, inset: 0.10)
            : clampedToRoom(start, room: startRoom!.rect, inset: 0.10)
        let cleanEnd = endRoom == nil
            ? clampedToCommon(end, inset: 0.10)
            : clampedToRoom(end, room: endRoom!.rect, inset: 0.10)

        if let s = startRoom, let e = endRoom, s.id == e.id {
            return simplifyRoute(compactRoute([cleanStart, cleanEnd]))
        }

        var route: [CGPoint] = [cleanStart]

        if let s = startRoom {
            let roomDoor = s.door.point(in: s.rect, inset: 0.095)
            let commonDoor = commonDoorPoint(for: s, inset: 0.095)
            route.append(CGPoint(x: cleanStart.x, y: roomDoor.y))
            route.append(roomDoor)
            route.append(commonDoor)
        }

        if let e = endRoom {
            let targetCommonDoor = commonDoorPoint(for: e, inset: 0.095)
            if let last = route.last {
                route.append(CGPoint(x: targetCommonDoor.x, y: last.y))
            }
            route.append(targetCommonDoor)
            let targetRoomDoor = e.door.point(in: e.rect, inset: 0.095)
            route.append(targetRoomDoor)
            route.append(CGPoint(x: cleanEnd.x, y: targetRoomDoor.y))
        } else {
            if let last = route.last {
                route.append(CGPoint(x: cleanEnd.x, y: last.y))
            }
        }

        route.append(cleanEnd)
        return simplifyRoute(compactRoute(route))
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
            let target = points[index]
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

    private func clampedToRoom(_ point: CGPoint, room: CGRect, inset: CGFloat = 0.06) -> CGPoint {
        CGPoint(
            x: clamp(point.x, lower: room.minX + inset, upper: room.maxX - inset),
            y: clamp(point.y, lower: room.minY + inset, upper: room.maxY - inset)
        )
    }

    private func clampedToFloor(_ point: CGPoint) -> CGPoint {
        CGPoint(
            x: clamp(point.x, lower: floorPlanBounds.minX + 0.03, upper: floorPlanBounds.maxX - 0.03),
            y: clamp(point.y, lower: floorPlanBounds.minY + 0.03, upper: floorPlanBounds.maxY - 0.03)
        )
    }

    private func clampedToCommon(_ point: CGPoint, inset: CGFloat = 0.11) -> CGPoint {
        CGPoint(
            x: clamp(point.x, lower: floorLayout.commonRect.minX + inset, upper: floorLayout.commonRect.maxX - inset),
            y: clamp(point.y, lower: floorLayout.commonRect.minY + inset, upper: floorLayout.commonRect.maxY - inset)
        )
    }

    private func commonDoorPoint(for room: FloorRoom, inset: CGFloat) -> CGPoint {
        let common = floorLayout.commonRect
        let interiorProbe = room.rect.insetBy(dx: 0.002, dy: 0.002)
        if common.contains(interiorProbe) {
            return room.door.point(in: room.rect, inset: inset)
        }
        switch room.door.edge {
        case .top:
            return CGPoint(x: room.door.center, y: common.maxY - inset)
        case .bottom:
            return CGPoint(x: room.door.center, y: common.minY + inset)
        case .left:
            return CGPoint(x: common.maxX - inset, y: room.door.center)
        case .right:
            return CGPoint(x: common.minX + inset, y: room.door.center)
        }
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
            handleTap(on: memberID)
        case .world(let worldID):
            guard let index = worldSleepers.firstIndex(where: { $0.id == worldID }) else { return }
            worldSleepers[index].isAwake = true
            worldSleepers[index].lateMinutes = 0
            wakeBanner = "Late alarm sent to \(worldSleepers[index].name)."
            clearBannerLater()
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
                    .foregroundStyle(AppPalette.inkPrimary)
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
                    .foregroundStyle(AppPalette.inkPrimary)
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

            ZStack {
                VStack(spacing: 4) {
                    TVObject(
                        awakeCount: awakeCount,
                        sleepingCount: sleepingCount,
                        lateCount: lateCount
                    )
                    furnitureLabel("TV")
                }
                .position(
                    x: size.width * layout.furniture.tv.x,
                    y: mapY(layout.furniture.tv.y)
                )

                VStack(spacing: 4) {
                    AlarmClockObject(onTap: onAlarmTap)
                    furnitureLabel("Alarm")
                }
                .position(
                    x: size.width * layout.furniture.alarm.x,
                    y: mapY(layout.furniture.alarm.y)
                )

                VStack(spacing: 4) {
                    WorldAlarmObject(onTap: onWorldAlarmTap)
                    furnitureLabel("World Alarm")
                }
                .position(
                    x: size.width * layout.furniture.worldAlarm.x,
                    y: mapY(layout.furniture.worldAlarm.y)
                )

                VStack(spacing: 4) {
                    BulletinBoardObject(onTap: onBoardTap)
                    furnitureLabel("Bulletin")
                }
                .position(
                    x: size.width * layout.furniture.bulletin.x,
                    y: mapY(layout.furniture.bulletin.y)
                )
            }
        }
    }

    private func furnitureLabel(_ title: String) -> some View {
        Text(title)
            .font(AppTypography.pixel(11, weight: .semibold))
            .foregroundStyle(AppPalette.inkPrimary)
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(AppPalette.roomWall.opacity(0.96))
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
                    .frame(width: 76, height: 86)
                    .offset(x: 4, y: 4)

                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(AppPalette.boardWood)
                    .frame(width: 80, height: 92)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(AppPalette.roomBoundary, lineWidth: AppStroke.standard)
                    )

                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(AppPalette.boardPaper)
                    .frame(width: 64, height: 72)

                Capsule()
                    .fill(AppPalette.roomTeal.opacity(0.9))
                    .frame(width: 24, height: 10)
                    .offset(x: -8, y: -16)

                Capsule()
                    .fill(AppPalette.roomMustard.opacity(0.9))
                    .frame(width: 22, height: 10)
                    .offset(x: 10, y: -2)

                Capsule()
                    .fill(AppPalette.accentPrimary.opacity(0.85))
                    .frame(width: 24, height: 10)
                    .offset(y: 14)
            }
            .frame(width: 92, height: 102)
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
                .frame(width: 174, height: 96)
                .offset(x: 5, y: 5)

            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(AppPalette.alarmShell)
                .frame(width: 174, height: 96)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(AppPalette.roomBoundary, lineWidth: AppStroke.standard)
                )

            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppPalette.tvScreen)
                .frame(width: 142, height: 62)
                .overlay {
                    HStack(spacing: 4) {
                        statusChip(title: "Awake", value: awakeCount, tone: AppPalette.statusAwake)
                        statusChip(title: "Sleep", value: sleepingCount, tone: AppPalette.statusSleep)
                        statusChip(title: "Late", value: lateCount, tone: AppPalette.statusLate)
                    }
                    .padding(.horizontal, 4)
                }
                .offset(y: -3)

            Path { path in
                path.move(to: CGPoint(x: 12, y: 10))
                path.addLine(to: CGPoint(x: 0, y: 0))
                path.move(to: CGPoint(x: 24, y: 10))
                path.addLine(to: CGPoint(x: 36, y: 0))
            }
            .stroke(AppPalette.roomBoundary, lineWidth: AppStroke.standard)
            .frame(width: 36, height: 12)
            .offset(y: -50)
        }
        .frame(width: 186, height: 108)
    }

    private func statusChip(title: String, value: Int, tone: Color) -> some View {
        HStack(spacing: 3) {
            Text(title)
                .font(AppTypography.pixel(9, weight: .semibold))
            Text("\(value)")
                .font(AppTypography.pixel(10, weight: .bold))
        }
        .foregroundStyle(AppPalette.inkPrimary)
        .padding(.horizontal, 5)
        .padding(.vertical, 3)
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
                    .frame(width: 76, height: 10)
                    .offset(y: 24)

                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(AppPalette.alarmShell)
                    .frame(width: 58, height: 38)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(AppPalette.roomBoundary, lineWidth: AppStroke.standard)
                    )

                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(AppPalette.white)
                    .frame(width: 34, height: 20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(AppPalette.roomBoundary, lineWidth: AppStroke.standard)
                    )
                    .overlay {
                        Capsule()
                            .fill(AppPalette.inkPrimary)
                            .frame(width: 2, height: 6)
                            .offset(y: -3)
                        Capsule()
                            .fill(AppPalette.inkPrimary)
                            .frame(width: 6, height: 2)
                            .offset(x: 4, y: 1)
                    }
                    .offset(y: 1)

                HStack(spacing: 24) {
                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .fill(AppPalette.roomMustard)
                        .frame(width: 10, height: 8)
                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .fill(AppPalette.roomMustard)
                        .frame(width: 10, height: 8)
                }
                .offset(y: -21)
            }
            .frame(width: 86, height: 68)
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
                    .frame(width: 64, height: 46)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(AppPalette.blockOrange, lineWidth: AppStroke.standard)
                    )

                Image(systemName: "clock")
                    .font(AppTypography.pixel(18, weight: .bold))
                    .foregroundStyle(AppPalette.inkPrimary)
            }
            .frame(width: 86, height: 66)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Open World Alarm")
    }
}

private struct RoomBackground: View {
    let layout: FloorLayout
    private let wallLineWidth: CGFloat = AppStroke.standard
    private let innerWallLineWidth: CGFloat = AppStroke.standard

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
        return points
    }

    private struct LineSegment {
        let horizontal: Bool
        let fixed: CGFloat
        let start: CGFloat
        let end: CGFloat
    }

    private func innerWallsPath(in size: CGSize) -> Path {
        var path = Path()
        for segment in deduplicatedInnerSegments(in: size) {
            if segment.horizontal {
                path.move(to: CGPoint(x: segment.start, y: segment.fixed))
                path.addLine(to: CGPoint(x: segment.end, y: segment.fixed))
            } else {
                path.move(to: CGPoint(x: segment.fixed, y: segment.start))
                path.addLine(to: CGPoint(x: segment.fixed, y: segment.end))
            }
        }
        return path
    }

    private func deduplicatedInnerSegments(in size: CGSize) -> [LineSegment] {
        var segments: [LineSegment] = []

        for room in layout.rooms {
            let rect = normalizedRect(room.rect, in: size)
            let doorCenter = normalizedDoorCenter(room.door, roomRect: room.rect, in: size)
            let doorHalfW = max(pixelStep * 3.2, room.door.width * size.width * 0.5)
            let doorHalfH = max(pixelStep * 3.2, (room.door.width / layout.planHeight) * size.height * 0.5)

            func addHorizontal(y: CGFloat, startX: CGFloat, endX: CGFloat) {
                let start = min(startX, endX)
                let end = max(startX, endX)
                guard end - start > 1 else { return }
                segments.append(LineSegment(horizontal: true, fixed: y, start: start, end: end))
            }

            func addVertical(x: CGFloat, startY: CGFloat, endY: CGFloat) {
                let start = min(startY, endY)
                let end = max(startY, endY)
                guard end - start > 1 else { return }
                segments.append(LineSegment(horizontal: false, fixed: x, start: start, end: end))
            }

            if !isEdgeOnOutline(horizontal: true, fixed: room.rect.minY, start: room.rect.minX, end: room.rect.maxX) {
                if room.door.edge == .top {
                    addHorizontal(y: rect.minY, startX: rect.minX, endX: doorCenter.x - doorHalfW)
                    addHorizontal(y: rect.minY, startX: doorCenter.x + doorHalfW, endX: rect.maxX)
                } else {
                    addHorizontal(y: rect.minY, startX: rect.minX, endX: rect.maxX)
                }
            }

            if !isEdgeOnOutline(horizontal: true, fixed: room.rect.maxY, start: room.rect.minX, end: room.rect.maxX) {
                if room.door.edge == .bottom {
                    addHorizontal(y: rect.maxY, startX: rect.minX, endX: doorCenter.x - doorHalfW)
                    addHorizontal(y: rect.maxY, startX: doorCenter.x + doorHalfW, endX: rect.maxX)
                } else {
                    addHorizontal(y: rect.maxY, startX: rect.minX, endX: rect.maxX)
                }
            }

            if !isEdgeOnOutline(horizontal: false, fixed: room.rect.minX, start: room.rect.minY, end: room.rect.maxY) {
                if room.door.edge == .left {
                    addVertical(x: rect.minX, startY: rect.minY, endY: doorCenter.y - doorHalfH)
                    addVertical(x: rect.minX, startY: doorCenter.y + doorHalfH, endY: rect.maxY)
                } else {
                    addVertical(x: rect.minX, startY: rect.minY, endY: rect.maxY)
                }
            }

            if !isEdgeOnOutline(horizontal: false, fixed: room.rect.maxX, start: room.rect.minY, end: room.rect.maxY) {
                if room.door.edge == .right {
                    addVertical(x: rect.maxX, startY: rect.minY, endY: doorCenter.y - doorHalfH)
                    addVertical(x: rect.maxX, startY: doorCenter.y + doorHalfH, endY: rect.maxY)
                } else {
                    addVertical(x: rect.maxX, startY: rect.minY, endY: rect.maxY)
                }
            }
        }

        var unique: [String: LineSegment] = [:]
        for segment in segments {
            let fixed = Int((segment.fixed * 100).rounded())
            let start = Int((segment.start * 100).rounded())
            let end = Int((segment.end * 100).rounded())
            let key = "\(segment.horizontal)-\(fixed)-\(start)-\(end)"
            unique[key] = segment
        }
        return Array(unique.values)
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
        let tolerance: CGFloat = 0.0008
        let targetStart = min(start, end)
        let targetEnd = max(start, end)
        let targetLength = targetEnd - targetStart

        guard targetLength > 0.001 else { return false }

        for segment in outlineAxisSegments() where segment.horizontal == horizontal {
            if abs(segment.fixed - fixed) > tolerance {
                continue
            }
            let overlap = max(0, min(targetEnd, segment.end) - max(targetStart, segment.start))
            if overlap >= targetLength - 0.0015 {
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
    let tint: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AppPalette.flatShadow.opacity(0.55))
                .frame(width: 126, height: 76)
                .offset(x: 4, y: 4)

            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AppPalette.roomWall)
                .frame(width: 126, height: 76)

            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(AppPalette.white)
                    .frame(width: 30, height: 44)
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(isSleeping ? tint.opacity(0.68) : tint)
                    .frame(width: 78, height: 46)
            }
        }
        .frame(width: 126, height: 76)
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
        VStack(spacing: 3) {
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
                .font(AppTypography.pixel(10, weight: .bold))
                .foregroundStyle(AppPalette.inkPrimary)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(
                    Capsule()
                        .fill(AppPalette.white)
                )

            Text(member.activity)
                .font(AppTypography.pixel(8, weight: .semibold))
                .foregroundStyle(AppPalette.inkMuted)
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
                .frame(width: 58, height: 58)
                .shadow(color: AppPalette.flatShadow.opacity(0.35), radius: 0, x: 2, y: 3)

            if member.status == .sleeping {
                sleepingEyes
                    .offset(y: -2)
            } else {
                normalEyes
                    .offset(y: -1)
                if isWakeReaction {
                    Circle()
                        .fill(AppPalette.inkPrimary)
                        .frame(width: 4, height: 4)
                        .offset(y: 10)
                } else {
                    Capsule()
                        .fill(AppPalette.inkPrimary)
                        .frame(width: 10, height: 2)
                        .offset(y: 10)
                }
            }
        }
        .frame(width: 62, height: 62)
    }

    private var avatarShape: AnyShape {
        member.avatar.bodyShape.view
    }

    private var normalEyes: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(AppPalette.white)
                .frame(width: 18, height: 18)
                .overlay(Circle().fill(AppPalette.inkPrimary).frame(width: 12, height: 12))
            Circle()
                .fill(AppPalette.white)
                .frame(width: 18, height: 18)
                .overlay(Circle().fill(AppPalette.inkPrimary).frame(width: 12, height: 12))
        }
    }

    private var sleepingEyes: some View {
        HStack(spacing: 10) {
            Capsule()
                .fill(AppPalette.inkPrimary)
                .frame(width: 12, height: 3)
            Capsule()
                .fill(AppPalette.inkPrimary)
                .frame(width: 12, height: 3)
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
            return RoundedRectangle(cornerRadius: rect.width * 0.30, style: .continuous).path(in: rect)
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
        VStack(alignment: .leading, spacing: 8) {
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
                        .font(AppTypography.pixel(13, weight: .black))
                        .foregroundStyle(AppPalette.inkSecondary)

                    if overdue && !member.isMe {
                        Button {
                            onWakeTap(member.id)
                        } label: {
                            Text("Wake Up")
                                .font(AppTypography.pixel(11, weight: .black))
                                .foregroundStyle(AppPalette.inkPrimary)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(AppPalette.blockGray)
                                        .overlay(
                                            Capsule()
                                                .stroke(AppPalette.inkPrimary, lineWidth: AppStroke.standard)
                                        )
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
                .padding(.vertical, 7)
                .background(
                    RoundedRectangle(cornerRadius: AppRadius.control)
                        .fill(AppPalette.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppRadius.control)
                                .stroke(AppPalette.inkPrimary, lineWidth: overdue ? 1.8 : 1.4)
                        )
                )
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.card)
                .fill(AppPalette.white)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.card)
                        .stroke(AppPalette.inkPrimary, lineWidth: 2)
                )
        )
    }
}

private struct WakeScheduleFullScreenView: View {
    let members: [FamilyMember]
    let isOverdue: (FamilyMember) -> Bool
    let onWakeTap: (UUID) -> Void
    let formatWake: (FamilyMember) -> String
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    onBack()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(AppTypography.pixel(16, weight: .semibold))
                    .foregroundStyle(AppPalette.inkPrimary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(AppPalette.white)
                            .overlay(
                                Capsule().stroke(AppPalette.inkPrimary, lineWidth: AppStroke.standard)
                            )
                    )
                }
                .buttonStyle(.plain)

                Spacer()

                Text("Wake Schedule")
                    .font(AppTypography.pixel(30, weight: .bold))
                    .foregroundStyle(AppPalette.inkPrimary)

                Spacer()
                Color.clear.frame(width: 84, height: 1)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 10)

            ScrollView(showsIndicators: false) {
                WakeScheduleListView(
                    members: members,
                    isOverdue: isOverdue,
                    onWakeTap: onWakeTap,
                    formatWake: formatWake
                )
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
        }
        .background(
            AppPalette.appBackground
                .ignoresSafeArea()
        )
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
        0x42B9BB,
        0xCC95AE,
        0xEE6C4D,
        0xE2AF26,
        0x7692CC,
        0x6EC9B1,
        0xB8AFE0,
        0xE8B27B,
        0x9CB9D9,
        0xAFCDBA
    ]

    static let avatarCatalog: [AvatarTheme] = [
        AvatarTheme(id: "shape-teal-square", fillHex: 0x42B9BB, bodyShape: .roundedSquare, faceStyle: .classic),
        AvatarTheme(id: "shape-pink-pentagon", fillHex: 0xCC95AE, bodyShape: .pentagon, faceStyle: .classic),
        AvatarTheme(id: "shape-coral-circle", fillHex: 0xEE6C4D, bodyShape: .coralCircle, faceStyle: .classic),
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
            position: CGPoint(x: 0.16, y: 0.50),
            isMe: true,
            activity: "Walking"
        ),
        FamilyMember(
            id: UUID(),
            name: "Ruby",
            avatar: avatarTheme(with: "shape-pink-pentagon"),
            status: .awake,
            wakeSchedule: WakeSchedule(hour: 7, minute: 45),
            position: CGPoint(x: 0.24, y: 0.62),
            isMe: false,
            activity: "Walking"
        ),
        FamilyMember(
            id: UUID(),
            name: "Will",
            avatar: avatarTheme(with: "shape-coral-circle"),
            status: .awake,
            wakeSchedule: WakeSchedule(hour: 8, minute: 20),
            position: CGPoint(x: 0.61, y: 0.72),
            isMe: false,
            activity: "Walking"
        ),
        FamilyMember(
            id: UUID(),
            name: "Mason",
            avatar: avatarTheme(with: "shape-yellow-four"),
            status: .awake,
            wakeSchedule: WakeSchedule(hour: 9, minute: 30),
            position: CGPoint(x: 0.46, y: 0.80),
            isMe: false,
            activity: "Walking"
        ),
        FamilyMember(
            id: UUID(),
            name: "Eric",
            avatar: avatarTheme(with: "shape-blue-arch"),
            status: .awake,
            wakeSchedule: WakeSchedule(hour: 8, minute: 40),
            position: CGPoint(x: 0.43, y: 0.94),
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
        VStack(spacing: 0) {
            HStack {
                Button {
                    onBack()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(AppTypography.pixel(16, weight: .semibold))
                    .foregroundStyle(AppPalette.inkPrimary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(AppPalette.white)
                            .overlay(
                                Capsule()
                                    .stroke(AppPalette.inkPrimary, lineWidth: AppStroke.standard)
                            )
                    )
                }
                .buttonStyle(.plain)

                Spacer()

                Text("Ranking")
                    .font(AppTypography.pixel(30, weight: .bold))
                    .foregroundStyle(AppPalette.inkPrimary)

                Spacer()
                Color.clear.frame(width: 84, height: 1)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 10)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(sections) { section in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(section.title)
                                .font(AppTypography.pixel(16, weight: .semibold))
                                .foregroundStyle(AppPalette.inkPrimary)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(section.tint)
                                        .overlay(
                                            Capsule()
                                                .stroke(AppPalette.inkPrimary, lineWidth: AppStroke.standard)
                                        )
                                )

                            ForEach(section.rows) { row in
                                HStack {
                                    Text("#\(row.rank)")
                                        .font(AppTypography.pixel(16, weight: .bold))
                                        .frame(width: 36)
                                        .padding(.vertical, 5)
                                        .background(
                                            RoundedRectangle(cornerRadius: AppRadius.micro)
                                                .fill(AppPalette.blockGray)
                                        )
                                        .foregroundStyle(AppPalette.inkPrimary)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(row.name)
                                            .font(AppTypography.pixel(16, weight: .semibold))
                                            .foregroundStyle(AppPalette.inkPrimary)
                                        Text(row.score)
                                            .font(AppTypography.pixel(13, weight: .regular))
                                            .foregroundStyle(AppPalette.inkSecondary)
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: AppRadius.card)
                                        .fill(AppPalette.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: AppRadius.card)
                                                .stroke(AppPalette.inkPrimary, lineWidth: AppStroke.standard)
                                        )
                                )
                            }
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: AppRadius.card)
                                .fill(AppPalette.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppRadius.card)
                                        .stroke(AppPalette.inkPrimary, lineWidth: AppStroke.standard)
                                )
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .background(AppPalette.appBackground.ignoresSafeArea())
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
