enum ReportType {
  SEXUAL_CONTENT('Sexual content'),
  VIOLENT_CONTENT('Violent content'),
  HARASSMENT('Harassment'),
  SPAM('Spam'),
  MISINFORMATION('Misinformation'),
  SELF_HARM('Self-Harm');

  final String label;
  const ReportType(this.label);
}
