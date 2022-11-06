default: build-submodule

.PHONY:
update-submodule:
	# create a clean (maybe updated) copy of whisper.cpp
	rsync ../../ggml.c Sources/whisper.cpp/
	rsync ../../ggml.h Sources/whisper.cpp/
	rsync ../../whisper.cpp Sources/whisper.cpp/
	rsync ../../whisper.h Sources/whisper.cpp/

SOURCES := $(shell find Sources/ -print)
.build: $(SOURCES)
	swift build

.PHONY:
build-submodule: update-submodule Package.swift .build
	touch publish-trigger

.PHONY:
build: Package.swift .build

.PHONY:
publish: publish-trigger
	echo " \
		\n\
		cd /path/to/whisper.cpp/bindings/ios\n\
		git commit\n\
		git tag 0.0.1\n\
		git push origin master --tags\n\
		"

clean:
	rm -rf .build