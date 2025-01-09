#!/bin/sh
# Configuration variables
LEFT_SPLIT=25    # percentage of available width
MIDDLE_SPLIT=50  # percentage of available width
RIGHT_SPLIT=25   # percentage of available width
GAP_SIZE=16      # pixels between windows
BORDER_PADDING=4 # pixels from screen edges

# Enable debug output
set -x

echo "=== Starting layout toggle script ==="

# Get the current workspace
current_workspace=$(hyprctl activewindow -j | jq -r '.workspace.id')
echo "Current workspace: $current_workspace"

# Get all windows in current workspace
windows=($(hyprctl clients -j | jq -r --arg ws "$current_workspace" '.[] | select(.workspace.id == ($ws | tonumber)) | .address'))
echo "Found ${#windows[@]} windows: ${windows[*]}"

if [ ${#windows[@]} -ne 3 ]; then
    echo "Error: Need exactly 3 windows, found ${#windows[@]}"
    notify-send "Layout Error" "Need exactly 3 windows to arrange"
    exit 1
fi

# Check if any window is floating
any_floating=false
for window in "${windows[@]}"; do
    is_floating=$(hyprctl clients -j | jq -r --arg addr "$window" '.[] | select(.address == $addr) | .floating')
    if [ "$is_floating" = "true" ]; then
        any_floating=true
        break
    fi
done

if [ "$any_floating" = "true" ]; then
    # If any window is floating, unfloat all windows
    echo "Switching to tiled layout"
    for window in "${windows[@]}"; do
        is_floating=$(hyprctl clients -j | jq -r --arg addr "$window" '.[] | select(.address == $addr) | .floating')
        if [ "$is_floating" = "true" ]; then
            hyprctl dispatch togglefloating address:$window
        fi
    done
else
    # If no windows are floating, apply the 30/40/30 layout
    echo "Switching to 30/40/30 layout"

    # Get the focused monitor dimensions
    focused_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true)')
    monitor_width=$(echo "$focused_monitor" | jq -r '.width')
    monitor_height=$(echo "$focused_monitor" | jq -r '.height')
    reserved_top=$(echo "$focused_monitor" | jq -r '.reserved[1]')

    # Get currently focused window
    focused_window=$(hyprctl activewindow -j | jq -r '.address')

    # Calculate dimensions with gaps
    total_gap_space=$(( GAP_SIZE * 2 ))
    available_width=$(( monitor_width - total_gap_space ))

    # Width calculations based on configured splits
    left_width=$(( available_width * LEFT_SPLIT / 100 ))
    middle_width=$(( available_width * MIDDLE_SPLIT / 100 ))
    right_width=$(( available_width * RIGHT_SPLIT / 100 ))

    # Height calculation
    window_height=$(( monitor_height - reserved_top - (2 * BORDER_PADDING) ))

    # X position calculations
    left_x=$BORDER_PADDING
    middle_x=$(( left_width + GAP_SIZE + BORDER_PADDING ))
    right_x=$(( middle_x + middle_width + GAP_SIZE ))

    # Y position
    y_pos=$(( reserved_top + BORDER_PADDING ))

    # Make all windows floating and position them
    for window in "${windows[@]}"; do
        hyprctl dispatch togglefloating address:$window
    done

    # Position left window
    hyprctl dispatch movewindowpixel exact $left_x $y_pos,address:${windows[0]}
    hyprctl dispatch resizewindowpixel exact $left_width $window_height,address:${windows[0]}

    # Position focused window in middle
    hyprctl dispatch movewindowpixel exact $middle_x $y_pos,address:${focused_window}
    hyprctl dispatch resizewindowpixel exact $middle_width $window_height,address:${focused_window}

    # Position right window
    right_window=""
    for window in "${windows[@]}"; do
        if [ "$window" != "${windows[0]}" ] && [ "$window" != "$focused_window" ]; then
            right_window=$window
            break
        fi
    done
    hyprctl dispatch movewindowpixel exact $right_x $y_pos,address:$right_window
    hyprctl dispatch resizewindowpixel exact $right_width $window_height,address:$right_window
fi

echo "=== Final Window States ==="
for window in "${windows[@]}"; do
    echo "Window $window state:"
    hyprctl clients -j | jq --arg addr "$window" '.[] | select(.address == $addr) | {class, title, floating}'
done
