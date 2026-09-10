import 'package:flutter/material.dart';

enum MessageCategory {
  places,
  food,
  schedule,
  walking,
  budget,
  transportation,
  activities,
  general,
}

class ChatMessage {
  final String id;
  final String senderName;
  final String? senderAvatar;
  final bool isMe;
  final String text;
  final String timestamp;
  final MessageCategory category;
  final String categoryLabel;
  final String categoryIcon;
  bool isSavedToNotebook;

  ChatMessage({
    required this.id,
    required this.senderName,
    this.senderAvatar,
    required this.isMe,
    required this.text,
    required this.timestamp,
    required this.category,
    required this.categoryLabel,
    required this.categoryIcon,
    this.isSavedToNotebook = false,
  });
}

class NotebookItem {
  final String id;
  final ChatMessage originalMessage;
  String structuredTitle;
  String category;
  String categoryIcon;
  Color badgeColor;
  final String contributorName;
  final String timestamp;
  String? userNotes;

  NotebookItem({
    required this.id,
    required this.originalMessage,
    required this.structuredTitle,
    required this.category,
    required this.categoryIcon,
    required this.badgeColor,
    required this.contributorName,
    required this.timestamp,
    this.userNotes,
  });
}

class ItineraryStop {
  final String time;
  final String name;
  final String category;
  final String notes;
  final String distance;
  final bool isHighlight;

  ItineraryStop({
    required this.time,
    required this.name,
    required this.category,
    required this.notes,
    required this.distance,
    this.isHighlight = false,
  });
}

class ItineraryDay {
  final int dayNumber;
  final String date;
  final String summary;
  final String walkingEstimate;
  final List<ItineraryStop> stops;

  ItineraryDay({
    required this.dayNumber,
    required this.date,
    required this.summary,
    required this.walkingEstimate,
    required this.stops,
  });
}

class ChatConversation {
  final String id;
  final String name;
  final String destination;
  final bool isGroup;
  final int memberCount;
  final String lastMessage;
  final String timestamp;
  final int unreadCount;
  final String avatarLetter;
  final Color avatarColor;
  final List<ChatMessage> messages;
  final List<NotebookItem> notebookItems;
  final List<ItineraryDay> itinerary;

  ChatConversation({
    required this.id,
    required this.name,
    required this.destination,
    required this.isGroup,
    required this.memberCount,
    required this.lastMessage,
    required this.timestamp,
    required this.unreadCount,
    required this.avatarLetter,
    required this.avatarColor,
    required this.messages,
    required this.notebookItems,
    required this.itinerary,
  });
}

class PlanningTopic {
  final String key;
  final String title;
  final bool isDiscussed;
  final String? suggestedMessage;

  const PlanningTopic({
    required this.key,
    required this.title,
    required this.isDiscussed,
    this.suggestedMessage,
  });
}

class ChatDragPayload {
  final List<ChatMessage> messages;
  final bool isBunch;

  const ChatDragPayload({
    required this.messages,
    this.isBunch = false,
  });

  factory ChatDragPayload.single(ChatMessage msg) =>
      ChatDragPayload(messages: [msg], isBunch: false);

  factory ChatDragPayload.bunch(List<ChatMessage> msgs) =>
      ChatDragPayload(messages: msgs, isBunch: true);

  int get count => messages.length;
}

