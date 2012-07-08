VIM = ${HOME}/.vim
JSHINT_VIM = ./ftplugin/javascript/jshint.vim
JSHINT_RUNNER = ./ftplugin/javascript/jshint.vim

install:
	@echo "Installing jshint.vim..."
	@mkdir -p ${VIM}/ftplugin/javascript
	@cp ${JSHINT_VIM} ${VIM}/ftplugin/javascript
	@cp ${JSHINT_RUNNER} ${VIM}/ftplugin/javascript
	@echo "jshint.vim was successfully installed!"

