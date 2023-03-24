# 地球物理数値解析 サンプルコード

## 線形移流方程式
- ソースコード： ``advection.f90``
- コンパイルおよび実行方法
	```
	$ gfortran advection.f90 && ./a.out | gnuplot -p
	```
- 初期条件：矩形波，sin波
- スキーム：1次精度風上差分法，Lax-Friedrichs法，Lax-Wendroff法

## Burgers方程式
- ソースコード： ``burgers.f90``
- コンパイルおよび実行方法
	```
	$ gfortran burgers.f90 && ./a.out | gnuplot -p
	```
- 初期条件：矩形波，sin波
- スキーム：1次精度風上差分法，local Lax-Friedrichs法，2段階Lax-Wendroff法

## Euler方程式
- ソースコード： ``euler.f90``
- コンパイルおよび実行方法
	```
	$ gfortran euler.f90 && ./a.out | gnuplot -p
	```
- 初期条件：Sodの衝撃波管問題
- スキーム：2段階Lax-Wendroff法
