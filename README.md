# Overview

This repo will walk you through setting up the Azure infrastructure necessary to build custom images using Azure Image Builder and push to a Shared Image Gallery. You will need to have [Terraform](https://www.terraform.io/downloads.html) either locally on your machine or you can clone this repo in your [Azure Cloud Shell](https://shell.azure.com) which already has Terraform installed.

# Setup

1. Read through these guides

    - https://github.com/marketplace/actions/build-azure-virtual-machine-image

    - https://github.com/Azure/build-vm-image

1. Create a user-assigned managed identity

    ```sh
    az identity create -g <RESOURCE GROUP> -n <USER ASSIGNED IDENTITY NAME>
    ```

    > Keep the `principalId` value handy as you will need this for your custom role assignment

1. Make sure you have a service principal with the proper permissions in your subscription

    ```sh
    az ad sp create-for-rbac --name "myGitHubAction" --role contributor \
      --scopes <YOUR SCOPE> \
      --sdk-auth
    ```

    > Copy the contents to your clipboard

1. In your GitHub repo, head over to Settings and create a new Secret named `AZURE_CREDENTIALS` and paste in the content

1. Build your infrastructure using `terraform apply` from the root of this repo. 

    > There is a `variables.tf` file in the root directory which contain default values for variables. You should overwrite the defaults with your own values by providing a file that ends with the name `*.auto.tfvars`

    > You will need to include your `principalId` for the role assignment for your user assigned managed identity which you created in the step above

1. Add a new GitHub Action and paste in the following for a basic Windows 10 multi-session image build

    ```yml
    name: create_custom_windows_image

    on: push

    jobs:
      azure-image-builder:
        runs-on: windows-latest
        steps:
        - name: Checkout
          uses: actions/checkout@v2

        - name: Azure login
          uses: azure/login@v1
          with:
            creds: ${{secrets.AZURE_CREDENTIALS}}

        - name: Build custom VM image
          uses: azure/build-vm-image@v0
          with:
            resource-group-name: 'rg-ycc-aib'
            managed-identity: 'ycc-aib'
            location: 'westus2'
            source-os-type: 'Windows'
            source-image-type: 'PlatformImage'
            source-image: microsoftwindowsdesktop:office-365:20h1-evd-o365pp:latest
            dist-type: 'SharedImageGallery'
            dist-resource-id: '/subscriptions/<YOUR SUBSCIRPTION ID>/resourceGroups/<YOUR RESOURCE GROUP>/providers/Microsoft.Compute/galleries/<YOUR SHARED IMAGE GALLERY NAME>/images/<YOUR SHARED IMAGE NAME>'
            dist-location: 'westus2,centralus'
    ```

# Troubleshooting Tips

- If you encounter errors in the workflow but there is no meaningful error message, then head over to your subscription and check the activity log. Chances are you may be running into a policy action.
