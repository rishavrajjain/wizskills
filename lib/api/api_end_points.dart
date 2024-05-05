class ApiEndpoints {
  static const String gptApiUrl =
      'https://wizskillsai.openai.azure.com/openai/deployments/deplymentgpt/chat/completions?api-version=2024-02-15-preview';
  static const String gptApiKey = 'c6ec9e339bc94ce382c0163f476c7412';
  static const String whisperEndpoint =
      'https://wizskillsai.openai.azure.com';
  static const String whisperApiKey = 'c6ec9e339bc94ce382c0163f476c7412';
  static const String whisperDeploymentName = 'deployment-01';
  static const String whisperApiUrl =
      '$whisperEndpoint/openai/deployments/$whisperDeploymentName/audio/transcriptions?api-version=2024-02-01';
}
