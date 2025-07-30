enum Environment { dev, prod }

class EnvConfig {
  static const Environment env = Environment.prod;

  static String get baseUrl {
    switch (env) {
      case Environment.dev:
        return 'https://newsapi.org/';
      case Environment.prod:
        return 'https://newsapi.org/';
    }
  }
}
