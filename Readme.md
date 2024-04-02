# 地球物理数値解析／Numerical Analysis in Geophysics

これは東京大学理学部・理学系研究科の学部大学院共通講義「地球物理数値解析」の講義資料およびサンプルをまとめたリポジトリです．

## 講義スライド（HTML）
0. [イントロダクション](https://amanotk.github.io/numerical-geophysics/introduction.html#/)
1. [序論：様々な偏微分方程式](https://amanotk.github.io/numerical-geophysics/chap01.html#/)
2. [差分法の基礎](https://amanotk.github.io/numerical-geophysics/chap02.html#/)
3. [双曲型偏微分方程式の解法 (1)：線形問題](https://amanotk.github.io/numerical-geophysics/chap03.html#/)
4. [双曲型偏微分方程式の解法 (2)：非線形問題](https://amanotk.github.io/numerical-geophysics/chap04.html#/)

## Jupyter Notebook
[notebook](https://github.com/amanotk/numerical-geophysics/tree/main/notebook)にjupyter notebook（`.ipynb`）形式のファイルがあります．  
Googleアカウントがあれば，各 `.ipynb` ファイル先頭に表示されているアイコン
<img src="https://colab.research.google.com/assets/colab-badge.svg">
をクリックすることでブラウザ上で（Google Colabで）サンプルを動かすことができます．

## Fortran
[fortran](https://github.com/amanotk/numerical-geophysics/tree/main/fortran)にFortranのサンプルが置いてありますので，必要に応じて参照してください．

## スライドファイル生成
講義スライドファイルの自動生成は以下のコマンド
```
 $ quarto render
```
