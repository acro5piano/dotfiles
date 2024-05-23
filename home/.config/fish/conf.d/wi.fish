function wi
  set station (iwctl device list | grep wlan | grep ' on ' | awk '{print $1}')
  iwctl station $station $argv
end

set commands "get-networks scan connect"

complete -c wi -f -n "not __fish_seen_subcommand_from $commands" \
    -a $commands

complete -c wi -f -n "__fish_seen_subcommand_from connect" \
    -a "(wi get-networks | grep '*' | awk '{print \$1}')"
