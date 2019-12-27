#!/bin/bash

if output=$(git status --untracked-files=no --porcelain) && [ -z "$output" ]; then
  # Working directory clean excluding untracked files
  cp ~/.config/nvim/init.vim .
  cp ~/.config/nvim/vim_*.vim .
  git status
else 
  # Uncommitted changes in tracked files
  git status
  echo "***********************************"
  echo "Repo is not clean. Aborting update."
  echo "***********************************"
fi


