SRCS		= srcs
COMPOSER	= docker-compose.yml


# Règles
all			:
			docker-compose -f $(SRCS)/$(COMPOSER) up --build 

stop		:
			docker-compose -f $(SRCS)/$(COMPOSER) down

debug		: rmv
			docker-compose -f $(SRCS)/$(COMPOSER) up --build -d
			docker exec -it $(filter-out $@,$(MAKECMDGOALS)) sh

%:
    @:

rmv			:
			rm -rf /home/no3/data/mariadb

clean		:
			docker system prune

fclean		: rmv
			docker system prune -fa

re			: fclean all

.PHONY		: all stop clean fclean re rmv
