const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.responseFriendRequest = functions.https.onCall(async (data, context) => {
    const id = data.id;
    const accepted = data.accepted;

    const userUid = context.auth.uid;

    if (!userUid) {
        return {
            message: 'User is not logged in!'
        };
    }

    const doc = await admin.firestore().collection('cl_requests').doc(id).get();

    if (doc.exists) {
        const docData = doc.data();

        if (accepted === true) {

            const from = await admin.firestore().collection('cl_users').doc(docData.from).get();

            const to = await admin.firestore().collection('cl_users').doc(docData.to).get();

            const created_at = admin.firestore.FieldValue.serverTimestamp();

            await admin.firestore()
                .collection('cl_users')
                .doc(from.id)
                .collection('cl_friends')
                .doc(to.id)
                .set({ created_at });

            await admin.firestore()
                .collection('cl_users')
                .doc(to.id)
                .collection('cl_friends')
                .doc(from.id)
                .set({ created_at });

            const fromData = from.data();

            if (String(fromData.token).length > 0) {

                const toData = to.data();

                const notification = {
                    title: 'Friend Request Accepted',
                    body: `${toData.name} accepted your friend request!`,
                };

                const message = {
                    notification,
                    data: {
                        sender: to.id,
                        title: 'Friend Request Accepted',
                        body: `${toData.name} accepted your friend request!`,
                    },
                };

                await admin.messaging().sendToDevice(
                    fromData.token,
                    message,
                    {
                        contentAvailable: true,
                        priority: 'high'
                    },
                );

            }

        } 

        await admin.firestore().collection('cl_requests').doc(id).delete();

        return {
            message: 'Done!'
        };

    }
});

exports.friendRequest = functions.https.onCall(async (data, context) => {
    const friendUid = data.uid;
    const userUid = context.auth.uid;

    if (!userUid) {
        return {
            message: 'User is not logged in!'
        };
    }

    if (friendUid) {

        const doc = await admin.firestore()
            .collection('cl_requests')
            .where('from', '==', userUid)
            .where('to', '==', friendUid)
            .get();

        if (doc.size > 0) {
            return {
                message: 'Friend request already exists!'
            };
        }

        const document = {
            from: userUid,
            to: friendUid,
            created_at: admin.firestore.FieldValue.serverTimestamp(),
        };

        await admin.firestore().collection('cl_requests').add(document);

        const query = await admin.firestore().collection('cl_users').doc(friendUid).get();

        if (query.exists) {
            const friendData = query.data();

            if (String(friendData.token).length > 0) {

                const notification = {
                    title: 'Friend Request',
                    body: `${friendData.name} wants to be your friend!`,
                };

                const message = {
                    notification,
                    data: {
                        sender: userUid,
                        title: 'Friend Request',
                        body: `${friendData.name} wants to be your friend!`,
                    },
                };

                await admin.messaging().sendToDevice(
                    friendData.token,
                    message,
                    {
                        contentAvailable: true,
                        priority: 'high'
                    },
                );

            }

        }
    }

    return {
        message: 'Friend request sent successfully!'
    };
});