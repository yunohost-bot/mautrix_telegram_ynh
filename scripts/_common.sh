#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================

# dependencies used by the app
# HACK zlib1g-dev libjpeg-dev (libwebp-dev and libolm-dev optional but necessary for stickers/e2be) are necessary to compile / install pillow
pkg_dependencies="postgresql python3 zlib1g-dev libjpeg-dev libwebp-dev python3-venv libpq-dev libffi-dev libolm-dev"

#=================================================
# PERSONAL HELPERS
#=================================================

write_bridge_config () {

}

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
