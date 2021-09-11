//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import Foundation
import FeedFeature

final class FeedViewModel {
	typealias Observer<T> = (T) -> Void

	private let feedLoader: FeedLoader

	init(feedLoader: FeedLoader) {
		self.feedLoader = feedLoader
	}

	var title: String {
		Localized.Feed.title
	}

	var errorMessage: String {
		Localized.Feed.error
	}

	var onLoadingStateChange: Observer<Bool>?
	var onFeedLoad: Observer<[FeedImage]>?
	var onFeedLoadFailure: Observer<String>?

	func loadFeed() {
		onLoadingStateChange?(true)
		feedLoader.load { [weak self] result in
			switch result {
			case let .success(feed):
				self?.onFeedLoad?(feed)
			case .failure:
				guard let self = self else { return }
				self.onFeedLoadFailure?(self.errorMessage)
			}
			self?.onLoadingStateChange?(false)
		}
	}
}
