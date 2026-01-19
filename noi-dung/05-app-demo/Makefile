# Đây là Makefile giúp hỗ trợ quản lý vòng đời Azure SQL Edge trên macos Apple Silicon.
# Lý do: Không có SQL Server hỗ trợ ARM.
# Sử dụng Colima.

# --- Configuration ---
DB_NAME = sql_practice
DB_PASSWORD = Password123!
# We use Azure SQL Edge for M1/M2/M3/M4 chips compatibility
IMAGE = mcr.microsoft.com/azure-sql-edge
PORT = 1433

# --- Colima Settings ---
# Allocating 4GB RAM is healthy for SQL Server on a Mac
COLIMA_CPU = 2
COLIMA_MEM = 4

.PHONY: help up start stop down clean logs status

# Default target: show help
help:
	@echo "DATABASE LAB CONTROLLER (Colima + MS SQL)"
	@echo "------------------------------------------------"
	@echo "  make up      -> Start Colima and the DB (Ready to work)"
	@echo "  make down    -> Stop DB and shutdown Colima (Save battery)"
	@echo "  make restart -> Restart everything"
	@echo "  make clean   -> DESTROY the DB container (Fresh start)"
	@echo "  make logs    -> Show database logs"
	@echo "  make status  -> Check if Colima and Docker are running"
	@echo "------------------------------------------------"

# 1. START WORK (The "I am ready to practice" command)
up: check-colima start-container
	@echo "Database is ready at localhost:$(PORT)"
	@echo "   User: sa"
	@echo "   Pass: $(DB_PASSWORD)"

# 2. FINISH WORK (The "I am done for today" command)
down:
	@echo "Stopping SQL Container..."
	-docker stop $(DB_NAME)
	@echo "Stopping Colima VM..."
	colima stop
	@echo "Lab closed."

# 3. UTILITIES
restart: down up

logs:
	docker logs -f $(DB_NAME)

status:
	@echo "--- Colima Status ---"
	@colima status
	@echo "\n--- Container Status ---"
	@docker ps -a --filter name=$(DB_NAME)

clean:
	@echo "WARNING: This will delete the database container and data."
	@read -p "Are you sure? [y/N] " ans && [ $${ans:-N} = y ]
	-docker stop $(DB_NAME)
	-docker rm $(DB_NAME)
	@echo "Container removed."

# --- INTERNAL HELPERS (Do not run directly) ---

check-colima:
	@if ! colima status > /dev/null 2>&1; then \
		echo "Starting Colima (VM)..."; \
		colima start --cpu $(COLIMA_CPU) --memory $(COLIMA_MEM); \
	else \
		echo "Colima is already running."; \
	fi

start-container:
	@if [ ! "$$(docker ps -a -q -f name=$(DB_NAME))" ]; then \
		echo "Creating new container $(DB_NAME)..."; \
		docker run -e "ACCEPT_EULA=1" \
			--cap-add SYS_PTRACE \
			-e "MSSQL_SA_PASSWORD=$(DB_PASSWORD)" \
			-p $(PORT):1433 \
			--name $(DB_NAME) \
			-d $(IMAGE); \
	else \
		if [ ! "$$(docker ps -q -f name=$(DB_NAME))" ]; then \
			echo "Starting existing container..."; \
			docker start $(DB_NAME); \
		else \
			echo "Container is already running."; \
		fi \
	fi
