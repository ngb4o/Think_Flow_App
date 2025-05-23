class ApiEndpointUrls {
  ApiEndpointUrls._();

  static const String loginWithEmailAndPassword = "/auth/v1/authenticate";
  static const String loginWithGoogle = "/auth/v1/google/login";
  static const String signupWithEmailAndPassword = "/auth/v1/register";
  static const String verifyEmail = "/auth/v1/verify-email";
  static const String resendVerifyEmail = "/auth/v1/verify-email/send-otp";
  static const String forgotPassword = "/auth/v1/forgot-password";
  static const String resetPassword = "/auth/v1/reset-password";
  static const String logout = "/auth/v1/logout";
  static const String userProfile = "/user/v1/users/profile";
  static const String note = "/note/v1/notes";
  static const String textNote = "/note/v1/texts/note";
  static const String audioNote = "/media/v1/audios/note";
  static const String audio = "/media/v1/audios";
  static const String text = "/note/v1/texts";
  static const String archive = "/note/v1/notes/archive";
  static const String archived = "/note/v1/notes/archived";
  static const String unarchive = "/note/v1/notes/unarchive";
  static const String shareLinkNoteToEmail = "/share/email";
  static const String acceptShareNote = "/note/v1/notes/accept";
  static const String createLinkNote = "/share/link";
  static const String noteShareWithMe = "/note/v1/notes/shared-with-me";
  static const String members = "/members";
  static const String image = "/media/v1/images";
  static const String createSummaryNote = "/summary";
  static const String summary = "/gen/v1/gen/summaries";
  static const String createMindmapNote = "/mindmap";
  static const String mindmap = "/gen/v1/gen/mindmaps";
  static const String registerFcmToken = "/notification/v1/notifications/fcm-token";
  static const String transcript = "/gen/v1/gen/transcripts";
  static const String listNotification = "/notification/v1/notifications";
}
