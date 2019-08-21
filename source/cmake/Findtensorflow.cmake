# Input:
# TENSORFLOW_ROOT 
#
# Output:
# TensorFlow_FOUND        
# TensorFlow_INCLUDE_DIRS 
# TensorFlow_LIBRARY    
# TensorFlow_LIBRARY_PATH
# TensorFlowFramework_LIBRARY    
# TensorFlowFramework_LIBRARY_PATH

# define the search path
list(APPEND TensorFlow_search_PATHS ${TENSORFLOW_ROOT})
list(APPEND TensorFlow_search_PATHS "/usr/")
list(APPEND TensorFlow_search_PATHS "/usr/local/")

# includes
find_path(TensorFlow_INCLUDE_DIRS
  NAMES 
  tensorflow/core/public/session.h
  tensorflow/core/platform/env.h
  tensorflow/core/framework/op.h
  tensorflow/core/framework/op_kernel.h
  tensorflow/core/framework/shape_inference.h
  PATHS ${TensorFlow_search_PATHS} 
  PATH_SUFFIXES "/include"
  NO_DEFAULT_PATH
  )
if (NOT TensorFlow_INCLUDE_DIRS AND tensorflow_FIND_REQUIRED)
  message(FATAL_ERROR 
    "Not found 'include/tensorflow/core/public/session.h' directory in path '${TensorFlow_search_PATHS}' "
    "You can manually set the tensorflow install path by -DTENSORFLOW_ROOT ")
endif ()

list(APPEND CMAKE_FIND_LIBRARY_SUFFIXES .so.1)

# tensorflow_cc and tensorflow_framework
if (NOT TensorFlow_FIND_COMPONENTS)
  set(TensorFlow_FIND_COMPONENTS tensorflow_cc tensorflow_framework)
endif ()
# the lib
set (TensorFlow_LIBRARY_PATH "")
foreach (module ${TensorFlow_FIND_COMPONENTS})
  find_library(TensorFlow_LIBRARY_${module}
    NAMES ${module}
    PATHS ${TensorFlow_search_PATHS} PATH_SUFFIXES lib NO_DEFAULT_PATH
    )
  if (TensorFlow_LIBRARY_${module})
    list(APPEND TensorFlow_LIBRARY ${TensorFlow_LIBRARY_${module}})
    get_filename_component(TensorFlow_LIBRARY_PATH_${module} ${TensorFlow_LIBRARY_${module}} PATH)
    list(APPEND TensorFlow_LIBRARY_PATH ${TensorFlow_LIBRARY_PATH_${module}})
  elseif (tensorflow_FIND_REQUIRED)
    message(FATAL_ERROR 
      "Not found lib/'${module}' in '${TensorFlow_search_PATHS}' "
      "You can manually set the tensorflow install path by -DTENSORFLOW_ROOT ")
  endif ()
endforeach ()

# tensorflow_framework
if (NOT TensorFlowFramework_FIND_COMPONENTS)
  set(TensorFlowFramework_FIND_COMPONENTS tensorflow_framework)
endif ()
# the lib
set (TensorFlowFramework_LIBRARY_PATH "")
foreach (module ${TensorFlowFramework_FIND_COMPONENTS})
  find_library(TensorFlowFramework_LIBRARY_${module}
    NAMES ${module}
    PATHS ${TensorFlow_search_PATHS} PATH_SUFFIXES lib NO_DEFAULT_PATH
    )
  if (TensorFlowFramework_LIBRARY_${module})
    list(APPEND TensorFlowFramework_LIBRARY ${TensorFlowFramework_LIBRARY_${module}})
    get_filename_component(TensorFlowFramework_LIBRARY_PATH_${module} ${TensorFlowFramework_LIBRARY_${module}} PATH)
    list(APPEND TensorFlowFramework_LIBRARY_PATH ${TensorFlowFramework_LIBRARY_PATH_${module}})
  elseif (tensorflow_FIND_REQUIRED)
    message(FATAL_ERROR 
      "Not found lib/'${module}' in '${TensorFlow_search_PATHS}' "
      "You can manually set the tensorflow install path by -DTENSORFLOW_ROOT ")
  endif ()
endforeach ()

# define the output variable
if (TensorFlow_INCLUDE_DIRS AND TensorFlow_LIBRARY AND TensorFlowFramework_LIBRARY)
  set(TensorFlow_FOUND TRUE)
else ()
  set(TensorFlow_FOUND FALSE)
endif ()

# print message
if (NOT TensorFlow_FIND_QUIETLY)
  message(STATUS "Found TensorFlow: ${TensorFlow_INCLUDE_DIRS}, ${TensorFlow_LIBRARY} "
    " in ${TensorFlow_search_PATHS}")
  message(STATUS "Found TensorFlowFramework: ${TensorFlow_INCLUDE_DIRS}, ${TensorFlowFramework_LIBRARY} "
    " in ${TensorFlow_search_PATHS}")
endif ()

unset(TensorFlow_search_PATHS)
