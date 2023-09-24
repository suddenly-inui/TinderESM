import UserNotifications

class NotificationService {
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("通知許可された")
            } else {
                print("通知許可されなかった")
            }
        }
    }
}
