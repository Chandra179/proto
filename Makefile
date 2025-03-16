# gRPC Generation Makefile with dynamic directory
.PHONY: generate clean help

## generate: Generate gRPC code (REQUIRED: NAME=proto_name, OPTIONAL: DIR=output_dir)
generate:
ifndef NAME
	$(error NAME parameter is required. Usage: make generate NAME=<proto> [DIR=<output>])
endif
	@echo "Generating code for $(NAME).proto..."
	@mkdir -p $(if $(DIR),$(DIR),go-gen)
	protoc --go_out=$(DIR) --go-grpc_out=$(DIR) \
		--go_opt=module=github.com/Chandra179/proto/$(DIR) \
		--go-grpc_opt=module=github.com/Chandra179/proto/$(DIR) \
		$(NAME).proto
	@echo "Generated files in $(if $(DIR),$(DIR))/ directory"

## clean: Remove generated files
clean:
ifndef DIR
	$(warning DIR parameter not specified, cleaning default 'go-gen' directory)
	@rm -rf go-gen/*.pb.go
else
	@echo "Cleaning $(DIR) directory..."
	@rm -rf $(DIR)/*.pb.go
endif

## help: Show usage
help:
	@echo "Usage:"
	@echo "  make generate NAME=<proto> [DIR=<dir>]  # Generate code (NAME required)"
	@echo "  make clean [DIR=<dir>]                 # Clean specific directory"
	@echo "  make help                              # Show this message"
	@echo "\nExamples:"
	@echo "  make generate NAME=health DIR=health-gen"
	@echo "  make generate NAME=users DIR=user-service"
	@echo "  make clean DIR=health-gen"