import vweb
import bot
import net.http

fn testsuite_begin() {
	go run_bot()
}

fn run_bot() {
	bot.run()
}

fn test_ping()? {
	r := http.post_json('http://127.0.0.1:8001/events', '{"hello" : "world"}')?
	assert r.text ==  '{"hello" : "world"}'
}

// fn post_json()