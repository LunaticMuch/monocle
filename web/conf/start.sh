#!/bin/sh -x
# Copyright (C) 2021 Monocle authors
# SPDX-License-Identifier: AGPL-3.0-or-later

# Apply runtime settings for the web interface:
test -z "$REACT_APP_API_URL" || (sed  -e "s@__API_URL__@$REACT_APP_API_URL@" /app/index.html > /tmp/index.html; cp /tmp/index.html /app/index.html; rm /tmp/index.html);
test -z "$REACT_APP_TITLE"   || (sed -i -e "s@__TITLE__@$REACT_APP_TITLE@" /app/index.html > /tmp/index.html; cp /tmp/index.html /app/index.html; rm /tmp/index.html);

# Start the web server
exec nginx -g "daemon off;"
