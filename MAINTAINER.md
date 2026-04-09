# 構築ガイド

このドキュメントは、講義スライドをビルド・デプロイするための手順を説明します。

## クイックスタート

```bash
# 環境セットアップ（初回のみ）
make setup

# スライド生成（ビルド）
make render

# ローカルプレビュー（推奨）
# CI／公開と同じ出力を確認するには、レンダリングして生成された docs/ を静的に配信してください。
# 例:
python -m http.server 8080 --directory docs &
# ブラウザで http://localhost:8080/ を開き、生成された HTML を確認します。

# 注: `make preview` は Quarto の開発サーバーを起動しますが、preview はソースを /src/ 下で提供するため
# 相対パスの振る舞いが CI/公開時と異なる場合があります。公開と同じ見た目を確認するには上記の手順を推奨します。
```

## クイック確認 (file:// と HTTP サーバー)

生成された HTML を手早く確認するだけなら、ファイルをブラウザで直接開く（file:// URL）でも動作することが多いです。例: ブラウザで `docs/chap02.html` を開く。

ただし、前述のとおり絶対パス（先頭 `/`）、Quarto のランタイム JavaScript、MIME タイプなどにより挙動が異なる場合があります。公開時と同一の表示を確認したい場合は、`python -m http.server --directory docs` で docs/ を配信して確認することを推奨します。

## ローカルプレビューの注意点

- docs/ を配信する場合はリポジトリのルートからコマンドを実行してください（`docs/` ディレクトリが存在することを確認）。
- Unix シェルの例（推奨、簡潔）:

```bash
# レンダリング
make render
# docs/ を配信してブラウザで確認
python -m http.server 8080 --directory docs &
# ブラウザで http://localhost:8080/ を開く。停止は `kill %1` や `pkill -f "http.server"` などで行えます。
```

- PowerShell の例（Windows）:

```powershell
# レンダリング
make render
# サーバー起動（PowerShell）
Start-Process -NoNewWindow -FilePath python -ArgumentList '-m','http.server','8080','--directory','docs'
# ブラウザで http://localhost:8080/ を開く。停止はタスクマネージャー等で python プロセスを終了してください。
```

- 簡易チェックとしてファイルを直接開く（file://）こともできますが、絶対パスや Quarto ランタイム依存機能の差異に注意してください。

## 環境詳細

使用されるバージョン：
- **Quarto**: 1.3.450（`.quarto-version` で管理）
- **Python**: 3.11（`.python-version` で管理）
- **Python パッケージ**: `pyproject.toml` と `uv.lock` で管理
  - numpy >= 1.24.0
  - matplotlib >= 3.7.0
  - jupyter >= 1.0.0

## 環境セットアップの詳細

### 1. Quarto のインストール

```bash
./install-quarto.sh
```

または、[Quarto 公式サイト](https://quarto.org/docs/download/) から手動でインストールしてください。

### 2. Python パッケージのインストール

[uv](https://docs.astral.sh/uv/) を使用：

```bash
uv sync
```

または pip：

```bash
pip install numpy matplotlib jupyter
```

## ビルドコマンド

| コマンド | 説明 |
|---------|-------------|
| `make setup` | Quarto と Python 依存関係をインストール |
| `make render` | ドキュメントをビルド |
| `make preview` | Quarto の開発サーバーを起動（ポート 4200）。詳細は下の「ローカルプレビューの注意点」を参照 |
| `make clean` | 生成された HTML ファイルを削除 |
| `make check` | 環境セットアップを確認 |

## ディレクトリ構造

```
numerical-geophysics/
├── src/                    # Quarto ソースファイル
│   ├── index.qmd
│   ├── introduction.qmd
│   ├── chap01.qmd
│   ├── ...
│   ├── bibliography.bib
│   └── lecture-theme.css
├── notebook/               # Jupyter ノートブック
├── report/                 # レポート課題
├── figure/                 # 静的画像
├── fortran/                # Fortran コードサンプル
├── docs/                   # 生成された HTML（CI のみ）
└── ...
```

## GitHub Actions（自動デプロイ）

このリポジトリでは GitHub Actions を使用して、main ブランチへのプッシュ時に自動的にスライドをビルドし GitHub Pages にデプロイします。

### 仕組み

- main ブランチへのプッシュ時に GitHub Actions が：
  1. Quarto 1.3.450 をセットアップ
  2. Python 3.11 と uv をセットアップ
  3. `uv.lock` から依存関係をインストール
  4. すべての QMD ファイルをレンダリング
  5. GitHub Pages（`gh-pages` ブランチ）にデプロイ

### 設定

ワークフローは `.github/workflows/publish.yml` で定義されています。

### フリーズされた計算

コード実行は `freeze: auto` を使用（`_quarto.yaml` で設定）：
- コードはローカルで実行
- 結果は `_freeze/` ディレクトリに保存
- GitHub Actions はフリーズされた結果を使用（CI でコードを実行しない）
- 高コストな計算を再実行せずに再現可能なビルドを保証

コードを再実行するには、`_freeze/` ディレクトリを削除してローカルでレンダリングしてください。

### 手動トリガー

手動でビルドを実行することもできます：
1. GitHub の **Actions** タブを開く
2. "Quarto Publish" ワークフローを選択
3. "Run workflow" をクリック

### 初回設定

GitHub Actions がデプロイできるようにするには：
1. ローカルで一度 `quarto publish gh-pages` を実行（`_publish.yml` が作成されます）
2. リポジトリの Actions に**Read and write permissions**を設定
3. GitHub Pages のソースを `gh-pages` ブランチに設定

## トラブルシューティング

### "quarto: command not found"

`make setup` を実行するか、手動で `./install-quarto.sh` を実行してください。`~/.local/bin` が PATH に含まれていることを確認してください。

### Python パッケージのエラー

```bash
uv sync
```

を実行して、すべての依存関係が正しくインストールされていることを確認してください。

### バージョン不一致の警告

```bash
make check
```

を実行して環境を確認してください。Quarto のバージョンが一致しない場合は、`make setup` を再実行してください。

### Windows ユーザー

**WSL（Windows Subsystem for Linux）:**
`install-quarto.sh` スクリプトは WSL で自動的に動作します - WSL を Linux として検出します。

**ネイティブ Windows:**
`install-quarto.sh` スクリプトはネイティブ Windows をサポートしています：
1. 抽出には `unzip` または PowerShell が必要
2. `quarto.exe` を `~/.local/bin/` にインストール
3. PATH に追加：`setx PATH "%USERPROFILE%\.local\bin;%PATH%"`

または、uv for Windows をインストールして Python パッケージを管理してください。

## 詳細

詳細な環境設定については [AGENTS.md](./AGENTS.md) を参照してください。
