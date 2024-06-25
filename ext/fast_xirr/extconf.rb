require 'mkmf'

$srcs = ['xirr.c', 'brent.c', 'bisection.c', 'common.c']

create_makefile('fast_xirr/fast_xirr')

