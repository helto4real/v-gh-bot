module bot
import x.json2

pub type GhEvent = GhPingEvent | GhIssueEvent

pub struct GhPingEvent {
pub mut:
	hook_id string
}

fn (mut e GhPingEvent) from_json(an json2.Any) {
	mp := an.as_map()
	mut js_field_name := ''
	$for field in GhPingEvent.fields {
		// FIXME: C error when initializing js_field_name inside comptime for
		js_field_name = field.name
		for attr in field.attrs {
			if attr.starts_with('json:') {
				js_field_name = attr.all_after('json:').trim_left(' ')
				break
			}
		}
		match field.name {
			'hook_id' { e.hook_id = mp[js_field_name].str() }
			else {}
		}
	}
}

pub struct GhIssueEvent {
pub:
	action string
}