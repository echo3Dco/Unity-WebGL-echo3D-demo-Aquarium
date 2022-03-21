using UnityEngine;
using System.Collections;
using UnityEditor;
using UnityEditor.AnimatedValues;

[CustomEditor(typeof(EverloopController))]
public class EverloopControllerEditor : Editor {
	
	private bool showDetailedInfo;
	private bool enableAutopilot;
	private int numActiveTracks;
	private int trackNumberVariance;
	private bool changeTracksAutomatically;
	private float trackFadeInDuration;
	private float trackFadeOutDuration;
	private float avgFadeTimeout;
	private float fadeTimeoutVariance;

	public override void OnInspectorGUI() {
		EverloopController t = (EverloopController)target;
		int numTracks = t.GetComponentsInChildren<AudioSource>().Length;
		showDetailedInfo = t.showDetailedInfo;

		EditorGUI.BeginChangeCheck();

		float volume = EditorGUILayout.Slider("Master volume", t.volume, 0f, 1f);

		bool fadeInOnStart = EditorGUILayout.ToggleLeft("Fade in on start", t.fadeInOnStart);

		EditorGUILayout.BeginHorizontal();
		EditorGUILayout.LabelField("Master fade in/out duration");
		float masterFadeDuration = EditorGUILayout.FloatField(t.masterFadeDuration);
		EditorGUILayout.EndHorizontal();

		EditorGUILayout.Separator();

		if (showDetailedInfo) {
			EditorGUILayout.HelpBox("Autopilot starts and stops random tracks according to the specified preferences",
				MessageType.None);
		}

		enableAutopilot = EditorGUILayout.ToggleLeft("Enable autopilot", t.enableAutopilot);
		if (enableAutopilot) {
			EditorGUI.indentLevel++;

			if (showDetailedInfo) {
				EditorGUILayout.HelpBox("Average number of tracks to be playing at the same time", 
										MessageType.None);
			}

			EditorGUILayout.LabelField("Number of active tracks:");
			numActiveTracks = EditorGUILayout.IntSlider(t.numActiveTracks, 1, numTracks);
			EditorGUILayout.Space();

			if (showDetailedInfo) {
				EditorGUILayout.HelpBox("Maximum deviation from the average active tracks", MessageType.None);
			}
			EditorGUILayout.LabelField("Track number variance:");
			trackNumberVariance = EditorGUILayout.IntSlider(t.trackNumberVariance, 0, numTracks);
			EditorGUILayout.Space();

			if (showDetailedInfo) {
				EditorGUILayout.HelpBox("If enabled, autopilot will cross-fade between random tracks", MessageType.None);
			}
			changeTracksAutomatically = EditorGUILayout.ToggleLeft("Change tracks automatically", 
				t.changeTracksAutomatically);
			EditorGUILayout.Space();

			if (showDetailedInfo) {
				EditorGUILayout.HelpBox("How long it takes to fade in/out a track in autopilot", MessageType.None);
			}
			EditorGUILayout.BeginHorizontal();
			EditorGUILayout.LabelField("Tracks fade in duration");
			trackFadeInDuration = EditorGUILayout.FloatField(t.trackFadeInDuration);
			EditorGUILayout.EndHorizontal();
			
			EditorGUILayout.BeginHorizontal();
			EditorGUILayout.LabelField("Tracks fade out duration");
			trackFadeOutDuration = EditorGUILayout.FloatField(t.trackFadeOutDuration);
			EditorGUILayout.EndHorizontal();

			EditorGUILayout.Space();

			if (showDetailedInfo) {
				EditorGUILayout.HelpBox("How long it takes on average before removing or adding a track", 
										MessageType.None);
			}
			EditorGUILayout.BeginHorizontal();
			EditorGUILayout.LabelField("Track change interval");
			avgFadeTimeout = EditorGUILayout.FloatField(t.avgFadeTimeout);
			EditorGUILayout.EndHorizontal();

			if (showDetailedInfo) {
				EditorGUILayout.HelpBox("Maximum deviation from the average track change interval", 
										MessageType.None);
			}
			EditorGUILayout.BeginVertical();
			EditorGUILayout.LabelField("Track change interval variance:");
			fadeTimeoutVariance = EditorGUILayout.Slider(t.fadeTimeoutVariance, 0f, t.avgFadeTimeout);
			EditorGUILayout.EndVertical();

			EditorGUI.indentLevel--;
		}

		if (showDetailedInfo) {
			EditorGUILayout.HelpBox("Outputs debug text into the Console", 
				MessageType.None);
		}

		t.verbose = EditorGUILayout.ToggleLeft("Verbose mode", t.verbose);

		t.showDetailedInfo = EditorGUILayout.ToggleLeft("Show detailed info", t.showDetailedInfo);

		if (EditorGUI.EndChangeCheck()) {
			Undo.RecordObject(target, "EverloopController");
			t.volume = volume;
			t.fadeInOnStart = fadeInOnStart;
			t.masterFadeDuration = masterFadeDuration;
			t.numActiveTracks = numActiveTracks;
			t.trackNumberVariance = trackNumberVariance;
			t.changeTracksAutomatically = changeTracksAutomatically;
			t.trackFadeInDuration = trackFadeInDuration;
			t.trackFadeOutDuration = trackFadeOutDuration;
			t.avgFadeTimeout = avgFadeTimeout;
			t.fadeTimeoutVariance = fadeTimeoutVariance;
			t.enableAutopilot = enableAutopilot;
		}

		EditorGUILayout.Separator();
		EditorGUILayout.HelpBox(string.Format("{0} tracks detected.", numTracks), 
								numTracks > 1? MessageType.Info : MessageType.Error);
		
		base.OnInspectorGUI();
	}
}
