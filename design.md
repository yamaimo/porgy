要件分析、設計
==============

やりたいこと
------------

Markdownから手軽にPDFを作りたい。

けれど、技術書を書くのに必要な機能は欲しい：

- 出力の設定
    - 用紙サイズを指定する
    - 本文領域のサイズを指定する（＝余白のサイズを指定する）
    - フォント、文字サイズ、行送りを指定する
    - デザインテンプレートを使用し、必要なら上書きする
    - 紙版/電子版など、設定を変えて出力する
        - 紙版で必要となる機能
            - トンボをつける
            - 隠しノンブルを振る
        - 電子版で必要となる機能
            - リンクを貼る
            - PDFにメタ情報を入れる（タイトル、著者、etc.）
            - PDFのアウトラインを出力する
- 文書構造
    - 見出しを作る
        - 見出しに番号を自動で振る
        - 見出しの体裁を変更する
    - ページをデザインする
        - ヘッダ/フッタ/ツメの形式を指定する
            - 現在の見出しを出力する
            - ページ番号を出力する
- 文章の記述
    - フォントを変える
    - 文字の色（前景色/背景色）を変える
    - 文字を強調する（太字/斜体/打ち消し）
    - 改行/改ページを指定する
    - 左寄せ/中央寄せ/右寄せをする
    - 空行を入れる
    - 領域を枠で囲む（インライン/ブロック）
    - 区切り線を引く
    - 脚注を書く
    - 傍注を書く
    - 引用をする
    - 箇条書きを作る
        - 番号なしリストを書く
        - 番号ありリストを書く
        - 定義リストを書く
        - 箇条書きのスタイルを指定する
    - コードを書く
        - インラインでコード片を書く
        - コードブロックを書く
    - 数式を書く
        - インライン数式を書く
        - ディスプレイ数式を書く
- 図表
    - 画像を載せる
    - 図を書く
    - 表を書く
    - 図/画像を拡大/縮小、回転させる
    - 表/画像をフローティングで配置する
    - 文章の回り込みを指定する
- 相互参照
    - 見出し/図/表の番号/ページを参照する
    - 目次を作成する
    - 索引を作成する
    - 参考文献を載せる
- その他
    - マクロを定義して使う
    - 複数のMardownから1つのPDFを作る
    - 暗号化したパスワード付きZIPを作る
    - 他にも？

Markdownの文章はそれ単体で読めるようになっていて欲しい。
出力の設定やマクロの定義は別ファイルで行いたい。

以下の2つが考えられるので、どちらにも対応したい：

1. すでに存在するMarkdownの文章（複数でもいい）から、デザインを指定してPDFを生成する。
2. 何もないところからMarkdownの文章を作成し、デザインを指定してPDFを生成する。

ファイル構成
------------

ビルド対象となる一連のファイルをプロジェクトと呼ぶことにする。

プロジェクトには以下の4種類のファイルが含まれる：

- `*.md`        原稿（複数可）
- `*.rb`        マクロ定義（複数可）
- `porgy.yml`   設定ファイル
- `Rakefile`    ビルドルール

具体的なビルドターゲットは`porgy.yml`の中で定義し、
ビルドターゲットと原稿・マクロ定義の結び付けも`porgy.yml`で定義する。

コマンド
--------

`porgy`コマンドを用意する。

とりあえずは上記ファイル構成を作る`init`サブコマンドだけで十分。
ビルドは`rake`で行う。

### `init`サブコマンド

プロジェクトに必要なファイルを用意する。

指定された引数の種類によって、挙動が以下のようになるとよさそう：

- 何も指定しなかった場合、現在のディレクトリに`porgy.yml`と`Rakefile`を用意する。
  すでに存在する場合はエラー。
- 任意個のMarkdownファイルとRubyスクリプトが指定された場合、
  それらをビルド対象とする設定の`porgy.yml`と`Rakefile`を現在のディレクトリに用意する。
  （Markdownファイル/Rubyスクリプトが存在しなかったら、空のファイルを用意する）
- ディレクトリ`<name>`が指定された場合、そのディレクトリ以下（なければ作る）に、
  `<name>.md`、`<name>.rb`を用意し（なければ作る）、それらをビルド対象とする
  `porgy.yml`と`Rakefile`をそのディレクトリに用意する。

マクロの使用方法
----------------

マクロはMarkdownの中で`#{<マクロ>}`と呼び出す。
マクロには任意のRubyコードが使え、最後に評価された式の値を文字列に変換したものになる。

ビルド処理の流れ
----------------

`rake`コマンドでビルドを行うと、以下のように処理する：

1. `porgy.yml`の設定にしたがって原稿を読む。
2. Markdonのライブラリ（Redcarpetかkrandownの予定）でHTMLに変換する。
3. HTMLから中間オブジェクトに変換する。
4. `porgy.yml`の設定にしたがってマクロ定義を読む。
5. マクロを評価して出力オブジェクトに変換する。
6. Prawnを使って出力オブジェクトの組版を行う。
7. 相互参照をチェックして、出力オブジェクトの更新が必要なければ終了。
   更新が必要であれば出力オブジェクトを更新して6.へ。

ページ番号などは組版されたタイミングで決まるので、決まってないときは？などにする。
被参照オブジェクトは出力オブジェクト内に発火オブジェクトを仕込んでおいて、
組版されたらページ番号を取得、そして参照オブジェクトに更新の必要を通知する。

振動することがあるので、更新試行回数に上限は必要。

複数の原稿を持つプロジェクトで1枚の原稿を対象にビルドする可能性もあるので、
解決されないまま残る参照オブジェクトがいる可能性もあることに注意が必要。