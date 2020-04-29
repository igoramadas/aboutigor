# GITHUB MANAGER
# -----------------------------------------------------------------------------
# Handles communications with GitHub.

class GitHub

    cache = require "./cache"
    expresser = require "expresser"
    githubApi = require("@octokit/rest").Octokit
    moment = expresser.libs.moment

    # GitHub settings.
    refreshInterval = 1800000
    recentDays = 30
    github = new githubApi {protocol: "https"}

    # INIT
    # -------------------------------------------------------------------------

    # Init the GitHub module.
    init: =>
        @recentActivity()
        setInterval @recentActivity, refreshInterval

    # GITHUB DATA
    # -------------------------------------------------------------------------

    # Get recent activity.
    recentActivity: =>
        commits = 0
        minDate = moment().subtract(recentDays, "d").unix()

        try
            data = await github.activity.listEventsForAuthenticatedUser {username: "igoramadas", per_page: 100}, (err, data) ->
            arr = []

            for evt in data.data
                if moment(evt.created_at, moment.ISO_8601).unix() > minDate
                    activity = {}
                    activity.type = evt.type
                    activity.repo = evt.repo
                    activity.date = evt.created_at
                    activity.toString = -> return "#{@type} on #{@date}"
                    arr.push activity

                    if evt.payload?.commits?
                        commits += evt.payload.commits.length

            cache.set "github-recent-commit-count", commits
            cache.set "github-recent-activity", arr
            expresser.logger.info "GitHub.recentActivity", data.length
        catch ex
            expresser.logger.error "GitHub.recentActivity", ex

# Singleton implementation
# -----------------------------------------------------------------------------
GitHub.getInstance = ->
    @instance = new GitHub() if not @instance?
    return @instance

module.exports = exports = GitHub.getInstance()
