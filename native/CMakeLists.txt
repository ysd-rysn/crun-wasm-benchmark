add_executable(fannkuch-redux-c
  ../src/fannkuch-redux.c
)

add_executable(nbody-c
  ../src/nbody.c
)
target_link_libraries(nbody-c PUBLIC m)

add_executable(mandelbrot-c
  ../src/mandelbrot.c
)

add_executable(mandelbrot-simd-c
  ../src/mandelbrot-simd.c
)

add_executable(binary-trees-c
  ../src/binary-trees.c
)

add_executable(fasta-c
  ../src/fasta.c
)
