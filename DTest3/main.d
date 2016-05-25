module main;

import std.random;
import std.stdio;
import std.datetime;

template stopTime(alias f) {
	auto stopTime() {
		auto sw = StopWatch(AutoStart.yes);
		f();
		sw.stop();
		return sw.peek.msecs;
	}
}

int main() {
	int[] source;
	source.length = 50_000_000;

	foreach(ref x; source)
		x = uniform(0, int.max);

	int[int] m;

	auto elapsed = stopTime!({ foreach(x; source) m[x] = 0; });
	writefln("Insertion: %d msecs\n", elapsed);
	writefln("Map.length = %d", m.length);

	elapsed = stopTime!({
		auto acc = 0;
		foreach(x; source) {
			auto v = x in m;
			if (v !is null)
				acc += *v % 10;
			auto _ = m[x];
		}
		});
	writefln("Lookup: %d msecs\n", elapsed);

	readln();
	return 0;
}