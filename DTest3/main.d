module main;

import std.random;
import std.stdio;
import std.datetime;

int main() {
	int[] source;
	source.length = 50_000_000;

	foreach(ref x; source)
		x = uniform(0, int.max);

	int[int] m;

	auto sw = StopWatch(AutoStart.yes);
	foreach(x; source) m[x] = 0;
	sw.stop();
	writefln("Insertion: %d msecs\n", sw.peek.msecs);
	writefln("Map.length = %d", m.length);

	sw.reset();
	sw.start();
	auto acc = 0;
	foreach(x; source) {
		auto v = x in m;
		if (v !is null)
			acc += *v % 10;
		auto _ = m[x];
	}
	sw.stop();
	writefln("Lookup: %d msecs\n", sw.peek.msecs);

	readln();
	return 0;
}