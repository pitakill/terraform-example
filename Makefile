APP_NAME = pitakill/ecb
APP_BACKEND_DIR = backend
DANGLING_IMAGES = $(shell docker images -f "dangling=true" -q)

.PHONY: all build deploy clean

build:
			cd $(APP_BACKEND_DIR) && \
			docker build -t $(APP_NAME) .

deploy-code-backend:
			docker push $(APP_NAME)

clean:
			docker rmi $(DANGLING_IMAGES)

deploy-app:
			terraform init && \
			terraform apply --auto-approve

destroy-app:
			terraform destroy --auto-approve

all: build deploy-code-backend clean destroy-app deploy-app
