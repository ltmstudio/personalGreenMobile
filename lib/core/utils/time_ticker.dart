class TimeTicker {
  const TimeTicker();

  Stream<int> tick({required int ticksInMinutes}) {
    return Stream.periodic(
        const Duration(minutes: 1), (x) => ticksInMinutes - x - 1)
        .take(ticksInMinutes);
  }

  Stream<int> tickSecond({required int ticks}) {
    return Stream.periodic(const Duration(seconds: 1), (x) => ticks - x - 1)
        .take(ticks);
  }
}