DOCKER       = docker
DOCKER_IMAGE = tikv-website
DOCKER_RUN   = $(DOCKER) run --rm --interactive --tty --volume `pwd`:/home/builder/build
NODE_BIN     = node_modules/.bin
NETLIFY_FUNC = $(NODE_BIN)/netlify-lambda

serve:
	hugo server \
		--buildDrafts \
		--buildFuture \
		--disableFastRender \
		--bind 0.0.0.0

serve-production:
	hugo server \
		--disableFastRender \
		--buildFuture \
		--bind 0.0.0.0

production-build:
	hugo --minify \
		--buildFuture

preview-build:
	hugo \
		--buildDrafts \
		--buildFuture \
		--baseURL $(DEPLOY_PRIME_URL) \
		--minify

docker-image:
	$(DOCKER) build . --tag $(DOCKER_IMAGE)

docker-serve:
	$(DOCKER_RUN) -p 13131:13131 $(DOCKER_IMAGE) sh -c "yarn && make serve-production"
