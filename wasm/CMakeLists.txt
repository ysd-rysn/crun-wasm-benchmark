function(add_emcc_executable name)
  foreach(l ${ARGN})
    get_filename_component(fp ${l} REALPATH)
    list(APPEND listed ${fp})
  endforeach()

  add_custom_target(emcc-${name} ALL
	emcc -Oz -s INITIAL_MEMORY=4000MB
    ${listed} -o ${name}
    BYPRODUCTS ${name}
    DEPENDS ${listed}
  )
endfunction()

add_emcc_executable(fannkuch-redux-c.wasm
  ../src/fannkuch-redux.c
)

add_emcc_executable(nbody-c.wasm
  ../src/nbody.c
)

add_emcc_executable(mandelbrot-c.wasm
  ../src/mandelbrot.c
)

add_emcc_executable(mandelbrot-simd-c.wasm
  ../src/mandelbrot-simd.c
)

add_emcc_executable(binary-trees-c.wasm
  ../src/binary-trees.c
)

add_emcc_executable(fasta-c.wasm
  ../src/fasta.c
)
