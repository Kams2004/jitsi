#!/bin/bash
# Run this on the server (~/jitsi-docker) after a `git pull`, or let it pull
# for you: `./deploy.sh` fetches the latest main, fast-forwards onto it, and
# recreates whatever containers changed.
#
# Deliberately NOT automated over SSH from GitHub — this only ever runs when
# someone is at the keyboard on the server, on purpose.
#
# --ff-only refuses to run if local commits/edits can't fast-forward cleanly
# (e.g. an uncommitted docker-compose.yml edit) instead of discarding them.
# Commit, stash, or resolve those first if this stops you.
#
# Doesn't touch .env — it's gitignored on purpose (live secrets) and was
# never part of this repo, so settings that live there (DYNAMIC_BRANDING_URL,
# etc.) still need to be edited by hand, separately from this script.

set -e
cd "$(dirname "$0")"

echo "==> Fetching latest changes..."
git fetch origin
git pull --ff-only origin main

echo "==> Pulling updated images (if any)..."
docker compose pull

echo "==> Recreating changed containers..."
docker compose up -d

echo "==> Done. Current state:"
docker compose ps
