// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ja';

  static String m0(userName) => "${userName}さんは嬉しいです。";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "authUserLoadError": MessageLookupByLibrary.simpleMessage(
      "現在のユーザー情報の読み込みエラー",
    ),
    "bottomMenuHome": MessageLookupByLibrary.simpleMessage("家"),
    "bottomMenuNew": MessageLookupByLibrary.simpleMessage("新しい"),
    "bottomMenuProfile": MessageLookupByLibrary.simpleMessage("プロフィール"),
    "bottomMenuReels": MessageLookupByLibrary.simpleMessage("リール"),
    "bottomMenuSearch": MessageLookupByLibrary.simpleMessage("検索"),
    "controlText": MessageLookupByLibrary.simpleMessage("設定"),
    "feedCurrentUserError": MessageLookupByLibrary.simpleMessage(
      "現在アクセスしているユーザー検索エラー",
    ),
    "feedFollow": MessageLookupByLibrary.simpleMessage("フォローする"),
    "feedFollowing": MessageLookupByLibrary.simpleMessage("フォローを解除する"),
    "feedListError": MessageLookupByLibrary.simpleMessage("フィードの読み込みエラー"),
    "feedNoFeedList": MessageLookupByLibrary.simpleMessage("登録されたフィードは存在しません。"),
    "feedRecentlyListError": MessageLookupByLibrary.simpleMessage(
      "最新のフィード読み込みエラー",
    ),
    "loginButtonText": MessageLookupByLibrary.simpleMessage("ログイン"),
    "loginEmailText": MessageLookupByLibrary.simpleMessage("Eメール"),
    "loginErrorContent": MessageLookupByLibrary.simpleMessage(
      "会員情報が一致しません。\nログイン情報を確認してもう一度お試しください。",
    ),
    "loginErrorTitle": MessageLookupByLibrary.simpleMessage("ログインエラー"),
    "loginGreetingText": m0,
    "loginPasswordText": MessageLookupByLibrary.simpleMessage("パスワード"),
    "loginSignUpLinkText": MessageLookupByLibrary.simpleMessage(
      "会員ではありませんか？会員登録",
    ),
    "loginValidatorEmailText1": MessageLookupByLibrary.simpleMessage(
      "メール形式が正しくありません。",
    ),
    "loginValidatorPasswordText1": MessageLookupByLibrary.simpleMessage(
      "パスワードが正しくありません。",
    ),
    "loginValidatorPasswordText2": MessageLookupByLibrary.simpleMessage(
      "パスワードは最低6文字以上入力してください。",
    ),
    "newFeedErrorTitle": MessageLookupByLibrary.simpleMessage("フィードアップロードエラー"),
    "newFeedHintText": MessageLookupByLibrary.simpleMessage(
      "フィードの内容を作成してください...",
    ),
    "newFeedTitleText": MessageLookupByLibrary.simpleMessage("新しいフィード"),
    "newFeedTypeImage": MessageLookupByLibrary.simpleMessage("イメージ"),
    "newFeedTypeText": MessageLookupByLibrary.simpleMessage("テキスト"),
    "newFeedTypeVideo": MessageLookupByLibrary.simpleMessage("動画"),
    "newFeedUploadSuccess": MessageLookupByLibrary.simpleMessage(
      "フィードがアップロードされました。",
    ),
    "newFeedUploadText": MessageLookupByLibrary.simpleMessage("フィードを上げる"),
    "newSelectMediaText": MessageLookupByLibrary.simpleMessage(
      "写真や動画を選択してください",
    ),
    "newSelectPhotos": MessageLookupByLibrary.simpleMessage("写真を選択"),
    "newSelectVideo": MessageLookupByLibrary.simpleMessage("動画を選択 - リール"),
    "profileLanguage": MessageLookupByLibrary.simpleMessage("言語"),
    "profileLogout": MessageLookupByLibrary.simpleMessage("ログアウト"),
    "profileSettingEn": MessageLookupByLibrary.simpleMessage("英語"),
    "profileSettingJa": MessageLookupByLibrary.simpleMessage("日本語"),
    "profileSettingKr": MessageLookupByLibrary.simpleMessage("韓国語"),
    "profileSubTitle": MessageLookupByLibrary.simpleMessage("画面のテーマを変更します。"),
    "profileThemeTitle": MessageLookupByLibrary.simpleMessage("画面テーマ"),
    "signUpButtonText": MessageLookupByLibrary.simpleMessage("会員登録"),
    "signUpCommentText": MessageLookupByLibrary.simpleMessage("一行紹介"),
    "signUpDefaultErrorMsg": MessageLookupByLibrary.simpleMessage(
      "不明なエラーが発生しました。しばらくしてからもう一度お試しください。",
    ),
    "signUpEmailAlreadyInUseErrorMsg": MessageLookupByLibrary.simpleMessage(
      "すでに使用しているメールアドレスです。別のメールでお試しください。",
    ),
    "signUpEmailText": MessageLookupByLibrary.simpleMessage("Eメール"),
    "signUpErrorTitle": MessageLookupByLibrary.simpleMessage("会員登録エラー"),
    "signUpHelperCommentText": MessageLookupByLibrary.simpleMessage(
      "一行紹介は最低5文字以上、20文字以下で入力してください。",
    ),
    "signUpHelperEmailText": MessageLookupByLibrary.simpleMessage(
      "メール形式に合わせて入力してください。",
    ),
    "signUpHelperNameText": MessageLookupByLibrary.simpleMessage(
      "名前は少なくとも3文字、最大10文字まで可能です。",
    ),
    "signUpHelperPasswordConfirmText": MessageLookupByLibrary.simpleMessage(
      "入力したパスワードをもう一度入力してください。",
    ),
    "signUpHelperPasswordText": MessageLookupByLibrary.simpleMessage(
      "パスワードは最低6文字以上、10文字以下で入力してください。",
    ),
    "signUpInvalidEmailErrorMsg": MessageLookupByLibrary.simpleMessage(
      "無効なメールアドレスの形式です。正しいメールアドレスを入力してください。",
    ),
    "signUpLoginLinkText": MessageLookupByLibrary.simpleMessage(
      "すでに会員ですか？ログインする",
    ),
    "signUpNameText": MessageLookupByLibrary.simpleMessage("名前"),
    "signUpPasswordConfirmText": MessageLookupByLibrary.simpleMessage(
      "パスワード確認",
    ),
    "signUpPasswordText": MessageLookupByLibrary.simpleMessage("パスワード"),
    "signUpSendVerificationEmailText1": MessageLookupByLibrary.simpleMessage(
      "認証メールを送信しました。",
    ),
    "signUpSendVerificationEmailText2": MessageLookupByLibrary.simpleMessage(
      "認証メールを送信しました。\n認証メールをクリックして会員登録を完了します。",
    ),
    "signUpValidatorCommentText1": MessageLookupByLibrary.simpleMessage(
      "一行紹介形式が正しくありません。",
    ),
    "signUpValidatorCommentText2": MessageLookupByLibrary.simpleMessage(
      "一行紹介は最低6文字、最大20文字まで可能です。",
    ),
    "signUpValidatorEmailText1": MessageLookupByLibrary.simpleMessage(
      "メール形式が正しくありません。",
    ),
    "signUpValidatorNameText1": MessageLookupByLibrary.simpleMessage(
      "名前が正しくありません。",
    ),
    "signUpValidatorNameText2": MessageLookupByLibrary.simpleMessage(
      "名前は少なくとも3文字、最大10文字まで可能です。",
    ),
    "signUpValidatorPasswordText1": MessageLookupByLibrary.simpleMessage(
      "パスワードが正しくありません。",
    ),
    "signUpValidatorPasswordText2": MessageLookupByLibrary.simpleMessage(
      "パスワードは最低6文字以上入力してください",
    ),
    "signUpValidatorPasswordText3": MessageLookupByLibrary.simpleMessage(
      "パスワードとパスワードの確認が一致しません。",
    ),
    "signUpWeakPasswordErrorMsg": MessageLookupByLibrary.simpleMessage(
      "パスワードが弱すぎます。 6桁以上のパスワードを使用してください。",
    ),
  };
}
