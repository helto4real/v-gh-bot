import ghbot

fn main() {
	mut bot := ghbot.new_bot()
	go bot.run()

	for {
		event := bot.read_next_event() or { break }
		match event {
			ghbot.GhPingEvent {
				eprintln('GOT PING EVENT: $event')
			}
			else {}
		}
	}
}
