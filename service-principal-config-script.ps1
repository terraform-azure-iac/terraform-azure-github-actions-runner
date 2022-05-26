############################
# Update Service Principal #
############################

<#
- Checks if github-actions service principal with the name "github-actions" exists, returns if not
- Checks which roles are assigned
- Outputs if new roles are needed and which
- Promts for confirmation before assigning new roles
#>

# Roles needed for github-actions
$rolesToSet = @("Contributor", "Key Vault Certificates Officer", "User Access Administrator", "Key Vault Secrets Officer")

# Get current subscription
$currentSubId = az account show --query id --output tsv
$currentSubName = az account show --query name --output tsv

echo "Current Subscription: $currentSubName `n"
echo "Checking existing role assignemnts for github-actions application.. `n"
 
# Get Object Id of github-actions application in Azure AD and check if it exists
$objectId = az ad sp list --all --query "[?displayName=='github-actions'].{ObjectId:objectId}" --output tsv

if (!$objectId) {
    echo "A service principal with the name github-actions does not exist in $currentSubName" 
    Return
}

# Show current assigned roles roles 
$currentRoles = az role assignment list --assignee $objectId --query "[].{Name:roleDefinitionName,Scope:scope}" --output json | ConvertFrom-Json

$newRoles = $rolesToSet | Where {$currentRoles.Name -NotContains $_}

if ($newRoles) {
    if ($currentRoles) {
        echo "Not all roles are set. Current roles:" 
        $currentRoles.Name
    }
    else{
        echo "No roles are set"
    }
    echo "`nNew roles to set:"          
          $newRoles
}
else {
    echo "All roles are set:"
    $currentRoles
    Return
}

$confirmation = read-host "`nAdd new roles (y/N)?`n"

if ($confirmation -eq 'y') {
    echo "Adding roles.."
    foreach ($role in $newRoles) {
        az role assignment create --assignee $objectId --role $role --scope /subscriptions/$currentSubId
    }
}
else {
    echo "Aborting"
    Return
}

echo "`nRoles after configuration:"
az role assignment list --assignee $objectId --query "[].{Name:roleDefinitionName,Scope:scope}" --output table


# # Remove all roles from the application
# $objectId = az ad sp list --all --query "[?displayName=='github-actions'].{ObjectId:objectId}" --output tsv
# az role assignment delete --assignee $ObjectId