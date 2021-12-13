<!-- TOC -->

- [About](#about)
- [Requirements](#requirements)
  - [How to](#how-to)
  - [Requirements](#requirements-1)

<!-- TOC -->
# About

1. This directory contains the files:<br>
    
   This directory contain the local k8s cluster

   Running a multi-node Kubernetes cluster is pretty painless with KinD (Kubernetes in Docker). It takes about a minute to spin up a cluster. You could use their kind CLI tool but in my opinion if you plan to use Terraform in production you should use it in development too. It saves you from running multiple commands manually or creating a wrapper shell script.

   In production you’d likely use a managed Kubernetes services from your cloud hosting service of choice but for local development this will get you going with a local cluster very quickly. We’ll also go over how to hook up an NGINX Ingress Controller using Helm so you can access your services over localhost.

2. The goal is to create a local cluster. Just run .demo.sh and It will spin up everything

# Requirements

=====================

NOTE: Terraform and docker installed

