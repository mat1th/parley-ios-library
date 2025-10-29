import Foundation
import UIKit

protocol ParleyMessageViewDelegate: AnyObject {
    @MainActor func didSelectMedia(_ media: MediaObject)
    @MainActor func shareMedia(url: URL, source: CGRect)
    @MainActor func didSelect(_ button: MessageButton)
}
