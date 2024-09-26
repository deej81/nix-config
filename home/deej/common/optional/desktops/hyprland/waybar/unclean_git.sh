#!/bin/sh

# Directory where your Git repositories are stored
CODE_DIR=/home/deej/code  # Replace with your full path

# Initialize the variables
has_unpushed_or_uncommitted=0
tooltip=""

# Loop through each CLIENT/REPO under the CODE_DIR
for client in "$CODE_DIR"/*; do
  if [ -d "$client" ]; then
    for repo in "$client"/*; do
      if [ -d "$repo/.git" ]; then
        cd "$repo" || continue
        repo_name=$(basename "$repo")
        
        # Check for uncommitted changes
        uncommitted_changes=$(git status --porcelain)
        
        # Check for unpushed commits
        #git fetch origin &> /dev/null
        unpushed_commits=$(git log --branches --not --remotes)

        # If either uncommitted changes or unpushed commits are found
        if [[ -n "$uncommitted_changes" || -n "$unpushed_commits" ]]; then
          has_unpushed_or_uncommitted=1
          tooltip+="$client/$repo_name\n"  # Add the repo to the tooltip
        fi
      fi
    done
  fi
done
tooltip=$(echo "$tooltip" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g')
# Set the text and tooltip based on the status
if [[ $has_unpushed_or_uncommitted -eq 1 ]]; then
  echo -e "{\"text\": \"⚠️ Dirty\", \"class\": \"warning\", \"tooltip\": \"$tooltip\"}"
else
  echo -e "{\"text\": \"✓ All clean\", \"class\": \"ok\", \"tooltip\": \"No dirty repositories\"}"
fi
