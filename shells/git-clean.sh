#!/bin/bash


# Standard Prune - Removes Branches No Longer Tracked
git fetch -p

# Will remove local branches that have already been merged
git branch --merged | grep -v "\*" | xargs -n 1 git branch -d
