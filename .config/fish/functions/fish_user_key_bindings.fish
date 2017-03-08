
function fish_user_key_bindings
    fzf_key_bindings
    bind \cr __fzf_history
    bind \e\ch backward-kill-path-component
end
