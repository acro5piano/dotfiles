---
description: Explain things in HTML format
---

やったことを高校生でもわかるように1枚のHTMLで図解して。
完了したら、 `python -m http.server <directory> <port>` して、 `brave http://0.0.0.0:<port>` コマンドで開いて。サーバーを起動するのは、 Chrome 拡張機能を有効にするため。

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

`$HOME/ai-html-notes`

ディレクトリが無ければ新規作成して
