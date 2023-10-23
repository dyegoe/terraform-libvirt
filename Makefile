include .makefiles/*.mk

.PHONY: examples clean
examples: ## terraform apply examples
	@$(MAKE) -C examples/ tfapply

clean: ## clean all terraform files
	@$(call msg_tfclean_all,$(ENV_MSG))
	@rm -rf $(TF_CLEAN_FILES)
	@$(MAKE) -C examples/ clean
