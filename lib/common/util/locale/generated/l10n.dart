// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Settings`
  String get controlText {
    return Intl.message('Settings', name: 'controlText', desc: '', args: []);
  }

  /// `Email`
  String get loginEmailText {
    return Intl.message('Email', name: 'loginEmailText', desc: '', args: []);
  }

  /// `Password`
  String get loginPasswordText {
    return Intl.message(
      'Password',
      name: 'loginPasswordText',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get loginButtonText {
    return Intl.message('Sign In', name: 'loginButtonText', desc: '', args: []);
  }

  /// `Not a member? Sign up`
  String get loginSignUpLinkText {
    return Intl.message(
      'Not a member? Sign up',
      name: 'loginSignUpLinkText',
      desc: '',
      args: [],
    );
  }

  /// `The email format is incorrect.`
  String get loginValidatorEmailText1 {
    return Intl.message(
      'The email format is incorrect.',
      name: 'loginValidatorEmailText1',
      desc: '',
      args: [],
    );
  }

  /// `Your password is incorrect.`
  String get loginValidatorPasswordText1 {
    return Intl.message(
      'Your password is incorrect.',
      name: 'loginValidatorPasswordText1',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a password of at least 6 characters.`
  String get loginValidatorPasswordText2 {
    return Intl.message(
      'Please enter a password of at least 6 characters.',
      name: 'loginValidatorPasswordText2',
      desc: '',
      args: [],
    );
  }

  /// `Nice to meet you, {userName}`
  String loginGreetingText(Object userName) {
    return Intl.message(
      'Nice to meet you, $userName',
      name: 'loginGreetingText',
      desc: '',
      args: [userName],
    );
  }

  /// `Login Error`
  String get loginErrorTitle {
    return Intl.message(
      'Login Error',
      name: 'loginErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your membership information does not match.\nPlease check your login information and try again.`
  String get loginErrorContent {
    return Intl.message(
      'Your membership information does not match.\nPlease check your login information and try again.',
      name: 'loginErrorContent',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get signUpEmailText {
    return Intl.message('Email', name: 'signUpEmailText', desc: '', args: []);
  }

  /// `Name`
  String get signUpNameText {
    return Intl.message('Name', name: 'signUpNameText', desc: '', args: []);
  }

  /// `one line introduction`
  String get signUpCommentText {
    return Intl.message(
      'one line introduction',
      name: 'signUpCommentText',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get signUpPasswordText {
    return Intl.message(
      'Password',
      name: 'signUpPasswordText',
      desc: '',
      args: [],
    );
  }

  /// `Verify Password`
  String get signUpPasswordConfirmText {
    return Intl.message(
      'Verify Password',
      name: 'signUpPasswordConfirmText',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUpButtonText {
    return Intl.message(
      'Sign Up',
      name: 'signUpButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Already a member? Sign In`
  String get signUpLoginLinkText {
    return Intl.message(
      'Already a member? Sign In',
      name: 'signUpLoginLinkText',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email address in the correct format.`
  String get signUpHelperEmailText {
    return Intl.message(
      'Please enter your email address in the correct format.',
      name: 'signUpHelperEmailText',
      desc: '',
      args: [],
    );
  }

  /// `The name must have a minimum of 3 characters and a maximum of 10 characters.`
  String get signUpHelperNameText {
    return Intl.message(
      'The name must have a minimum of 3 characters and a maximum of 10 characters.',
      name: 'signUpHelperNameText',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a one-line introduction of at least 5 characters and no more than 20 characters.`
  String get signUpHelperCommentText {
    return Intl.message(
      'Please enter a one-line introduction of at least 5 characters and no more than 20 characters.',
      name: 'signUpHelperCommentText',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a password of at least 6 characters and no more than 10 characters.`
  String get signUpHelperPasswordText {
    return Intl.message(
      'Please enter a password of at least 6 characters and no more than 10 characters.',
      name: 'signUpHelperPasswordText',
      desc: '',
      args: [],
    );
  }

  /// `Please re-enter the password you entered.`
  String get signUpHelperPasswordConfirmText {
    return Intl.message(
      'Please re-enter the password you entered.',
      name: 'signUpHelperPasswordConfirmText',
      desc: '',
      args: [],
    );
  }

  /// `The email format is incorrect.`
  String get signUpValidatorEmailText1 {
    return Intl.message(
      'The email format is incorrect.',
      name: 'signUpValidatorEmailText1',
      desc: '',
      args: [],
    );
  }

  /// `The name is incorrect.`
  String get signUpValidatorNameText1 {
    return Intl.message(
      'The name is incorrect.',
      name: 'signUpValidatorNameText1',
      desc: '',
      args: [],
    );
  }

  /// `The name can be a minimum of 3 characters and a maximum of 10 characters.`
  String get signUpValidatorNameText2 {
    return Intl.message(
      'The name can be a minimum of 3 characters and a maximum of 10 characters.',
      name: 'signUpValidatorNameText2',
      desc: '',
      args: [],
    );
  }

  /// `The one-line introduction format is incorrect.`
  String get signUpValidatorCommentText1 {
    return Intl.message(
      'The one-line introduction format is incorrect.',
      name: 'signUpValidatorCommentText1',
      desc: '',
      args: [],
    );
  }

  /// `A one-line introduction can have a minimum of 6 characters and a maximum of 20 characters.`
  String get signUpValidatorCommentText2 {
    return Intl.message(
      'A one-line introduction can have a minimum of 6 characters and a maximum of 20 characters.',
      name: 'signUpValidatorCommentText2',
      desc: '',
      args: [],
    );
  }

  /// `The email format is incorrect.`
  String get signUpValidatorPasswordText1 {
    return Intl.message(
      'The email format is incorrect.',
      name: 'signUpValidatorPasswordText1',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a password of at least 6 characters.`
  String get signUpValidatorPasswordText2 {
    return Intl.message(
      'Please enter a password of at least 6 characters.',
      name: 'signUpValidatorPasswordText2',
      desc: '',
      args: [],
    );
  }

  /// `The password and confirm password do not match.`
  String get signUpValidatorPasswordText3 {
    return Intl.message(
      'The password and confirm password do not match.',
      name: 'signUpValidatorPasswordText3',
      desc: '',
      args: [],
    );
  }

  /// `A verification email has been sent.`
  String get signUpSendVerificationEmailText1 {
    return Intl.message(
      'A verification email has been sent.',
      name: 'signUpSendVerificationEmailText1',
      desc: '',
      args: [],
    );
  }

  /// `A verification email has been sent.\nYou must click on the verification email to complete membership registration.`
  String get signUpSendVerificationEmailText2 {
    return Intl.message(
      'A verification email has been sent.\nYou must click on the verification email to complete membership registration.',
      name: 'signUpSendVerificationEmailText2',
      desc: '',
      args: [],
    );
  }

  /// `Membership Registration Error`
  String get signUpErrorTitle {
    return Intl.message(
      'Membership Registration Error',
      name: 'signUpErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your password is too weak. Please use a password of at least six characters.`
  String get signUpWeakPasswordErrorMsg {
    return Intl.message(
      'Your password is too weak. Please use a password of at least six characters.',
      name: 'signUpWeakPasswordErrorMsg',
      desc: '',
      args: [],
    );
  }

  /// `This email address is already in use. Please try a different email address.`
  String get signUpEmailAlreadyInUseErrorMsg {
    return Intl.message(
      'This email address is already in use. Please try a different email address.',
      name: 'signUpEmailAlreadyInUseErrorMsg',
      desc: '',
      args: [],
    );
  }

  /// `The email address format is invalid. Please enter a valid email address.`
  String get signUpInvalidEmailErrorMsg {
    return Intl.message(
      'The email address format is invalid. Please enter a valid email address.',
      name: 'signUpInvalidEmailErrorMsg',
      desc: '',
      args: [],
    );
  }

  /// `An unknown error has occurred. Please try again later.`
  String get signUpDefaultErrorMsg {
    return Intl.message(
      'An unknown error has occurred. Please try again later.',
      name: 'signUpDefaultErrorMsg',
      desc: '',
      args: [],
    );
  }

  /// `Error loading current user information`
  String get authUserLoadError {
    return Intl.message(
      'Error loading current user information',
      name: 'authUserLoadError',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get bottomMenuHome {
    return Intl.message('Home', name: 'bottomMenuHome', desc: '', args: []);
  }

  /// `Search`
  String get bottomMenuSearch {
    return Intl.message('Search', name: 'bottomMenuSearch', desc: '', args: []);
  }

  /// `New`
  String get bottomMenuNew {
    return Intl.message('New', name: 'bottomMenuNew', desc: '', args: []);
  }

  /// `Reels`
  String get bottomMenuReels {
    return Intl.message('Reels', name: 'bottomMenuReels', desc: '', args: []);
  }

  /// `Profile`
  String get bottomMenuProfile {
    return Intl.message(
      'Profile',
      name: 'bottomMenuProfile',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get profileLogout {
    return Intl.message('Log Out', name: 'profileLogout', desc: '', args: []);
  }

  /// `Screen Theme`
  String get profileThemeTitle {
    return Intl.message(
      'Screen Theme',
      name: 'profileThemeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Change the screen theme.`
  String get profileSubTitle {
    return Intl.message(
      'Change the screen theme.',
      name: 'profileSubTitle',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get profileLanguage {
    return Intl.message(
      'Language',
      name: 'profileLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Korean`
  String get profileSettingKr {
    return Intl.message('Korean', name: 'profileSettingKr', desc: '', args: []);
  }

  /// `English`
  String get profileSettingEn {
    return Intl.message(
      'English',
      name: 'profileSettingEn',
      desc: '',
      args: [],
    );
  }

  /// `Japanese`
  String get profileSettingJa {
    return Intl.message(
      'Japanese',
      name: 'profileSettingJa',
      desc: '',
      args: [],
    );
  }

  /// `Select photos`
  String get newSelectPhotos {
    return Intl.message(
      'Select photos',
      name: 'newSelectPhotos',
      desc: '',
      args: [],
    );
  }

  /// `Select Video - Reels`
  String get newSelectVideo {
    return Intl.message(
      'Select Video - Reels',
      name: 'newSelectVideo',
      desc: '',
      args: [],
    );
  }

  /// `Please select a photo or video`
  String get newSelectMediaText {
    return Intl.message(
      'Please select a photo or video',
      name: 'newSelectMediaText',
      desc: '',
      args: [],
    );
  }

  /// `Please write your feed content...`
  String get newFeedHintText {
    return Intl.message(
      'Please write your feed content...',
      name: 'newFeedHintText',
      desc: '',
      args: [],
    );
  }

  /// `New Feed`
  String get newFeedTitleText {
    return Intl.message(
      'New Feed',
      name: 'newFeedTitleText',
      desc: '',
      args: [],
    );
  }

  /// `Post a Feed`
  String get newFeedUploadText {
    return Intl.message(
      'Post a Feed',
      name: 'newFeedUploadText',
      desc: '',
      args: [],
    );
  }

  /// `TEXT`
  String get newFeedTypeText {
    return Intl.message('TEXT', name: 'newFeedTypeText', desc: '', args: []);
  }

  /// `IMAGE`
  String get newFeedTypeImage {
    return Intl.message('IMAGE', name: 'newFeedTypeImage', desc: '', args: []);
  }

  /// `VIDEO`
  String get newFeedTypeVideo {
    return Intl.message('VIDEO', name: 'newFeedTypeVideo', desc: '', args: []);
  }

  /// `The feed has been uploaded.`
  String get newFeedUploadSuccess {
    return Intl.message(
      'The feed has been uploaded.',
      name: 'newFeedUploadSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Feed upload error`
  String get newFeedErrorTitle {
    return Intl.message(
      'Feed upload error',
      name: 'newFeedErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Error loading latest feed`
  String get feedRecentlyListError {
    return Intl.message(
      'Error loading latest feed',
      name: 'feedRecentlyListError',
      desc: '',
      args: [],
    );
  }

  /// `Feed loading error`
  String get feedListError {
    return Intl.message(
      'Feed loading error',
      name: 'feedListError',
      desc: '',
      args: [],
    );
  }

  /// `There are no registered feeds.`
  String get feedNoFeedList {
    return Intl.message(
      'There are no registered feeds.',
      name: 'feedNoFeedList',
      desc: '',
      args: [],
    );
  }

  /// `Error in querying currently connected users`
  String get feedCurrentUserError {
    return Intl.message(
      'Error in querying currently connected users',
      name: 'feedCurrentUserError',
      desc: '',
      args: [],
    );
  }

  /// `follow`
  String get feedFollow {
    return Intl.message('follow', name: 'feedFollow', desc: '', args: []);
  }

  /// `unfollow`
  String get feedFollowing {
    return Intl.message('unfollow', name: 'feedFollowing', desc: '', args: []);
  }

  /// `Feed follow/following Error`
  String get feedFollowFollowingError {
    return Intl.message(
      'Feed follow/following Error',
      name: 'feedFollowFollowingError',
      desc: '',
      args: [],
    );
  }

  /// `Feed like processing error`
  String get feedLikeError {
    return Intl.message(
      'Feed like processing error',
      name: 'feedLikeError',
      desc: '',
      args: [],
    );
  }

  /// `Feed bookmark processing error`
  String get feedBookmarkError {
    return Intl.message(
      'Feed bookmark processing error',
      name: 'feedBookmarkError',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'ko'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
