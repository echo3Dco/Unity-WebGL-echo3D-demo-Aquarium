# Unity-WebGL-echo3D-Demo-Aquarium
This digital "Equarium" loads its decorations and fish at runtime using the echo3D API. The echo3D platform allows the app to select and display multitudes of different fish types without requiring any asset bundling or inclusion in the app build itself. New critters can be added by uploading to your echo3D project without increasing the app footprint. Because fish are randomly selected, scaled and textured, no two aquariums will ever be exactly the same!

## Setup
* Built with Unity 2020.3.3.  _(Note: Build process will fail Unity 2021 versions.)_
* [Register for FREE at echo3D](https://console.echo3d.com/#/auth/register?utm_term={keyword}&utm_campaign=webgl_echo3d_demo&utm_source=github&utm_medium=readme). <br>
* To view a completed demo project that only requires the echo3D API key & entry ID, clone this repo. The echo3D Unity SDK is aleady included in the project.

## Video
* See on Youtube [here](link goes here).

## Steps
* [Add these models](https://docs.echo3D.co/quickstart/add-a-3d-model) to the echo3D console from the Models/Critters folder. Add these models to 1 project in the echo3D console. This project will have its own [project key](https://docs.echo3d.com/quickstart/access-the-console). <br>
* [Add these models](https://docs.echo3D.co/quickstart/add-a-3d-model) to the echo3D console from the Models/Decor folder. Add these models to another project in the echo3D console. This project will have its own [project key](https://docs.echo3d.com/quickstart/access-the-console). <br>
* Open the Equarium scene.
* [Set the API key](https://docs.echo3d.co/quickstart/access-the-console) for those same models in the `Global.cs` script in Assets/Scripts. <br>
![APIKeyandEntryId](https://user-images.githubusercontent.com/99516371/195749269-f7a43477-b67a-49e8-a212-6abdb9c948fd.png)<br>
* [Add the entry IDs](https://docs.echo3d.co/quickstart/access-the-console) for the hammerhead shark and all static models.<br>
![NEWAPIKeyandEntryID](https://user-images.githubusercontent.com/99516371/205407613-b746840f-8e8a-4ec8-b056-a680395dfab4.png)<br>
* [Uncheck](https://docs.echo3d.co/web-console/deliver-pages/security-page) the “Enable Secret Key” box in your echo3D console (For a production build, it’s best to [add the echo3D security key](https://docs.echo3d.co/web-console/deliver-pages/security-page) to the `Global.cs` script as well). <br>
![NEWSecKey2](https://user-images.githubusercontent.com/99516371/195749308-b2349a3b-7e43-4d3c-8f09-fbfa9d3cb0be.png).

## Run
Run the editor or build the WebGL app. Within a browser sounds will not play until you interact with the window. Increase the music volume with "P" and decrease with "L". Reload the page / re-run the editor app to load different fish and try to see them all!

## Learn More
Refer to our [documentation](https://docs.echo3D.co/unity/) to learn more about how to use Unity and echo3D.

## Troubleshooting
Due to browser limitations models loaded via this app will **not** respond to changes in metadata made via the echo3D platform (Scale, rotation etc). Refreshing the app will refetch models with reflected changes.

Visit our troubleshooting guide [here](https://docs.echo3d.co/unity/troubleshooting#im-getting-a-newtonsoft.json.dll-error-in-unity).

## Support
Feel free to reach out at [support@echo3D.co](mailto:support@echo3D.co) or join our [support channel on Slack](https://go.echo3D.co/join). 

## Credits
A big thanks to mdsn and their terrific [aquarium gurgle sound](https://freesound.org/people/mdsn/sounds/175274/).

This demo implements features or assets from the following Unity Asset Store packages:
 - [Thalassophobia: Stylized Oceans](https://assetstore.unity.com/packages/3d/environments/landscapes/thalassophobia-stylized-oceans-192227)
 - [Everloop](https://assetstore.unity.com/packages/audio/music/everloop-nonlinear-soundtrack-45205)


## Screenshots
![Aquarium](https://user-images.githubusercontent.com/99516371/213614646-9bbf5b6b-19d6-41fb-9cb0-8bc3dec914c3.png)<br>
![ezgif com-gif-maker](https://user-images.githubusercontent.com/99516371/213615019-6674938a-c30e-4d1e-9f65-b9140369c6c2.gif)

