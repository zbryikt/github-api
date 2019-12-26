require! <[fs @octokit/rest]>
require! <[../secret]>
Octokit = require "@octokit/rest"

# API Documentation 
# https://octokit.github.io/rest.js/
# https://developer.github.com/v3/gists/
# if not authed correctly, `HttpError Not Found` might show.
octokit = new Octokit auth: secret.token

/*
octokit.repos
  .list-for-org do
    org: 'octokit'
    type: \public
  .then -> console.log it.data
*/
/*
octokit.gists.create do
  files: do
    "index.html": { content: "hello world!" } 
*/
lc = {}
octokit.gists.list!
  .then ->
    it.data.map -> it{url, id}
    octokit.gists.get gist_id: lc.id = it.data.0.id
  .then -> 
    #console.log it.data.history
    octokit.gists.getRevision do
      gist_id: lc.id
      sha: it.data.history.0.version
  .then ->
    #console.log [v for k,v of it.data.files].map -> it{filename, content}
    octokit.gists.update do
      gist_id: lc.id
      files: do
        "index.html": do
          content: it.data.files['index.html'].content + '.'
          filename: "index.html"
  .then ->
    console.log it
    console.log \done.
