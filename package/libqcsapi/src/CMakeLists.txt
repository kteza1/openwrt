cmake_minimum_required(VERSION 2.6)

PROJECT(qcsapi C)

SET(CMAKE_SHARED_LIBRARY_LINK_C_FLAGS "")
ADD_DEFINITIONS(-I. -fPIC -O -g -Wall -Werror -Wno-unused-variable -Wno-unused-parameter -D_GNU_SOURCE)

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})

SET(LIB_SOURCES qcsapi_rpc/generated/qcsapi_rpc_xdr.c qcsapi_rpc/generated/qcsapi_rpc_clnt_adapter.c)

ADD_LIBRARY(libqcsapi SHARED ${LIB_SOURCES})
TARGET_LINK_LIBRARIES(libqcsapi rpc)
SET_TARGET_PROPERTIES(libqcsapi PROPERTIES
	OUTPUT_NAME qcsapi
	VERSION 1.0.1
	SOVERSION 1
)

ADD_EXECUTABLE(qcsapi-pcie
	call_qcsapi.c
	qcsapi_driver.c
	qcsapi_output.c
	qcsapi_sem.c
	qcsapi_rpc/client/pcie/qcsapi_pcie_rpc_client.c
	qcsapi_rpc_common/client/rpc_pci_clnt.c
)
SET_TARGET_PROPERTIES(qcsapi-pcie PROPERTIES OUTPUT_NAME qcsapi-pcie)
TARGET_LINK_LIBRARIES(qcsapi-pcie libqcsapi)

ADD_EXECUTABLE(qcsapi-sample
	qcsapi_rpc_sample/c_rpc_qcsapi_sample.c
	qcsapi_rpc_common/client/find_host_addr.c
)
SET_TARGET_PROPERTIES(qcsapi-sample PROPERTIES OUTPUT_NAME qcsapi-sample)
TARGET_LINK_LIBRARIES(qcsapi-sample libqcsapi)

ADD_EXECUTABLE(qcsapi-sockraw
	call_qcsapi.c
	qcsapi_driver.c
	qcsapi_output.c
	qcsapi_sem.c
	qcsapi_rpc/client/socket_raw/qcsapi_socketraw_rpc_client.c
	qcsapi_rpc_common/client/rpc_raw_clnt.c
	qcsapi_rpc_common/common/rpc_raw.c
)
SET_TARGET_PROPERTIES(qcsapi-sockraw PROPERTIES OUTPUT_NAME qcsapi-sockraw)
TARGET_LINK_LIBRARIES(qcsapi-sockraw libqcsapi)

ADD_EXECUTABLE(qcsapi-sockrpc
	call_qcsapi.c
	qcsapi_driver.c
	qcsapi_output.c
	qcsapi_sem.c
	qcsapi_rpc/client/socket/qcsapi_socket_rpc_client.c
	qcsapi_rpc_common/client/find_host_addr.c
)
SET_TARGET_PROPERTIES(qcsapi-sockrpc PROPERTIES OUTPUT_NAME qcsapi-sockrpc)
TARGET_LINK_LIBRARIES(qcsapi-sockrpc libqcsapi)

INSTALL(FILES qcsapi.h DESTINATION include)

INSTALL(TARGETS libqcsapi qcsapi-pcie qcsapi-sample qcsapi-sockraw qcsapi-sockrpc
	ARCHIVE DESTINATION lib
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
)
