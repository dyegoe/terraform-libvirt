include .makefiles/*.mk

.PHONY: k8s bastion clean
k8s: ## terraform apply k8s
	@$(MAKE) -C examples/k8s/ tfapply

bastion: ## terraform apply bastion
	@$(MAKE) -C examples/bastion/ tfapply

clean: ## clean all terraform files
	@$(call msg_tfclean_all,$(ENV_MSG))
	@rm -rf $(TF_CLEAN_FILES)
	@$(MAKE) -C examples/k8s/ clean
	@$(MAKE) -C examples/bastion/ clean
