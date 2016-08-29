# 左右にウィンドウを分割する
split-window -h

# 1番目(左側)のウィンドウを選択
select-pane -t 1

# 上下にウィンドウを分割
split-window -v

# 横幅調整
tmux resize-pane -x 80

