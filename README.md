# iOS Salesman Address Book

A salesman has a name and a working area. Working area is an array of postcode expressions. A postcode expression is either a 5 digit number or an abbreviation with an asterisk at the end. Postcode expression 762* means that all postcodes between 76200 and 76299 are included.

## Architecture Overview


```
┌─ Presentation Layer ──────────────┐
│  ├── Views
│  ├── ViewModels 
│  ├── Components
│  └── State Management 
├─ Domain Layer ───────────────────┤
│  ├── Models 
│  ├── Use Cases 
│  └── Repository Protocol
├─ Data Layer ─────────────────────┤
│  ├── Repository Implementations   
└─ Core ───────────────────────────┤
   ├── Dependency Injection        
   ├── Configuration              
   └── Extensions                 
```

### Core Components

#### `SalesmanListViewModel`
Uses `CurrentValueSubject` for search debouncing to maintain state consistency and prevent race conditions during rapid user input.

```swift
private let searchInputSubject = CurrentValueSubject<String, Never>("")
private var currentSearchCancellable: AnyCancellable?
```

#### `SearchPostcodeUseCase` 
Implements wildcard postcode matching with built-in input validation, chosen over separate validation/filtering UseCases for simplicity.

#### `SalesmanListState`
Immutable state container with computed properties for UI binding:
- `displayedSalesmen`: Context-aware salesman display
- `showEmptySearchResult`: Smart empty state detection
- `isSearching`: Real-time search status


## Features

- **1-second debounce** for optimal UX
- **Wildcard postcode matching**
- Dark mode support
- **Empty state handling** and error management
- **Immutable state** with `copy()` pattern
- Translatable strings
- **Predictable state transitions** via Reducer
- **Intent-based actions** for clear data flow


## Scope Expansions (Kicked out of current task)

- **Remote API integration** with URLSession/Alamofire
- **local db** for offline storage
- **Caching strategy** with expiration policies
- **Pagination** for large datasets
