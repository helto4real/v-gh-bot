import ghbot
fn main() {
	mut bot := ghbot.new_bot()
	go handle_messages(mut bot)
	bot.run()
}

fn handle_messages(mut bot ghbot.GithubBot) {
	for {
		event := bot.read_next_event() or {
			break
		}
		eprintln(event)
		// match event {
		// 	ghbot.GhPingEvent {
		// 		eprintln('GOT PING EVENT: $event')
		// 	}
		// 	ghbot.GhIssueEvent {
		// 		eprintln('GOT ISSUE EVENT: $event')
		// 	}
		// 	// else {}
		// }
	}
}