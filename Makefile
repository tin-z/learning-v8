V8_HOME ?= /Users/danielbevenius/work/google/javascript/v8
v8_build_dir = $(V8_HOME)/out/x64.debug
v8_include_dir = $(V8_HOME)/include

v8_libs = $(v8_build_dir)/libv8_base.a $(v8_build_dir)/libv8_libbase.a $(v8_build_dir)/libv8_external_snapshot.a $(v8_build_dir)/libv8_libplatform.a $(v8_build_dir)/libicuuc.a $(v8_build_dir)/libicui18n.a ${v8_build_dir}/libv8_libsampler.a

COMPILE_TEST = clang++ -std=c++0x -O0 -g -I`pwd`/deps/googletest/googletest/include -I$(v8_include_dir) $(v8_libs) -pthread tests/main.cc lib/gtest/libgtest.a -o 

hello-world: natives_blob.bin snapshot_blob.bin hello-world.cc
	@echo "Using v8_home = $(v8_include_dir)"
	clang++ -O0 -g -I$(v8_include_dir) $(v8_libs) hello-world.cc -o $@ -pthread -std=c++0x

natives_blob.bin:
	@cp $(v8_build_dir)/$@ .

snapshot_blob.bin:
	@cp $(v8_build_dir)/$@ .

check: tests/local_test tests/persistent-object_test tests/maybe_test tests/smi_test
	./tests/smi_test

tests/local_test: tests/local_test.cc
	$(COMPILE_TEST) tests/local_test

tests/persistent-object_test: tests/persistent-object_test.cc
	$(COMPILE_TEST) tests/persistent-object_test

tests/maybe_test: tests/maybe_test.cc
	$(COMPILE_TEST) tests/maybe_test

tests/smi_test: tests/smi_test.cc
	$(COMPILE_TEST) tests/smi_test

.PHONY: clean

clean: 
	rm -f hello-world
	rm -f natives_blob.bin
	rm -f snapshot_blob.bin
	rm -rf hello-world.dSYM
	rm -rf tests/local_test
	rm -rf tests/persistent-object_test
	rm -rf tests/maybe_test
	rm -rf tests/smi_test