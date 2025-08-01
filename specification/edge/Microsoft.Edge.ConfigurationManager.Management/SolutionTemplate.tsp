import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "./ProvisioningState.tsp";
import "@typespec/openapi";
import "./ProvisioningState.tsp";
import "./UpdateType.tsp";

using TypeSpec.OpenAPI;
using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Microsoft.Edge;

@doc("Solution Template Properties")
model SolutionTemplateProperties {
  @doc("Description of Solution template")
  description: string;

  @doc("List of capabilities")
  capabilities: string[];

  @doc("Latest solution template version")
  @visibility(Lifecycle.Read)
  latestVersion?: string;

  @doc("State of resource")
  state?: ResourceState;

  @doc("Flag to enable external validation")
  enableExternalValidation?: boolean;

  @doc("Provisioning state of resource")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

@doc("Solution Template Resource. Contains capabilities and operations for creating versions.")
model SolutionTemplate
  is Azure.ResourceManager.TrackedResource<SolutionTemplateProperties> {
  @doc("The name of the SolutionTemplate")
  @maxLength(61)
  @minLength(3)
  @pattern("^(?!v-)(?!.*-v-)[a-zA-Z0-9]([-a-zA-Z0-9]*[a-zA-Z0-9])?(\\.[a-zA-Z0-9]([-a-zA-Z0-9]*[a-zA-Z0-9])?)*$")
  @path
  @key("solutionTemplateName")
  @segment("solutionTemplates")
  name: string;

  ...EntityTagProperty;
}

@doc("Solution Template Version With Update Type")
model SolutionTemplateVersionWithUpdateType {
  @doc("Update type")
  updateType?: UpdateType;

  @doc("Version to create")
  @pattern("^(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)$")
  version?: string;

  @doc("Solution Template Version")
  solutionTemplateVersion: SolutionTemplateVersion;
}

@armResourceOperations
interface SolutionTemplates {
  @doc("Get a Solution Template Resource")
  get is ArmResourceRead<SolutionTemplate>;

  @doc("Create or update a Solution Template Resource")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<SolutionTemplate>;

  @doc("update a Solution Template Resource")
  update is ArmResourcePatchSync<SolutionTemplate, SolutionTemplateProperties>;

  @doc("Create a Solution Template Version Resource")
  createVersion is ArmResourceActionAsync<
    SolutionTemplate,
    SolutionTemplateVersionWithUpdateType,
    SolutionTemplateVersion
  >;

  @doc("Remove Solution Template Version Resource")
  removeVersion is ArmResourceActionNoResponseContentAsync<
    SolutionTemplate,
    VersionParameter
  >;

  @doc("Delete a Solution Template Resource")
  delete is ArmResourceDeleteWithoutOkAsync<SolutionTemplate>;

  @doc("List by specified resource group")
  listByResourceGroup is ArmResourceListByParent<SolutionTemplate>;

  @doc("List by subscription")
  listBySubscription is ArmListBySubscription<SolutionTemplate>;
}
