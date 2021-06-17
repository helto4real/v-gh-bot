module ghbot

import x.json2

pub fn (mut bot GithubBot) read_next_event() ?&GhEvent {
	event := <-bot.ctx.events or { return none }
	return event
}

fn (mut bot GithubBot) handle_new_event(event string, body json2.Any) {
	match event {
		'ping' {
			mut ping_event := new_ping_event_from_json(body)
			lock bot.ctx {
				bot.ctx.events <- &GhEvent(ping_event)
			}
		}
		'issues' {
			mut issue_event := new_issue_event_from_json(body)
			lock bot.ctx {
				bot.ctx.events <- &GhEvent(issue_event)
			}
		}
		else {}
	}
}
