# 📋 Feature Guide: Main Screen

## 🔗 [📁 Open Feature Folder (`lib/features/screens/main_screen`)](../../features/screens/main_screen)

> **Auto-generated** on 2026-09-29  
> Source: `lib/features/screens/main_screen/`  
> Design rules: `lib/core/ai_guide/AI_GENERAL_PROMPT_FOR_DESIGN_GUIDE.md`

---

## 📌 Design Rules Quick-Reference
| Rule | Detail |
|------|--------|
| Routing | `@RoutePage()` + `AutoRouteWrapper` |
| State | BLoC / Cubit (`BlocBuilder` + `BlocListener`) |
| Lifecycle | Abstract `BaseState` via mixin file |
| Widget extraction | Every component → separate file in `widgets/` |
| Spacing | `n.verticalSpace` / `n.horizontalSpace` (no raw `SizedBox`) |
| Colors | `AppColors` only – no hardcoded hex |
| Typography | `AppTextStyles` + `.copyWith()` – no inline `TextStyle` |
| Padding/Sizes | `AppPadding.pN` / `AppSizes.sN` constants |
| Semantics | Outermost wrapper on every root widget |
| Imports | Package imports only (`package:…`) |
| Strings | Via `generate_key.dart` → `'key'.tr()` |
| Const | Use `const` constructors everywhere possible |
| Build limit | Single `build()` method ≤ 100 lines |

---

## 🎛️ Controller

### Files
| File | Description |
|------|-------------|
| `controller/main_screen_cubit.dart` | Business logic, emits states |
| `controller/main_screen_state.dart` | State model (`MainScreenLoaded`, …) |

### Cubit: `MainScreenCubit`
- Extends **`BaseCubit<MainScreenState>`**
- Uses `CancelManager` for cancellable network requests
- Static accessor: `MainScreenCubit.get(context: context)`
- Holds an instance of `BaseMainScreenService` (injected via DI)

### Methods
- `init()`
- `getProjectsFunc(BaseRequestBackType baseRequestBackType,{NoParameters? parameter})`
- `close()`

### State: `MainScreenLoaded`
**State fields (nullable `BaseEmit`):**
- `refreshOrInit`

- Uses `copyWith()` pattern so only the relevant slice of state changes per action
- `allWorkersEmit` → broadcast channel for global listeners

---

## 🗄️ Data Layer

### Files
| File | Description |
|------|-------------|
| `data/repo/base_main_screen_repo.dart` | Abstract contract for repo |
| `data/repo/main_screen_remote_repo.dart` | Concrete Dio implementation |
| `data/model/` | Response / entity models |

### `BaseMainScreenRepo` (abstract)
Declares method contracts — services depend on this abstraction, never on the concrete class.

_No methods declared yet._

### `MainScreenRemoteRepo`
- Implements `BaseMainScreenRepo`
- Uses **`DioHelper`** for HTTP calls
- Wraps responses via `handleResponse(asObject: Model.fromJson)`
- Endpoints used: `EndPoints.getProjects`

### Models
- `data/model/project_data.dart`

---

## 🔧 Service Layer

### Files
| File | Description |
|------|-------------|
| `service/base_main_screen_service.dart` | Abstract service contract |
| `service/main_screen_remote_service.dart` | Orchestrates repo + caching |

### `BaseMainScreenService` (abstract)
Bridge between Cubit and Repo — the Cubit only sees this interface.

**Service methods:**
- `getProjectsServ(RequestCallbackObserver<PojectsData, NoParameters> requestInfo,)`

### `MainScreenRemoteService`
- Depends on `BaseMainScreenRepo` and `BaseLocalRepo`
- Uses `RequestCallbackObserver` to drive `Loading / Success / ErrorState` flow
- ✅ **Local cache** is active (`readData` / `clearData`)
- ✅ **Cache write-back** on success (`saveLocal`)

---

## 🖥️ UI Layer

> **Overview**: Provides detailed breakdowns of each screen, injected dependencies, specific state listening logic, and atomic widgets.

### 📄 Screen: `main_screen`

#### Main Screen File: `ui/main_screen/main_screen_screen.dart`
| Aspect | Value |
|--------|-------|
| Class | `MainScreenPage extends StatefulWidget` |
| AutoRoute | ✅ `@RoutePage()` + `AutoRouteWrapper` |
| Route Args | `MainScreenRouteArgs` passed via constructor |
| BlocListener | ✅ Present |
| Listens to States | _Listening to state changes_ |
| BlocBuilder | ⬜ Not yet added |
| Semantics | ⚠️ Missing — required by design rules |
| Structure | `Scaffold` has body defined |

#### Mixin / BaseState: `ui/main_screen/main_screen_screen_mixin.dart`
| Aspect | Value |
|--------|-------|
| Class | `MainScreenPageBaseState extends State<MainScreenPage>` |
| Cubit access | `late final MainScreenCubit mainScreenCubit` |
| initState | ⚠️ `initState` has TODO stubs |
| dispose | Called via `super.dispose()` |

#### 🧱 Atomic Widgets (`ui/main_screen/widgets/`)

Each extracted component below includes an **AI Usage Hint** mapping out how it should be used, what it expects, and specific design rules it follows.

##### 🧩 `MainScreenBody` (`main_screen_body.dart`)
- **Type**: `MainScreenBody extends StatelessWidget`
- **Constructor Props**: _None_
- **Core Widgets Used**: `Card`, `Column`, `Container`, `Image`

**💡 AI / Dev Readme Hint:**
- **Static Component**: Layout-only widget with no required parameters. Safe to instantiate directly.
- **A11y**: ✅ Contains `Semantics` wrappers properly.
- **Styling**: Uses standard project styling (`Spacing Extensions`).

---


## ✅ AI Task Checklist (read before making changes)

Use this checklist before and after implementing any task in this feature:

- [ ] Route registered via `dart run lib/core/tools/create_auto_files/route_generator_data.dart`
- [ ] All strings use `'key'.tr()` (extracted via `generate_key.dart`)
- [ ] Colors → `AppColors` only
- [ ] Typography → `AppTextStyles` (+ `.copyWith()` for tweaks)
- [ ] Spacing → `n.verticalSpace` / `n.horizontalSpace` (no raw `SizedBox`)
- [ ] Padding → `AppPadding.pN` / `AppSizes.sN` constants
- [ ] Every root widget wrapped with `Semantics(label: '…')`
- [ ] All widgets use `const` constructors where possible
- [ ] Each `build()` ≤ 100 lines — extract if exceeded
- [ ] New widgets placed in `ui/main_screen/widgets/`
- [ ] Package imports only (no relative `../../` imports)
- [ ] `BlocListener` handles errors (SnackBar / Dialog)
- [ ] `CancelManager` keys added to `close()` in cubit

---

*Generated by `dart run lib/core/tools/mcp/feature_doc_generator.dart main_screen`*

## ✍️ Custom Prompts & Notes
> Add any manual hints, instructions, or specific feature rules here.
> Everything below this line is preserved automatically during regeneration.

This is a MANUAL test note. Do NOT delete me!

