program main_discretization
! メインファイル:
! 状態変数と操作変数を離散化して2期間モデルを解く.

    use mod_types
    use mod_my_econ_fcn
    use mod_generate_grid

    implicit none

    ! *** カリブレーション ***
    real(dp), parameter :: beta  = 0.985**30     ! 割引因子
    real(dp), parameter :: gamma = 2.0           ! 相対的危険回避度
    real(dp), parameter :: rent  = 1.025**30-1.0 ! 純利子率

    ! *** パラメータ ***
    integer, parameter :: nw = 10 ! 所得グリッドの数
    integer, parameter :: na = 40 ! 貯蓄グリッドの数
    real(dp), parameter :: w_max = 1.0   ! 所得グリッドの最大値
    real(dp), parameter :: w_min = 0.1   ! 所得グリッドの最小値
    real(dp), parameter :: a_max = 1.0   ! 貯蓄グリッドの最大値
    real(dp), parameter :: a_min = 0.025 ! 貯蓄グリッドの最小値

    ! *** ローカル変数 ***
    integer :: i, j, maxl
    real(dp) :: cons, time_begin, time_end
    real(dp), dimension(na) :: grid_a
    real(dp), dimension(nw) :: grid_w
    real(dp), dimension(nw) :: pol
    real(dp), dimension(na, nw) :: obj
    !---------------------------------

    ! 計算時間をカウント開始
    call cpu_time( time_begin )

    write(*,*) ""
    write(*,*) " -+-+-+- Solve two period model using discretization -+-+-+-"

    ! グリッドポイントを計算
    call grid_uniform(w_min, w_max, nw, grid_w)
    call grid_uniform(a_min, a_max, na, grid_a)

    ! あらゆる(w,a)の組み合わせについて生涯効用を計算

    ! 初期化
    obj = 0.0

    do i = 1,nw
        do j = 1,na
            cons = grid_w(i) - grid_a(j)
            if (cons > 0.0) then
                obj(j, i) = CRRA(cons, gamma) + beta*CRRA((1.0+rent)*grid_a(j), gamma)
            else
                ! 消費が負値の場合、ペナルティを与えてその値が選ばれないようにする
                obj(j, i) = -10000.0;
            end if
        end do
    end do

    ! 効用を最大にする操作変数を探し出す：政策関数

    ! 初期化
    pol = 0.0

    ! 各wについて生涯効用を最大にするaを探す
    do i = 1,nw
        maxl = maxloc(obj(:,i), dim=1)
        pol(i) = grid_a(maxl)
    end do

    ! 計算時間をカウント終了
    call cpu_time( time_end )
    write (*,"(' Program finished sucessfully in', f12.9, ' seconds')") time_end - time_begin

    ! 計算結果をテキストファイルで出力
    open (10, file='policy_function.txt')
        do i = 1,nw
            write (10,*) pol(i)
        end do
    close (10)

end program main_discretization
