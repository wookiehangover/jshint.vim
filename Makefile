VIM = ${HOME}/.vim
JS_FOLDER = ftplugin/javascript
JSHINT_VIM = ./${JS_FOLDER}/jshint.vim
JSHINT_RUNNER = ./${JS_FOLDER}/jshint

install:
	@echo "Installing jshint.vim..."
	@mkdir -p ${VIM}/${JS_FOLDER}
	@cp ${JSHINT_VIM} ${VIM}/${JS_FOLDER}
	@cp -r ${JSHINT_RUNNER} ${VIM}/${JS_FOLDER}
	@echo "jshint.vim was successfully installed!"

update:
	@echo "Getting latest jshint from npm..."
	@cd ./${JS_FOLDER}/jshint && npm update

.PHONY: install update
