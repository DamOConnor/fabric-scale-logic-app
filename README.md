# Use a Logic App to Scale Microsoft Fabric

<img src="images/Fabric_256.svg" alt="Fabric Image" style="margin: 10px;" width="100" align="right"/>

![level](https://img.shields.io/badge/Microsoft%20Fabric-IaC-green)

## Introduction

This repo will create a resource group and Logic App to scale the given Fabric Capacity in a given region.  Fabric SKU and can be altered in the Bicep if required.  Region is parameterised along with resource group name, Fabric Capacity name.


## Deploy with Bicep
```
az deployment sub create --location uksouth --template-file bicep/main.bicep
```

## Deploy with ARM
```
az deployment group create --resource-group rg-fabric-private --template-file la-scale-fabric.json
```