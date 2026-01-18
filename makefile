PATH_SCRIPTS=./scripts

install:
	@$(PATH_SCRIPTS)/install.sh | tee -a logs_install_script

