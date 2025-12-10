import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_tracking_app/core/errors/failures.dart';
import 'package:time_tracking_app/features/tasks/domain/entities/timer_tracker.dart';
import 'package:time_tracking_app/features/tasks/domain/usecases/fetch_timer.dart';
import 'package:time_tracking_app/features/tasks/domain/usecases/task_timer.dart';

class MockTaskTimer extends Mock implements TaskTimer {}

class MockFetchTimer extends Mock implements FetchTimer {}

const testTaskId = 'task-123';
const testErrorMessage = 'Test error message';
final testTimeSpent = const Duration(minutes: 30);
final testTotalTimeSpent = const Duration(hours: 1);
final testStartedAt = DateTime.now();

final testTimerTracker = TimerTracker(
  taskId: testTaskId,
  timerStartedAt: testStartedAt,
  timeSpent: testTimeSpent,
  isTimerRunning: true,
);

final testStoppedTimerTracker = TimerTracker(
  taskId: testTaskId,
  timerStartedAt: null,
  timeSpent: testTotalTimeSpent,
  isTimerRunning: false,
);

final testResetTimerTracker = TimerTracker(
  taskId: testTaskId,
  timerStartedAt: null,
  timeSpent: Duration.zero,
  isTimerRunning: false,
);

void main() {
  late MockTaskTimer mockTaskTimer;
  late MockFetchTimer mockFetchTimer;
  late TimerBloc timerBloc;

  // Register fallback values
  setUpAll(() {
    registerFallbackValue(testTaskId);
    registerFallbackValue(testTimeSpent);
    registerFallbackValue(testTotalTimeSpent);
    registerFallbackValue(testTimerTracker);
    registerFallbackValue(testStoppedTimerTracker);
    registerFallbackValue(testResetTimerTracker);
  });

  setUp(() {
    mockTaskTimer = MockTaskTimer();
    mockFetchTimer = MockFetchTimer();
    timerBloc = TimerBloc(taskTimer: mockTaskTimer, fetchTimer: mockFetchTimer);
  });

  tearDown(() {
    timerBloc.close();
  });

  group('TimerBloc', () {
    test('initial state should be TimerInitial', () {
      expect(timerBloc.state, equals(const TimerInitial()));
    });

    group('StopTimerEvent', () {
      blocTest<TimerBloc, TimerState>(
        'emits [TimerStopped, TimerLoaded] when StopTimerEvent succeeds',
        build: () {
          when(
            () => mockTaskTimer(
              taskId: any(named: 'taskId'),
              timeSpent: any(named: 'timeSpent'),
            ),
          ).thenAnswer((_) async => const Right(null));
          return timerBloc;
        },
        act: (bloc) => bloc.add(StopTimerEvent(testTaskId, testTotalTimeSpent)),
        expect: () => [
          TimerStopped(testTaskId, testTotalTimeSpent),
          TimerLoaded(testStoppedTimerTracker),
        ],
        verify: (_) {
          verify(
            () => mockTaskTimer(
              taskId: testTaskId,
              timeSpent: testTotalTimeSpent,
            ),
          ).called(1);
        },
      );

      blocTest<TimerBloc, TimerState>(
        'emits [TimerError] when StopTimerEvent fails',
        build: () {
          when(
            () => mockTaskTimer(
              taskId: any(named: 'taskId'),
              timeSpent: any(named: 'timeSpent'),
            ),
          ).thenAnswer((_) async => Left(ServerFailure(testErrorMessage)));
          return timerBloc;
        },
        act: (bloc) => bloc.add(StopTimerEvent(testTaskId, testTotalTimeSpent)),
        expect: () => [TimerError(testErrorMessage)],
        verify: (_) {
          verify(
            () => mockTaskTimer(
              taskId: testTaskId,
              timeSpent: testTotalTimeSpent,
            ),
          ).called(1);
        },
      );
    });

    group('ResetTimerEvent', () {
      blocTest<TimerBloc, TimerState>(
        'emits [TimerReset, TimerLoaded] when ResetTimerEvent succeeds',
        build: () {
          when(
            () => mockTaskTimer(
              taskId: any(named: 'taskId'),
              startedAt: any(named: 'startedAt'),
              timeSpent: any(named: 'timeSpent'),
            ),
          ).thenAnswer((_) async => const Right(null));
          return timerBloc;
        },
        act: (bloc) => bloc.add(ResetTimerEvent(testTaskId)),
        expect: () => [
          TimerReset(testTaskId),
          TimerLoaded(testResetTimerTracker),
        ],
        verify: (_) {
          verify(
            () => mockTaskTimer(
              taskId: testTaskId,
              startedAt: null,
              timeSpent: Duration.zero,
            ),
          ).called(1);
        },
      );

      blocTest<TimerBloc, TimerState>(
        'emits [TimerError] when ResetTimerEvent fails',
        build: () {
          when(
            () => mockTaskTimer(
              taskId: any(named: 'taskId'),
              startedAt: any(named: 'startedAt'),
              timeSpent: any(named: 'timeSpent'),
            ),
          ).thenAnswer((_) async => Left(ServerFailure(testErrorMessage)));
          return timerBloc;
        },
        act: (bloc) => bloc.add(ResetTimerEvent(testTaskId)),
        expect: () => [TimerError(testErrorMessage)],
        verify: (_) {
          verify(
            () => mockTaskTimer(
              taskId: testTaskId,
              startedAt: null,
              timeSpent: Duration.zero,
            ),
          ).called(1);
        },
      );
    });
  });
}
