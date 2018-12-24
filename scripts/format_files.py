# inspired from https://gist.github.com/willprice/e07efd73fb7f13f917ea

import subprocess
import os

BRANCH = "travis-"+os.getenv("TRAVIS_BUILD_NUMBER", "unknown")
subprocess.call("git checkout -b " + BRANCH, shell=True)
subprocess.call("../flutter/bin/flutter format lib/ test/", shell=True)
subprocess.call("git config --global user.email \"travis@travis-ci.org\"", shell=True)
subprocess.call("git config --global user.name \"Travis CI\"", shell=True)

changes = subprocess.run(("git diff-index --name-only HEAD --".split(" ")), stdout=subprocess.PIPE)

if len(changes.stdout.decode()) > 0:
    commit_message = "TRAVIS BUILD: " + os.getenv("TRAVIS_BUILD_NUMBER", default="unknown")
    commit_message += "\nformatted files:\n"
    commit_message += changes.stdout.decode()

    subprocess.call("git add -A", shell=True)
    subprocess.call("git commit --message \"" + commit_message + "\"", shell=True)

    subprocess.call("git remote add travis https://" + os.getenv("GITHUB_TOKEN") + "@github.com/veetaw/quake.git", shell=True)
    subprocess.call("git push --quiet travis " + BRANCH, shell=True)
