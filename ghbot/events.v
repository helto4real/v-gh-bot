module ghbot

import x.json2
import time
import json

pub type GhEvent = GhIssueEvent | GhPingEvent

[heap]
pub struct GhPingEvent {
pub:
	hook_id    i64
	hook       &Hook
	repository &Repository
}

fn new_ping_event_from_json(json json2.Any) &GhPingEvent {
	mp := json.as_map()
	return &GhPingEvent{
		hook_id: mp['hook_id'].i64()
		hook: new_hook_from_json(mp['hook'])
		repository: new_repository_from_json(mp['repository'])
	}
}

[heap]
pub struct GhIssueEvent {
pub:
	action     string
	issue      &Issue
	repository &Repository
	sender     &User
}

fn new_issue_event_from_json(json json2.Any) &GhIssueEvent {
	mp := json.as_map()
	return &GhIssueEvent{
		action: mp['action'].str()
		issue: new_issue_from_json(mp['issue'])
		repository: new_repository_from_json(mp['repository'])
		sender: new_user_from_json(mp['sender'])
	}
}

[heap]
pub struct Issue {
	url                      string
	repository_url           string
	labels_url               string
	comments_url             string
	events_url               string
	html_url                 string
	id                       i64
	node_id                  string
	number                   int
	title                    string
	user                     &User
	labels                   []string
	state                    string
	locked                   bool
	assignee                 string
	assignees                []string
	milestone                string
	comments                 int
	created_at               time.Time
	updated_at               time.Time
	closed_at                time.Time
	author_association       string
	active_lock_reason       string
	body                     string
	performed_via_github_app string
}


pub fn new_issue_from_json(json json2.Any) &Issue {
	mut mp := json.as_map()
	return &Issue{
		url: mp['url'].str()
		repository_url: mp['repository_url'].str()
		labels_url: mp['labels_url'].str()
		comments_url: mp['comments_url'].str()
		events_url: mp['events_url'].str()
		html_url: mp['html_url'].str()
		id: mp['id'].i64()
		node_id: mp['node_id'].str()
		number: mp['number'].int()
		title: mp['title'].str()
		user: new_user_from_json(mp['user'])
		labels: mp['labels'].arr().map(it.str())
		state: mp['state'].str()
		locked: mp['locked'].bool()
		assignee: mp['assignee'].str()
		assignees: mp['assignees'].arr().map(it.str())
		milestone: mp['milestone'].str()
		comments: mp['comments'].int()
		created_at: time.parse_iso8601(mp['created_at'].str()) or { time.Time{} }
		updated_at: time.parse_iso8601(mp['updated_at'].str()) or { time.Time{} }
		closed_at: time.parse_iso8601(mp['closed_at'].str()) or { time.Time{} }
		author_association: mp['author_association'].str()
		active_lock_reason: mp['active_lock_reason'].str()
		body: mp['body'].str()
		performed_via_github_app: mp['performed_via_github_app'].str()
	}
}

[heap]
pub struct Hook {
pub mut:
	id            i64
	typ           string
	name          string
	active        bool
	events        []string
	config        &Config
	updated_at    time.Time
	created_at    time.Time
	url           string
	test_url      string
	ping_url      string
	last_response &Response
}

pub fn new_hook_from_json(json json2.Any) &Hook {
	mut mp := json.as_map()
	return &Hook{
		id: mp['id'].i64()
		typ: mp['type'].str()
		name: mp['name'].str()
		active: mp['active'].bool()
		events: mp['events'].arr().map(it.str())
		config: new_config_from_json(mp['config'])
		updated_at: time.parse_iso8601(mp['updated_at'].str()) or { time.Time{} }
		created_at: time.parse_iso8601(mp['created_at'].str()) or { time.Time{} }
		url: mp['url'].str()
		test_url: mp['test_url'].str()
		ping_url: mp['ping_url'].str()
		last_response: new_response_from_json(mp['last_response'])
	}
}

[heap]
pub struct Config {
	content_type string
	insecure_ssl string
	secret       string
	url          string
}

pub fn new_config_from_json(json json2.Any) &Config {
	mut mp := json.as_map()
	return &Config{
		content_type: mp['content_type'].str()
		insecure_ssl: mp['insecure_ssl'].str()
		secret: mp['secret'].str()
		url: mp['url'].str()
	}
}

[heap]
pub struct Response {
	code    int
	status  string
	message string
}

pub fn new_response_from_json(json json2.Any) &Response {
	mut mp := json.as_map()
	return &Response{
		code: mp['code'].int()
		status: mp['status'].str()
		message: mp['message'].str()
	}
}

[heap]
pub struct License {
	key     string
	name    string
	spdx_id string
	url     string
	node_id string
}

pub fn new_license_from_json(json json2.Any) &License {
	mut mp := json.as_map()
	return &License{
		key: mp['key'].str()
		name: mp['name'].str()
		spdx_id: mp['spdx_id'].str()
		url: mp['url'].str()
		node_id: mp['node_id'].str()
	}
}

[heap]
pub struct Repository {
	id                i64
	node_id           string
	name              string
	full_name         string
	private           bool
	owner             &User
	html_url          string
	description       string
	fork              string
	url               string
	forks_url         string
	keys_url          string
	collaborators_url string
	teams_url         string
	hooks_url         string
	issue_events_url  string
	events_url        string
	assignees_url     string
	branches_url      string
	tags_url          string
	blobs_url         string
	git_tags_url      string
	git_refs_url      string
	trees_url         string
	statuses_url      string
	languages_url     string
	stargazers_url    string
	contributors_url  string
	subscribers_url   string
	subscription_url  string
	commits_url       string
	git_commits_url   string
	comments_url      string
	issue_comment_url string
	contents_url      string
	compare_url       string
	merges_url        string
	archive_url       string
	downloads_url     string
	issues_url        string
	pulls_url         string
	milestones_url    string
	notifications_url string
	labels_url        string
	releases_url      string
	deployments_url   string
	created_at        time.Time
	updated_at        time.Time
	pushed_at         time.Time
	git_url           string
	ssh_url           string
	clone_url         string
	svn_url           string
	homepage          string
	size              string
	stargazers_count  string
	watchers_count    string
	language          string
	has_issues        string
	has_projects      string
	has_downloads     string
	has_wiki          string
	has_pages         string
	forks_count       int
	mirror_url        string
	archived          string
	disabled          string
	open_issues_count string
	license           &License
	forks             string
	open_issues       string
	watchers          string
	default_branch    string
}

pub fn new_repository_from_json(json json2.Any) &Repository {
	mut mp := json.as_map()
	return &Repository{
		id: mp['id'].i64()
		node_id: mp['node_id'].str()
		name: mp['name'].str()
		full_name: mp['full_name'].str()
		private: mp['private'].bool()
		owner: new_user_from_json(mp['owner'])
		html_url: mp['html_url'].str()
		description: mp['description'].str()
		fork: mp['fork'].str()
		url: mp['url'].str()
		forks_url: mp['forks_url'].str()
		keys_url: mp['keys_url'].str()
		collaborators_url: mp['collaborators_url'].str()
		teams_url: mp['teams_url'].str()
		hooks_url: mp['hooks_url'].str()
		issue_events_url: mp['issue_events_url'].str()
		events_url: mp['events_url'].str()
		assignees_url: mp['assignees_url'].str()
		branches_url: mp['branches_url'].str()
		tags_url: mp['tags_url'].str()
		blobs_url: mp['blobs_url'].str()
		git_tags_url: mp['git_tags_url'].str()
		git_refs_url: mp['git_refs_url'].str()
		trees_url: mp['trees_url'].str()
		statuses_url: mp['statuses_url'].str()
		languages_url: mp['languages_url'].str()
		stargazers_url: mp['stargazers_url'].str()
		contributors_url: mp['contributors_url'].str()
		subscribers_url: mp['subscribers_url'].str()
		subscription_url: mp['subscription_url'].str()
		commits_url: mp['commits_url'].str()
		git_commits_url: mp['git_commits_url'].str()
		comments_url: mp['comments_url'].str()
		issue_comment_url: mp['issue_comment_url'].str()
		contents_url: mp['contents_url'].str()
		compare_url: mp['compare_url'].str()
		merges_url: mp['merges_url'].str()
		archive_url: mp['archive_url'].str()
		downloads_url: mp['downloads_url'].str()
		issues_url: mp['issues_url'].str()
		pulls_url: mp['pulls_url'].str()
		milestones_url: mp['milestones_url'].str()
		notifications_url: mp['notifications_url'].str()
		labels_url: mp['labels_url'].str()
		releases_url: mp['releases_url'].str()
		deployments_url: mp['deployments_url'].str()
		created_at: time.parse_iso8601(mp['created_at'].str()) or { time.Time{} }
		updated_at: time.parse_iso8601(mp['updated_at'].str()) or { time.Time{} }
		pushed_at: time.parse_iso8601(mp['pushed_at'].str()) or { time.Time{} }
		git_url: mp['git_url'].str()
		ssh_url: mp['ssh_url'].str()
		clone_url: mp['clone_url'].str()
		svn_url: mp['svn_url'].str()
		homepage: mp['homepage'].str()
		size: mp['size'].str()
		stargazers_count: mp['stargazers_count'].str()
		watchers_count: mp['watchers_count'].str()
		language: mp['language'].str()
		has_issues: mp['has_issues'].str()
		has_projects: mp['has_projects'].str()
		has_downloads: mp['has_downloads'].str()
		has_wiki: mp['has_wiki'].str()
		has_pages: mp['has_pages'].str()
		forks_count: mp['forks_count'].int()
		mirror_url: mp['mirror_url'].str()
		archived: mp['archived'].str()
		disabled: mp['disabled'].str()
		open_issues_count: mp['open_issues_count'].str()
		license: new_license_from_json(mp['license'])
		forks: mp['forks'].str()
		open_issues: mp['open_issues'].str()
		watchers: mp['watchers'].str()
		default_branch: mp['default_branch'].str()
	}
}

[heap]
pub struct User {
	login               string
	id                  i64
	node_id             string
	avatar_url          string
	gravatar_id         string
	url                 string
	html_url            string
	followers_url       string
	following_url       string
	gists_url           string
	starred_url         string
	subscriptions_url   string
	organizations_url   string
	repos_url           string
	events_url          string
	received_events_url string
	typ                 string
	site_admin          string
}

pub fn new_user_from_json(json json2.Any) &User {
	mut mp := json.as_map()
	return &User{
		login: mp['login'].str()
		id: mp['id'].i64()
		node_id: mp['node_id'].str()
		avatar_url: mp['avatar_url'].str()
		gravatar_id: mp['gravatar_id'].str()
		url: mp['url'].str()
		html_url: mp['html_url'].str()
		followers_url: mp['followers_url'].str()
		following_url: mp['following_url'].str()
		gists_url: mp['gists_url'].str()
		starred_url: mp['starred_url'].str()
		subscriptions_url: mp['subscriptions_url'].str()
		organizations_url: mp['organizations_url'].str()
		repos_url: mp['repos_url'].str()
		events_url: mp['events_url'].str()
		received_events_url: mp['received_events_url'].str()
		typ: mp['type'].str()
		site_admin: mp['site_admin'].str()
	}
}
