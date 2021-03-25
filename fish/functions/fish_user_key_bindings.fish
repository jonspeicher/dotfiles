# https://github.com/fish-shell/fish-shell/issues/3541
function fish_user_key_bindings
    for mode in insert default visual
        bind -M $mode \cf forward-char
    end
end
