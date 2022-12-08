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

add_emcc_executable(fannkuch-redux.wasm
  ../src/fannkuch-redux.c
)

add_emcc_executable(nbody.wasm
  ../src/nbody.c
)

add_emcc_executable(mandelbrot.wasm
  ../src/mandelbrot.c
)

add_emcc_executable(mandelbrot-simd.wasm
  ../src/mandelbrot-simd.c
)

add_emcc_executable(binary-trees.wasm
  ../src/binary-trees.c
)

add_emcc_executable(fasta.wasm
  ../src/fasta.c
)
