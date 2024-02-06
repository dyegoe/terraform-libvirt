include ../.makefiles/*.mk

ENV_NAME = examples
ENV_MSG = examples
TFPLAN = $(ENV_NAME).tfplan

$(TF_INIT_FILES):
	@$(call tfenvdef)
	@$(call msg_tfinit_start,$(ENV_MSG))
	@$(TERRAFORM) init
	@$(call msg_tfinit_end,$(ENV_MSG))

$(TFPLAN): $(TF_INIT_FILES)
	@$(call tfenvdef)
	@$(call msg_tfplan_start,$(ENV_MSG))
	@$(TERRAFORM) plan -out=$(TFPLAN)
	@$(call msg_tfplan_end,$(ENV_MSG))

.PHONY: tfinit tfupgrade tfplan tfplan-force tfapply tfdestroy tfclean tfclean-init tfclean-plan

tfinit: $(TF_INIT_FILES) ## terraform init

tfupgrade: tfinit ## terraform init -upgrade
	@$(call tfenvdef)
	@$(call msg_tfupgrade_start,$(ENV_MSG))
	@$(TERRAFORM) init -upgrade
	@$(call msg_tfupgrade_end,$(ENV_MSG))

tfplan: $(TFPLAN) ## terraform plan -out
tfplan-force: tfclean-plan $(TFPLAN) ## clean plan files && terraform plan

tfapply: $(TFPLAN) ## terraform apply
	@$(call tfenvdef)
	@$(call msg_tfapply_start,$(ENV_MSG))
	@$(TERRAFORM) apply $(TFPLAN)
	@rm -f $(TFPLAN)
	@$(call msg_tfapply_end,$(ENV_MSG))

tfdestroy: tfinit ## terraform destroy
	@$(call tfenvdef)
	@$(call msg_tfdestroy_start,$(ENV_MSG))
	@$(TERRAFORM) destroy -auto-approve
	@$(call msg_tfdestroy_end,$(ENV_MSG))

tfclean: ## clean all terraform files
	@$(call msg_tfclean_all,$(ENV_MSG))
	@rm -rf $(TF_CLEAN_FILES)

tfclean-init: ## clean init files
	@$(call msg_clean_init,$(ENV_MSG))
	@rm -rf $(TF_INIT_FILES)

tfclean-plan: ## clean plan files
	@$(call msg_clean_plan,$(ENV_MSG))
	@rm -f $(TFPLAN)

.PHONY: clean
clean: tfdestroy tfclean ## destroy and clean all terraform files

.DEFAULT_GOAL := tfapply
