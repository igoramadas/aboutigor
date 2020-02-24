# LAST.FM MANAGER
# -----------------------------------------------------------------------------
# Handles communications with Last.fm.

class LastFm

    cache = require "./cache"
    expresser = require "expresser"
    lodash = expresser.libs.lodash
    settings = require("setmeup").settings

    # Require last.fm node.
    LastFmNode = require("lastfm").LastFmNode
    lastfm = null

    # Last.fm settings.
    refreshInterval = 7200000
    recentPeriod = "3month"
    apiKey = settings.lastfm.apiKey
    apiSecret = settings.lastfm.apiSecret
    apiUser = settings.lastfm.user

    # INIT
    # -------------------------------------------------------------------------

    # Init the Last.fm module
    init: =>
        config = {api_key: apiKey, secret: apiSecret, useragent: "aboutigor.com"}
        lastfm = new LastFmNode config

        @recentTopArtists()
        setInterval @recentTopArtists, refreshInterval

    # LAST.FM DATA
    # -------------------------------------------------------------------------

    # Get top artists for the specified period.
    recentTopArtists: =>
        callback = (data) ->
            artists = data?.topartists.artist
            cache.set "lastfm-recent-topartists", artists
            expresser.logger.info "LastFm.recentTopArtists", lodash.map(artists, "name").join()

        lastfm.request "user.getTopArtists", {period: recentPeriod, limit: 8, user: apiUser, handlers: {success: callback}}

# Singleton implementation
# -----------------------------------------------------------------------------
LastFm.getInstance = ->
    @instance = new LastFm() if not @instance?
    return @instance

module.exports = exports = LastFm.getInstance()
