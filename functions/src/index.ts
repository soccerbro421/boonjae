/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// import * as functions from "firebase-functions";
import * as v2 from "firebase-functions/v2";
const {onCall} = require("firebase-functions/v2/https");
const {onSchedule} = require("firebase-functions/v2/scheduler");
const {logger} = require("firebase-functions");
const messaging = require("firebase-admin/messaging");
import * as admin from "firebase-admin";

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
});


exports.dailyEcouragementMessage = onSchedule("30 17 * * *", async (event : any) => {
  // Fetch all user details.

  try {
    const currentDayOfWeek = new Date().getDay();

    // Get the corresponding day name
    const dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
    const currentDayName = dayNames[currentDayOfWeek];

    const message = {
      notification: {
          title: "Let's try our habits!",
          body: "Do that thing you wanted to do :D",
      },
      topic: currentDayName,
    };

    await messaging.getMessaging().send(message);

    logger.log("Send todays message! :D");
  } catch (error) {
    console.error("Error:", error);
    throw new v2.https.HttpsError("internal", "Something bad");
  }

  
});

export const removeFriend = onCall(
  {
    enforceAppCheck: true, // Reject requests with missing or invalid App Check tokens.
  },
  async (request: any) => {
    try {
      const uid1 = request.data.uid1;
      const uid2 = request.data.uid2;

      // Check if the request is authenticated
      // if (!request.auth) {
      //   throw new v2.https.HttpsError(
      //     "unauthenticated",
      //     "Authentication required."
      //   );
      // }

      // Get references to the user documents
      const user1Ref = admin.firestore().collection("users").doc(uid1);
      const user2Ref = admin.firestore().collection("users").doc(uid2);

      // Get the friend lists of both users
      const user1 = await user1Ref.get();
      const user2 = await user2Ref.get();

      if (!user1.exists || !user2.exists) {
        throw new v2.https.HttpsError(
          "not-found",
          "One or both users not found."
        );
      }

      // Remove the friends from each other's friend lists
      const user1Friends = user1.data()?.friends || [];
      const user2Friends = user2.data()?.friends || [];

      const updatedUser1Friends = user1Friends.
        filter((friendId: string) => friendId !== uid2);
      const updatedUser2Friends = user2Friends.
        filter((friendId: string) => friendId !== uid1);

      // Update the friend lists in Firestore
      await user1Ref.update({ friends: updatedUser1Friends });
      await user2Ref.update({ friends: updatedUser2Friends });

      return { success: true };
    } catch (error) {
      console.error("Error:", error);
      throw new v2.https.HttpsError("internal", "Something bad");
    }
  });

export const addFriend = onCall(
  {
    enforceAppCheck: true, // Reject requests with missing or invalid App Check tokens.
  },
  async (request: any) => {

    try {

      const uid1 = request.data.uid1;
      const uid2 = request.data.uid2;

      // Check if the request is authenticated
      // if (!request.auth) {
      //   throw new v2.https.HttpsError(
      //     "unauthenticated",
      //     "Authentication required."
      //   );
      // }

      // Get references to the user documents
      const user1Ref = admin.firestore().collection("users").doc(uid1);
      const user2Ref = admin.firestore().collection("users").doc(uid2);

      // Get the friend lists of both users
      const user1 = await user1Ref.get();
      const user2 = await user2Ref.get();

      if (!user1.exists || !user2.exists) {
        throw new v2.https.HttpsError(
          "not-found",
          "One or both users not found."
        );
      }

      // Add the friends to each other's friend lists
      const user1Friends = user1.data()?.friends || [];
      const user2Friends = user2.data()?.friends || [];

      const updatedUser1Friends = [...user1Friends, uid2];
      const updatedUser2Friends = [...user2Friends, uid1];

      // Update the friend lists in Firestore
      await user1Ref.update({ friends: updatedUser1Friends });
      await user2Ref.update({ friends: updatedUser2Friends });


      // send notification to second user
      const user2TokenSnapshot = await admin.firestore().collection("users").doc(uid2).collection("tokens").get();
        
        if (!user2TokenSnapshot.empty) {
            const user2Token = user2TokenSnapshot.docs[0].data().token;

            // Construct the message payload
            const message = {
                notification: {
                    title: "New Friend Added",
                    body: "You have a new friend on Boonjae!",
                },
                token: user2Token,
            };
      
            await messaging.getMessaging().send(message);

            // Send the FCM notification
            // await admin.messaging().send;
        }

      return { success: true };
    } catch (error) {
      console.error("Error:", error);
      throw new v2.https.HttpsError("internal", "Something went wrong.");
    }
  });

  export const createFriendRequest = onCall(
    {
      enforceAppCheck: true, // Reject requests with missing or invalid App Check tokens.
    },
    async (request: any) => {
      try {
        const requestorUid = request.data.requestorUid;
        const requesteeUid = request.data.requesteeUid;
  
        // Check if the requestor and requestee are different
        if (requestorUid === requesteeUid) {
          throw new v2.https.HttpsError(
            "invalid-argument",
            "Requestor and requestee cannot be the same user."
          );
        }
  

        // Create or update the friend request document
        const requestId = admin.firestore().collection('friendRequests').doc().id;
        const friendRequestRef = admin.firestore().collection('friendRequests').doc(requestId);
  
        await friendRequestRef.set({
          from: requestorUid,
          to: requesteeUid,
          status: 'PENDING',
        });
  
        // send notification to requestee
        const requesteeTokenSnapshot = await admin.firestore().collection("users").doc(requesteeUid).collection("tokens").get();
  
        if (!requesteeTokenSnapshot.empty) {
          const requesteeToken = requesteeTokenSnapshot.docs[0].data().token;
  
          // Construct the message payload
          const message = {
            notification: {
              title: "New Friend Request",
              body: "You have a new friend request on Boonjae!",
            },
            token: requesteeToken,
          };
  
          await messaging.getMessaging().send(message);
        }
  
        return { success: true };
      } catch (error) {
        console.error("Error:", error);
        throw new v2.https.HttpsError("internal", "Something went wrong.");
      }
    }
  );
  

export const blockUser = onCall(
  {
    enforceAppCheck: true, // Reject requests with missing or invalid App Check tokens.
  },
  async (request: any) => {
    try {

      const blockerUid = request.data.blockerUid;
      const blockedUid = request.data.blockedUid;

      // remove friends
      const user1Ref = admin.firestore().collection("users").doc(blockerUid);
      const user2Ref = admin.firestore().collection("users").doc(blockedUid);

      // Get the friend lists of both users
      const user1 = await user1Ref.get();
      const user2 = await user2Ref.get();

      if (!user1.exists || !user2.exists) {
        throw new v2.https.HttpsError(
          "not-found",
          "One or both users not found."
        );
      }
      // Remove the friends from each other's friend lists
      const user1Friends = user1.data()?.friends || [];
      const user2Friends = user2.data()?.friends || [];

      const updatedUser1Friends = user1Friends.
        filter((friendId: string) => friendId !== blockedUid);
      const updatedUser2Friends = user2Friends.
        filter((friendId: string) => friendId !== blockerUid);

      // Update the friend lists in Firestore
      await user1Ref.update({ friends: updatedUser1Friends });
      await user2Ref.update({ friends: updatedUser2Friends });

      // Check if the request is authenticated
      // if (!context.auth) {
      //   throw new v2.https.HttpsError(
      //     "unauthenticated",
      //     "Authentication required."
      //   );
      // }

      // Get references to the user documents
      // block users
      const blockerUserRef = admin
        .firestore()
        .collection("users")
        .doc(blockerUid);
      const blockedUserRef = admin
        .firestore()
        .collection("users")
        .doc(blockedUid);

      await blockerUserRef
        .collection("usersIBlocked")
        .doc(blockedUid)
        .set({
          val: true,
        });

      await blockedUserRef
        .collection("usersBlockedMe")
        .doc(blockerUid)
        .set({
          val: true,
        });

      return { success: true };
    } catch (error) {
      console.error("Error:", error);
      throw new v2.https.HttpsError("internal", "Something went wrong.");
    }
  });

export const unblockUser = onCall(
  {
    enforceAppCheck: true, // Reject requests with missing or invalid App Check tokens.
  },
  async (request: any) => {
    try {
      const unblockerUid = request.data.unblockerUid;
      const unblockedUid = request.data.unblockedUid;

      // Check if the request is authenticated
      // if (!context.auth) {
      //   throw new v2.https.HttpsError(
      //     "unauthenticated",
      //     "Authentication required."
      //   );
      // }

      // Get references to the user documents
      const unblockerUserRef = admin.
        firestore().
        collection("users").
        doc(unblockerUid);
      const unblockedUserRef = admin
        .firestore()
        .collection("users")
        .doc(unblockedUid);
      await unblockerUserRef
        .collection("usersIBlocked")
        .doc(unblockedUid)
        .delete();
      await unblockedUserRef
        .collection("usersBlockedMe")
        .doc(unblockerUid)
        .delete();

      return { success: true };
    } catch (error) {
      console.error("Error:", error);
      throw new v2.https.HttpsError("internal", "Something went wrong.");
    }
  });

// export const helloWorld = onRequest((request, response) => {
//     // debugger;
//     logger.info("Hello logs!", { structuredData: true });
//     response.send("Hello from Firebase!");
// });
