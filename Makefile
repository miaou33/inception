SRCS		= srcs
COMPOSER	= docker-compose.yml

SERVICE ?= wordpress
SHELL_TYPE ?= sh
DEBUG_PORT ?= 9000

# Règles
all			: run

run			:
	    	mkdir -p /home/noe/data/mariadb
	    	mkdir -p /home/noe/data/wordpress
		    sudo chown -R noe:noe /home/noe/data
			docker-compose -f $(SRCS)/$(COMPOSER) up --build -d

stop		:
			docker-compose -f $(SRCS)/$(COMPOSER) down

#debug		: rmv
#			docker-compose -f $(SRCS)/$(COMPOSER) up --build -d
#			docker exec -it $(filter-out $@,$(MAKECMDGOALS)) sh

debug:
			docker-compose -f $(SRCS)/$(COMPOSER) exec -p $(DEBUG_PORT):$(DEBUG_PORT) $(SERVICE) $(SHELL_TYPE)
			#docker-compose -f $(SRCS)/$(COMPOSER) logs -f $(DEBUG_PORT):$(DEBUG_PORT) $(SERVICE) $(SHELL_TYPE)&


%:
    @:

rmv			:
    		@VOLUMES=$$(docker volume ls -qf dangling=true); \
    		if [ -n "$$VOLUMES" ]; then \
        		docker volume rm $$VOLUMES; \
    		else \
        		echo "No dangling volumes to remove"; \
    		fi

clean		:
			docker system prune

fclean		: stop rmv
			docker system prune -fa

re			: fclean all

.PHONY		: all run stop debug rmv clean fclean re 
