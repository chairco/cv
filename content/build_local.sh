#!/usr/bin/env bash

set -e
cd "$(dirname ${BASH_SOURCE[0]})"

DIR="`pwd`"

# We need at least bundler to proceed
if [ "`command -v bundle`" == "" ]; then
        echo "WARN: Could not find bundle."
    echo "Attempting to install locally. If this doesn't work, please install with 'gem install bundler'."

    # Adjust the PATH to discover a locally installed Ruby gem
    if which ruby >/dev/null && which gem >/dev/null; then
        export PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
    fi

    # install bundler locally
    gem install --user-install bundler
fi

# Install Ruby dependencies locally
bundle install --path .rubydeps

DOCS_SRC=${DIR}
DOCS_DST=${DOCS_SRC}/content

# use 'bundle exec' to insert the local Ruby dependencies
# the site is served on localhost:4000
bundle exec jekyll serve --baseurl= --watch --source "${DOCS_SRC}" --destination "${DOCS_DST}"