# ╭──────────────────────────────────────────────────╮
# │  Refresh Script                                  │
# │  Restarts necessary components to apply themes.  │
# │                                                  │
# │  Maintained by @liyankova                        │
# ╰──────────────────────────────────────────────────╯
#!/bin/bash

# Terminate existing instances
# pkill waybar
pkill swaync

# Wait a moment for processes to terminate
sleep 0.5

# Relaunch components
# waybar &
swaync &
