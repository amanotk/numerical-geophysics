# 地球物理数値解析／Numerical Analysis in Geophysics

これは東京大学理学部・理学系研究科の学部大学院共通講義「地球物理数値解析」の講義スライドおよびサンプルコード用のリポジトリです．

# まとめページ
[こちら](https://amanotk.github.io/numerical-geophysics/)からどうぞ．

# クイックスタート

## 1. 環境セットアップ

ビルド環境をセットアップするには，以下のコマンドを実行します：

```bash
make setup
```

これにより：
- 必要なバージョンの Quarto がインストールされます
- Python 3.11 と必要なパッケージ（numpy, matplotlib, jupyter）がインストールされます

## 2. スライド生成

セットアップ後，以下のコマンドで HTML スライドを生成します：

```bash
make render
```

または直接：

```bash
quarto render
```

## 3. プレビュー

ブラウザでプレビューするには：

```bash
make preview
```

または：

```bash
quarto preview --port 4200
```

# 環境構築の詳細

使用されるバージョン：
- **Quarto**: 1.3.450（`.quarto-version` で管理）
- **Python**: 3.11（`.python-version` で管理）
- **Python パッケージ**: `pyproject.toml` と `uv.lock` で管理

詳細は [AGENTS.md](./AGENTS.md) を参照してください．

# 自動デプロイ（GitHub Actions）

このリポジトリでは GitHub Actions を使用して，main ブランチへのプッシュ時に自動的にスライドをビルドし GitHub Pages にデプロイします．

## 仕組み

- main ブランチへのプッシュ時に GitHub Actions が：
  1. Quarto 1.3.450 をセットアップ
  2. Python 3.11 と uv をセットアップ
  3. `uv.lock` から依存関係をインストール
  4. すべての QMD ファイルをレンダリング
  5. GitHub Pages（`gh-pages` ブランチ）にデプロイ

## 初回設定

GitHub Actions がデプロイできるようにするには：
1. ローカルで一度 `quarto publish gh-pages` を実行（`_publish.yml` が作成されます）
2. リポジトリの Actions に**Read and write permissions**を設定
3. GitHub Pages のソースを `gh-pages` ブランチに設定

## マニュアルトリガー

手動でビルドを実行することもできます：
1. GitHub の **Actions** タブを開く
2. "Quarto Publish" ワークフローを選択
3. "Run workflow" をクリック

# 手動セットアップ

`make` コマンドが使えない場合，以下の手順で手動セットアップできます：

## 1. Quarto のインストール

```bash
./install-quarto.sh
```

または，[Quarto 公式サイト](https://quarto.org/docs/getting-started/installation.html) から手動でインストールしてください．

## 2. Python パッケージのインストール

[uv](https://docs.astral.sh/uv/) を使用：

```bash
uv sync
```

または pip：

```bash
pip install numpy matplotlib jupyter
```

# スライドファイル生成

講義スライドは quarto で書かれています．以下のコマンドで HTML が自動生成されます．

```bash
quarto render
```

生成された HTML ファイルは `docs/` ディレクトリに保存されます．
