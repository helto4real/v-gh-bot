// ghbot implements an simple strongly typed github bot in V
// for now it uses globals until vweb support state between requests
// sorry for the hack :)
module ghbot

import nedpals.vex.router
import nedpals.vex.server
import nedpals.vex.ctx

import vweb
import x.json2
import os

__global(
	
	gtx &GlobalContext
)

fn init() {
	gtx = new_global_context()
}

// GlobalContext is a hack until vweb supports
// shared state. This is used mainly to share
// a channel between requests and background tasks
[heap]
struct GlobalContext {
	gh_events chan &GhEvent = chan &GhEvent{cap: 100}
}

// new_global_context creates new instance of GlobalContext
fn new_global_context() &GlobalContext {
	return &GlobalContext{}
}

// GitHubBot, the vweb app
pub struct GithubBot {
	vweb.Context
	gh_events chan &GhEvent = gtx.gh_events
}

// gh_events provides the main webhook interface for Github events.
['/events'; post]
pub fn (mut bot GithubBot) gh_events() vweb.Result {
	eprintln('>>>>> received http request at /json_echo is: $bot.req')

	event := bot.req.header.get_custom('X-Github-Event') or {
		// require the event header to be present
		return bot.server_error(428)
	}

	json := json2.raw_decode(bot.req.data) or {
		json2.Any(json2.null)
	}

	if json == json2.Any(json2.null) {
		return bot.server_error(500)
	}

	handle_new_event(event, json, gtx.gh_events)

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
	port := (os.environ()['GH_BOT_WEBHOOK_PORT'] or {"8001"}).int()

	// mut app := router.new()
	// app.inject(bot)
	// app.route(.post, '/events', fn (req &ctx.Req, mut res ctx.Resp) {
    //     bot := &GithubBot(req.ctx)
	// 	event := req.headers['X-GitHub-Event'][0] or {
	// 		// require the event header to be present
	// 		res.send('', 428)
	// 		return
	// 	}

	// 	json := json2.raw_decode(req.body.bytestr()) or {
	// 		json2.Any(json2.null)
	// 	}

	// 	if json == json2.Any(json2.null) {
	// 		res.send('', 500)
	// 		return
	// 	}

	// 	handle_new_event(event, json, bot.gh_events)
	// 	res.send('', 200)

	// 	})
	// server.serve(app, port)
	vweb.run(bot, port)
}

pub fn new_bot() &GithubBot {
	return &GithubBot{}
}