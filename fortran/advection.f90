program advection
  implicit none

  real(8), parameter :: m_pi = 4*atan(1.0d0)
  integer, parameter :: nx = 100
  real(8), parameter :: nu = 0.5d0

  integer :: i, step, scheme, init_type
  real(8) :: x(nx), u(nx)
  character(len=128) :: datfile

  ! <<< スキーム >>>
  ! 0 : 1次精度風上差分法
  ! 1 : Lax-Friedrichs法
  ! 2 : Lax-Wendroff法から選択
  scheme = 0

  ! <<< 初期条件 >>>
  ! 0 : 矩形波
  ! 1 : sin波
  init_type = 0

  ! 初期化
  call setup(x, u, init_type)

  i = 0
  step = 20

  ! データ出力
  write(datfile, fmt='("advection",i3.3,".dat")') i*step
  call savefile(x, u, trim(datfile))

  ! gnuplot用
  write(*,fmt='(a)') '#!/usr/bin/gnuplot'
  write(*,fmt='("plot """, a, """ w lp")') trim(datfile)

  do i = 1, 4
     if ( scheme == 0 ) then
        call push_upwind(u, nu, step)
     else if ( scheme == 1 ) then
        call push_lf(u, nu, step)
     else if ( scheme == 2 ) then
        call push_lw(u, nu, step)
     end if

     ! データ出力
     write(datfile, fmt='("advection",i3.3,".dat")') i*step
     call savefile(x, u, trim(datfile))

     ! gnuplot用
     write(*,fmt='("replot """, a, """ w lp")') trim(datfile)
  end do

contains
  !
  ! 初期化
  !
  subroutine setup(x, u, init_type)
    implicit none
    real(8), intent(inout) :: x(:)
    real(8), intent(inout) :: u(:)
    integer, intent(in)    :: init_type

    integer :: ix, nx
    real(8) :: dx

    nx = size(x)
    dx = 1/real(nx, kind=8)

    do ix = 1, nx
       x(ix) = dx * ix - dx / 2
    end do

    if( init_type == 0 ) then
       ! 矩形波
       do ix = 1, nx
          if( x(ix) < 0.5d0 ) then
             u(ix) = 1
          else
             u(ix) = 0
          end if
       end do
    else if( init_type == 1 ) then
       ! sin波
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
  subroutine push_upwind(u, nu, step)
    implicit none
    real(8), intent(inout) :: u(:)
    real(8), intent(in)    :: nu
    integer, intent(in)    :: step

    integer :: n, ix, lbx, ubx
    real(8) :: v(size(u))

    lbx = 2
    ubx = size(u) - 1

    do n = 1, step
       ! 一時変数
       v = u
       ! 更新
       if( nu > 0 ) then
          do ix = lbx, ubx
             u(ix) = v(ix) - nu * (v(ix) - v(ix-1))
          end do
       else
          do ix = lbx, ubx
             u(ix) = v(ix) + nu * (v(ix) - v(ix+1))
          end do
       end if
       ! 境界条件
       u(lbx-1) = u(ubx)
       u(ubx+1) = u(lbx)
    end do

  end subroutine push_upwind

  !
  ! Lax-Friedrichs法
  !
  subroutine push_lf(u, nu, step)
    implicit none
    real(8), intent(inout) :: u(:)
    real(8), intent(in)    :: nu
    integer, intent(in)    :: step

    integer :: n, ix, lbx, ubx
    real(8) :: v(size(u))

    lbx = 2
    ubx = size(u) - 1

    do n = 1, step
       ! 一時変数
       v = u
       ! 更新
       do ix = lbx, ubx
          u(ix) = &
               & + 0.5d0    * (v(ix+1) + v(ix-1)) &
               & - 0.5d0*nu * (v(ix+1) - v(ix-1))
       end do
       ! 境界条件
       u(lbx-1) = u(ubx)
       u(ubx+1) = u(lbx)
    end do

  end subroutine push_lf

  !
  ! Lax-Wendroff法
  !
  subroutine push_lw(u, nu, step)
    implicit none
    real(8), intent(inout) :: u(:)
    real(8), intent(in)    :: nu
    integer, intent(in)    :: step

    integer :: n, ix, lbx, ubx
    real(8) :: v(size(u))

    lbx = 2
    ubx = size(u) - 1

    do n = 1, step
       ! 一時変数
       v = u
       ! 更新
       do ix = lbx, ubx
          u(ix) = v(ix) &
               & - 0.5d0*nu    * (v(ix+1) - v(ix-1)) &
               & + 0.5d0*nu**2 * (v(ix+1) - 2*v(ix) + v(ix-1))
       end do
       ! 境界条件
       u(lbx-1) = u(ubx)
       u(ubx+1) = u(lbx)
    end do

  end subroutine push_lw

end program advection
