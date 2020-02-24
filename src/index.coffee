# MAIN SERVER
# -----------------------------------------------------------------------------

# Init expresser and settings.
setmeup = require "setmeup"
setmeup.load()
setmeup.loadFromEnv()

expresser = require "expresser"
legacy = require "expresser-legacy"
legacy.init expresser, true

# Routes.
routes = require "./routes"
routes.set expresser.app

# Get data from GitHub.
github = require "./github"
github.init()

# Get data from Last.fm.
lastfm = require "./lastfm"
lastfm.init()
