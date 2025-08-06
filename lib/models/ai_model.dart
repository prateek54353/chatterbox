// lib/models/ai_model.dart

enum AiModelType {
  textWriter,
  imageGenerator,
  codeTutor,
  translator,
  generalChat,
}

// This extension makes it easy to get metadata for each model type.
extension AiModelTypeExtension on AiModelType {
  String get title {
    switch (this) {
      case AiModelType.textWriter:
        return 'AI Text Writer';
      case AiModelType.imageGenerator:
        return 'AI Image Generator';
      case AiModelType.codeTutor:
        return 'AI Code Tutor';
      case AiModelType.translator:
        return 'AI Translator';
      case AiModelType.generalChat:
        return 'General Chat';
    }
  }

  String get initialPrompt {
    switch (this) {
      case AiModelType.textWriter:
        return 'You are a helpful and creative text writer...';
      case AiModelType.imageGenerator:
        return 'You are an AI image generation assistant...';
      case AiModelType.codeTutor:
        return 'You are an expert programming tutor...';
      case AiModelType.translator:
        return 'You are an expert language translator...';
      case AiModelType.generalChat:
        return 'Hi there! Ask me anything.';
    }
  }
}