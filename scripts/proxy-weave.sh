#!/bin/bash

kubectl port-forward -n weave "$(kubectl get -n weave pod --selector=weave-scope-comp│
onent=app -o jsonpath='{.items..metadata.name}')" 4040 &
