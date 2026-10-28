enum VisitorStatus {
  registered('Registered'),
  checkedIn('Checked In'),
  checkedOut('Checked Out');

  const VisitorStatus(this.label);

  final String label;

  static VisitorStatus fromLabel(String? value) {
    for (final status in VisitorStatus.values) {
      if (status.label == value) {
        return status;
      }
    }
    return VisitorStatus.registered;
  }
}
