# Azure Video Analyzer Edge

> see https://aka.ms/autorest

This is the AutoRest configuration file for Azure Video Analyzer edge.

These swaggers are used to generate the SDKs for Azure Video Analyzer. These SDKs are models only (no client) and customer would need to use IoT SDK to send direct method calls to IoT hub. These SDKs are not ARM based and doesn't do any REST calls. all operations are sent as direct methods on IoT hub.

---

## Getting Started

To build the SDK for Azure Video Analyzer edge, simply [Install AutoRest](https://aka.ms/autorest/install) and in this folder, run:

> `autorest`

To see additional help and options, run:

> `autorest --help`

---

## Configuration

### Basic Information

These are the global settings for the Azure Video Analyzer edge API.

``` yaml
openapi-type: data-plane
tag: package-preview-1.1.0
directive:
  - where:
      - $.definitions.MethodRequest.properties.methodName
    suppress:
      - RequiredReadOnlyProperties
```


### Tag: package-preview-1.1.0

These settings apply only when `--tag=package-preview-1.1.0` is specified on the command line.

```yaml $(tag) == 'package-preview-1.1.0'
input-file:
  - VideoAnalyzer.Edge/preview/1.1.0/AzureVideoAnalyzer.json
  - VideoAnalyzer.Edge/preview/1.1.0/AzureVideoAnalyzerSdkDefinitions.json
```
### Tag: package-ava-edge-1-0-0-preview

These settings apply only when `--tag=package-ava-edge-1-0-0-preview` is specified on the command line.

``` yaml $(tag) == 'package-ava-edge-1-0-0-preview'
input-file:
  - VideoAnalyzer.Edge/preview/1.0.0/AzureVideoAnalyzer.json
  - VideoAnalyzer.Edge/preview/1.0.0/AzureVideoAnalyzerSdkDefinitions.json
```

---

# Code Generation

## Swagger to SDK

This section describes what SDK should be generated by the automatic system.
This is not used by Autorest itself.

``` yaml $(swagger-to-sdk)
swagger-to-sdk:
  - repo: azure-sdk-for-net
```

## C#

These settings apply only when `--csharp` is specified on the command line.
Please also specify `--csharp-sdks-folder=<path to "SDKs" directory of your azure-sdk-for-net clone>`.

``` yaml $(csharp)
csharp:
  azure-arm: false
  payload-flattening-threshold: 2
  license-header: MICROSOFT_MIT_NO_VERSION
  namespace: Microsoft.Azure.Media.AzureVideoAnalyzer.Edge
  output-folder: $(csharp-sdks-folder)/mediaservices/Microsoft.Azure.Media.AzureVideoAnalyzer.Edge/src/Generated
  clear-output-folder: true
  use-internal-constructors: true
  override-client-name: AzureVideoAnalyzerEdgeClient
  use-datetimeoffset: true
```

## Multi-API/Profile support for AutoRest v3 generators

AutoRest V3 generators require the use of `--tag=all-api-versions` to select api files.

This block is updated by an automatic script. Edits may be lost!

``` yaml $(tag) == 'all-api-versions' /* autogenerated */
# include the azure profile definitions from the standard location
require: $(this-folder)/../../../profiles/readme.md

# all the input files across all versions
input-file:
  - $(this-folder)/VideoAnalyzer.Edge/preview/1.0.0/AzureVideoAnalyzer.json

```

If there are files that should not be in the `all-api-versions` set,
uncomment the  `exclude-file` section below and add the file paths.

``` yaml $(tag) == 'all-api-versions'
#exclude-file:
#  - $(this-folder)/Microsoft.Example/stable/2010-01-01/somefile.json
```
