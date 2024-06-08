function wi
  set station (iwctl device list | rg '(wlan[0-9]+)' --replace '$1' --only-matching)
  echo "using station: $station"
  iwctl station $station $argv
end

set commands "get-networks scan connect"

complete -c wi -f -n "not __fish_seen_subcommand_from $commands" \
    -a $commands

complete -c wi -f -n "__fish_seen_subcommand_from connect" \
    -a "(wi get-networks | grep '*' | awk '{print \$1}')"
