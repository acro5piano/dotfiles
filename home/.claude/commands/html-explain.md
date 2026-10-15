---
description: Explain things in HTML format
---

やったことを高校生でもわかるように1枚のHTMLで図解して。

説明する対象が指定されていない場合は、現在のプルリクエストもしくは今までの実装について図解して。

# 対象・追加指示

$ARGUMENTS

# 構成

```
<タイトル>
副題

<目次>
|----------|
| - 1. ... |
| - 2. ... |
| - 3. ... |
|----------|

<仕様や背景、やりたかったことなど>

<コードの挙動、ウォークスルー>
```

# コードのハイライト

highlight.js を利用して。末尾にこれを挿入:

```
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.12.0/styles/default.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.12.0/highlight.min.js"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.12.0/languages/rust.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.12.0/languages/typescript.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.12.0/languages/css.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.12.0/languages/json.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.12.0/languages/yaml.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.12.0/languages/bash.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.12.0/languages/sql.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.12.0/languages/python.min.js"></script>

<script>hljs.highlightAll();</script>
```

コードには、フォントの設定もして:

```
<style>
  code {
    background: #eef1f7;
    border-radius: 5px;
    padding: 1px 6px;
    font-family: "Source Code Pro", ui-monospace, "SF Mono", Menlo, Consolas, monospace;
    font-size: 13px;
  }
</style>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Source+Code+Pro:ital,wght@0,400;0,600;1,400&display=swap">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.12.0/styles/atom-one-dark.min.css">
```

# Metaタグ

(社内) ブログに使うかもしれないから、 適宜 meta タグを設定して

```
<title>{title}</title>
<meta property="og:title" content={title} />
<meta name="description" content={description} />
<meta property="og:description" content={description} />
<link rel="icon" href="/favicon.ico" />
```

# 出力先

`$HOME/.local/share/io.github.acro5piano.markbrain/notes/ai-html/<YYYYMMDD-HHMM>-<english-slug>.html`

- `<YYYYMMDD-HHMM>` は作成時のローカル時刻（`date +%Y%m%d-%H%M`）
- `<english-slug>` は内容を表す短い英語の kebab-case（小文字・ハイフン区切り）
- 例: `20260921-1855-ai-learn-switch-stronger.html`

ディレクトリが無ければ新規作成して

# git 管理されている場合は commit & push

出力ディレクトリが git 管理下（`git -C <出力ディレクトリ> rev-parse --is-inside-work-tree` が成功）なら、HTML 保存後に確認なしで自動的に commit & push して。

- 出力ディレクトリがシンボリックリンクでも、`git -C <出力ディレクトリ>` でリンク先のリポジトリを対象にする
- `git add` は今回作成したHTMLファイルだけ（`git add -A` は使わない）
- コミットメッセージは `add: <english-slug>` のように簡潔に
- push は `git push origin <現在のブランチ>`（`git push` 単体は使わない）
- git 管理されていなければ何もしない
- push に失敗したら、握りつぶさずに理由を報告する

完了したら、 `python -m http.server 18768 --directory <保存先ディレクトリ>` して、 `brave http://0.0.0.0:18768/<slug>.html` コマンドで開いて。
サーバーを起動するのは、 Chrome 拡張機能を有効にするため。
既にサーバーが起動していたら、改めて起動する必要は無い。
