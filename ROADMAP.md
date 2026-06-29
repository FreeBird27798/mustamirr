# Mustamirr — Project Roadmap

## Project Overview
A Flutter educational content app where teachers upload materials and students download them for offline use.

**Roles:** Student | Teacher | Admin  
**Backend:** Laravel REST API (friend's part)  
**State Management:** BLoC  
**Architecture:** Clean Architecture  
**HTTP Client:** Dio  

---

## Packages to Add
- [ ] `flutter_bloc` — state management ✅ (already in pubspec)
- [ ] `equatable` — value equality ✅ (already in pubspec)
- [ ] `dio` — HTTP client ✅ (already in pubspec)
- [ ] `get_it` — dependency injection
- [ ] `go_router` — navigation & role-based routing
- [ ] `flutter_downloader` — download files to device
- [ ] `path_provider` — access local storage paths
- [ ] `open_filex` — open downloaded files (PDF, video, etc.)
- [ ] `cached_network_image` — cache images
- [ ] `flutter_local_notifications` — local push notifications
- [ ] `shared_preferences` — store token & user session locally
- [ ] `dartz` — functional error handling (Either)

---

## Folder Structure
```
lib/
├── core/
│   ├── api/          # Dio client, interceptors, endpoints
│   ├── errors/       # Failures, exceptions
│   ├── usecases/     # Base usecase class
│   ├── di/           # get_it dependency injection setup
│   └── utils/        # constants, helpers
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── student/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── teacher/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── admin/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart
```

---

## Features Breakdown

### Phase 1 — Foundation
- [ ] Set up folder structure
- [ ] Add & configure all packages
- [ ] Set up Dio client with base URL + auth interceptor
- [ ] Set up get_it dependency injection
- [ ] Set up go_router with role-based routing

### Phase 2 — Auth Feature (I build, you learn)
- [ ] Splash screen
- [ ] Onboarding screens (3 screens, shown only once)
- [ ] Login screen (UI) + Remember Me
- [ ] Register screen (UI)
- [ ] AuthBloc (login / register / logout events & states)
- [ ] Auth repository + data source (mock first, then real API)
- [ ] Save token with shared_preferences
- [ ] Route user to correct screen based on role

### Phase 3 — Student Feature (you build, I review)
- [ ] Browse subjects by grade/subject screen
- [ ] Subject detail screen (list of files)
- [ ] Download file feature (flutter_downloader)
- [ ] Offline files screen (locally stored files)
- [ ] Open downloaded file (open_filex)
- [ ] Search screen
- [ ] StudentBloc

### Phase 4 — Teacher Feature (you build, I review)
- [ ] Upload file screen (PDF / video / image)
- [ ] My content screen (list of uploaded files)
- [ ] Edit / delete content
- [ ] TeacherBloc

### Phase 5 — Admin Feature (you build, I review)
- [ ] User management screen
- [ ] Content moderation screen
- [ ] Stats dashboard screen
- [ ] AdminBloc

### Phase 6 — Polish & Connect API
- [ ] Replace all mock data with real Dio API calls
- [ ] Push notifications (flutter_local_notifications + FCM or Laravel)
- [ ] Error handling & loading states throughout the app
- [ ] Multi-language support (Arabic + English) using flutter_localizations + intl
- [ ] App icon & splash screen
- [ ] CI/CD pipeline (.github/workflows/ci.yml) — runs flutter analyze, dart format, flutter test on every push
- [ ] Final testing

---

## Testing Strategy
> After each feature: build first, then test together.  
> Tests will cover concepts from your QA course (white box, black box, error guessing, functional).

| Feature | Test Type | Tools |
|---------|-----------|-------|
| AuthBloc logic | Unit (white box) | bloc_test |
| Repository / API calls | Unit + mocking | mocktail |
| Login / Register flow | Functional (black box) | flutter_test |
| Edge cases (wrong password, no internet) | Error guessing | mocktail |
| Download / Offline flow | Functional | flutter_test |

## Phase 7 — Testing (after each feature)
- [ ] Auth — BLoC unit tests + repository mocking
- [ ] Auth — functional tests (login flow, wrong credentials)
- [ ] Student — BLoC unit tests
- [ ] Student — functional tests (browse, download, offline)
- [ ] Teacher — BLoC unit tests
- [ ] Teacher — functional tests (upload, edit, delete)
- [ ] Admin — BLoC unit tests

---

## GitHub Setup
- [ ] Initialize git repo (`git init`)
- [ ] Create `.gitignore` (Flutter default)
- [ ] Create GitHub repo (you + your friend as collaborators)
- [ ] Agree on branching strategy (see below)
- [ ] Push initial commit

### Branching Strategy
```
main          ← stable, working code only
dev           ← integration branch
feature/auth  ← one branch per feature
feature/student
feature/teacher
feature/admin
```
**Rule:** never push directly to `main`. Always go through a feature branch → PR → merge into `dev` → merge into `main` when stable.

---

## Work Style
- I build Phase 1 & 2 with you (explaining every step)
- You build Phase 3, 4, 5 applying what you learned
- I review your code and give feedback after each phase
- We write tests together after each feature
- We connect the real API together in Phase 6

---

## Phase 8 — Graduation Presentation
> Built after the project is complete — real screenshots, real results.
- [ ] Slides structure (problem → solution → features → architecture → demo → testing → conclusion)
- [ ] Architecture diagram (Clean Architecture layers)
- [ ] Screenshots of all screens
- [ ] Demo video or live demo
- [ ] Testing section (link to QA course concepts: white box, black box, error guessing)
- [ ] Tech stack slide
- [ ] Challenges & lessons learned slide

---

## Progress
- [ ] GitHub Setup
- [ ] Phase 1 — Foundation
- [ ] Phase 2 — Auth + Tests
- [ ] Phase 3 — Student + Tests
- [ ] Phase 4 — Teacher + Tests
- [ ] Phase 5 — Admin + Tests
- [ ] Phase 6 — API Integration
- [ ] Phase 7 — Testing
- [ ] Phase 8 — Graduation Presentation
