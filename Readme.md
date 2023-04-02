# 地球物理数値解析／Numerical Analysis in Geophysics

これは東京大学理学部・理学系研究科の学部大学院共通講義「地球物理数値解析」の講義資料およびサンプルをまとめたリポジトリです．

## 講義スライド（PDF）
- [イントロダクション](introduction.pdf)
- [様々な偏微分方程式](resume01.pdf)
- [差分法の基礎](resume02.pdf)
- [双曲型偏微分方程式の解法 (1)：線形問題](resume03.pdf)
- [双曲型偏微分方程式の解法 (2)：非線形問題](resume04.pdf)

## Jupyter Notebook
[notebook](https://github.com/amanotk/numerical-geophysics/tree/main/notebook)にjupyter notebook（`.ipynb`）形式のファイルがあります．  
Googleアカウントがあれば，各 `.ipynb` ファイル先頭に表示されているアイコン
<img src="https://colab.research.google.com/assets/colab-badge.svg">
をクリックすることでブラウザ上で（Google Colabで）サンプルを動かすことができます．

## Fortran
[fortran](https://github.com/amanotk/numerical-geophysics/tree/main/fortran)にFortranのサンプルが置いてありますので，必要に応じて参照してください．

## PDFファイル生成
講義スライドPDFの自動生成は以下のコマンド
```
 $ npx @marp-team/marp-cli@latest \
 	--theme lecture-theme.css --allow-local-files --html --pdf \
	introduction.md resume{01..04}.md
```
