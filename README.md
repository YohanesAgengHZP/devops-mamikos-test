

# VUE SNAKE GAME USING DOCKER AND MINIKUBE
Apps can be accesed via these links:
- **Grafana**: [http://103.89.165.77:8080/grafana/login](http://103.89.165.77:8080/grafana/login)
  - **Username**: visitor
  - **Password**: visitor

- **Vue Snake Game Apps**: [http://103.89.165.77:8080/vue-snake-game/](http://103.89.165.77:8080/vue-snake-game/)

Containerize vue app using docker, you can find image used on this repo on the packages menu
## Prerequisite
-   Docker 
-   Helm
-   Minikube Cluster
-   Kubectl
-   GHCR repository to pull or push image

## installation
    1. clone this repository

```bash
    git clone https://github.com/YohanesAgengHZP/devops-test-mamikos.git
  
```

    2. Run using docker

```bash
    cd (path)\devops-test-mamikos
    docker compose up -d
```

    3. Acces the application
    
```bash
    htto://localhost:8080/
```
## Screenshots

[![image.png](https://i.postimg.cc/63FtqpZz/image.png)](https://postimg.cc/34jPb7nD)

##=======================
## Using Minikube, Deploy CI/CD into Minikube Cluster

After we containerize application, we then move to next step. Create CI/CD Pipeline using Github Action with Self-Hosted Runner on a VPS


## Running Core Vue Apps on minikube cluster
    1. Create namespace for main application

```bash
    kubectl create namespace mamikos-devops
```

    2. get into /kubernetes directory to run all yaml script

```bash
    cd (path)\devops-test-mamikos\kubernetes
    kubectl apply -f *.yaml
```

    3. Check status of deployment
    
```bash
    kubectl get all
```

    4. Test the service URL
    
```bash
    minikube service list
    minikube service vuejs-app -n mamikos-devops --url
```

    5. Access the service url to check
    
```bash
    http://(IP Address):(NodePort)

    Example:
    http://192.168.58.2:30829
```
    6. Allow port forwarding or tunneling to access via localhost
    
```bash
    ssh -L 8080:192.168.58.2:30829 username@host
```

[![image.png](https://i.postimg.cc/63FtqpZz/image.png)](https://postimg.cc/34jPb7nD)




    ##=======================
## HPA Testing

To ensure autoscaling using HPA (Horizontal Pod Autoscaling), we will use CPU utilization as the threshold. I have set it to 20%. If the threshold is reached or exceeded, it will replicate pods, and it will remove pods if the CPU threshold is not met. 


## Running Core Vue Apps on minikube cluster
    1. Check for metrics server

```bash
    kubectl top pods -n kube-system
    error: Metrics API not available
    helm install metrics-server metrics-server/metrics-server --namespace kube-system
    kubectl get pods -n kube-system
    kubectl get apiservices | grep metrics
    kubectl top nodes
    kubectl top pods --all-namespaces

```
    2. Apply HPA deployment $$ check for status

```bash
    cd (path)\devops-test-mamikos\kubernetes
    kubectl apply -f hpa.yaml
```

    3. Start the load test, use load-test script from repo && monitor the replication
    
```bash
    ./load-test.sh Start
    kubectl get hpa -n mamikos-devops -w
    kubectl get deployments vuejs-app -n mamikos-devop
```

    4. Check for CPU Utilization
    Before reach thresgold, only one pod
[![image.png](https://i.postimg.cc/ncDgzVFS/image.png)](https://postimg.cc/w7904psD)

[![image.png](https://i.postimg.cc/wvW8hwZW/image.png)](https://postimg.cc/CBfQ0sFD)

    After reach and pass the threshold (20 % utlization)
[![image.png](https://i.postimg.cc/BQtpQJ3L/image.png)](https://postimg.cc/HVDX6DVd)

[![image.png](https://i.postimg.cc/G27DZsHM/image.png)](https://postimg.cc/vgnDnT79)

    5. Stop load test
```bash
    ./load-test stop
```

    




    
## Monitoring Resources Cluster
Here we are going to monitor resource management using grafana - prometheus stack. Metrics will be exported into prometheus TSDB, and then will be visualized via Grafana Dashboard.

    1. Minikube Cluster Resources
    2. Host Machine Resource


## Running Core Vue Apps on minikube cluster
    1. Check for metrics server

```bash
    kubectl top pods -n kube-system
    error: Metrics API not available
    helm install metrics-server metrics-server/metrics-server --namespace kube-system
    kubectl get pods -n kube-system
    kubectl get apiservices | grep metrics
    kubectl top nodes
    kubectl top pods --all-namespaces

```
    2. get into /monitoring/prometheus && /monitoring/grafana

```bash
    kubectl create namespaces monitoring
    k apply -f *.yaml
```

    3. run helm chart && helm repo for prometheus stack
    
```bash
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update
    helm install prometheus prometheus-community/prometheus --namespace monitoring
```
[![image.png](https://i.postimg.cc/52KTssmT/image.png)](https://postimg.cc/tsPBTtwN)

    4. run helm chart && helm repo for grafana

```bash
    helm repo add grafana https://grafana.github.io/helm-charts
    helm install grafana grafana/grafana --namespace monitoring
```
    5. expose port grafana
```bash
    kubectl expose service grafana --namespace monitoring --type=NodePort --target-port=3000 --name=grafana-ext
```
[![image.png](https://i.postimg.cc/3N3t8GB2/image.png)](https://postimg.cc/5YkBp6Dt)

```bash
    http://192.168.58.2:32000
```

    6. configure data source
    get into grafana dashboard using admin/admin user/password and then configure data source to get metrics from prometheus

```bash
    http://prometheus-service:80
```

    7. configure data dashboard
    here we can use template dashboard Node Exporter and Kubernetes resource dashboard

```bash
    import dashboard id
    Node Exporter Dashboard : 1860
    Kubernetes resource     : 15759
```
Kubernees Resource Dashboard
[![image.png](https://i.postimg.cc/DyZcxnYf/image.png)](https://postimg.cc/RqkfF5B2)

Node Exporter Resource Dashboard
[![image.png](https://i.postimg.cc/sXsY7rhr/image.png)](https://postimg.cc/GBgTn6K7)

## Lessons Learned

    1. Berapa lama waktu yang Anda habiskan untuk menyelesaikan coding test ini?
    Jawaban:
    - Untuk menyelesaikan technical test, yakni mulai dari kontainerisasi app hingga akhirnya dapat dimonitor dalam Kubernetes cluster, memakan waktu kurang lebih 9 jam. Berikut rincian waktunya:
    - Mencari VPS untuk hosting self-hosted runner GitHub (1 jam)
    - Memahami kembali fundamental Kubernetes serta instalasi tools dari Docker hingga Minikube (2 jam)
    - Implementasi dari semua tantangan pada test (4 jam)
    - Bug fixing (1 jam)
    - Dokumentasi (1 jam)
    
    2. Apa yang Anda pelajari atau tantangan terbesar yang Anda hadapi selama pengerjaan tugas ini?
    Jawaban:
    Banyak hal yang saya pelajari selama mengerjakan tugas technical test ini:
    - Mulai dari melakukan research (membandingkan harga) antar-VPS terkait cost management.
    - Instalasi self-hosted runner pada VPS tersendiri. Karena saya terbiasa menggunakan VPS built-in seperti GitLab public runner, ini adalah kali pertama saya menggunakan self-hosted runner.
    - ilmu mengenai fundamental Kubernetes mulai dari komponen, arsitektur, perintah, RBAC (Role-Based Access Control), deployment, services, hingga monitoring.
    - Implementasi CI/CD menggunakan GitHub Actions, dengan best practices seperti penggunaan built-in cache untuk mempercepat waktu build Docker image.
    - Pengalaman pertama deploy ke dalam Kubernetes cluster menggunakan CI/CD, karena biasanya saya hanya menggunakan CI/CD untuk deployment Docker saja.
    - Resource management dan skalabilitas, terutama terkait HPA (Horizontal Pod Autoscaling).
    - Set up monitoring tools untuk Kubernetes cluster.
    
    3. Apakah ada alternatif solusi atau pendekatan lain yang Anda pertimbangkan? Jelaskan.
    Ada beberapa alternatif yang mungkin membuat jalannya proses CI/CD pada cluster Kubernetes lebih efektif:
    - Menggunakan Managed Kubernetes Services (contoh: GKE, EKS, atau AKS). Dengan menggunakan layanan ini, proses konfigurasi menjadi lebih mudah karena aspek-aspek kompleks seperti networking sudah ditangani oleh tools bawaan, yang mempercepat proses setup dan meningkatkan keamanan.
    - Implementasi Helm. Setelah menyelesaikan test ini, saya mempertimbangkan Helm untuk mengelola aplikasi yang lebih kompleks. Dengan Helm Chart, kita bisa mendefinisikan konfigurasi deployment dalam satu paket yang terstruktur, sehingga jika terjadi kesalahan atau isu setelah proses deployment, kita dapat melakukan rollback dengan lebih cepat.

    4. Bagaimana solusi yang Anda buat memastikan skalabilitas dan performa yang optimal?
    Jawaban:
    - Skalabilitas:
    Dalam pengerjaan ini, saya telah mengimplementasikan HPA, yang memungkinkan aplikasi atau pod bertambah atau berkurang otomatis berdasarkan kriteria tertentu (contoh: CPU utilization). Ini membuat aplikasi dapat menangani lonjakan traffic secara dinamis dan efisien.

    - Performa optimal:
    Terdapat beberapa cara yang telah saya implementasikan untuk mendukung performa optimal:
        a. Implementasi Multi-stage Building pada Docker Image
            Dengan metode multi-stage build dan caching pada proses CI/CD, proses build menjadi lebih cepat dan ringan. Pemilihan base image juga mempengaruhi ukuran image, yang membantu meminimalisir resource overhead.
        b. Implementasi Resource Limit pada Kubernetes Cluster
            Ini membantu mengatur seberapa banyak resource yang dapat digunakan oleh aplikasi, sehingga menghindari over-utilization yang bisa berdampak pada performa cluster.
        c. Implementasi Monitoring System
            Dengan monitoring system, kita bisa memantau kondisi cluster, khususnya penggunaan resource. Monitoring ini memungkinkan kita merespons atau mengambil tindakan lebih cepat ketika terjadi anomali pada sistem, sebelum user mengalami dampaknya.

    5. Bagaimana Anda akan meningkatkan keamanan dalam pipeline ini jika diterapkan pada lingkungan produksi?
    Jawaban:
    - Penggunaan Credential Management seperti Secrets dan Variables
        Penggunaan fitur ini dapat meningkatkan keamanan terutama pada data kredensial seperti API keys, token, password, dan username. Pada pengerjaan ini, saya telah mengimplementasikan credential management agar pipeline tidak perlu menyimpan informasi sensitif di ranah publik.
    - Penggunaan RBAC (Role-Based Access Control)
        Seperti privilege atau permission, kita bisa menentukan role atau user tertentu yang boleh mengubah konfigurasi atau melakukan deployment pada level production.
    - Menambahkan Step untuk Melakukan CVE atau Image Scanning
        Scanning Docker image penting untuk mengurangi risiko keamanan. Beberapa contoh tools yang dapat digunakan adalah Docker Scout dan Dependabot.
    
    6. Apakah ada langkah tambahan yang bisa dilakukan untuk monitoring dan logging di aplikasi ini? (optional)
    Jawaban:
    Selain menggunakan Prometheus dan Grafana, kita dapat mengimplementasikan OpenTelemetry untuk pembuatan metrics yang kustom. Dengan OpenTelemetry, kita bisa membuat metrics sesuai kebutuhan, dan menggabungkan data tracing serta log menjadi satu informasi yang utuh, sehingga visualisasi end-to-end lebih terlihat.
    Implementasi Alerting Ketika Terjadi Anomali
    Alerting memungkinkan kita segera mengetahui jika ada masalah atau beban yang tidak normal pada sistem, sehingga kita bisa merespon secara cepat.

