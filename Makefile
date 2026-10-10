RENOVATE_IMAGE ?= renovate/renovate:44.103.7

.PHONY: validate validate-renovate

validate: validate-renovate

validate-renovate:
	docker run --rm --volume "$(CURDIR):/repo" --workdir /repo \
		$(RENOVATE_IMAGE) renovate-config-validator --strict --no-global renovate.json
