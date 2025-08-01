import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;
using TypeSpec.OpenAPI;

namespace Microsoft.HybridConnectivity;

//---------------------------------------------- Models ----------------------------------------------

//------------------- Generate Aws Template -------------------

@doc("ConnectorId and SolutionTypes and their properties to Generate AWS CFT Template.")
model GenerateAwsTemplateRequest {
  @doc("The name of public cloud connector")
  connectorId: string;

  #suppress "@azure-tools/typespec-azure-resource-manager/missing-x-ms-identifiers"
  @identifiers(#[])
  @doc("The list of solution types and their settings")
  solutionTypes?: Array<SolutionTypeSettings>;
}

@doc("The properties of Solution Type")
model SolutionTypeSettings {
  @doc("The type of the solution")
  solutionType: string;

  @doc("Solution settings")
  solutionSettings?: SolutionSettings;
}

//------------------- Test Permissions -------------------

@doc("Public connector permissions.")
model TestPermissionResult {
  #suppress "@azure-tools/typespec-azure-resource-manager/missing-x-ms-identifiers"
  @doc("Solution type permissions.")
  solutionTypes: Array<SolutionTypePermissions>;
}

@doc("Solution type permissions.")
model SolutionTypePermissions {
  @doc("The name of solution Type")
  solutionType: SolutionTypeEnum;

  @doc("The status")
  status: Status;

  @doc("The details of the status")
  statusDetails: string;
}

@doc("Solution types.")
union SolutionTypeEnum {
  string,

  @doc("Asset Management solution type")
  `Microsoft.AssetManagement`: "Microsoft.AssetManagement",

  @doc("Hybrid Compute Onboard solution type")
  `Microsoft.HybridCompute.Onboard`: "Microsoft.HybridCompute.Onboard",

  @doc("VWan Provisioning solution type")
  `Microsoft.HybridNetwork.VWan.Provision`: "Microsoft.HybridNetwork.VWan.Provision",
}

@doc("Connection status.")
union Status {
  string,

  @doc("Connected status")
  Connected: "Connected",

  @doc("Disconnected status")
  Disconnected: "Disconnected",
}

//------------------- Public Cloud Connector -------------------

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-name-pattern"
@doc("Public Cloud Connector")
model PublicCloudConnector is TrackedResource<PublicCloudConnectorProperties> {
  @doc("Represent public cloud connectors resource.")
  @pattern("^[a-zA-Z0-9-]{3,63}$")
  @key("publicCloudConnector")
  @path
  @segment("publicCloudConnectors")
  name: string;
}

#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance"
@doc("Public Cloud Connector")
model PublicCloudConnectorUpdate extends TrackedResourceUpdate {
  #suppress "@azure-tools/typespec-azure-core/no-private-usage"
  @doc("The resource-specific properties for this resource.")
  @Azure.ResourceManager.Private.conditionalClientFlatten
  properties?: PublicCloudConnectorPropertiesUpdate;
}

#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance"
@doc("The resource model definition for an Azure Resource Manager tracked top level resource which has 'tags' and a 'location'")
model TrackedResourceUpdate extends Azure.ResourceManager.CommonTypes.Resource {
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record"
  @doc("Resource tags.")
  tags?: Record<string>;
}

@doc("Properties of public cloud connectors.")
model PublicCloudConnectorPropertiesUpdate {
  @doc("Cloud profile for AWS.")
  awsCloudProfile?: AwsCloudProfileUpdate;
}

@doc("cloud profile for AWS.")
model AwsCloudProfileUpdate {
  @doc("List of AWS accounts which need to be excluded.")
  excludedAccounts?: string[];
}

@doc("Properties of public cloud connectors.")
model PublicCloudConnectorProperties {
  @doc("Cloud profile for AWS.")
  awsCloudProfile: AwsCloudProfile;

  @doc("Host cloud the public cloud connector.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  hostType: HostType;

  @doc("The resource provisioning state.")
  @visibility(Lifecycle.Read)
  provisioningState?: ResourceProvisioningState;

  @doc("Connector primary identifier.")
  @visibility(Lifecycle.Read)
  connectorPrimaryIdentifier?: string;
}

@doc("Enum of host cloud the public cloud connector is referencing.")
union HostType {
  string,

  @doc("AWS state")
  AWS: "AWS",
}

@doc("cloud profile for AWS.")
model AwsCloudProfile {
  @doc("Account id for the AWS account.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  accountId: string;

  @doc("List of AWS accounts which need to be excluded.")
  excludedAccounts?: string[];

  @doc("Boolean value that indicates whether the account is organizational or not. True represents organization account, whereas false represents a single account.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  isOrganizationalAccount?: boolean = false;
}

//------------------- Solution Configuration -------------------

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-name-pattern"
@doc("Solution Configuration")
model SolutionConfiguration
  is ExtensionResource<SolutionConfigurationProperties> {
  @doc("Represent Solution Configuration Resource.")
  @pattern("^[a-zA-Z0-9-]{3,63}$")
  @key("solutionConfiguration")
  @path
  @segment("solutionConfigurations")
  name: string;
}

@doc("Solution configuration resource.")
model SolutionConfigurationProperties {
  @doc("The resource provisioning state.")
  @visibility(Lifecycle.Read)
  provisioningState?: ResourceProvisioningState;

  @doc("The type of the solution")
  solutionType: string;

  @doc("Solution settings")
  solutionSettings?: SolutionSettings;

  @doc("The status of solution configurations")
  @visibility(Lifecycle.Read)
  status?: SolutionConfigurationStatus;

  @doc("The detailed message of status details")
  @visibility(Lifecycle.Read)
  statusDetails?: string;

  @doc("The last time resources were inventoried")
  @visibility(Lifecycle.Read)
  lastSyncTime?: utcDateTime;
}

#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance"
@doc("Solution Configuration")
model SolutionConfigurationUpdate
  extends Azure.ResourceManager.CommonTypes.ProxyResource {
  #suppress "@azure-tools/typespec-azure-core/no-private-usage"
  @doc("The resource-specific properties for this resource.")
  @Azure.ResourceManager.Private.conditionalClientFlatten
  properties?: SolutionConfigurationPropertiesUpdate;
}

@doc("Solution configuration resource.")
model SolutionConfigurationPropertiesUpdate {
  @doc("The type of the solution")
  solutionType?: string;

  @doc("Solution settings")
  solutionSettings?: SolutionSettings;
}

@doc("Solution Configuration Status.")
union SolutionConfigurationStatus {
  @doc("New status")
  New: "New",

  @doc("InProgress status")
  InProgress: "InProgress",

  @doc("Canceled status")
  Completed: "Completed",

  @doc("Failed status")
  Failed: "Failed",

  string,
}

//------------------- Solution Type -------------------

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-name-pattern"
model SolutionTypeResource is ProxyResource<SolutionTypeProperties> {
  @doc("Solution Type resource")
  @segment("solutionTypes")
  @key("solutionType")
  @path
  name: string;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "This proxy resource does not have a state"
@doc("Definition of Solution type resource.")
model SolutionTypeProperties {
  @doc("The name of the solution type.")
  solutionType?: string;

  @doc("Short description of solution type.")
  description?: string;

  @doc("The locations this solution is supported in.")
  supportedAzureRegions?: string[];

  #suppress "@azure-tools/typespec-azure-resource-manager/missing-x-ms-identifiers"
  @doc("Array of solution settings and its description.")
  @identifiers(#[])
  solutionSettings?: SolutionTypeSettingsProperties[];
}

@doc("Represent Solution settings properties description array.")
model SolutionTypeSettingsProperties {
  @doc("The name of the solution setting property.")
  name: string;

  @doc("The UI friendly name of the solution setting property.")
  displayName: string;

  @doc("Type of the solution setting property, represented as a string.")
  type: string;

  @doc("Description of solution setting property.")
  description: string;

  @doc("Array of allowed values for this solution settings property.")
  allowedValues: string[];

  @doc("Default value for this solution settings property.")
  defaultValue: string;
}

//------------------- Inventory -------------------

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-name-pattern"
@parentResource(SolutionConfiguration)
model InventoryResource is ProxyResource<InventoryProperties> {
  @doc("Inventory resource")
  @segment("inventory")
  @key("inventoryId")
  @visibility(Lifecycle.Read)
  @path
  name: string;
}

@doc("Definition of inventory.")
model InventoryProperties {
  @doc("Gets or sets the cloud native resource type.")
  cloudNativeType?: CloudNativeType;

  @doc("Gets or sets the cloud native resource name.")
  cloudNativeResourceId?: string;

  @doc("Gets or sets the mapped azure resource id.")
  azureResourceId?: string;

  @doc("Gets or sets the status of the inventory.")
  status?: SolutionConfigurationStatus;

  @doc("Gets or sets the status details.")
  statusDetails?: string;

  @doc("The resource provisioning state.")
  @visibility(Lifecycle.Read)
  provisioningState?: ResourceProvisioningState;
}

@doc("Cloud Native Type enum.")
union CloudNativeType {
  string,

  @doc("ec2 enum.")
  ec2: "ec2",
}

//------------------- Shared -------------------

#suppress "@azure-tools/typespec-azure-resource-manager/no-empty-model" "Existing use case"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "will move to a more structured model when stable/GA"
@doc("Solution settings")
model SolutionSettings is Record<string>;

//---------------------------------------------- Operations ----------------------------------------------

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "Need to remove autoroute"
#suppress "@azure-tools/typespec-azure-resource-manager/no-empty-model" "Existing use case"
@route("/subscriptions/{subscriptionId}/providers/Microsoft.HybridConnectivity/")
interface GenerateAwsTemplate {
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-operation" "Need to remove autoroute"
  @route("generateAwsTemplate")
  @post
  @action
  @tag("GenerateAwsTemplate")
  @doc("Retrieve AWS Cloud Formation template")
  post(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,

    @doc("ConnectorId and SolutionTypes and their properties to Generate AWS CFT Template.")
    @body
    generateAwsTemplateRequest: GenerateAwsTemplateRequest,
  ): Azure.ResourceManager.ArmResponse<GenerateAwsTemplateResponse> | ErrorResponse;
}

/**
 * The HybridConnectivity post operation response
 */
#suppress "@azure-tools/typespec-azure-resource-manager/no-empty-model"
model GenerateAwsTemplateResponse {}

@armResourceOperations
interface PublicCloudConnectors {
  get is ArmResourceRead<PublicCloudConnector>;
  createOrUpdate is ArmResourceCreateOrUpdateAsync<PublicCloudConnector>;
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<
    PublicCloudConnector,
    PublicCloudConnectorUpdate
  >;
  delete is ArmResourceDeleteSync<PublicCloudConnector>;
  listByResourceGroup is ArmResourceListByParent<PublicCloudConnector>;
  listBySubscription is ArmListBySubscription<PublicCloudConnector>;

  testPermissions is ArmResourceActionAsync<
    PublicCloudConnector,
    void,
    Azure.ResourceManager.Foundations.OperationStatusResult
  >;
}

@armResourceOperations
interface SolutionConfigurations {
  get is ArmResourceRead<SolutionConfiguration>;
  createOrUpdate is ArmResourceCreateOrReplaceSync<SolutionConfiguration>;
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<
    SolutionConfiguration,
    SolutionConfigurationUpdate
  >;
  delete is ArmResourceDeleteSync<SolutionConfiguration>;
  listByWidget is ArmResourceListAtScope<SolutionConfiguration>;

  @doc("Trigger immediate sync with source cloud")
  syncNow is ArmResourceActionAsync<
    SolutionConfiguration,
    void,
    Azure.ResourceManager.Foundations.OperationStatusResult
  >;
}

@armResourceOperations
interface Inventory {
  get is ArmResourceRead<InventoryResource>;
  listBySolutionConfiguration is ArmResourceListByParent<InventoryResource>;
}

@armResourceOperations
interface SolutionTypes {
  get is ArmResourceRead<SolutionTypeResource>;
  listByWidget is ArmResourceListAtScope<SolutionTypeResource>;
  listBySubscription is ArmListBySubscription<SolutionTypeResource>;
}
