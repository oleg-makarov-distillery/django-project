---
apiVersion: v1
kind: Namespace
metadata:
  name: BRANCH
---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: APP_NAME
  namespace: BRANCH
  labels:
    app: APP_NAME
spec:
  replicas: 2
  selector:
    matchLabels:
      app: APP_NAME
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1  
  template:
    metadata:
      labels:
        app: APP_NAME
    spec:
      containers:
        - name: APP_NAME
          image: flomsk/django-test:7
          imagePullPolicy: Always
          ports:
            - containerPort: 8000
          env:
          - name: secret_key
            value: "SECRET_KEY"
---

apiVersion: v1
kind: Service
metadata:
  name: APP_NAME
  namespace: BRANCH
  labels:
    app: APP_NAME
spec:
  type: ClusterIP
  ports:
    - port: 8000
      targetPort: 8000
      protocol: TCP
      name: http
  selector:
      app: APP_NAME
---

apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress-BRANCH
  namespace: BRANCH
  annotations:
    kubernetes.io/ingress.class: "nginx"
spec:
  rules:
  - host: BRANCH.tests.flomsk.com
    http:
      paths:
      - backend:
          serviceName: APP_NAME
          servicePort: 8000
        path: /
