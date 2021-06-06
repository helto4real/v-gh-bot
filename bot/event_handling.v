module bot
import x.json2

fn (mut bot GithubBot) process_events() {
	for {
		event := <- gtx.gh_events or {
			// it is closed and we no longer should process events
			eprintln('EXIT EVENT')
			return
		}
		match event {
			GhPingEvent {
				eprintln('GOT PING EVENT: $event')
			}
			else {}
		}
	}
}

fn handle_new_event(event string, body json2.Any, events chan GhEvent) {
	match event {
		'ping' {
			mut ping_event := new_ping_event_from_json(body)
			events <- GhEvent(ping_event)
		}
		else {}
	}
}

