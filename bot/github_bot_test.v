import vweb
import bot
import net.http
import time
fn testsuite_begin() {
	go run_bot()
	time.sleep_ms(100)
}

fn run_bot() {
	bot.run()
}

fn test_ping()? {
	r := post_json('s', '{"hello" : "world"}')?
	assert r.status_code == 200
}

fn post_json(event string, json string)?http.Response {
	mut req := http.new_request(.post, 'http://127.0.0.1:8001/events', json)?
	req.add_custom_header('X-GitHub-Event', event)?
	return req.do()
}