# SERVER ROUTES
# -----------------------------------------------------------------------------

# Require modules.
cache = require "./cache"
expresser = require "expresser"
lodash = expresser.libs.lodash
moment = expresser.libs.moment

# Bind all routes.
exports.set = (app) ->

    # The index / homepage.
    indexPage = (req, res) ->
        recentGitHub = cache.get "github-recent-activity"
        recentGitHubCommitCount = cache.get "github-recent-commit-count"

        recentTopArtists = cache.get "lastfm-recent-topartists"
        recentTopArtistsList = lodash.map(recentTopArtists, "name").join ", "

        options =
            lodash: lodash
            moment: moment
            recentGitHub: recentGitHub
            recentGitHubCommitCount: recentGitHubCommitCount
            recentTopArtists: recentTopArtists
            recentTopArtistsList: recentTopArtistsList

        app.renderView req, res, "index.pug", options

    # BIND ROUTES
    # -------------------------------------------------------------------------

    app.get "/", indexPage
