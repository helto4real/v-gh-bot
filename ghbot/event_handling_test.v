module ghbot

import os
import x.json2

// todo: add all elements
fn test_ping_event() ? {
	json := get_test_file_as_any('./ghbot/events/ping.json') or { panic(err.msg) }
	mut bot := new_bot()
	bot.handle_new_event('ping', json)

	res := bot.read_next_event() ?

	if res is GhPingEvent {
		eprintln(res)
		assert res.hook_id == 302428919
		// test the hook parsing
		assert res.hook.id == 123123123
		assert res.hook.active
		assert res.hook.name == 'web'
		assert res.repository.owner.login == 'helto4real'
		assert res.repository.license.key == 'mit'
	} else {
		assert false
	}
}

// todo: add all elements
fn test_issue_event() ? {
	json := get_test_file_as_any('./ghbot/events/new_issue.json') or { panic(err.msg) }
	ch := chan &GhEvent{cap: 100}
	mut bot := new_bot()
	bot.handle_new_event('issues', json)

	res := bot.read_next_event() ?

	if res is GhIssueEvent {
		eprintln(res)
		assert res.action == 'opened'
		// test the issue parsing
		assert res.issue.id == 123456
		assert res.issue.number == 2
		assert res.issue.user.login == 'helto4real'
		assert res.issue.user.id == 12345
		assert res.repository.owner.login == 'helto4real'
		assert res.sender.login == 'helto4real'
	} else {
		assert false
	}
}

fn test_edited_issue_event() ? {
	json := get_test_file_as_any('./ghbot/events/update_issue.json') or { panic(err.msg) }
	mut bot := new_bot()
	bot.handle_new_event('issues', json)

	res := bot.read_next_event() ?

	if res is GhIssueEvent {
		eprintln(res)
		assert res.action == 'edited'
		// test the issue parsing
		assert res.issue.id == 913665911
		assert res.issue.number == 3
		assert res.issue.user.login == 'helto4real'
		assert res.issue.user.id == 26500160
		assert res.repository.owner.login == 'helto4real'
		assert res.sender.login == 'helto4real'
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
