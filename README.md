## Building

Image for node running:

```sh
$ docker build -t indy-node -f node.Dockerfile --build-arg version=<version> .
```

Args:
`version` - wanted version of indy-node, empty for latest

## Adding node

```
$ docker run --rm -v $(pwd)/data:/var/lib/indy -p 9701:9701 -p 9702:9702 indy-node [params]
```

Options:
```
-h|--help - list of options

-w|--network - name of Sovrin network. Env variable - NETWORK_NAME

-n|--name - name of Node. Env variable - NODE_NAME

-p|--port - network port for nodes comunication. Env variable - NODE_PORT

-c|--client - network port for clients connection. Env variable - CLIENT_PORT

-s|--seed - seed of node. Env variable - NODE_SEED

-f|--file - path to env file
```

Genesises files (pool and domain) should be at `$(pwd)/data/[NETWORK_NAME]` dir before startup.
Docker `-p` parameters should change if other ports are used.
Add `-d` at docker command for running as service.
