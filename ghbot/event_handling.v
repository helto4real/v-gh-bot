module ghbot
import x.json2

pub fn (mut bot GithubBot) read_next_event() ?GhEvent {
	event := <- gtx.gh_events or {
		return none
	}
	return event
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

