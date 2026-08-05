// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Split.tr';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get enterEmailToContinue => 'Enter your email to continue';

  @override
  String get email => 'Email';

  @override
  String get emailHintText => 'name@example.com';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordHintText => '••••••••';

  @override
  String get login => 'Login';

  @override
  String get doNotHaveAccount => 'Don\'t have an account?';

  @override
  String get signUpWithEmail => 'Sign up with email';

  @override
  String get orContinueWith => 'or continue with';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get createAccount => 'Create Account';

  @override
  String get joinUs => 'Join Splittr to start splitting bills easily.';

  @override
  String get fullName => 'Full Name';

  @override
  String get fullNameHintText => 'John Doe';

  @override
  String get signUp => 'Sign Up';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUpSuccess => 'Sign Up Successful';

  @override
  String get guestLogin => 'Login as guest';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get groups => 'Groups';

  @override
  String get groupName => 'Group Name';

  @override
  String get groupDescription => 'Group Description';

  @override
  String get createGroup => 'Create Group';

  @override
  String get joinGroup => 'Join Group';

  @override
  String get activities => 'Activities';

  @override
  String get logout => 'Logout';

  @override
  String get profile => 'Profile';

  @override
  String get enterCode => 'Enter the invite code shared by your friend.';

  @override
  String get groupCode => 'Group Code';

  @override
  String get validGroupCode => 'Please enter a valid group code';

  @override
  String get failedToJoinGroup => 'Failed to join group';

  @override
  String get goToDashboard => 'Go to Dashboard';

  @override
  String get joiningGroup => 'Joining group...';

  @override
  String get joiningGroupSubtitle =>
      'Please wait while we add you to the group.';

  @override
  String get inviteCode => 'Invite Code';

  @override
  String get inviteLink => 'Invite Link';

  @override
  String get copyCode => 'Copy Code';

  @override
  String get copyLink => 'Copy Link';

  @override
  String get inviteCodeCopied => 'Invite code copied to clipboard!';

  @override
  String get inviteLinkCopied => 'Invite link copied to clipboard!';

  @override
  String get noGroupsYet => 'No groups yet';

  @override
  String get createGroupEmptyStateSubtitle =>
      'Create a group to start splitting expenses with your friends.';

  @override
  String get youAreOwed => 'You are owed';

  @override
  String get youOwe => 'You owe';

  @override
  String get settleUp => 'Settle up';

  @override
  String get navigationError => 'Navigation Error';

  @override
  String get backToDashboard => 'Back to Dashboard';

  @override
  String get myGroups => 'My Groups';

  @override
  String get groupDetails => 'Group Details';

  @override
  String get deleteGroup => 'Delete Group';

  @override
  String get deleteGroupConfirmation =>
      'Are you sure you want to delete this group? This action cannot be undone.';

  @override
  String get delete => 'Delete';

  @override
  String get failedToLoadPreview => 'Failed to load group preview.';

  @override
  String get close => 'Close';

  @override
  String get retry => 'Retry';

  @override
  String invitedBy(String creatorName) {
    return 'Invited by $creatorName';
  }

  @override
  String membersCount(int count) {
    return '$count members';
  }

  @override
  String get decline => 'Decline';

  @override
  String get acceptInvite => 'Accept Invite';

  @override
  String get friends => 'Friends';

  @override
  String get myFriends => 'My Friends';

  @override
  String get noFriendsYet => 'No friends yet';

  @override
  String get addFriendsEmptyStateSubtitle =>
      'Add friends to start splitting expenses with them.';

  @override
  String get cancel => 'Cancel';

  @override
  String get activity => 'Activity';

  @override
  String get noRecentActivity => 'No recent activity';

  @override
  String get noRecentActivitySubtitle =>
      'Activities in your groups will appear here.';

  @override
  String get failedToLoadActivities => 'Failed to load activities';
}
