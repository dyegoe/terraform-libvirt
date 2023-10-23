TF_INIT_FILES = .terraform/terraform.tfstate .terraform .terraform.lock.hcl
TF_CLEAN_FILES = $(TF_INIT_FILES) *.tfstate *.tfstate.* *.tfvars *tfplan*
TERRAFORM = $(shell command -v terraform 2> /dev/null)

########## Colors ##########
COLOR_GREEN = \033[0;32m
COLOR_BLUE = \033[0;34m
COLOR_CIAN = \033[0;36m
COLOR_BOLD = \033[1m
COLOR_RESET = \033[0m

########## Terraform functions ##########
define msg_tfinit_start
	@printf "${COLOR_BLUE}${COLOR_BOLD}########## Initializing Terraform files ${COLOR_CIAN}${COLOR_BOLD}[${1}] ${COLOR_BLUE}${COLOR_BOLD}##########${COLOR_RESET}\n"
endef
define msg_tfinit_end
	@printf "${COLOR_BLUE}${COLOR_BOLD}########## Terraform init finished ${COLOR_CIAN}${COLOR_BOLD}[${1}] ${COLOR_BLUE}${COLOR_BOLD}##########${COLOR_RESET}\n"
endef
define msg_tfupgrade_start
	@printf "${COLOR_BLUE}${COLOR_BOLD}########## Upgrading Terraform modules ${COLOR_CIAN}${COLOR_BOLD}[${1}] ${COLOR_BLUE}${COLOR_BOLD}##########${COLOR_RESET}\n"
endef
define msg_tfupgrade_end
	@printf "${COLOR_BLUE}${COLOR_BOLD}########## Terraform upgrade finished ${COLOR_CIAN}${COLOR_BOLD}[${1}] ${COLOR_BLUE}${COLOR_BOLD}##########${COLOR_RESET}\n"
endef
define msg_tfplan_start
	@printf "${COLOR_BLUE}${COLOR_BOLD}########## Planning Terraform files ${COLOR_CIAN}${COLOR_BOLD}[${1}] ${COLOR_BLUE}${COLOR_BOLD}##########${COLOR_RESET}\n"
endef
define msg_tfplan_end
	@printf "${COLOR_BLUE}${COLOR_BOLD}########## Terraform plan finished ${COLOR_CIAN}${COLOR_BOLD}[${1}] ${COLOR_BLUE}${COLOR_BOLD}##########${COLOR_RESET}\n"
endef
define msg_tfapply_start
	@printf "${COLOR_BLUE}${COLOR_BOLD}########## Applying Terraform files ${COLOR_CIAN}${COLOR_BOLD}[${1}] ${COLOR_BLUE}${COLOR_BOLD}##########${COLOR_RESET}\n"
endef
define msg_tfapply_end
	@printf "${COLOR_BLUE}${COLOR_BOLD}########## Terraform apply finished ${COLOR_CIAN}${COLOR_BOLD}[${1}] ${COLOR_BLUE}${COLOR_BOLD}##########${COLOR_RESET}\n"
endef
define msg_tfdestroy_start
	@printf "${COLOR_BLUE}${COLOR_BOLD}########## Destroying Terraform files ${COLOR_CIAN}${COLOR_BOLD}[${1}] ${COLOR_BLUE}${COLOR_BOLD}##########${COLOR_RESET}\n"
endef
define msg_tfdestroy_end
	@printf "${COLOR_BLUE}${COLOR_BOLD}########## Terraform destroy finished ${COLOR_CIAN}${COLOR_BOLD}[${1}] ${COLOR_BLUE}${COLOR_BOLD}##########${COLOR_RESET}\n"
endef
define msg_tffmt_start
	@printf "${COLOR_BLUE}${COLOR_BOLD}########## Formating Terraform files ${COLOR_CIAN}${COLOR_BOLD}[${1}] ${COLOR_BLUE}${COLOR_BOLD}##########${COLOR_RESET}\n"
endef
define msg_tffmt_end
	@printf "${COLOR_BLUE}${COLOR_BOLD}########## Terraform fmt finished ${COLOR_CIAN}${COLOR_BOLD}[${1}] ${COLOR_BLUE}${COLOR_BOLD}##########${COLOR_RESET}\n"
endef
define msg_tfclean_init
	@printf "${COLOR_BLUE}${COLOR_BOLD}########## Cleaning Terraform init files ${COLOR_CIAN}${COLOR_BOLD}[${1}] ${COLOR_BLUE}${COLOR_BOLD}##########${COLOR_RESET}\n"
endef
define msg_tfclean_plan
	@printf "${COLOR_BLUE}${COLOR_BOLD}########## Cleaning Terraform plan files ${COLOR_CIAN}${COLOR_BOLD}[${1}] ${COLOR_BLUE}${COLOR_BOLD}##########${COLOR_RESET}\n"
endef
define msg_tfclean_all
	@printf "${COLOR_BLUE}${COLOR_BOLD}########## Cleaning Terraform files ${COLOR_CIAN}${COLOR_BOLD}[${1}] ${COLOR_BLUE}${COLOR_BOLD}##########${COLOR_RESET}\n"
endef

########## Additional helpers ##########
envdef = $(if $(value $(1)),,$(error $(1) not set. Please export $(1)=value))
define tfenvdef
	$(call envdef,TF_VAR_ssh_public_key)
endef

########## help ##########
.PHONY: help
help:
	@printf "${COLOR_GREEN}${COLOR_BOLD}[Available targets]${COLOR_RESET}\n"
	@grep -E '^\S+:.*?## .*$$' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "${COLOR_BLUE}%-30s${COLOR_RESET} %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
