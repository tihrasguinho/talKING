const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

const firestore = admin.firestore();

const messaging = admin.messaging();

exports.notifyNewMessage = functions.firestore.document('cl_messages/{docId}').onCreate(async (snapshot, context) => {
    const data = snapshot.data();

    const to = (await firestore.collection('cl_users').doc(data.to).get()).data();

    if (to.token !== '') {

        const from = (await firestore.collection('cl_users').doc(data.from).get()).data();

        const type = data.type;

        const notification = {
            title: from.name,
            body: type === 'text' ? data.message : type === 'image' ? 'Image' : type === 'audio' ? 'Audio' : 'Video',
            image: from.image,
        };

        const payload = {
            notification: JSON.stringify(notification),
            message: JSON.stringify(data),
            type: 'new_message'
        };

        const message = {
            data: payload,
        };

        const options = {
            contentAvailable: true,
            priority: 'high'
        };

        await messaging.sendToDevice(to.token, message, options);

    }
});

exports.notifyFriendRequest = functions.firestore.document('cl_requests/{docId}').onCreate(async (snapshot, context) => {
    const snap = snapshot.data();

    const to = (await firestore.collection('cl_users').doc(snap.to).get()).data();

    if (to.token !== '') {

        const from = (await firestore.collection('cl_users').doc(snap.from).get()).data();

        const notification = {
            title: 'Friend Request',
            body: `${from.name} sent you a friend request!`,
            image: from.image,
        };

        const data = { 
            notification: JSON.stringify(notification),
            type: 'friend_request'
         };

        const message = { data };

        await messaging.sendToDevice(
            to.token,
            message,
            {
                contentAvailable: true,
                priority: 'high'
            },
        );

    }
});

exports.notifyFriendRequestResponse = functions.firestore.document('cl_requests/{docId}').onUpdate(async (snapshot, context) => {
    const after = snapshot.after.data();

    if (after.status === 'accepted') {

        const from = (await firestore.collection('cl_users').doc(after.from).get()).data();

        await firestore.collection('cl_users').doc(after.from).collection('cl_friends').doc(after.to).set({ created_at: after.updated_at });

        await firestore.collection('cl_users').doc(after.to).collection('cl_friends').doc(after.from).set({ created_at: after.updated_at });

        if (from.token !== '') {

            const to = (await firestore.collection('cl_users').doc(after.to).get()).data();

            const notification = {
                title: 'Friend Accepted',
                body: `${to.name} accepted your friend request!`,
                image: to.image,
            };

            const data = {
                notification: JSON.stringify(notification),
                type: 'friend_accepted'
            };

            const message = { data };

            await messaging.sendToDevice(
                from.token,
                message,
                {
                    contentAvailable: true,
                    priority: 'high'
                },
            );

        }

    }

    await firestore.collection('cl_requests').doc(context.params.docId).delete();
});