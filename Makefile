ifeq ($(OS), Windows_NT)
  detected_OS := Windows
else
  detected_OS := $(shell sh -c 'uname 2>/dev/null || echo Unknown')
endif

# MacOS X
QUOTE := -i
ifeq ($(detected_OS), Darwin)
	QUOTE := -i ''
endif

new_machine_true:
	@sed $(QUOTE) "s/SETUP_NEW_MACHINE=false/SETUP_NEW_MACHINE=true/g" ./.vagrantbox.conf
	@echo "Reset configuration"

new_machine_false:
	@sed $(QUOTE) 's/SETUP_NEW_MACHINE=true/SETUP_NEW_MACHINE=false/g' ./.vagrantbox.conf
	@echo "Set new configuration"

clean_known_hosts_file:
	@sed $(QUOTE) "/^192\.168\.*\.*/d" ~/.ssh/known_hosts
	@echo "clean known_hosts file"
