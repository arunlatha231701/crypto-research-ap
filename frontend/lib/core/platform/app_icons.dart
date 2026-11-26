// app_icons.dart
// Location: lib/core/app_icons.dart
//
// ══════════════════════════════════════════════════════════════════════════════
// ADAPTIVE PLATFORM ICONS — 202 ICONS, 100% CUPERTINO ON iOS
// ══════════════════════════════════════════════════════════════════════════════
//
// Provides platform-adaptive icons for the entire app:
//   • Android → Material Icons (Icons.*)
//   • iOS     → Cupertino Icons (CupertinoIcons.*)
//
// USAGE:
//   import 'package:iFillip/core/app_icons.dart';
//
//   Icon(AppIcons.arrowBack)           // auto-picks per platform
//   Icon(AppIcons.checkCircle)         // auto-picks per platform
//
// ALL icons have Cupertino mappings — zero Material icons on iOS builds.
// ══════════════════════════════════════════════════════════════════════════════

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:material_ui/material_ui.dart';

class AppIcons {
  AppIcons._(); // prevent instantiation

  /// Platform check — resolved once, cached forever
  static final bool _isIOS = defaultTargetPlatform == TargetPlatform.iOS;

  // ══════════════════════════════════════════════════════════════════════════
  // NAVIGATION & ARROWS
  // ══════════════════════════════════════════════════════════════════════════

  static IconData get arrowBack =>
      _isIOS ? CupertinoIcons.back : Icons.arrow_back;

  static IconData get arrowBackIos =>
      _isIOS ? CupertinoIcons.chevron_back : Icons.arrow_back_ios_new_rounded;

  static IconData get arrowBackRounded =>
      _isIOS ? CupertinoIcons.back : Icons.arrow_back_rounded;

  static IconData get arrowForwardIos =>
      _isIOS ? CupertinoIcons.chevron_forward : Icons.arrow_forward_ios_rounded;

  static IconData get arrowForwardIosPlain =>
      _isIOS ? CupertinoIcons.chevron_forward : Icons.arrow_forward_ios;

  static IconData get arrowForwardRounded =>
      _isIOS ? CupertinoIcons.forward : Icons.arrow_forward_rounded;

  static IconData get arrowDropDown =>
      _isIOS ? CupertinoIcons.chevron_down : Icons.arrow_drop_down;

  static IconData get keyboardArrowDown =>
      _isIOS ? CupertinoIcons.chevron_down : Icons.keyboard_arrow_down_rounded;

  // Icons.keyboard_arrow_down (non-rounded variant used in exam files)
  static IconData get keyboardArrowDownPlain =>
      _isIOS ? CupertinoIcons.chevron_down : Icons.keyboard_arrow_down;

  static IconData get chevronLeft =>
      _isIOS ? CupertinoIcons.chevron_left : Icons.chevron_left;

  static IconData get chevronLeftRounded =>
      _isIOS ? CupertinoIcons.chevron_back : Icons.chevron_left_rounded;

  static IconData get chevronRight =>
      _isIOS ? CupertinoIcons.chevron_right : Icons.chevron_right;

  static IconData get chevronRightRounded =>
      _isIOS ? CupertinoIcons.chevron_forward : Icons.chevron_right_rounded;

  static IconData get expandMore =>
      _isIOS ? CupertinoIcons.chevron_down : Icons.expand_more;

  static IconData get expandLess =>
      _isIOS ? CupertinoIcons.chevron_up : Icons.expand_less;

  // ══════════════════════════════════════════════════════════════════════════
  // HOME, DASHBOARD & GRID
  // ══════════════════════════════════════════════════════════════════════════

  static IconData get homeOutlined =>
      _isIOS ? CupertinoIcons.house : Icons.home_outlined;

  static IconData get homeRounded =>
      _isIOS ? CupertinoIcons.house_fill : Icons.home_rounded;

  static IconData get dashboard =>
      _isIOS ? CupertinoIcons.square_grid_2x2 : Icons.dashboard;

  static IconData get gridView =>
      _isIOS ? CupertinoIcons.square_grid_2x2 : Icons.grid_view;

  static IconData get gridViewRounded =>
      _isIOS ? CupertinoIcons.square_grid_2x2_fill : Icons.grid_view_rounded;

  // ══════════════════════════════════════════════════════════════════════════
  // PERSON & PEOPLE
  // ══════════════════════════════════════════════════════════════════════════

  static IconData get person => _isIOS ? CupertinoIcons.person : Icons.person;

  static IconData get personOutline =>
      _isIOS ? CupertinoIcons.person : Icons.person_outline;

  static IconData get personRounded =>
      _isIOS ? CupertinoIcons.person_fill : Icons.person_rounded;

  static IconData get personOutlineRounded =>
      _isIOS ? CupertinoIcons.person : Icons.person_outline_rounded;

  static IconData get personOffRounded =>
      _isIOS ? CupertinoIcons.person_badge_minus : Icons.person_off_rounded;

  static IconData get accountCircleOutlined =>
      _isIOS ? CupertinoIcons.person_circle : Icons.account_circle_outlined;

  static IconData get people => _isIOS ? CupertinoIcons.person_2 : Icons.people;

  static IconData get peopleOutline =>
      _isIOS ? CupertinoIcons.person_2 : Icons.people_outline;

  static IconData get peopleOutlineRounded =>
      _isIOS ? CupertinoIcons.person_2 : Icons.people_outline_rounded;

  static IconData get peopleAltRounded =>
      _isIOS ? CupertinoIcons.person_2_fill : Icons.people_alt_rounded;

  static IconData get groupsRounded =>
      _isIOS ? CupertinoIcons.person_3_fill : Icons.groups_rounded;

  static IconData get badgeRounded =>
      _isIOS ? CupertinoIcons.person_crop_rectangle_fill : Icons.badge_rounded;

  // ── Gender ──
  static IconData get maleRounded =>
      _isIOS ? CupertinoIcons.person : Icons.male_rounded;

  static IconData get femaleRounded =>
      _isIOS ? CupertinoIcons.person : Icons.female_rounded;

  // ══════════════════════════════════════════════════════════════════════════
  // SCHOOL & EDUCATION
  // ══════════════════════════════════════════════════════════════════════════

  static IconData get school => _isIOS ? CupertinoIcons.book : Icons.school;

  static IconData get schoolOutlined =>
      _isIOS ? CupertinoIcons.book : Icons.school_outlined;

  static IconData get schoolRounded =>
      _isIOS ? CupertinoIcons.book_fill : Icons.school_rounded;

  static IconData get classOutlined =>
      _isIOS ? CupertinoIcons.book : Icons.class_outlined;

  static IconData get classRounded =>
      _isIOS ? CupertinoIcons.book_fill : Icons.class_rounded;

  static IconData get menuBookOutlined =>
      _isIOS ? CupertinoIcons.book : Icons.menu_book_outlined;

  static IconData get historyEduOutlined => _isIOS
      ? CupertinoIcons.pencil_ellipsis_rectangle
      : Icons.history_edu_outlined;

  // ══════════════════════════════════════════════════════════════════════════
  // CHECK, CANCEL & STATUS
  // ══════════════════════════════════════════════════════════════════════════

  static IconData get checkCircle =>
      _isIOS ? CupertinoIcons.checkmark_circle : Icons.check_circle;

  static IconData get checkCircleOutline =>
      _isIOS ? CupertinoIcons.checkmark_circle : Icons.check_circle_outline;

  static IconData get checkCircleRounded => _isIOS
      ? CupertinoIcons.checkmark_circle_fill
      : Icons.check_circle_rounded;

  static IconData get checkRounded =>
      _isIOS ? CupertinoIcons.checkmark : Icons.check_rounded;

  static IconData get check => _isIOS ? CupertinoIcons.checkmark : Icons.check;

  static IconData get doneAll =>
      _isIOS ? CupertinoIcons.checkmark_seal : Icons.done_all;

  static IconData get checklistRounded =>
      _isIOS ? CupertinoIcons.text_badge_checkmark : Icons.checklist_rounded;

  static IconData get checkBox =>
      _isIOS ? CupertinoIcons.checkmark_square_fill : Icons.check_box;

  static IconData get checkBoxOutlineBlank =>
      _isIOS ? CupertinoIcons.square : Icons.check_box_outline_blank;

  static IconData get cancel =>
      _isIOS ? CupertinoIcons.xmark_circle_fill : Icons.cancel;

  static IconData get cancelOutlined =>
      _isIOS ? CupertinoIcons.xmark_circle : Icons.cancel_outlined;

  static IconData get cancelRounded =>
      _isIOS ? CupertinoIcons.xmark_circle_fill : Icons.cancel_rounded;

  static IconData get close => _isIOS ? CupertinoIcons.xmark : Icons.close;

  static IconData get closeRounded =>
      _isIOS ? CupertinoIcons.xmark : Icons.close_rounded;

  static IconData get clear => _isIOS ? CupertinoIcons.xmark : Icons.clear;

  static IconData get error =>
      _isIOS ? CupertinoIcons.exclamationmark_circle_fill : Icons.error;

  static IconData get errorOutline =>
      _isIOS ? CupertinoIcons.exclamationmark_circle : Icons.error_outline;

  static IconData get errorOutlineRounded => _isIOS
      ? CupertinoIcons.exclamationmark_circle
      : Icons.error_outline_rounded;

  static IconData get warning =>
      _isIOS ? CupertinoIcons.exclamationmark_triangle : Icons.warning;

  static IconData get warningAmberRounded => _isIOS
      ? CupertinoIcons.exclamationmark_triangle_fill
      : Icons.warning_amber_rounded;

  static IconData get info =>
      _isIOS ? CupertinoIcons.info_circle_fill : Icons.info;

  static IconData get infoOutline =>
      _isIOS ? CupertinoIcons.info_circle : Icons.info_outline;

  static IconData get infoOutlineRounded =>
      _isIOS ? CupertinoIcons.info_circle : Icons.info_outline_rounded;

  // ══════════════════════════════════════════════════════════════════════════
  // CALENDAR & TIME
  // ══════════════════════════════════════════════════════════════════════════

  static IconData get calendarMonth =>
      _isIOS ? CupertinoIcons.calendar : Icons.calendar_month;

  static IconData get calendarMonthOutlined =>
      _isIOS ? CupertinoIcons.calendar : Icons.calendar_month_outlined;

  static IconData get calendarMonthRounded =>
      _isIOS ? CupertinoIcons.calendar : Icons.calendar_month_rounded;

  static IconData get calendarToday =>
      _isIOS ? CupertinoIcons.calendar_today : Icons.calendar_today;

  static IconData get calendarTodayOutlined =>
      _isIOS ? CupertinoIcons.calendar_today : Icons.calendar_today_outlined;

  static IconData get calendarTodayRounded =>
      _isIOS ? CupertinoIcons.calendar_today : Icons.calendar_today_rounded;

  static IconData get dateRange =>
      _isIOS ? CupertinoIcons.calendar : Icons.date_range;

  static IconData get dateRangeRounded =>
      _isIOS ? CupertinoIcons.calendar : Icons.date_range_rounded;

  static IconData get eventRounded =>
      _isIOS ? CupertinoIcons.calendar : Icons.event_rounded;

  static IconData get eventBusy =>
      _isIOS ? CupertinoIcons.calendar_badge_minus : Icons.event_busy;

  static IconData get eventBusyRounded =>
      _isIOS ? CupertinoIcons.calendar_badge_minus : Icons.event_busy_rounded;

  static IconData get eventNote =>
      _isIOS ? CupertinoIcons.calendar_badge_plus : Icons.event_note;

  static IconData get eventNoteRounded =>
      _isIOS ? CupertinoIcons.calendar_badge_plus : Icons.event_note_rounded;

  static IconData get eventSeatOutlined =>
      _isIOS ? CupertinoIcons.tickets : Icons.event_seat_outlined;

  static IconData get eventSeatRounded =>
      _isIOS ? CupertinoIcons.tickets_fill : Icons.event_seat_rounded;

  static IconData get accessTime =>
      _isIOS ? CupertinoIcons.clock : Icons.access_time;

  static IconData get accessTimeRounded =>
      _isIOS ? CupertinoIcons.clock : Icons.access_time_rounded;

  static IconData get accessTimeOutlined =>
      _isIOS ? CupertinoIcons.clock : Icons.access_time_outlined;

  static IconData get timerOutlined =>
      _isIOS ? CupertinoIcons.timer : Icons.timer_outlined;

  static IconData get schedule =>
      _isIOS ? CupertinoIcons.clock : Icons.schedule;

  static IconData get scheduleRounded =>
      _isIOS ? CupertinoIcons.clock_fill : Icons.schedule_rounded;

  // ══════════════════════════════════════════════════════════════════════════
  // LOCK, SECURITY & AUTH
  // ══════════════════════════════════════════════════════════════════════════

  static IconData get lock => _isIOS ? CupertinoIcons.lock : Icons.lock;

  static IconData get lockOutline =>
      _isIOS ? CupertinoIcons.lock : Icons.lock_outline;

  static IconData get lockOutlineRounded =>
      _isIOS ? CupertinoIcons.lock : Icons.lock_outline_rounded;

  static IconData get lockRounded =>
      _isIOS ? CupertinoIcons.lock_fill : Icons.lock_rounded;

  static IconData get lockResetRounded =>
      _isIOS ? CupertinoIcons.lock_rotation : Icons.lock_reset_rounded;

  static IconData get vpnKeyOutlined =>
      _isIOS ? CupertinoIcons.lock_shield : Icons.vpn_key_outlined;

  static IconData get fingerprintOutlined =>
      _isIOS ? CupertinoIcons.hand_raised : Icons.fingerprint_outlined;

  static IconData get fingerprintRounded =>
      _isIOS ? CupertinoIcons.hand_raised_fill : Icons.fingerprint_rounded;

  static IconData get visibility =>
      _isIOS ? CupertinoIcons.eye : Icons.visibility;

  static IconData get visibilityRounded =>
      _isIOS ? CupertinoIcons.eye_fill : Icons.visibility_rounded;

  static IconData get visibilityOutlined =>
      _isIOS ? CupertinoIcons.eye : Icons.visibility_outlined;

  static IconData get visibilityOff =>
      _isIOS ? CupertinoIcons.eye_slash : Icons.visibility_off;

  static IconData get visibilityOffOutlined =>
      _isIOS ? CupertinoIcons.eye_slash : Icons.visibility_off_outlined;

  static IconData get adminPanelSettings =>
      _isIOS ? CupertinoIcons.shield_lefthalf_fill : Icons.admin_panel_settings;

  static IconData get adminPanelSettingsRounded => _isIOS
      ? CupertinoIcons.shield_lefthalf_fill
      : Icons.admin_panel_settings_rounded;

  static IconData get loginRounded =>
      _isIOS ? CupertinoIcons.arrow_right_square : Icons.login_rounded;

  static IconData get logoutRounded =>
      _isIOS ? CupertinoIcons.arrow_left_square : Icons.logout_rounded;

  // ══════════════════════════════════════════════════════════════════════════
  // MAIL & COMMUNICATION
  // ══════════════════════════════════════════════════════════════════════════

  static IconData get emailOutlined =>
      _isIOS ? CupertinoIcons.mail : Icons.email_outlined;

  static IconData get mailOutline =>
      _isIOS ? CupertinoIcons.mail : Icons.mail_outline;

  static IconData get mailRounded =>
      _isIOS ? CupertinoIcons.mail_solid : Icons.mail_rounded;

  static IconData get markEmailReadRounded => _isIOS
      ? CupertinoIcons.checkmark_seal_fill
      : Icons.mark_email_read_rounded;

  static IconData get sendOutlined =>
      _isIOS ? CupertinoIcons.paperplane : Icons.send_outlined;

  static IconData get phone => _isIOS ? CupertinoIcons.phone : Icons.phone;

  static IconData get campaignRounded =>
      _isIOS ? CupertinoIcons.speaker_2_fill : Icons.campaign_rounded;

  static IconData get recordVoiceOverRounded =>
      _isIOS ? CupertinoIcons.mic_fill : Icons.record_voice_over_rounded;

  static IconData get recordVoiceOverOutlined =>
      _isIOS ? CupertinoIcons.mic : Icons.record_voice_over_outlined;

  static IconData get chatBubbleOutline =>
      _isIOS ? CupertinoIcons.chat_bubble : Icons.chat_bubble_outline;

  static IconData get publish =>
      _isIOS ? CupertinoIcons.arrow_up_circle : Icons.publish;

  // ══════════════════════════════════════════════════════════════════════════
  // FILE, DOWNLOAD & UPLOAD
  // ══════════════════════════════════════════════════════════════════════════

  static IconData get fileDownload =>
      _isIOS ? CupertinoIcons.cloud_download : Icons.file_download;

  static IconData get fileDownloadOutlined =>
      _isIOS ? CupertinoIcons.cloud_download : Icons.file_download_outlined;

  static IconData get fileDownloadRounded =>
      _isIOS ? CupertinoIcons.cloud_download_fill : Icons.file_download_rounded;

  static IconData get download =>
      _isIOS ? CupertinoIcons.cloud_download : Icons.download;

  static IconData get downloadDoneRounded =>
      _isIOS ? CupertinoIcons.checkmark_circle : Icons.download_done_rounded;

  static IconData get upload =>
      _isIOS ? CupertinoIcons.cloud_upload : Icons.upload;

  static IconData get uploadFile =>
      _isIOS ? CupertinoIcons.cloud_upload_fill : Icons.upload_file;

  static IconData get cloudUpload =>
      _isIOS ? CupertinoIcons.cloud_upload : Icons.cloud_upload;

  static IconData get cloudOffRounded =>
      _isIOS ? CupertinoIcons.wifi_slash : Icons.cloud_off_rounded;

  static IconData get cloudOffOutlined =>
      _isIOS ? CupertinoIcons.wifi_slash : Icons.cloud_off_outlined;

  static IconData get cloudDone =>
      _isIOS ? CupertinoIcons.checkmark_circle : Icons.cloud_done;

  static IconData get downloadRounded =>
      _isIOS ? CupertinoIcons.cloud_download_fill : Icons.download_rounded;

  static IconData get inboxOutlined =>
      _isIOS ? CupertinoIcons.tray : Icons.inbox_outlined;

  static IconData get inboxRounded =>
      _isIOS ? CupertinoIcons.tray_fill : Icons.inbox_rounded;

  static IconData get attachFileRounded =>
      _isIOS ? CupertinoIcons.paperclip : Icons.attach_file_rounded;

  static IconData get insertDriveFile =>
      _isIOS ? CupertinoIcons.doc : Icons.insert_drive_file;

  static IconData get archiveOutlined =>
      _isIOS ? CupertinoIcons.archivebox : Icons.archive_outlined;

  static IconData get attachFile =>
      _isIOS ? CupertinoIcons.paperclip : Icons.attach_file;

  static IconData get pictureAsPdf =>
      _isIOS ? CupertinoIcons.doc : Icons.picture_as_pdf;

  static IconData get pictureAsPdfRounded =>
      _isIOS ? CupertinoIcons.doc_fill : Icons.picture_as_pdf_rounded;

  static IconData get description =>
      _isIOS ? CupertinoIcons.doc_text : Icons.description;

  static IconData get descriptionOutlined =>
      _isIOS ? CupertinoIcons.doc_text : Icons.description_outlined;

  static IconData get brokenImage =>
      _isIOS ? CupertinoIcons.photo : Icons.broken_image;

  static IconData get folderZip =>
      _isIOS ? CupertinoIcons.folder_fill : Icons.folder_zip;

  static IconData get imageRounded =>
      _isIOS ? CupertinoIcons.photo_fill : Icons.image_rounded;

  // ══════════════════════════════════════════════════════════════════════════
  // DOCUMENT & ASSIGNMENT
  // ══════════════════════════════════════════════════════════════════════════

  static IconData get assignment =>
      _isIOS ? CupertinoIcons.doc_text_fill : Icons.assignment;

  static IconData get assignmentOutlined =>
      _isIOS ? CupertinoIcons.doc_text : Icons.assignment_outlined;

  static IconData get assignmentRounded =>
      _isIOS ? CupertinoIcons.doc_text_fill : Icons.assignment_rounded;

  static IconData get assignmentLate =>
      _isIOS ? CupertinoIcons.doc_text : Icons.assignment_late;

  static IconData get assessment =>
      _isIOS ? CupertinoIcons.chart_bar_fill : Icons.assessment;

  static IconData get assessmentOutlined =>
      _isIOS ? CupertinoIcons.chart_bar : Icons.assessment_outlined;

  static IconData get factCheckOutlined =>
      _isIOS ? CupertinoIcons.checkmark_rectangle : Icons.fact_check_outlined;

  static IconData get addTaskRounded =>
      _isIOS ? CupertinoIcons.plus_circle_fill : Icons.add_task_rounded;

  static IconData get tableChart =>
      _isIOS ? CupertinoIcons.table : Icons.table_chart;

  static IconData get feedRounded =>
      _isIOS ? CupertinoIcons.news_solid : Icons.feed_rounded;

  static IconData get listAltRounded =>
      _isIOS ? CupertinoIcons.list_bullet_indent : Icons.list_alt_rounded;

  static IconData get rateReviewOutlined =>
      _isIOS ? CupertinoIcons.star_circle : Icons.rate_review_outlined;

  static IconData get rule =>
      _isIOS ? CupertinoIcons.checkmark_rectangle : Icons.rule;

  static IconData get quiz =>
      _isIOS ? CupertinoIcons.question_circle : Icons.quiz;

  // ══════════════════════════════════════════════════════════════════════════
  // SEARCH, FILTER & REFRESH
  // ══════════════════════════════════════════════════════════════════════════

  static IconData get search => _isIOS ? CupertinoIcons.search : Icons.search;

  static IconData get searchRounded =>
      _isIOS ? CupertinoIcons.search : Icons.search_rounded;

  static IconData get filterList =>
      _isIOS ? CupertinoIcons.line_horizontal_3_decrease : Icons.filter_list;

  static IconData get filterListRounded => _isIOS
      ? CupertinoIcons.line_horizontal_3_decrease
      : Icons.filter_list_rounded;

  static IconData get refresh =>
      _isIOS ? CupertinoIcons.refresh : Icons.refresh;

  static IconData get refreshRounded =>
      _isIOS ? CupertinoIcons.refresh : Icons.refresh_rounded;

  // ══════════════════════════════════════════════════════════════════════════
  // SETTINGS, EDIT & MISC ACTIONS
  // ══════════════════════════════════════════════════════════════════════════

  static IconData get settings => _isIOS ? CupertinoIcons.gear : Icons.settings;

  static IconData get settingsOutlined =>
      _isIOS ? CupertinoIcons.gear : Icons.settings_outlined;

  static IconData get settingsRounded =>
      _isIOS ? CupertinoIcons.gear_solid : Icons.settings_rounded;

  static IconData get tune =>
      _isIOS ? CupertinoIcons.slider_horizontal_3 : Icons.tune;

  static IconData get tuneOutlined =>
      _isIOS ? CupertinoIcons.slider_horizontal_3 : Icons.tune_outlined;

  static IconData get tuneRounded =>
      _isIOS ? CupertinoIcons.slider_horizontal_3 : Icons.tune_rounded;

  static IconData get edit => _isIOS ? CupertinoIcons.pencil : Icons.edit;

  static IconData get editOutlined =>
      _isIOS ? CupertinoIcons.pencil : Icons.edit_outlined;

  static IconData get editRounded =>
      _isIOS ? CupertinoIcons.pencil : Icons.edit_rounded;

  static IconData get editNote =>
      _isIOS ? CupertinoIcons.pencil_outline : Icons.edit_note;

  static IconData get editNoteRounded =>
      _isIOS ? CupertinoIcons.pencil_outline : Icons.edit_note_rounded;

  static IconData get delete => _isIOS ? CupertinoIcons.delete : Icons.delete;

  static IconData get deleteOutline =>
      _isIOS ? CupertinoIcons.delete : Icons.delete_outline;

  static IconData get add => _isIOS ? CupertinoIcons.add : Icons.add;

  static IconData get addCircleOutline =>
      _isIOS ? CupertinoIcons.plus_circled : Icons.add_circle_outline;

  static IconData get translate =>
      _isIOS ? CupertinoIcons.globe : Icons.translate;

  static IconData get language =>
      _isIOS ? CupertinoIcons.globe : Icons.language;

  static IconData get openInNew =>
      _isIOS ? CupertinoIcons.arrow_up_right_square : Icons.open_in_new;

  static IconData get openInNewRounded => _isIOS
      ? CupertinoIcons.arrow_up_right_square_fill
      : Icons.open_in_new_rounded;

  static IconData get link => _isIOS ? CupertinoIcons.link : Icons.link;

  static IconData get loopRounded =>
      _isIOS ? CupertinoIcons.arrow_2_circlepath : Icons.loop_rounded;

  static IconData get flagOutlined =>
      _isIOS ? CupertinoIcons.flag : Icons.flag_outlined;

  // ══════════════════════════════════════════════════════════════════════════
  // CAMERA, PHOTO & IMAGE
  // ══════════════════════════════════════════════════════════════════════════

  static IconData get cameraAlt =>
      _isIOS ? CupertinoIcons.camera : Icons.camera_alt;

  static IconData get cameraAltOutlined =>
      _isIOS ? CupertinoIcons.camera : Icons.camera_alt_outlined;

  static IconData get photoLibrary =>
      _isIOS ? CupertinoIcons.photo_on_rectangle : Icons.photo_library;

  static IconData get image => _isIOS ? CupertinoIcons.photo : Icons.image;

  // ══════════════════════════════════════════════════════════════════════════
  // CHARTS & ANALYTICS
  // ══════════════════════════════════════════════════════════════════════════

  static IconData get analyticsOutlined =>
      _isIOS ? CupertinoIcons.chart_bar : Icons.analytics_outlined;

  static IconData get analyticsDashboard =>
      _isIOS ? CupertinoIcons.graph_square_fill : Icons.insights_rounded;

  static IconData get analyticsProgress =>
      _isIOS ? CupertinoIcons.waveform_path_ecg : Icons.show_chart_rounded;

  static IconData get analyticsPerformance =>
      _isIOS ? CupertinoIcons.speedometer : Icons.speed_rounded;

  static IconData get analyticsReport =>
      _isIOS ? CupertinoIcons.graph_circle_fill : Icons.query_stats_rounded;

  static IconData get monitorHeartOutlined =>
      _isIOS ? CupertinoIcons.waveform_path_ecg : Icons.monitor_heart_outlined;

  // ══════════════════════════════════════════════════════════════════════════
  // MEDIA & EVENTS
  // ══════════════════════════════════════════════════════════════════════════

  static IconData get playCircleRounded =>
      _isIOS ? CupertinoIcons.play_circle_fill : Icons.play_circle_rounded;

  static IconData get emojiEventsRounded =>
      _isIOS ? CupertinoIcons.star_circle_fill : Icons.emoji_events_rounded;

  static IconData get emojiEvents =>
      _isIOS ? CupertinoIcons.star_circle_fill : Icons.emoji_events;

  static IconData get emojiEventsOutlined =>
      _isIOS ? CupertinoIcons.star_circle : Icons.emoji_events_outlined;

  static IconData get autoAwesome =>
      _isIOS ? CupertinoIcons.sparkles : Icons.auto_awesome;

  static IconData get autoAwesomeRounded =>
      _isIOS ? CupertinoIcons.sparkles : Icons.auto_awesome_rounded;

  static IconData get starRounded =>
      _isIOS ? CupertinoIcons.star_fill : Icons.star_rounded;

  static IconData get newspaper =>
      _isIOS ? CupertinoIcons.news_solid : Icons.newspaper;

  static IconData get newspaperOutlined =>
      _isIOS ? CupertinoIcons.news : Icons.newspaper_outlined;

  static IconData get audiotrack =>
      _isIOS ? CupertinoIcons.music_note : Icons.audiotrack;

  static IconData get videocam =>
      _isIOS ? CupertinoIcons.videocam : Icons.videocam;

  static IconData get slideshow =>
      _isIOS ? CupertinoIcons.play_rectangle_fill : Icons.slideshow;

  static IconData get formatQuoteRounded =>
      _isIOS ? CupertinoIcons.quote_bubble : Icons.format_quote_rounded;

  // ══════════════════════════════════════════════════════════════════════════
  // LOCATION
  // ══════════════════════════════════════════════════════════════════════════

  static IconData get locationOnOutlined =>
      _isIOS ? CupertinoIcons.location : Icons.location_on_outlined;

  // ══════════════════════════════════════════════════════════════════════════
  // NETWORK
  // ══════════════════════════════════════════════════════════════════════════

  static IconData get wifiOffRounded =>
      _isIOS ? CupertinoIcons.wifi_slash : Icons.wifi_off_rounded;

  // ══════════════════════════════════════════════════════════════════════════
  // FORM CONTROLS
  // ══════════════════════════════════════════════════════════════════════════

  static IconData get radioButtonChecked => _isIOS
      ? CupertinoIcons.checkmark_circle_fill
      : Icons.radio_button_checked;

  static IconData get radioButtonOff =>
      _isIOS ? CupertinoIcons.circle : Icons.radio_button_off;

  // ══════════════════════════════════════════════════════════════════════════
  // VOLUNTEER & CHARITY
  // ══════════════════════════════════════════════════════════════════════════

  static IconData get volunteerActivismOutlined =>
      _isIOS ? CupertinoIcons.heart : Icons.volunteer_activism_outlined;

  // ══════════════════════════════════════════════════════════════════════════
  // MEDICAL
  // ══════════════════════════════════════════════════════════════════════════

  static IconData get bloodtypeRounded =>
      _isIOS ? CupertinoIcons.drop_fill : Icons.bloodtype_rounded;

  // ══════════════════════════════════════════════════════════════════════════
  // LOADING & PROGRESS
  // ══════════════════════════════════════════════════════════════════════════

  static IconData get hourglassTop =>
      _isIOS ? CupertinoIcons.hourglass : Icons.hourglass_top;

  static IconData get aiAssistantOutlined =>
      _isIOS ? CupertinoIcons.gear : Icons.psychology;

  // ══════════════════════════════════════════════════════════════════════════
  // Ai Assitant Icons
  // ══════════════════════════════════════════════════════════════════════════

  static IconData get apartmentRounded =>
      _isIOS ? CupertinoIcons.building_2_fill : Icons.apartment_rounded;

  static IconData get circle =>
      _isIOS ? CupertinoIcons.circle_fill : Icons.circle;

  static IconData get aiSparkleFilled =>
      _isIOS ? CupertinoIcons.sparkles : Icons.auto_awesome_outlined;

  static IconData get aiSparkle =>
      _isIOS ? CupertinoIcons.sparkles : Icons.auto_awesome;

  static IconData get menuBookRounded =>
      _isIOS ? CupertinoIcons.book_fill : Icons.menu_book_rounded;

  static IconData get descriptionRounded =>
      _isIOS ? CupertinoIcons.doc_text_fill : Icons.description_rounded;

  // Add to AppIcons class:
  static IconData get addRounded =>
      _isIOS ? CupertinoIcons.add_circled : Icons.add_rounded;

  static IconData get deleteOutlineRounded =>
      _isIOS ? CupertinoIcons.delete : Icons.delete_outline_rounded;

  static IconData get healingRounded =>
      _isIOS ? CupertinoIcons.bandage_fill : Icons.healing_rounded;

  static IconData get keyboardArrowDownRounded =>
      _isIOS ? CupertinoIcons.chevron_down : Icons.keyboard_arrow_down_rounded;

  static IconData get quizRounded =>
      _isIOS ? CupertinoIcons.question_circle_fill : Icons.quiz_rounded;

  static IconData get swipeLeftRounded =>
      _isIOS ? CupertinoIcons.arrow_left_circle : Icons.swipe_left_rounded;

  static IconData get translateRounded =>
      _isIOS ? CupertinoIcons.globe : Icons.translate_rounded;

  // AI Assistant
  // Lesson plan

  static IconData get eventOutlined =>
      _isIOS ? CupertinoIcons.calendar : Icons.event_outlined;

  static IconData get articleOutlined =>
      _isIOS ? CupertinoIcons.doc_text : Icons.article_outlined;

  static IconData get barChart =>
      _isIOS ? CupertinoIcons.doc_text : Icons.article_outlined;

  static IconData get articleRounded =>
      _isIOS ? CupertinoIcons.doc_text_fill : Icons.article_rounded;
  static IconData get pushPin =>
      _isIOS ? CupertinoIcons.pin_fill : Icons.push_pin;
  static IconData get notificationsActiveRounded =>
      _isIOS ? CupertinoIcons.bell_fill : Icons.notifications_active_rounded;
  static IconData get topicOutline =>
      _isIOS ? CupertinoIcons.square_list : Icons.topic_outlined;
  static IconData get historyRounded =>
      _isIOS ? CupertinoIcons.clock : Icons.history_rounded;
  static IconData get groupsOutlined =>
      _isIOS ? CupertinoIcons.person_3_fill : Icons.groups_outlined;
  static IconData get keyboardArrowUpRounded =>
      _isIOS ? CupertinoIcons.chevron_up : Icons.keyboard_arrow_up_rounded;
  static IconData get lightBulbOutlineRounded =>
      _isIOS ? CupertinoIcons.lightbulb : Icons.lightbulb_outline_rounded;
  static IconData get gradeOutline =>
      _isIOS ? CupertinoIcons.star : Icons.grade_outlined;
  static IconData get hourglassEmptyRounded =>
      _isIOS ? CupertinoIcons.hourglass : Icons.hourglass_empty_rounded;

  static IconData get sendRounded =>
      _isIOS ? CupertinoIcons.paperplane : Icons.send_rounded;

  // Ai Assistant
  //Analytics
  static IconData get trendingUpRounded =>
      _isIOS ? CupertinoIcons.graph_square_fill : Icons.trending_up_rounded;

  static IconData get insertChartOutlinedRounded =>
      _isIOS ? CupertinoIcons.chart_bar : Icons.insert_chart_outlined_rounded;

  static IconData get touchAppRounded =>
      _isIOS ? CupertinoIcons.hand_raised_fill : Icons.touch_app_rounded;

  static IconData get notificationOffOutlined =>
      _isIOS ? CupertinoIcons.bell_slash : Icons.notifications_off_outlined;

  static IconData get copyRounded =>
      _isIOS ? CupertinoIcons.doc_on_doc : Icons.copy_rounded;

  static IconData get phoneOutlined =>
      _isIOS ? CupertinoIcons.phone : Icons.phone_outlined;

  static IconData get workspacePremiumRounded => _isIOS
      ? CupertinoIcons.star_circle_fill
      : Icons.workspace_premium_rounded;

  static IconData get analyticsRounded =>
      _isIOS ? CupertinoIcons.chart_bar_fill : Icons.analytics_rounded;

  static IconData get barChartRounded =>
      _isIOS ? CupertinoIcons.chart_bar_fill : Icons.bar_chart_rounded;

  static IconData get eventAvailableOutlined => _isIOS
      ? CupertinoIcons.calendar_badge_plus
      : Icons.event_available_outlined;

  static IconData get searchOffRounded =>
      _isIOS ? CupertinoIcons.search : Icons.search_off_rounded;

  static IconData get assignmentTurnedInOutlined => _isIOS
      ? CupertinoIcons.checkmark_square
      : Icons.assignment_turned_in_outlined;

  static IconData get phoneIphoneRounded => _isIOS
      ? CupertinoIcons.device_phone_portrait
      : Icons.phone_iphone_rounded;

  static IconData get smsOutlined =>
      _isIOS ? CupertinoIcons.chat_bubble : Icons.sms_outlined;

  static IconData get callRounded =>
      _isIOS ? CupertinoIcons.phone : Icons.call_rounded;

  static IconData get thumbUpAltOutlined =>
      _isIOS ? CupertinoIcons.hand_thumbsup : Icons.thumb_up_alt_outlined;

  static IconData get showChartRounded =>
      _isIOS ? CupertinoIcons.chart_bar_alt_fill : Icons.show_chart_rounded;

  static IconData get leaderboardOutlined =>
      _isIOS ? CupertinoIcons.chart_bar : Icons.leaderboard_outlined;

  static IconData get sortRounded =>
      _isIOS ? CupertinoIcons.sort_down : Icons.sort_rounded;

  static IconData get arrowForwardIosRounded =>
      _isIOS ? CupertinoIcons.chevron_right : Icons.arrow_forward_ios_rounded;

  static IconData get arrowBackIosNewRounded =>
      _isIOS ? CupertinoIcons.chevron_left : Icons.arrow_back_ios_new_rounded;

  static IconData get formatBold =>
      _isIOS ? CupertinoIcons.bold : Icons.format_bold;

  static IconData get formatItalic =>
      _isIOS ? CupertinoIcons.italic : Icons.format_italic;

  static IconData get formatUnderline =>
      _isIOS ? CupertinoIcons.underline : Icons.format_underline;

  static IconData get formatListNumbered =>
      _isIOS ? CupertinoIcons.list_number : Icons.format_list_numbered;

  static IconData get formatListBulleted =>
      _isIOS ? CupertinoIcons.list_bullet : Icons.format_list_bulleted;

  static IconData get formatQuote =>
      _isIOS ? CupertinoIcons.text_quote : Icons.format_quote;

  static IconData get code =>
      _isIOS ? CupertinoIcons.chevron_left_slash_chevron_right : Icons.code;

  static IconData get formatClear =>
      _isIOS ? CupertinoIcons.clear_fill : Icons.format_clear;

  static IconData get formatStrikethrough =>
      _isIOS ? CupertinoIcons.strikethrough : Icons.format_strikethrough;

  static IconData get lockOutlined =>
      _isIOS ? CupertinoIcons.lock : Icons.lock_outline_rounded;

  static IconData get pinchOutlined => _isIOS
      ? CupertinoIcons.arrow_up_left_arrow_down_right
      : Icons.pinch_outlined;

  // ── Save / confirm ──────────────────────────────────────────
  static IconData get save =>
      _isIOS ? CupertinoIcons.checkmark_circle_fill : Icons.save_rounded;

  static IconData get darkMode =>
      _isIOS ? CupertinoIcons.moon_fill : Icons.dark_mode;

  static IconData get lightMode =>
      _isIOS ? CupertinoIcons.sun_max_fill : Icons.light_mode;
  static IconData get keyboardArrowUp =>
      _isIOS ? CupertinoIcons.sun_max_fill : Icons.light_mode;

  static IconData get remedialAssessmentIcon =>
      _isIOS ? CupertinoIcons.arrow_counterclockwise : Icons.replay_rounded;
  static IconData get appUsageIcon =>
      _isIOS ? CupertinoIcons.app : Icons.apps_rounded;
  static IconData get unattendedScore =>
      _isIOS ? CupertinoIcons.person_crop_circle_badge_xmark : Icons.person_off;

  static IconData get percentOutlined =>
      _isIOS ? CupertinoIcons.percent : Icons.percent_outlined;

  static IconData get categoryOutlined =>
      _isIOS ? CupertinoIcons.square_grid_2x2 : Icons.category_outlined;

  static IconData get currencyRupeeRounded => Icons.currency_rupee_rounded;
  static IconData get creditCardRounded =>
      _isIOS ? CupertinoIcons.creditcard_fill : Icons.payment_rounded;
  static IconData get paymentApprovalIcon =>
      _isIOS ? CupertinoIcons.checkmark_seal_fill : Icons.approval_rounded;
  static IconData get qrCode2Rounded =>
      _isIOS ? CupertinoIcons.qrcode : Icons.qr_code_2_rounded;
  static IconData get phoneAndroidRounded => _isIOS
      ? CupertinoIcons.device_phone_portrait
      : Icons.phone_android_rounded;

  static IconData get accountBalanceWalletRounded => _isIOS
      ? CupertinoIcons.creditcard_fill
      : Icons.account_balance_wallet_rounded;

  static IconData get discountIcon =>
      _isIOS ? CupertinoIcons.tag : Icons.discount;

  static IconData get moreVert => Icons.more_vert_rounded;

  static IconData get receiptLongOutlined =>
      _isIOS ? CupertinoIcons.doc_plaintext : Icons.receipt_long_outlined;

  static IconData get discountReportOutlined =>
      _isIOS ? CupertinoIcons.percent : Icons.percent;

  static IconData get excelExportRounded =>
      _isIOS ? CupertinoIcons.square_grid_2x2 : Icons.table_chart_rounded;

  static IconData get removeRounded =>
      _isIOS ? CupertinoIcons.minus : Icons.remove_rounded;

  static IconData get bookmarkBorder =>
      _isIOS ? CupertinoIcons.bookmark : Icons.bookmark_border_rounded;

  static IconData get bookmark =>
      _isIOS ? CupertinoIcons.bookmark_fill : Icons.bookmark_rounded;

  static IconData get trendingDownRounded =>
      _isIOS ? CupertinoIcons.graph_square_fill : Icons.trending_down_rounded;
}
