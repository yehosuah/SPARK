import Testing
@testable import SPARK

@MainActor
struct StimulusFeedServiceTests {
    @Test
    func homeFeedUsesSeededFallback() async {
        let container = makeTestContainer()
        let feed = await container.services.stimulusFeedService.loadHomeFeed(for: nil)

        #expect(feed.featuredStimulus.isFeatured)
        #expect(feed.exploratoryStimuli.count == Constants.homeSparkCount)
    }
}
