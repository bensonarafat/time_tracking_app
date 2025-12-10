# Time tracking assessment 
This project follows clean architecture with a clear separation of concerns across three main layers 

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


## How it works 


### CI
The project includes Github actions for automated testing and building: 
Continuous Integration (.github/workflows/ci.yml)
Runs on every push to main and pull requests

 - Executes:

   - Code formatting check
   - Static analysis
   - Unit tests with coverage

### Final note 

Building this project was both fun and insightful.
The detailed API documentation made the workflow smooth, and applying Clean Architecture added structure and clarity.
I’m eager to hear your feedback!