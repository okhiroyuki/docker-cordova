all: hadolint dprint
hadolint:
	hadolint Dockerfile
	hadolint .devcontainer/Dockerfile
dprint:
	dprint check
fmt:
	dprint fmt
