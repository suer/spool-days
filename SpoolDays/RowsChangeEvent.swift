class RowsChangeEvent {
    enum EventType {
        case Delete, Move
    }
    var indexPath: NSIndexPath?
    var newIndexPath: NSIndexPath?
    var eventType: EventType

    init(indexPath: NSIndexPath?, newIndexPath: NSIndexPath?, eventType: EventType) {
        self.indexPath = indexPath
        self.newIndexPath = newIndexPath
        self.eventType = eventType
    }
}
