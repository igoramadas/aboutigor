# MAIN SERVER
# -----------------------------------------------------------------------------

# Init expresser and settings.
setmeup = require "setmeup"
setmeup.load()
setmeup.loadFromEnv()

# Port set via the PORT env?
setmeup.settings.app.port = process.env.PORT if process.env.PORT

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
