module bot

import vweb
import x.json2
import time
pub struct GithubBot {
	vweb.Context

}

['/events'; post]
pub fn (mut app GithubBot) events() vweb.Result {
	eprintln('>>>>> received http request at /json_echo is: $app.req')

	o := json2.fast_raw_decode(app.req.data) or {
		assert false
		json2.Any(json2.null)
	}

	m := o.as_map()
	eprintln('MAP: >>>> ${m['hello']}')
	app.set_content_type(app.req.header.get(.content_type) or { '' })
	return app.ok(app.req.data)
}

pub fn run() {
	mut app := &GithubBot{}
	vweb.run(app, 8001)
}

