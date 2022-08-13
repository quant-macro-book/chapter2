module mod_generate_grid
!
!  Purpose:
!   Generate meshed grids (evaluation points).
!   The grids are spaced uniformly or exponentially.
!   (1) grid_uniform
!   (2) grid_exp
!   (3) grid_double_exp
!   (4) grid_triple_exp
!
!  Record of revisions:
!     Date     Programmer  Description of change
!  ==========  ==========  ======================
!  10/21/2010  T. Yamada   Collect subroutines

    implicit none

    contains

    subroutine grid_uniform( mink, maxk, num_grid, grid )
    !
    !  Purpose:
    !    Generate a uniform grid between [maxk, mink].
    !    The number of grids is `num_grid'.
    !
    !  Record of revisions:
    !     Date     Programmer  Description of change
    !  ==========  ==========  =====================
    !  07/19/2003  T. Yamada   Original code
    !
        use mod_types, only:dp
        !****** input ******
        real(dp), intent(in) :: maxk
        real(dp), intent(in) :: mink
        integer,  intent(in) :: num_grid
        !****** output ******
        real(dp), intent(out), dimension(num_grid) :: grid
        !****** local variables ******
        integer :: i
        real(dp) :: increment
        !-----------------------------
        increment = (maxk-mink)/real(num_grid-1)
        do i = 1,num_grid
            grid(i) = (i-1)*increment+mink
        end do
        ! avoid rounding error
        if ( grid(num_grid) /= maxk ) then
            grid(num_grid) = maxk
        end if
    end subroutine grid_uniform


    subroutine grid_exp( mink, maxk, num_grid, grid )
    !
    !  Purpose:
    !    Generatea an exponentially-spaced grid.
    !
    !  Record of revisions:
    !     Date     Programmer  Description of change
    !  ==========  ==========  =====================
    !  10/21/2010  T. Yamada   Original code
    !
        use mod_types, only:dp
        !****** input ******
        real(dp), intent(in) :: maxk
        real(dp), intent(in) :: mink
        integer,  intent(in) :: num_grid
        !****** output ******
        real(dp), intent(out), dimension(num_grid) :: grid
        !****** local variables ******
        real(dp) :: maxd
        real(dp), dimension(num_grid) :: mesh
        !-----------------------------
        maxd = log(maxk+1.0)
        call grid_uniform( mink, maxd, num_grid, mesh )
        grid = exp(mesh)-1.0
    end subroutine grid_exp


    subroutine grid_double_exp( mink, maxk, num_grid, grid )
    !
    !  Purpose:
    !    Generatea a double-exponentially-spaced grid.
    !
    !  Record of revisions:
    !     Date     Programmer  Description of change
    !  ==========  ==========  =====================
    !  10/21/2010  T. Yamada   Original code
    !
        use mod_types, only:dp
        !****** input ******
        real(dp), intent(in) :: maxk
        real(dp), intent(in) :: mink
        integer,  intent(in) :: num_grid
        !****** output ******
        real(dp), intent(out), dimension(num_grid) :: grid
        !****** local variables ******
        real(dp) :: maxd
        real(dp), dimension(num_grid) :: mesh
        !-----------------------------
        maxd = log(log(maxk+1.0)+1.0)
        call grid_uniform( mink, maxd, num_grid, mesh )
        grid = exp(exp(mesh)-1.0)-1.0
    end subroutine grid_double_exp


    subroutine grid_triple_exp( mink, maxk, num_grid, grid )
    !
    !  Purpose:
    !    Generatea a triple-exponentially-spaced grid.
    !
    !  Record of revisions:
    !     Date     Programmer  Description of change
    !  ==========  ==========  =====================
    !  10/21/2010  T. Yamada   Original code
    !
        use mod_types, only:dp
        !****** input ******
        real(dp), intent(in) :: maxk
        real(dp), intent(in) :: mink
        integer,  intent(in) :: num_grid
        !****** output ******
        real(dp), intent(out), dimension(num_grid) :: grid
        !****** local variables ******
        real(dp) :: maxd
        real(dp), dimension(num_grid) :: mesh
        !-----------------------------
        maxd = log(log(log(maxk+1.0)+1.0)+1.0)
        call grid_uniform( mink, maxd, num_grid, mesh )
        grid = exp(exp(exp(mesh)-1.0)-1.0)-1.0
    end subroutine grid_triple_exp

end module mod_generate_grid
