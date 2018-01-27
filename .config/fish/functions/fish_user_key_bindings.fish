function fish_user_key_bindings
    bind \cr __fzf_history
    bind \e\ch backward-kill-word
    bind \ew __copy_command
    bind \e\cf fzf-file-widget
    bind \ec fzf-cd-widget
end
