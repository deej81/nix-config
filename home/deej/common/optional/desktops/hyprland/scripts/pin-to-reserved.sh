#!/usr/bin/env bash
# Toggle pin active window to reserved area (right 25%) across all workspaces
# If active window is pinned: unpin, unfloat, and remove reservation
# If active window is not pinned: activate reservation, unpin others, pin active

STATE_FILE="/tmp/hypr-reserve-toggle"
GAPS_IN=4
GAPS_OUT_RIGHT=8
GAPS_OUT_BOTTOM=8
BORDER_SIZE=1

# Get monitor info
MONITOR=$(hyprctl activeworkspace -j | jq -r '.monitor')
MONITOR_INFO=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$MONITOR\")")
WIDTH=$(echo "$MONITOR_INFO" | jq -r '.width')
HEIGHT=$(echo "$MONITOR_INFO" | jq -r '.height')
SCALE=$(echo "$MONITOR_INFO" | jq -r '.scale')

# Calculate logical dimensions
LOGICAL_WIDTH=$(awk "BEGIN {printf \"%.0f\", $WIDTH / $SCALE}")
LOGICAL_HEIGHT=$(awk "BEGIN {printf \"%.0f\", $HEIGHT / $SCALE}")
RESERVE_RIGHT=$((LOGICAL_WIDTH / 4))

# Check if active window is already pinned
IS_PINNED=$(hyprctl activewindow -j | jq -r '.pinned')

if [[ "$IS_PINNED" == "true" ]]; then
    # Unpin and unfloat the window, remove reservation
    hyprctl --batch "\
        dispatch pin active; \
        dispatch settiled active"
    hyprctl keyword monitor "$MONITOR,addreserved,0,0,0,0"
    rm -f "$STATE_FILE"
else
    # Activate reservation if not already active
    if [[ ! -f "$STATE_FILE" ]]; then
        hyprctl keyword monitor "$MONITOR,addreserved,0,0,0,$RESERVE_RIGHT"
        touch "$STATE_FILE"
    fi

    # Unpin any other pinned windows
    hyprctl clients -j | jq -r '.[] | select(.pinned == true) | .address' | while read -r addr; do
        hyprctl dispatch pin "address:$addr"
    done

    # Re-read monitor info to get updated reserved area
    MONITOR_INFO=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$MONITOR\")")
    RESERVED_TOP=$(echo "$MONITOR_INFO" | jq -r '.reserved[1]')

    # Calculate position and size to align with tiled windows
    # X: 75% + half gap (to create visual separation from tiled area)
    # Y: reserved top + border (to match tiled window positioning)
    # W: 25% - right gap - half inner gap
    # H: full height - reserved top - bottom gap - 2*border
    POS_X=$((LOGICAL_WIDTH * 75 / 100 + GAPS_IN / 2))
    POS_Y=$((RESERVED_TOP + BORDER_SIZE))
    WIN_WIDTH=$((LOGICAL_WIDTH * 25 / 100 - GAPS_OUT_RIGHT - GAPS_IN / 2))
    WIN_HEIGHT=$((LOGICAL_HEIGHT - RESERVED_TOP - GAPS_OUT_BOTTOM - 2 * BORDER_SIZE))

    hyprctl --batch "\
        dispatch setfloating active; \
        dispatch pin active; \
        dispatch moveactive exact ${POS_X} ${POS_Y}; \
        dispatch resizeactive exact ${WIN_WIDTH} ${WIN_HEIGHT}"
fi
