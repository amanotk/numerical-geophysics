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
\newcommand{\bm}[1]{{\bf #1}}
$$

# 1. 様々な偏微分方程式

---
## 1.1 偏微分方程式の分類
一般に$u = u(x, y)$が独立変数$x, y$の関数であるとき，$u$と$x, y$および偏導関数($\partial u/\partial x, \partial u/\partial y, \partial^2 u/\partial x \partial y, ...$)の間に成り立つ関係式を偏微分方程式と呼ぶ．物理的に興味のある系の多くは低次の微分で表される．
例えば
$$
a \frac{\partial^2 u}{\partial x^2} +
b \frac{\partial^2 u}{\partial x \partial y} +
c \frac{\partial^2 u}{\partial y^2} =
F \left( u, x, y, \frac{\partial u}{\partial x}, \frac{\partial u}{\partial y} \right)
$$
の形で表される系を考えよう．このとき $D = b^2 - 4 a c$の値によって偏微分方程式は

- $D < 0$ : 楕円型
- $D = 0$ : 放物型
- $D < 0$ : 双曲型

と分類される．

これは2次曲線
$$
a x^2 + b xy + c y^2 = F(x, y)
$$
が$D$の値によって楕円，放物線，双曲線に分類されるためである．
物理的にもこれらの分類によって解の性質は大きく異なる．

---
### 例1：Laplace方程式（楕円型方程式）
$a = c = 1, b = 0, F = 0$のとき，
$$
\frac{\partial^2 u}{\partial x^2} + \frac{\partial^2 u}{\partial y^2} = 0
$$
<!--
例えば与えられた境界で電位が与えられたときの真空中の静電ポテンシャルを求める問題に現れる．
-->

### 例2：拡散方程式（放物型方程式）
$a = 1, b = c = 0, F = \partial u/\partial y$で$y \rightarrow t$と置き換えて
$$
\frac{\partial u}{\partial t} = \frac{\partial^2 u}{\partial x^2}
$$

### 例3：波動方程式（双曲型方程式）
$a = 1, b = 0, c = -1, F = 0$で$y \rightarrow t$と置き換えて
$$
\frac{\partial^2 u}{\partial t^2} = \frac{\partial^2 u}{\partial x^2}
$$

---
## 1.2 境界条件（および初期条件）

- 偏微分方程式の解は対象とする領域の境界で与えられる何らかの拘束条件（境界条件）によって決定される．変数の一つが時間($t$)であるときは，$t = 0$で与える境界条件を初期条件と呼ぶのが通例である．
- 必要とされる境界条件の個数は微分の階数によって異なる．
- 境界における解の値を与える境界条件を**Direchlet型境界条件**と呼ぶ．一方で境界における解の一階微分値を与える境界条件を**Neumann型境界条件**と呼ぶ．
- 当然ながら解を規定するために必要十分な境界条件を与えなければ解は求まらない！


# 例？



---

<!--
_class: title
-->

# 2. 差分法の基礎

---
## 2.1 計算機による実数の表現

---
## 2.2 有限差分法による離散化

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
## 2.3 差分近似の誤差と精度

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
## 2.4 前進差分・後退差分・中心差分

差分近似の次数が同じであっても，その表現は必ずしも一つに定まるわけではない．それは評価点$x=x_i$における差分近似を構成するために近傍のどの点を採用するかに自由度があるためである．

評価点$x=x_i$の

- 前の点を使う $\displaystyle \left( \frac{\partial u}{\partial x} \right)_{i} \approx \frac{u_{i+1} - u_{i}}{\Delta x}$ のような差分を**前進差分** (forward difference)
- 後の点を使う $\displaystyle \left( \frac{\partial u}{\partial x} \right)_{i} \approx \frac{u_{i} - u_{i-1}}{\Delta x}$ のような差分を**後退差分** (backward difference)
- 前後を等しく用いる $\displaystyle \left( \frac{\partial u}{\partial x} \right)_{i} \approx \frac{u_{i+1} - u_{i-1}}{2 \Delta x}$ のような差分を**中心差分**（central difference）

と呼ぶ．これらは単なる呼び名であって，与えられた方程式を解くにあたってどの差分近似を採用すべきかは全く明らかでない．多くの場合において解くべき方程式の**物理的性質に適した差分近似**を用いなければ実用的な数値計算はできないことがほとんどである．
（そもそも時間微分の近似以外の場合においては前進・後退という名前が全く物理的にナンセンスである．）

---
## 2.5 高階微分の差分近似
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

---

<!--
_class: title
-->

# 3. 双曲型偏微分方程式の解法

---
## 3.1 線形移流方程式

以降ではしばらく以下の線形移流方程式の初期値・境界値問題を考える．ただし$c$は定数である．
$$
\frac{\partial u}{\partial t} + c \frac{\partial u}{\partial x} = 0
$$
初期値$u(x,t=0)$が与えられたときの解析解は以下で与えられ，初期に与えられたプロファイルが一定速度$c$で$x$の正方向に伝播する．
$$
u(x, t) = u(x - ct, 0)
$$

一見この方程式は簡単に解けそうにも思えるが，精度良く数値解を得るのは意外と難しい．またこの問題の数値解法は流体方程式などの非線形問題の解法の基礎となっている．（線形問題が解けないのであれば非線形問題が解けるわけがない！）


---

ここでは安直な差分近似を用いた線形移流方程式の数値解法を考えてみよう．解を時間・空間方向に離散化し，$u^{n}_{i}$ と書こう．ここで時間方向の格子点（時間ステップ）を上付き添字 $^n$ ，空間方向の格子点を下付き添字 $_i$ で現す．

時間方向の差分には過去の情報だけを用いて前進差分，空間方向は前後のバイアスがない中心差分を用いると，解くべき方程式は
$$
\frac{u^{n+1}_{i} - u^{n}_{i}}{\Delta t} + c \frac{u^{n}_{i+1} - u^{n}_{i-1}}{2 \Delta x} = 0
$$
と書ける．これを書き換えて
$$
u^{n+1}_{i} = u^{n}_{i} - \left( \frac{c \Delta t}{2 \Delta x} \right)
\left( u^{n}_{i+1} - u^{n}_{i-1} \right)
$$
を得る．右辺は$u^{n}_{i-1}, u^{n}_{i}, u^{n}_{i+1}$の情報のみで評価でき，これらから次のステップの解$u^{n}_{i}$が求まる．

数値解を求めるためのアルゴリズムは一般に数値計算**スキーム**と呼ばれる．この場合は時間方向に前進差分，空間方向に中心差分を用いているのでFTCSスキーム（Forward in Time and Centered in Space)と呼ばれる．

---
### 例：FTCSスキームによる数値解

---
## 3.2 数値計算スキームの性質

### 適合性

離散化の刻み幅を小さくしていくにつれて離散近似が元の微分方程式に近づくとき，そのスキームは「適合」すると呼ぶ．適合性は自然に満たされることが多い．

### 収束性

離散化の刻み幅を小さくしていくにつれて，数値解が元の微分方程式の解に近づくことを「収束」すると呼ぶ．収束するスキームであれば十分な離散点をとれば（原理的には）誤差をいくらでも小さくすることができる．

### 安定性

時間発展型の方程式の数値計算スキームについて適用される概念．スキームの数値的な誤差が時間的に増大しないとき，そのスキームは「安定」であると呼ぶ．数値的に安定でないスキームは実用的には使えない．詳細は次節で述べる．

---
### 例：FTCSスキーム（移流方程式）

時間・空間の両方向についてTaylor展開すると
$$
\begin{aligned}
\frac{u^{n+1}_{i} - u^{n}_{i}}{\Delta t} + c \frac{u^{n}_{i+1} - u^{n}_{i-1}}{2 \Delta x}
&=
\left( \frac{\partial u}{\partial t} \right)^{n}_{i} +
c \left( \frac{\partial u}{\partial t} \right)^{n}_{i}
\\
&+
\frac{\Delta t}{2} \left( \frac{\partial^2 u}{\partial t^2} \right)^{n}_{i} +
c\frac{\Delta x^2}{12} \left( \frac{\partial^3 u}{\partial x^3} \right)^{n}_{i}
+ \text{(higher orders)}
\end{aligned}
$$
これからFTCSスキームの打ち切り誤差は $\mathcal{O}(\Delta t, \Delta x^2)$ であることが分かる．

$\Delta t$や$\Delta x$を小さくしていくにつれて差分近似は明らかに元の微分方程式に近づくので，このスキームは適合する．一方で，収束性は実際に得られた数値解によって判断すべきものなので，これだけからは分からない．ただし，我々は実験的にこのスキームが不安定であることを知っているので，収束性も満たさないことは明らかである．

#### Q.3-1
Taylor展開によって実際に上記のFTCSスキームの打ち切り誤差評価が正しいことを示せ．

---
### 例：数値解の収束性

![height:400px center](figure/convergence.png)

<!--
_header: Ref: Matsumoto et al. (2019, PASJ)
-->

---
## 3.3 von Neumannの安定性解析
差分法の数値的安定性を調べるために最も一般的に使われている手法がvon Neumannの安定性解析である．これは「等間隔格子($\Delta t$および$\Delta x$が一定)で構成した線形差分近似式による初期値問題の解法」に適用可能な手法である．適用可能範囲が狭いようにも思われるが，実用的にはこれによって十分に有用な結果が得られる．

上記の定義により線形の問題を考えよう．空間方向の任意の関数はFourier級数で現すことができるが，各波数のモードは互いに独立であるから，一つの波数$k$について考えれば十分である．既に空間方向の格子点の添字に$i$を使っているので，以降では$j$を虚数単位として用いることとする．（すなわち $j^2 = -1$．）

$x_{i} = i \Delta x$とすれば，波数$k$のモードの解は以下のように書ける．
$$
u^{n}_{i} = \tilde{u}^n \exp[j (i k \Delta x)] = \tilde{u}^n \exp[j (i \theta)]
\quad (\theta = k \Delta x)
$$
ここで $\tilde{u}^n$ は複素振幅である．これを差分式に代入して解の時間発展の性質を調べてみよう．

なお，以降では
$$
\nu \equiv \frac{c \Delta t}{\Delta x}
$$
と置き，これをCourant数と呼ぶ．すぐに明らかになるように，Courant数は特に双曲型偏微分方程式の数値解の性質を決定する非常に重要な量である．

---
### 例：FTCSスキーム（移流方程式）

FTCSスキームの差分式に$u^{n}_{i}$を代入して整理すると
$$
g = 1 - \frac{1}{2} \nu
\left( e^{j\theta} - e^{-j\theta} \right) = 1 - j \nu \sin \theta
$$
を得る．ここで$g = \tilde{u}^{n+1}/\tilde{u}^{n}$は複素増幅率などと呼ばれる．

もう少し分かり易くするために，$g = |g| e^{j\phi}$と書いておこう．ここで$|g|$は$u^{n}_{i}$から$u^{n+1}_{i}$へ数値解を時間発展させた際の振幅の絶対値の増幅率，$\phi$は位相差を現す．具体的に評価すると
$$
|g|^2 = 1 + \nu^2 \sin \theta, \quad \tan \phi =- \nu \sin\theta
$$
である．一方で厳密解については以下で与えられることが簡単に示せる．
$$
|g|^2 = 1, \quad \phi = -\nu \theta
$$

つまり，厳密解は振幅が増大も減衰もせず一定なのにも関わらず，FTCSスキームによって得られる数値解の振幅は$\nu$や$\theta$の値に関わらず(すなわち$\Delta t$や$\Delta x$によらず)常に指数関数的に増大する．
これはFTCSスキームが数値的に**無条件不安定**であることを意味する．

#### Q.3-2
線形移流方程式の厳密解では$|g|^2 = 1$および$\phi = - \nu\theta$となることを示せ．

---
### 例：FTCSスキーム（拡散方程式）

放物型の偏微分方程式である拡散方程式
$$
\frac{\partial u}{\partial t} = D \frac{\partial^2 u}{\partial x^2}
$$
にも時間方向には前進差分，空間方向には中心差分をとったFTCSスキーム
$$
\frac{u^{n+1}_{i} - u^{n}_{i}}{\Delta t} =
D \frac{u^{n}_{i-1} - 2 u^{n}_{i} + u^{n}_{i-1}}{\Delta x^2}
$$
を考えてvon Neumannの安定性解析を適用すると
$$
g = 1 - 2 \mu (1 - \cos \theta)
$$
を得る．ただし $\mu = D \Delta t /\Delta x^2$ である．従って安定性の条件は$\mu \leq 1/2$で与えられる．すなわち，$\Delta x$を細かくするには$\Delta t \propto \Delta x^2$となるように$\Delta t$も小さくとらなければならないことが分かる．

#### Q.3-3
実際に上記の複素増幅率$g = 1 - 2 \mu (1 - \cos \theta)$で与えられることを示せ．


---
### 例：FTFSスキームおよびFTBSスキーム（移流方程式）

移流方程式において，FTFS（空間方向に前進差分; Forward in Space）やFTBS（空間方向に後退差分; Backward in Space）を採用した場合はどうなるだろうか．
$$
\text{FTFS:} \,
u^{n+1}_{i} = u^{n}_{i} - \nu \left( u^{n}_{i+1} - u^{n}_{i} \right)
\quad
\text{FTBS:} \,
u^{n+1}_{i} = u^{n}_{i} - \nu \left( u^{n}_{i} - u^{n}_{i-1} \right)
$$
と書けるので，
$$
\text{FTFS:} \,
g = 1 + \nu \left[ (1 - \cos \theta) + j \sin \theta \right]
\quad
\text{FTBS:} \,
g = 1 - \nu \left[ (1 - \cos \theta) + j \sin \theta \right]
$$
となる．すなわち$c \rightarrow -c$（$\nu \rightarrow -\nu$）として流れの符号を反転させれば同じ結果が得られるので，どちらか一方だけを考えればよい．

ここではFTFSを考えると，安定性$|g| \leq 1$を満たすためには
$$
-1 \leq \nu \leq 0
$$
が必要なことが直ちに分かる．（同様にFTBSでは$0 \leq \nu \leq 1$が安定性の条件である．）

#### Q.3-4
FTFSの安定性条件が$-1 \leq \nu \leq 0$で与えられることを示せ．
（この結果よりFTBSの安定性条件も直ちに明らかである．）

---
## 3.4 風上差分法

移流方程式におけるFTFSおよびFTBSの安定性条件についてもう少し考えてみよう．例えばFTBSスキーム
$$
u^{n+1}_{i} = u^{n}_{i} - \nu \left( u^{n}_{i} - u^{n}_{i-1} \right)
$$
の安定性条件$0 \leq \nu \leq 1$の下限および上限は以下のように解釈することができる．

- $0 \leq \nu$ であれば$u_{i}$を更新する際に用いる点$x_{i}, x_{i-1}$が物理的な情報伝播の「風上」に対応する．
- $\nu \leq 1$ であれば$u_{i}$に情報を運ぶ「風上」の点が$x_{i}, x_{i-1}$の間に位置する．

一般に（特別に設計されたスキームを除き），系の最大情報伝播速度$c_{\rm max}$に対応したCourant数に対して
$$
\frac{c_{\rm max} \Delta t}{\Delta x} \leq 1
$$
が数値的安定性の必要条件（十分条件とは限らない！）となることが多い．
これを**CFL(Courant-Friedrichs-Lewy)条件**と呼ぶ．

- 非線形や多次元問題についての厳密な安定性解析が難しいが，経験上はこれよりも少し厳しい条件が安定性として課されることが多いようである．従って，これよりも小さなCourant数を採用することが常である．
- 上記の風上差分スキームは空間精度が1次精度であり実用的ではない．しかし，現代の高精度数値流体計算スキームの多くはこのような風上差分の考え方を基に設計されており，この考え方は極めて重要である．


---

![height:400px center](figure/first-order-upwind.png)


<!--
_header: Ref: Toro (Riemann Solvers and Numerical Methods for Fluid Dynamcis)
-->

---
## 3.5 Lax-Friedrichsスキーム

移流方程式においては空間1次精度の風上差分は安定であり，FTCSスキームは空間2次精度であるにも関わらず不安定となる．実用的には2次精度以上のスキームが欲しくなるので，空間精度を向上させるためにもFTCSスキームについてもう少し考察してみよう．
打切り誤差の評価において時間微分を$\partial u/\partial t = - c \partial u/\partial x$を使って書き換えると
$$
\begin{aligned}
\frac{u^{n+1}_{i} - u^{n}_{i}}{\Delta t} + c \frac{u^{n}_{i+1} - u^{n}_{i-1}}{2 \Delta x}
&=
\left( \frac{\partial u}{\partial t} \right)^{n}_{i} +
c \left( \frac{\partial u}{\partial t} \right)^{n}_{i} +
c^2 \frac{\Delta t}{2} \left( \frac{\partial^2 u}{\partial x^2} \right)^{n}_{i}
+ \text{(higher orders)}
\end{aligned}
$$
となる．ここで誤差の最低次の$\mathcal{O}(\Delta t)$の項が実質的な逆拡散として作用するため，FTCSスキームが無条件不安定になると解釈できる．逆に考えれば，FTCSスキームに逆拡散を打ち消すような拡散効果を加えればスキームは安定化すると予想される．

ここでは$u^{n}_{i} \rightarrow (u^{n}_{i+1} + u^{n}_{i-1})/2$のような平均化操作を加えて，以下のように修正したスキームを考えよう．
$$
\begin{aligned}
\frac{u^{n+1}_{i} - (u^{n}_{i+1} + u^{n}_{i-1})/2}{\Delta t} +
c \frac{u^{n}_{i+1} - u^{n}_{i-1}}{2 \Delta x}
= 0
\end{aligned}
$$
これをLax-Friedrichsスキームと呼ぶ．

---

#### Q.3-5
Lax-Friedrichsスキームについてvon Neumannの安定性解析を行い，複素増幅率が
$$
g = \cos \theta - j \nu \sin \theta
$$
となることを示せ．これから直ちに$|\nu| \leq 1$のときにはこのスキームが安定となることが分かる．

#### Q.3-6
Lax-Friedrichsスキームについても同様にTaylor展開によって誤差評価を行うと
$$
\begin{aligned}
\frac{u^{n+1}_{i} - (u^{n}_{i+1} + u^{n}_{i-1})/2}{\Delta t} +
c \frac{u^{n}_{i+1} - u^{n}_{i-1}}{2 \Delta x}
&=
\left( \frac{\partial u}{\partial t} \right)^{n}_{i} +
c \left( \frac{\partial u}{\partial t} \right)^{n}_{i} -
\frac{\Delta x^2}{2 \Delta t} \left( 1- \nu^2 \right)
\left( \frac{\partial^2 u}{\partial x^2} \right)^{n}_{i} +
\text{(higher orders)}
\end{aligned}
$$
となることを示せ．これより$|\nu| \leq 1$のときには最低次の項が通常の拡散項として作用し，スキームは安定となる．


---

<!--
_class: title
-->

# 3. 双曲型偏微分方程式の解法

---

