import UIKit

/// Общие константы приложения.
enum AppSettings {
    
    static let inset: CGFloat = 20
    
}

/// Идентификаторы уведомлений для операций с привычкой.
enum NotificationNames {
    static let habitDidCreate = NSNotification.Name("HabitDidCreate")
    static let habitDidUpdate = NSNotification.Name("HabitDidUpdate")
    static let habitDidDelete = NSNotification.Name("HabitDidDelete")
}


