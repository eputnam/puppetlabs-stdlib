echo ""
echo "Checking out {scm_branch} branch"
git fetch eputnam
git checkout pot_bash

echo ""
echo "Generating new POT file"
bundle exec rake gettext:update_pot

echo ""
echo "Diffing new POT file with POT file from {scm_branch}"
set +e
git diff --exit-code ./locales/puppetlabs-stdlib.pot
diff_status=$?
set -e

if [[ "$diff_status" -eq 1 ]]; then
   echo "Changes found, commiting new POT file"
   if [[ 'false' == 'true' ]]; then
      git add ./locales/puppetlabs-stdlib.pot
      git commit -m "Updating POT file for $GIT_COMMIT"
      echo "Pushing changes back to repository"
      git push eputnam pot_bash
   fi
else
    echo "No changes to POT, keeping old POT file"
fi
