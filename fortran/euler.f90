program euler
  implicit none

  real(8), parameter :: m_pi = 4*atan(1.0d0)
  integer, parameter :: nx = 200
  real(8), parameter :: nu = 0.25d0
  real(8), parameter :: gamma = 1.4d0
  real(8), parameter :: epsilon = 0.5d0

  integer :: step
  real(8) :: dt, dx, tt
  real(8) :: x(nx), u(3,nx), flux(3,nx)
  character(len=128) :: datfile

  ! 初期化
  call setup(x, u, dx)

  tt = 0.40d0
  dt = nu*dx
  step = int(tt / dt)

  ! データ出力
  write(datfile, fmt='("euler",i3.3,".dat")') 0
  call savefile(x, u, trim(datfile))

  ! 2段階Lax-Wendroff法で数値解を求める
  call push_lw2(u, flux, dt, dx, epsilon, step)

  ! データ出力
  write(datfile, fmt='("euler",i3.3,".dat")') step
  call savefile(x, u, trim(datfile))

  ! gnuplot用
  write(*,fmt='(a)') '#!/usr/bin/gnuplot'
  write(*,fmt='("set title ""t = ", f5.2, """")') tt
  write(*,fmt='("set xrange[-1.0:+1.0]")')
  write(*,fmt='("set yrange[0:1.2]")')
  write(*,fmt='("plot   """, a, """ u 1:2 w l")') trim(datfile)
  write(*,fmt='("replot """, a, """ u 1:3 w l")') trim(datfile)
  write(*,fmt='("replot """, a, """ u 1:4 w l")') trim(datfile)

contains
  !
  ! 初期化: Riemann問題
  !
  subroutine setup(x, u, dx)
    implicit none
    real(8), intent(inout) :: x(:)
    real(8), intent(inout) :: u(:,:)
    real(8), intent(out)   :: dx

    integer :: ix, nx
    real(8) :: ro, vx, pr

    nx = size(u, 2)

    ! -1 < x < 1
    dx = 2/real(nx, kind=8)

    do ix = 1, nx
       x(ix) = dx * ix - dx / 2 - 1
    end do

    do ix = 1, nx
       if( x(ix) < 0.0d0 ) then
          ro = 1.0d0
          vx = 0.0d0
          pr = 1.0d0
       else
          ro = 0.125d0
          vx = 0.0d0
          pr = 0.1d0
       end if
       ! 保存変数に変換
       u(1,ix) = ro
       u(2,ix) = ro*vx
       u(3,ix) = 0.5d0*ro*vx**2 + pr/(gamma-1)
    end do

  end subroutine setup

  !
  ! データをファイルに保存
  !
  subroutine savefile(x, u, filename)
    implicit none
    real(8), intent(in) :: x(:)
    real(8), intent(in) :: u(:,:)
    character(len=*), intent(in) :: filename

    integer :: ix, lbx, ubx
    real(8) :: xx, ro, vx, pr

    lbx = 2
    ubx = size(u, 2) - 1

    open(unit=10, file=filename, action='write', &
     & form='formatted', status='replace')

    do ix = lbx, ubx
       xx = x(ix)
       ro = u(1,ix)
       vx = u(2,ix) / (ro + 1.0d-20)
       pr = (gamma - 1)*(u(3,ix) - 0.5*ro*vx**2)
       write(10, fmt='(f12.5, x, f12.5, x, f12.5, x, f12.5)') xx, ro, vx, pr
    end do

    close(10)

  end subroutine savefile

  !
  ! Euler方程式の流束
  !
  subroutine euler_flux(u, f)
    implicit none
    real(8), intent(in)  :: u(3)
    real(8), intent(out) :: f(3)

    real(8) :: ro, vx, pr

    ro = u(1)
    vx = u(2) / (ro + 1.0d-20)
    pr = (gamma - 1)*(u(3) - 0.5*ro*vx**2)

    f(1) = ro*vx
    f(2) = ro*vx**2 + pr
    f(3) = (0.5d0*ro*vx**2 + gamma/(gamma-1) * pr)*vx

  end subroutine euler_flux

  !
  ! 2段階Lax-Wendroff法
  !
  subroutine push_lw2(u, flux, dt, dx, epsilon, step)
    implicit none
    real(8), intent(inout) :: u(:,:)
    real(8), intent(inout) :: flux(:,:)
    real(8), intent(in)    :: dt
    real(8), intent(in)    :: dx
    real(8), intent(in)    :: epsilon
    integer, intent(in)    :: step

    integer :: n, ix, lbx, ubx
    real(8) :: uh(3), fx(3), fr(3), fl(3), dtx, kappa

    lbx = 2
    ubx = size(u,2) - 1
    dtx = dt/dx

    do n = 1, step
       ! 数値流束
       do ix = lbx-1, ubx
          ! 人工粘性係数
          kappa = epsilon * abs(u(2,ix+1)/u(1,ix+1) - u(2,ix)/u(1,ix)) / dtx

          ! 流束の計算
          call euler_flux(u(1:3,ix  ), fl)
          call euler_flux(u(1:3,ix+1), fr)
          uh(1:3) = 0.5d0*(u(1:3,ix+1) + u(1:3,ix)) - 0.5d0*dtx*(fr - fl)
          call euler_flux(uh, fx)
          flux(1:3,ix) = fx(1:3) - kappa*(u(1:3,ix+1) - u(1:3,ix))
       end do
       ! 更新
       do ix = lbx, ubx
          u(1:3,ix) = u(1:3,ix) - dtx * (flux(1:3,ix) - flux(1:3,ix-1))
       end do
       ! 境界条件
       u(1:3,lbx-1) = u(1:3,lbx)
       u(1:3,ubx+1) = u(1:3,ubx)
    end do

  end subroutine push_lw2

end program euler
