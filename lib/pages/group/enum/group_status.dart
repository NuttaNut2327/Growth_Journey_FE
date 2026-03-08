enum GroupStatus {
  NOT_JOINED('Not joined'),
  JOINED('Joined'),
  OWNER ('Owner');

  final String label;
  const GroupStatus(this.label);
}
