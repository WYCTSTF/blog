for branch in $(git branch -r | grep -v 'origin/master' | grep 'origin/' | sed 's|origin/||'); do
  git push origin --delete "$branch"
done

