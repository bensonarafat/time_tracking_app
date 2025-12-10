# Time tracking assessment 
This project follows clean architecture with a clear separation of concerns across three main layers 

## Technologies 
 - Flutter: For building the mobile application 
 - Dart: The programming language used with Flutter 
### Tools 
 - Flutter Bloc: State management 
 - Go router: App navigation and routing 
 - GetIt: Dependency injection for clean architecture. 

### Domain Layer
Core business logic 
 - Entities 
 - Repository Interfaces 
 - Use cases 
### Data Layer 
Data Sources & implementation 
 - Models 
 - API Client 
 - Repository Implementations 
### Presentation Layer 
 - Bloc 
 - Pages 
 - Widget (Reusable UI components)

I also wrote Unit tests for the Repository Interfaces, ApiClient, Repository Implementations, and Blocs. all tests will be found in the test folder.

## My Logic and approach to handle functions without API
<b>Task Status</b> <br/>  The API did not include a status field for tasks.
To handle this, whenever a task is moved to a new status, I create or update that task locally with the new status.
During subsequent remote fetches, I merge the remote task data with the locally stored status so the UI always reflects the correct state.

<b>For History:</b> <br/>  No api to fetch completed Task, even when you have the completed key set to true or false also you can pull a single task but not fetch completed task. So my approach was task was marked as completed, i store it locally, this enable me to fetch all completed tasks.

<b>Timer</b>: <br/> Timer data (elapsed time, taskId, and start time) is stored locally, since the API does not support timer-related endpoints.
This ensures that timing information persists across sessions and can be restored reliably.

Using Clean Architecture + Bloc was an excellent fit for this project because it enforces strict separation of concerns.
Each feature is isolated, meaning changes in the comment logic do not affect the task or timer business logic, and vice-versa. This improves maintainability, scalability, and readability throughout the codebase.

### Installation 
Follow these steps to get the app running on your local machine: 
  
  - Clone the repository 
  ```bash 
    git clone https://github.com/bensonarafat/time_tracking_app.git 
  ```
  - Navigate to the project drectory 
  ```bash
  cd time_tracking_app 
  ```
  - Pub get
  ``` 
  flutter clean & flutter pub get  
  ```
### Run the app 

To run the app, you must first obtain a Bear token from todoist(https://developer.todoist.com/rest/v2/#authorization) 
Then pass the `--dart-define` flag when running the app e.g
```bash 
flutter run --dart-define=TODOIST_API_TOKEN=API_KEYHERE
```

### Demo  
|         |              |            |
|---------|--------------|------------|
| <img src="https://github.com/bensonarafat/time_tracking_app/blob/main/gifs/kanban.gif?raw=true" width="150"/> <br/> Kanban | <img src="https://github.com/bensonarafat/time_tracking_app/blob/main/gifs/add_new.gif?raw=true" width="150"/> <br/> Create Task | <img src="https://github.com/bensonarafat/time_tracking_app/blob/main/gifs/drag.gif?raw=true" width="150"/> <br/> Drag and Drop |
| <img src="https://github.com/bensonarafat/time_tracking_app/blob/main/gifs/comment.gif?raw=true" width="150"/> <br/> Comment | <img src="https://github.com/bensonarafat/time_tracking_app/blob/main/gifs/timer.gif?raw=true" width="150"/> <br/> Timer | <img src="https://github.com/bensonarafat/time_tracking_app/blob/main/gifs/history.gif?raw=true" width="150"/> <br/> History |

### CI/CD
The project includes Github actions for automated testing and building: 
**Continuous Integration (.github/workflows/ci.yml)**
Runs on every push to main and pull requests
 - Executes:
   - Code formatting check
   - Static analysis
   - Unit tests with coverage

## Future Enhancements 

- **Continuous Deployment (Planned)**
Future enhancements will include automated deployment pipelines
- **Error Handling & Monitoring** 
Currently, i only handle ServerException to save time but on a productive app, other errors can be handled as well; errors like: 
   - **Network Error** - Internet connections 
   - **Cache Error** - Local storage
   - **Timeout Error** - network request takes longer. etc.


### Note test coverage is up to 40%
On viewing the the test coverage, you will notice the coverage is up to 40%. However crucial parts of the codebase base been tested. Also how important is Integration test, no Integration test was written as it takes a lot of effort time write.



### Final note 

Building this project was both fun and insightful.
The Todoist API documentation provided clarity throughout the integration process, and applying Clean Architecture ensured a well-structured, testable, and maintainable codebase.
I’m eager to hear your feedback!