module mod_types
    integer,  parameter :: dp = selected_real_kind(p = 15, r = 307)
    integer,  parameter :: i4 = selected_int_kind(9)
    real(dp), parameter :: pi = 3.141592653589793238462643383279502884197_dp
end module mod_types