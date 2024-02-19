Quick spike to see how the hybrid (text + semantic) search works with opensearch.

### How to run

```bash
cp .env_sample .env
# and add required values 

docker-compose up --build

# Wait for services to spin up

# Load the data once

docker exec -it semantic_search ./bin/load_data.rb

# Visit
# http://localhost:4567/search?q=benefits of smoking
```
