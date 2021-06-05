module bot

import vweb
import x.json2
// import time

__global(
	gtx &GlobalContext
)

fn init() {
	gtx = new_global_context()
}

struct GlobalContext {
	gh_events chan GhEvent = chan GhEvent{cap: 100}
}

pub struct GithubBot {
	vweb.Context
}

fn new_global_context() &GlobalContext {
	return &GlobalContext{}
}

pub fn new_bot() &GithubBot {
	return &GithubBot{}
}

['/events'; post]
pub fn (mut bot GithubBot) gh_events() vweb.Result {
	eprintln('>>>>> received http request at /json_echo is: $bot.req')

	event := bot.req.header.get_custom('X-Github-Event') or {
		// require the event header to be present
		return bot.server_error(428)
	}

	json := json2.fast_raw_decode(bot.req.data) or {
		json2.Any(json2.null)
	}

	if json == json2.Any(json2.null) {
		return bot.server_error(500)
	}

	handle_new_event(event, json)

	return bot.ok('')
}

['/'; get]
pub fn (mut app GithubBot) index() vweb.Result {
	app.set_content_type(vweb.mime_types['.html'])
	return app.ok('<html><body>Congratz! The bot is up and running!</body></html>')
}

pub fn run() {
	mut app := new_bot()
	go vweb.run(app, 8001)
	app.process_events()
}
