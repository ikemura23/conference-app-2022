import appioscombined
import ComposableArchitecture
import Event
import SwiftUI

struct SearchFiltersSectionView: View {
    private let store: Store<SearchState, SearchAction>

    struct ViewState: Equatable {
        public var filterFavorite: Bool
        public var filterDays: [DroidKaigi2022Day]
        public var filterCategories: [TimetableCategory]

        public init(state: SearchState) {
            self.filterFavorite = state.filterFavorite
            self.filterDays = state.filterDays
            self.filterCategories = state.filterCategories
        }
    }

    public init(store: Store<SearchState, SearchAction>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store.scope(state: ViewState.init)) { viewStore in
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    FilterButtonView(
                        title: viewStore.filterDays.isEmpty ?
                            StringsKt.shared.search_filter_select_day.localized() : viewStore.filterDays.map { $0.name }.joined(separator: ","),
                        isFiltered: !viewStore.filterDays.isEmpty
                    ) {
                        viewStore.send(.showDayFilterSheet)
                    }
                    FilterButtonView(
                        title: viewStore.filterCategories.isEmpty ? StringsKt.shared.search_filter_select_category.localized() : viewStore.filterCategories.map { $0.title.currentLangTitle }.joined(separator: ","),
                        isFiltered: !viewStore.filterCategories.isEmpty
                    ) {
                        viewStore.send(.showCategoryFilterSheet)
                    }
                    FavoriteToggleButtonView(isFavorite: viewStore.filterFavorite) {
                        viewStore.send(.filterFavorite)
                    }
                }
            }
        }
    }
}

#if DEBUG
struct SearchFiltersSection_Previews: PreviewProvider {
    static var previews: some View {
        SearchFiltersSectionView(
            store: .init(
                initialState: .init(
                    dayToTimetable: DroidKaigiSchedule.companion.fake().dayToTimetable
                ),
                reducer: .empty,
                environment: SearchEnvironment(
                    sessionsRepository: FakeSessionsRepository(),
                    eventKitClient: EventKitClientMock()
                )
            )
        )
    }
}
#endif
