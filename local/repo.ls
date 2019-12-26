require! <[fs crypto @octokit/rest]>
require! <[../secret]>
Octokit = require "@octokit/rest"

# API Documentation 
# https://octokit.github.io/rest.js/
# https://developer.github.com/v3/gists/
# if not authed correctly, `HttpError Not Found` might show.
octokit = new Octokit auth: secret.token

octokit.repos.getContents {
  owner: \zbryikt
  repo: \github-api-test-repo
  path: 'index.html'
}
  .then ->
    content = Buffer.from(it.data.content, \base64).toString \ascii
    content = content + "!!!"
    octokit.repos.createOrUpdateFile do
      owner: \zbryikt
      repo: \github-api-test-repo
      path: \index.html
      message: 'update automatically'
      content: Buffer.from(content).toString(\base64)
      sha: it.data.sha
  .then -> console.log \done.
