# Unity-WebGL-echo3D-Demo-Aquarium
This digital "Equarium" loads its decorations and fish at runtime using the echo3D API. The echo3D platform allows the app to select and display multitudes of different fish types without requiring any asset bundling or inclusion in the app build itself. New critters can be added by uploading to your echo3D project without increasing the app footprint. Because fish are randomly selected, scaled and textured, no two aquariums will ever be exactly the same!


## See it Live
The built WebGL application is available to preview via github pages. Check out https://echo3dco.github.io/Unity-WebGL-echo3D-demo-Aquarium/ to load the aquarium. Allow a few minutes for the application to stream and load assets. When it is complete, it will prompt you to press any key to unveil the aquarium. 


## Setup
* Built with Unity 2021.3.16f1
* [Register for FREE at echo3D](https://console.echo3d.com/#/auth/register?utm_term={keyword}&utm_campaign=webgl_echo3d_demo&utm_source=github&utm_medium=readme). <br>
* To view a completed demo project that only requires the echo3D API key & entry ID, clone this repo. The echo3D Unity SDK is aleady included in the project.


## Steps
* [Add these models](https://docs.echo3D.co/quickstart/add-a-3d-model) to the echo3D console from the Models/Critters folder. Add these models to 1 project in the echo3D console. This project will have its own [project key](https://docs.echo3d.com/quickstart/access-the-console). <br>
* [Add these models](https://docs.echo3D.co/quickstart/add-a-3d-model) to the echo3D console from the Models/Decor folder. Add these models to another project in the echo3D console. This project will have its own [project key](https://docs.echo3d.com/quickstart/access-the-console). <br>
* Open the Equarium scene.
* [Set the API key and entryIDs](https://docs.echo3d.co/quickstart/access-the-console) for each project, static models and the hammerhead shark in the `Global.cs` script found in Assets/Scripts. <br>
![APIKey](https://user-images.githubusercontent.com/101141358/224370768-7d369b16-908c-4e3b-adfb-f111ea1db14b.png)<br>
![EntryID](https://user-images.githubusercontent.com/101141358/224371439-2383a9cf-7a97-41d7-854e-b52abe56174a.png)<br>

* [If you have your secret key enabled](https://docs.echo3d.co/web-console/deliver-pages/security-page), add the security key for each project to the `Global.cs` script as well. <br>

## Run
Run the editor or build the WebGL app. Within a browser sounds will not play until you interact with the window. Increase the music volume with "P" and decrease with "L". Reload the page / re-run the editor app to load different fish and try to see them all!

## Learn More
Refer to our [documentation](https://docs.echo3D.co/unity/) to learn more about how to use Unity and echo3D.

## Troubleshooting
Due to browser limitations with WebGL and websockets, models loaded via this app will **not** respond to changes in metadata made via the echo3D platform (Scale, rotation etc). Refreshing the app will refetch models with reflected changes.

Visit our troubleshooting guide [here](https://docs.echo3d.co/unity/troubleshooting).

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

