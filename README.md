# sample


- wordpress
    - https://qiita.com/yubaken/items/8023649b5c86d1b8edc2



- 確認しないといけないもの
    - Cloud Filestore
    - Network Endpoint Group
    - Google Cloud Endpoints
        - https://qiita.com/k_shiota/items/5b6bbc5863cfc288fd95#apikey%E3%82%92%E7%99%BA%E8%A1%8C
        - https://cloud.google.com/endpoints/docs/openapi/get-started-kubernetes-engine?hl=ja
    - linkerd
    - OpenCensus


kubectl create secret generic mysql-pass --from-literal=password=yourpassword

kubectl get pod wordpress-6854b577c6-ld8jt --output=yaml
kubectl exec -it 

kubectl delete all,pvc,secret --all

# kubectlコマンド接続先変更

```
$ kubectl config current-context        #現在のコンテキスト
$ kubectl config get-contexts           #コンテキストの一覧
$ kubectl config use-context <context>  #コンテキストの切り替え
```