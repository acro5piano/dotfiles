# 一番初めのpaneを選択
select-pane -t 0
# 上下にウィンドウを分割する
split-window -v
# 1番目(下側)のウィンドウを選択
select-pane -t 1
# 左右にウィンドウを分割
split-window -v

# メインとなるウィンドウの高さを35行に設定
setw main-pane-height 50
# 上下分割レイアウトを反映
select-layout main-horizontal
display-panes
