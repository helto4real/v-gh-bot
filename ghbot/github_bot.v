// ghbot implements an simple strongly typed github bot in V
// for now it uses globals until vweb support state between requests
// sorry for the hack :)
module ghbot

// import nedpals.vex.router
// import nedpals.vex.server
// import nedpals.vex.ctx
import vweb
import x.json2
import os

// BotContext holds the context that are shared
// between requests
[heap]
struct BotContext {
	events chan &GhEvent = chan &GhEvent{cap: 100}
}

// new_bot_context creates new instance of BotContext
fn new_bot_context() &BotContext {
	return &BotContext{}
}

// GitHubBot, the vweb app
pub struct GithubBot {
	vweb.Context
	ctx shared BotContext
	// events chan &GhEvent = gtx.events
}

// events provides the main webhook interface for Github events.
['/events'; post]
pub fn (mut bot GithubBot) events() vweb.Result {
	eprintln('>>>>> received http request at /json_echo is: $bot.req')

	event := bot.req.header.get_custom('X-Github-Event') or {
		// require the event header to be present
		return bot.server_error(428)
	}

	json := json2.raw_decode(bot.req.data) or { json2.Any(json2.null) }

	if json == json2.Any(json2.null) {
		return bot.server_error(500)
	}
	bot.handle_new_event(event, json)

	return bot.ok('')
}

// index is the default page that can be used to see if bot is running
['/'; get]
pub fn (mut app GithubBot) index() vweb.Result {
	app.set_content_type(vweb.mime_types['.html'])
	return app.ok('<html><body>Congratz! The bot is up and running!</body></html>')
}

// run starts the bot and process events
// the port is configurable using the environment variable 'GH_BOT_WEBHOOK_PORT'
pub fn (mut bot GithubBot) run() {
	port := (os.environ()['GH_BOT_WEBHOOK_PORT'] or { '8001' }).int()
	vweb.run(bot, port)
}

pub fn new_bot() &GithubBot {
	return &GithubBot{
		ctx: BotContext{}
	}
}
