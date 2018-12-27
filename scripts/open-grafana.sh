set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $SCRIPT_DIR/set-kubeconfig.sh

xdg-open http://127.0.0.1:3000

kubectl -n monitoring port-forward service/grafana 3000
