# Unity-WebGL-echo3D-demo-Aquarium
 
![Equarium screenshot](/screenshot.png)
Example Unity WebGL project with echo3D integrated. 

This digital "Equarium" loads its decorations and fish at runtime using the echo3D API. The echo3D platform allows the app
to select and display multitudes of different fish types without requiring any asset bundling or inclusion in the app build itself. New critters can be added by uploading to your echo3D project without 
increasing the app footprint. 

Because fish are randomly selected, scaled and textured no two aquariums will ever be exactly the same!

Built and tested with Unity 2020.3.30f1 (NOTE: Build process will fail Unity 2021 versions)

# Register
Don't have an API Key? Make sure to register for FREE at [echo3D](www.echo3d.co)

# Setup

## Setup your echo3D account and model projects
1) Follow the instructions on our [documentation page](https://docs.echo3D.co/unity/adding-ar-capabilities) to [get your API key](https://docs.echo3D.co/unity/adding-ar-capabilities#3-set-you-api-key).
2) Two projects are required so create one additional project after signing in via the console (one project is created upon sign up). 

## Clone this project repository locally
Also download Unity (2020.3 LTS version strongly recommended) if you don't have that yet!

## Upload models to echo3D
1) From the project root, open the Models/Critters folder and upload all files to one project. This will be your 'fish' project.
2) From Models/Decor, upload all files to your other project. This will be your 'Static models' Project

## Populate Globals.cs
1) Enter the API and security keys for each project within the  `Globals.cs` file located in Assets/Scripts/
2) Enter the entry IDs for the hammerhead shark and all static models. You can find the entryIDs via the echo3D web console. 

# Running the app
After completing setup, open the project with Unity. Run the editor or build the app (WebGL is the only tested build target for this app!). Within a browser sounds will not play until you interact with the window.
Increase the music volume with "P" and decrease with "L". Reload the page / re-run the editor app to load different fish and try to see them all!

# Notes

Due to browser limitations models loaded via this app will **not** respond to changes in metadata made via the echo3D platform (Scale, rotation etc). Refreshing the app will refetch models with reflected changes.

# Credits

This demo implements features or assets from the following Unity Asset Store packages:
 - [Thalassophobia: Stylized Oceans](https://assetstore.unity.com/packages/3d/environments/landscapes/thalassophobia-stylized-oceans-192227)
 - [Everloop](https://assetstore.unity.com/packages/audio/music/everloop-nonlinear-soundtrack-45205)

A big thanks to mdsn and their terrific [aquarium gurgle sound!](https://freesound.org/people/mdsn/sounds/175274/)
