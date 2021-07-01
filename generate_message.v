
import strings
import os
import x.json2

struct JsonObject {
pub:
	

}
fn main() {
	if os.args.len != 2 {
		eprintln('Error: You have to specify one file')
		exit(1)
	}
	json_filename := os.args[1]
	json_text := os.read_file(json_filename) or {
		eprintln('Failed to read json file $err.msg')
		exit(1)
	}
	json := json2.raw_decode(json_text) or {
		eprintln('Please provide valid json file $json_filename')
		exit(1)
	}


	jm := json.as_map()
	b := strings.new_builder()
	structs := []map[string
	b.write_string('{')
	for a, o in jm {
		
		println('A: $a, $o')
	}
	b.write_string('}')
}