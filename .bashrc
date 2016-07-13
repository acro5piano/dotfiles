for f in ~/.profile.d/[0-9]*.sh
do
    source "$f"
done
for f in ~/.bash/[0-9]*.sh
do
    source "$f"
done

COLOR=$(echo $((`hostname | md5sum | sed 's/[^0-9]*//g'` % 40)) | sed 's/[^0-9]*//g')
export PS1="\[\e[0;${COLOR}m\]\u@\h:\w\[\e[m\] "

