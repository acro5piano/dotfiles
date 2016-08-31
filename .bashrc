for f in ~/.profile.d/[0-9]*.sh
do
    source "$f"
done
for f in ~/.bash/[0-9]*.sh
do
    source "$f"
done


### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
