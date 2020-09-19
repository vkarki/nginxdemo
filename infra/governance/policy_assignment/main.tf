resource "azurerm_policy_assignment" "azurePolicyAssignment" {
  name                 = var.policyAssignmentName
  scope                = var.scope
  policy_definition_id = var.policy_definition_id
  description          = var.description
  display_name         = var.display_name
  parameters           = var.parameters
}