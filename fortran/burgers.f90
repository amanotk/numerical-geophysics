program burgers
  implicit none

  real(8), parameter :: m_pi = 4*atan(1.0d0)
  integer, parameter :: nx = 200
  real(8), parameter :: nu = 0.2d0
  real(8), parameter :: alpha = 1.0d-3
  real(8), parameter :: epsilon = 0.1d0

  integer :: i, step, scheme, init_type
  real(8) :: dt, dx
  real(8) :: x(nx), u(nx)
  character(len=128) :: datfile

  ! <<< スキーム >>>
  ! 0 : 1次精度風上差分法
  ! 1 : Local Lax-Friedrichs法
  ! 2 : Lax-Wendroff法から選択
  scheme = 0

  ! <<< 初期条件 >>>
  ! 0 : 矩形波
  ! 1 : sin波
  init_type = 0

  ! 初期化
  call setup(x, u, dx, init_type)

  i = 0
  step = 100
  dt = nu*dx

  ! データ出力
  write(datfile, fmt='("burgers",i3.3,".dat")') i*step
  call savefile(x, u, trim(datfile))

  ! gnuplot用
  write(*,fmt='(a)') '#!/usr/bin/gnuplot'
  write(*,fmt='("plot """, a, """ w lp")') trim(datfile)

  do i = 1, 4
     if ( scheme == 0 ) then
        call push_upwind(u, dt, dx, alpha, step)
     else if ( scheme == 1 ) then
        call push_llf(u, dt, dx, alpha, step)
     else if ( scheme == 2 ) then
        call push_lw2(u, dt, dx, alpha, epsilon, step)
     end if

     ! データ出力
     write(datfile, fmt='("burgers",i3.3,".dat")') i*step
     call savefile(x, u, trim(datfile))

     ! gnuplot用
     write(*,fmt='("replot """, a, """ w lp")') trim(datfile)
  end do

contains
  !
  ! 初期化
  !
  subroutine setup(x, u, dx, init_type)
    implicit none
    real(8), intent(inout) :: x(:)
    real(8), intent(inout) :: u(:)
    real(8), intent(out)   :: dx
    integer, intent(in)    :: init_type

    integer :: ix, nx

    nx = size(x)

    if( init_type == 0 ) then
       ! 矩形波; -1 < x < 1
       dx = 2/real(nx, kind=8)

       do ix = 1, nx
          x(ix) = dx * ix - dx / 2 - 1
       end do

       do ix = 1, nx
          if( x(ix) < -1.0d0/3 .or. x(ix) > +1.0d0/3 ) then
             u(ix) = 0
          else
             u(ix) = 1
          end if
       end do
    else if( init_type == 1 ) then
       ! sin波
       dx = 1/real(nx, kind=8)

       do ix = 1, nx
          x(ix) = dx * ix - dx / 2
       end do

       do ix = 1, nx
          u(ix) = sin(2*m_pi*x(ix))
       end do
    end if

  end subroutine setup

  !
  ! データをファイルに保存
  !
  subroutine savefile(x, u, filename)
    implicit none
    real(8), intent(in) :: x(:)
    real(8), intent(in) :: u(:)
    character(len=*), intent(in) :: filename

    integer :: ix, lbx, ubx

    lbx = 2
    ubx = size(u) - 1

    open(unit=10, file=filename, action='write', &
     & form='formatted', status='replace')

    do ix = lbx, ubx
       write(10, fmt='(f12.5, x, f12.5)') x(ix), u(ix)
    end do

    close(10)

  end subroutine savefile

  !
  ! 一次精度風上差分法
  !
  subroutine push_upwind(u, dt, dx, alpha, step)
    implicit none
    real(8), intent(inout) :: u(:)
    real(8), intent(in)    :: dt
    real(8), intent(in)    :: dx
    real(8), intent(in)    :: alpha
    integer, intent(in)    :: step

    integer :: n, ix, lbx, ubx
    real(8) :: flux(size(u))

    lbx = 2
    ubx = size(u) - 1

    do n = 1, step
       ! 数値流束
       do ix = lbx-1, ubx
          flux(ix) = 0.25d0*(u(ix+1)**2 + u(ix)**2) &
               & - 0.25d0*abs(u(ix+1) + u(ix))*(u(ix+1) - u(ix)) &
               & - alpha/dx*(u(ix+1) - u(ix))
       end do
       ! 更新
       do ix = lbx, ubx
          u(ix) = u(ix) - dt/dx * (flux(ix) - flux(ix-1))
       end do
       ! 境界条件
       u(lbx-1) = u(ubx)
       u(ubx+1) = u(lbx)
    end do

  end subroutine push_upwind

  !
  ! Local Lax-Friedrichs法
  !
  subroutine push_llf(u, dt, dx, alpha, step)
    implicit none
    real(8), intent(inout) :: u(:)
    real(8), intent(in)    :: dt
    real(8), intent(in)    :: dx
    real(8), intent(in)    :: alpha
    integer, intent(in)    :: step

    integer :: n, ix, lbx, ubx
    real(8) :: cmax, flux(size(u))

    lbx = 2
    ubx = size(u) - 1

    do n = 1, step
       ! 数値流束
       do ix = lbx-1, ubx
          cmax = max(abs(u(ix)), abs(u(ix+1)))
          flux(ix) = 0.25d0*(u(ix+1)**2 + u(ix)**2) &
               & - 0.50d0*cmax*(u(ix+1) - u(ix)) &
               & - alpha/dx*(u(ix+1) - u(ix))
       end do
       ! 更新
       do ix = lbx, ubx
          u(ix) = u(ix) - dt/dx * (flux(ix) - flux(ix-1))
       end do
       ! 境界条件
       u(lbx-1) = u(ubx)
       u(ubx+1) = u(lbx)
    end do

  end subroutine push_llf

  !
  ! 2段階Lax-Wendroff法
  !
  subroutine push_lw2(u, dt, dx, alpha, epsilon, step)
    implicit none
    real(8), intent(inout) :: u(:)
    real(8), intent(in)    :: dt
    real(8), intent(in)    :: dx
    real(8), intent(in)    :: alpha
    real(8), intent(in)    :: epsilon
    integer, intent(in)    :: step

    integer :: n, ix, lbx, ubx
    real(8) :: uh, kappa, flux(size(u))

    lbx = 2
    ubx = size(u) - 1

    do n = 1, step
       ! 数値流束
       do ix = lbx-1, ubx
          kappa = epsilon * abs(u(ix+1) - u(ix))
          uh = 0.50d0*(u(ix+1) + u(ix)) - 0.25d0*dt/dx*(u(ix+1)**2 - u(ix)**2)
          flux(ix) = 0.50d0*uh**2 - (alpha/dx + kappa*dx/dt)*(u(ix+1) - u(ix))
       end do
       ! 更新
       do ix = lbx, ubx
          u(ix) = u(ix) - dt/dx * (flux(ix) - flux(ix-1))
       end do
       ! 境界条件
       u(lbx-1) = u(ubx)
       u(ubx+1) = u(lbx)
    end do

  end subroutine push_lw2

end program burgers
