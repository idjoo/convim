# Usage

```
docker run -it --rm \
    -v $(pwd):/mnt/workdir \
    --workdir=/mnt/workdir \
    cocatrip/convim nvim <file>

```

For convinience you may put the command in a function and put it in your shell config

```
function nvim {
    docker run -it --rm \
    -v $(pwd):/mnt/workdir \
    --workdir=/mnt/workdir \
    cocatrip/convim nvim "$@"
}
```
