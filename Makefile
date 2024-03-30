all: hadolint dprint
hadolint:
	hadolint Dockerfile
dprint:
	dprint check
fmt:
	dprint fmt
