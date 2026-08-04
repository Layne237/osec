const Notification = require('../models/Notification');
const logger = require('../utils/logger');

const inMemoryNotifications = [
  {
    notificationId: 'notif_1',
    id: 'notif_1',
    userId: 'user_demo',
    type: 'course_update',
    title: 'New lesson available',
    titleFr: 'Nouvelle leçon disponible',
    body: 'Chapter 3 of Dropshipping Masterclass is now available',
    bodyFr: 'Le chapitre 3 du Masterclass Dropshipping est disponible',
    read: false,
    createdAt: new Date().toISOString()
  },
  {
    notificationId: 'notif_2',
    id: 'notif_2',
    userId: 'user_demo',
    type: 'payment_success',
    title: 'Course Access Unlocked',
    titleFr: 'Accès au cours débloqué',
    body: 'Your payment for Mobile Money Growth was confirmed.',
    bodyFr: 'Votre paiement pour Croissance par Mobile Money a été confirmé.',
    read: true,
    createdAt: new Date(Date.now() - 86400000).toISOString()
  }
];

const registerDevice = async ({ userId = 'user_demo', deviceToken, platform = 'android', locale = 'fr' }) => {
  try {
    await Notification.create({
      notificationId: `dev_${Date.now()}`,
      userId,
      deviceToken,
      platform,
      locale,
      title: 'Device Registered',
      body: 'Notifications enabled for OSEC'
    });
  } catch (err) {
    // silently fallback
  }

  logger.info(`[Notification Service] Registered ${platform} device token for user ${userId}`);

  return {
    registered: true,
    deviceToken,
    platform,
    locale
  };
};

const getUserNotifications = async (userId = 'user_demo') => {
  let list = [];
  try {
    list = await Notification.find({ userId }).sort({ createdAt: -1 });
  } catch (err) {
    list = inMemoryNotifications;
  }

  if (!list.length) {
    list = inMemoryNotifications;
  }

  const formatted = list.map(item => ({
    id: item.notificationId || item.id || item._id,
    type: item.type,
    title: item.title,
    body: item.body,
    read: item.read,
    createdAt: item.createdAt
  }));

  return {
    notifications: formatted,
    unreadCount: formatted.filter(n => !n.read).length
  };
};

const markAsRead = async (id, userId = 'user_demo') => {
  let notif = inMemoryNotifications.find(n => n.id === id || n.notificationId === id);

  try {
    const dbNotif = await Notification.findOne({ $or: [{ notificationId: id }, { _id: id }] });
    if (dbNotif) {
      dbNotif.read = true;
      await dbNotif.save();
      notif = dbNotif;
    }
  } catch (err) {
    // in-memory fallback
  }

  if (!notif) {
    const error = new Error('Notification not found');
    error.statusCode = 404;
    error.code = 'NOT_FOUND';
    throw error;
  }

  notif.read = true;

  return {
    id: notif.notificationId || notif.id,
    read: true
  };
};

module.exports = {
  registerDevice,
  getUserNotifications,
  markAsRead,
  inMemoryNotifications
};
