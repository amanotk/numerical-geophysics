---
marp: true
theme: lecture-theme
math: mathjax
footer: "地球物理数値解析 天野孝伸 <<amano@eps.s.u-tokyo.ac.jp>>"
---

<!--
_class: title
-->


<style>
img[alt~="center"] {
  display: block;
  margin: 0 auto;
}
</style>

$$
\renewcommand{\bm}[1]{{\boldsymbol{#1}}}
$$


<!--
_class: title
-->

# 2. 差分法の基礎

---
## 2.1 有限差分法による離散化

計算機は連続的な関数を厳密に表現することができないため，基礎方程式を数値的に解く際には何らかの離散化が必要となる．典型的には離散的な格子点 $x_{i} (i = 1, 2, \ldots, N)$ において定義される $u_{i} = u(x_{i})$ を用いる．

この離散化によって格子点上の関数値は定義されたが，偏微分方程式に現れる微分値は未知である．（微分値も独立変数にとる手法も存在する．）安直には微分を差分に置き換えてやればよい．
例えば最も簡単な場合として等間隔格子 $x_{i} = i \Delta x$ を使う場合を考えると，一階微分は直感的に
$$
\left( \frac{\partial u}{\partial x} \right)_{i} \approx \frac{u_{i+1} - u_{i-1}}{2 \Delta x}
$$
のように近似することができるだろう．しかし，同様に
$$
\left( \frac{\partial u}{\partial x} \right)_{i} \approx \frac{u_{i+1} - u_{i}}{\Delta x}
$$
や
$$
\left( \frac{\partial u}{\partial x} \right)_{i} \approx \frac{u_{i} - u_{i-1}}{\Delta x}
$$
でも良さそうである．
どのような差分近似を採用したら良いのだろうか？

---
## 2.2 差分近似の誤差と精度

微分の差分近似は一意には決まらないが，その誤差は理論的に評価することができる．そのために$x = x_i$近傍でのTaylor展開を考えよう．
$$
u_{i\pm1} = u(x_{i} \pm \Delta x) = u_{i} \pm
\left( \frac{\partial u}{\partial x} \right)_{i} \Delta x^1 +
\frac{1}{2} \left( \frac{\partial u}{\partial x} \right)_{i} \Delta x^2 +
\mathcal{O} (\Delta x^3)
$$
これから直ちに
$$
\left( \frac{\partial u}{\partial x} \right)_{i} \approx \frac{u_{i+1} - u_{i-1}}{2 \Delta x} +
\mathcal{O} (\Delta x^2)
$$
を得る．すなわち，格子幅$\Delta x$を小さくするとこの差分近似の誤差は$\Delta x^2$に比例して小さくなることが分かる．このように展開を途中で打ち切ることから生じる誤差を打ち切り誤差と呼ぶ．

一般に差分近似の誤差が$\Delta x$の$n$乗に比例して小さくなるとき，その差分近似は$n$次精度と呼ばれる．


#### Q.2-1
差分近似 $\displaystyle \left( \frac{\partial u}{\partial x} \right)_{i} \approx \frac{u_{i+1} - u_{i}}{\Delta x}$ および $\displaystyle \left( \frac{\partial u}{\partial x} \right)_{i} \approx \frac{u_{i} - u_{i-1}}{\Delta x}$ の精度（次数）を求めよ．

---
## 2.3 前進差分・後退差分・中心差分

差分近似の次数が同じであっても，その表現は必ずしも一つに定まるわけではない．それは評価点$x=x_i$における差分近似を構成するために近傍のどの点を採用するかに自由度があるためである．

評価点$x=x_i$の

- 前の点を使う $\displaystyle \left( \frac{\partial u}{\partial x} \right)_{i} \approx \frac{u_{i+1} - u_{i}}{\Delta x}$ のような差分を**前進差分** (forward difference)
- 後の点を使う $\displaystyle \left( \frac{\partial u}{\partial x} \right)_{i} \approx \frac{u_{i} - u_{i-1}}{\Delta x}$ のような差分を**後退差分** (backward difference)
- 前後を等しく用いる $\displaystyle \left( \frac{\partial u}{\partial x} \right)_{i} \approx \frac{u_{i+1} - u_{i-1}}{2 \Delta x}$ のような差分を**中心差分**（central difference）

と呼ぶ．これらは単なる呼び名であって，与えられた方程式を解くにあたってどの差分近似を採用すべきかは全く明らかでない．多くの場合において，近似すべき項の**物理的性質に適した差分近似**を用いなければ実用的な数値計算はできないことがほとんどである．
（そもそも時間微分の近似以外の場合においては前進・後退という名前自体が物理的に全くナンセンスである．）

---
## 2.4 高階微分の差分近似
基本的には1階微分の場合と同様にTaylor展開を用いて必要な微分係数以外の項を消去すればよい．
例えば2階微分であれば
$$
\left( \frac{\partial^2 u}{\partial x^2} \right)_i \approx
\frac{u_{i+1} - 2 u_{i} + u_{i-1}}{\Delta x^2} +
\mathcal{O} (\Delta x^2)
$$

より高階の微分や前進差分・後退差分なども構成することができる．
よく使われる差分公式について https://en.wikipedia.org/wiki/Finite_difference_coefficient を参照せよ．

ある点の微分値を差分近似する際に必要となる周辺の範囲のことを**ステンシル**と呼ぶ．一般に，高階微分の差分近似や，同じ次数でも高次精度の差分を構成する際にはより広いステンシルが必要となる．



#### Q.2-2
上記の差分近似が2次精度であることを示せ．Taylor展開を3次まで行う必要があることに注意せよ．


