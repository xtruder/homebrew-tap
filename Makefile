RENOVATE_IMAGE ?= renovate/renovate:44.103.7

.PHONY: validate validate-renovate check-checksums

validate: validate-renovate check-checksums

check-checksums:
	scripts/check-checksums.sh

validate-renovate:
	docker run --rm --volume "$(CURDIR):/repo" --workdir /repo \
		$(RENOVATE_IMAGE) renovate-config-validator --strict --no-global renovate.json
