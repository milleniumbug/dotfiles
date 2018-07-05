# Launch a program and exit
# Originally I named it "launchex", but I don't want zsh autocompletes to launch to resolve to launchex
# so I renamed it to xlaunch
# why does it exist? it's a hack to get me a decent autocomplete for files
function xlaunch() { launch $@ && exit }
