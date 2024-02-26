Quick spike to see how the hybrid (text + semantic) search works with opensearch.

### How to run

```bash
cp .env_sample .env
# and add required values

# Text search only RAILS
docker-compose up --build semantic_search_rails
# Or
# Hybrid search SINATRAg
docker-compose up --build semantic_search_sinatra

# Wait for services to spin up...

# Create index and load the data once
# Rails:
docker exec -it semantic_search_rails rake etl:create_feedback_index

# Or
# Sinatra:
docker exec -it semantic_search_sinatra ./bin/load_data.rb

# Visit Rails
# http://localhost:3000/feedback/search?q=vaping

# Visit Sinatra
# http://localhost:4567/search?q=benefits of smoking
```
