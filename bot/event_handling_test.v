module bot

import os
import x.json2

fn test_ping_event() {
	json := get_test_file_as_any('./bot/events/ping.json') or { panic(err.msg) }
	ch := chan GhEvent{cap: 100}
	handle_new_event('ping', json, ch)

	res := <-ch

	if res is GhPingEvent {
		eprintln(res)
		assert res.hook_id == 302428919
		// test the hook parsing
		assert res.hook.id == 123123123
		assert res.hook.active
		assert res.hook.name=='web'
		assert res.repository.owner.login == 'helto4real'
		assert res.repository.license.key == 'mit'
	} else {
		assert false
	}
}

fn get_test_file_as_any(path string) ?json2.Any {
	file := os.read_file(path) ?
	eprintln(file)
	json := json2.raw_decode(file) ?
	return json
}
