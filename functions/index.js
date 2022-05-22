const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

const firestore = admin.firestore();

const messaging = admin.messaging();

exports.notifyFriendRequest = functions.firestore.document('cl_requests/{docId}').onCreate(async (snapshot, context) => {
    const snap = snapshot.data();

    const to = (await firestore.collection('cl_users').doc(snap.to).get()).data();

    if (to.token !== '') {

        const from = (await firestore.collection('cl_users').doc(snap.from).get()).data();

        const notification = {
            title: 'Friend Request',
            body: `${from.name} sent you a friend request!`
        };

        const data = {
            sender: snap.from,
            time: JSON.stringify(snap.created_at)
        };

        const message = {
            notification,
            data,
        };

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
                body: `${to.name} accepted your friend request!`
            };

            const data = {
                sender: after.to,
                time: JSON.stringify(after.updated_at)
            };

            const message = {
                notification,
                data,
            };

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