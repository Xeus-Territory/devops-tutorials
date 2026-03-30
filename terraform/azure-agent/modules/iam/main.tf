resource "azurerm_user_assigned_identity" "main" {
    location = var.location
    name = "${var.os}-identityforAgent"
    resource_group_name = var.resource_group_name
}

# Defination custom role for resource group
resource "azurerm_role_definition" "main" {
    name = "${var.os}-roleAgent"
    scope = var.subscription_target
    permissions {
      actions = ["*"]
      not_actions = [ "Microsoft.Authorization/elevateAccess/Action",
                      "Microsoft.Blueprint/blueprintAssignments/write",
                      "Microsoft.Blueprint/blueprintAssignments/delete",
                      "Microsoft.Compute/galleries/share/action"
                    ]
      data_actions = []
      not_data_actions = []
    }
}

resource "azurerm_role_assignment" "main" {
    scope = var.subscription_target
    principal_id = azurerm_user_assigned_identity.main.principal_id
    role_definition_id = azurerm_role_definition.main.role_definition_resource_id
}