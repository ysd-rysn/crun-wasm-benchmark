add_executable(fannkuch-redux
  ../src/fannkuch-redux.c
)

add_executable(nbody
  ../src/nbody.c
)
target_link_libraries(nbody PUBLIC m)

add_executable(mandelbrot
  ../src/mandelbrot.c
)

add_executable(mandelbrot-simd
  ../src/mandelbrot-simd.c
)

add_executable(binary-trees
  ../src/binary-trees.c
)

add_executable(fasta
  ../src/fasta.c
)
