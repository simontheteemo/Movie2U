---
layout: default
title: Demo
description: Movie2U Input/Output Examples
---

[Home](././) | 
[Architecture](.architecture) | 
[Technical Stack](.technical-stack) | 
[Deployment](.deployment) | 
[Demo](.demo)

# Demo

## Input Example
### Original Video
<iframe width="560" height="315" src="https://www.youtube.com/embed/o-WKik4qp3U" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Output Examples

### 1. Scene Labels
You can view the complete JSON data:
- [View Scene Labels JSON](./data/scene-labels.json)

<details>
<summary>Preview JSON data</summary>
{% include_relative data/scene-labels.json %}
</details>

### 2. Scene Narrative
> can be viewed in json file

### 3. Audio Description
<audio controls>
  <source src="./data/finalPolly.mp3" type="audio/mpeg">
  Your browser does not support the audio element.
</audio>

You can also [download the audio description](./data/finalPolly.mp3) directly.

## Before/After Comparison

| Feature | Before Enhancement | After Movie2U Processing |
|---------|-------------------|------------------------|
| Visual Context | ❌ No scene descriptions<br>❌ No object recognition<br>❌ Limited accessibility | ✅ Detailed scene labels<br>✅ Object detection & recognition<br>✅ Temporal scene understanding |
| Audio Description | ❌ Only original audio track<br>❌ No scene narration<br>❌ Missing visual context | ✅ Natural voice narration<br>✅ Scene-by-scene description<br>✅ Time-synchronized descriptions |
| Accessibility | ❌ Limited for visually impaired users<br>❌ No alternative content<br>❌ Dependency on visual cues | ✅ Enhanced accessibility<br>✅ Rich audio descriptions<br>✅ Independent content consumption |
| Technical Features | ❌ Basic video playback<br>❌ No AI enhancement<br>❌ Static content | ✅ AWS AI/ML processing<br>✅ Dynamic content generation<br>✅ Cloud-based scalability |

### Key Improvements
- **Automated Processing**: Converts standard videos into accessible content
- **AI-Powered Analysis**: Uses AWS Rekognition for accurate scene understanding
- **Natural Voice**: Leverages Amazon Polly for high-quality audio narration
- **Scalable Solution**: Handles videos of various lengths and complexities