SRCS		= srcs
COMPOSER	= docker-compose.yml


# Règles
all			: run

run			:
			docker-compose -f $(SRCS)/$(COMPOSER) up --build -d

stop		:
			docker-compose -f $(SRCS)/$(COMPOSER) down

debug		: rmv
			docker-compose -f $(SRCS)/$(COMPOSER) up --build -d
			docker exec -it $(filter-out $@,$(MAKECMDGOALS)) sh

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

fclean		: rmv
			docker system prune -fa

re			: fclean all

.PHONY		: all run stop debug rmv clean fclean re 
