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

import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const removeFriend = functions.https.onCall(async (data, context) => {
    try {
      const { uid1, uid2 } = data;
  
      // Check if the request is authenticated
      if (!context.auth) {
        throw new functions.https.HttpsError(
          "unauthenticated",
          "Authentication required."
        );
      }
  
      // Get references to the user documents
      const user1Ref = admin.firestore().collection("users").doc(uid1);
      const user2Ref = admin.firestore().collection("users").doc(uid2);
  
      // Get the friend lists of both users
      const user1 = await user1Ref.get();
      const user2 = await user2Ref.get();
  
      if (!user1.exists || !user2.exists) {
        throw new functions.https.HttpsError(
          "not-found",
          "One or both users not found."
        );
      }
  
      // Remove the friends from each other's friend lists
      const user1Friends = user1.data()?.friends || [];
      const user2Friends = user2.data()?.friends || [];
  
      const updatedUser1Friends = user1Friends.filter((friendId: string) => friendId !== uid2);
      const updatedUser2Friends = user2Friends.filter((friendId: string) => friendId !== uid1);
  
      // Update the friend lists in Firestore
      await user1Ref.update({ friends: updatedUser1Friends });
      await user2Ref.update({ friends: updatedUser2Friends });
  
      return { success: true };
    } catch (error) {
      console.error("Error:", error);
      throw new functions.https.HttpsError("internal", "Something went wrong.");
    }
  });


  export const addFriend = functions.https.onCall(async (data, context) => {
    try {
      const { uid1, uid2 } = data;
  
      // Check if the request is authenticated
      if (!context.auth) {
        throw new functions.https.HttpsError(
          "unauthenticated",
          "Authentication required."
        );
      }
  
      // Get references to the user documents
      const user1Ref = admin.firestore().collection("users").doc(uid1);
      const user2Ref = admin.firestore().collection("users").doc(uid2);
  
      // Get the friend lists of both users
      const user1 = await user1Ref.get();
      const user2 = await user2Ref.get();
  
      if (!user1.exists || !user2.exists) {
        throw new functions.https.HttpsError(
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
  
      return { success: true };
    } catch (error) {
      console.error("Error:", error);
      throw new functions.https.HttpsError("internal", "Something went wrong.");
    }
  });


  export const blockUser = functions.https.onCall(async (data, context) => {
    try {
      const { blockerUid, blockedUid } = data;
  
      // Check if the request is authenticated
      if (!context.auth) {
        throw new functions.https.HttpsError(
          "unauthenticated",
          "Authentication required."
        );
      }
  
      // Get references to the user documents
      const blockerUserRef = admin.firestore().collection("users").doc(blockerUid);
      const blockedUserRef = admin.firestore().collection("users").doc(blockedUid);
  
      // Create 'private' collection for blocker user and add blocked user to 'usersIBlocked'
      // Create 'usersIBlocked' subcollection for blocker user and add blocked user
      await blockerUserRef.collection("usersIBlocked").doc(blockedUid).set({
        val: true,
    });

    // Create 'usersBlockedMe' subcollection for blocked user and add blocker user
    await blockedUserRef.collection("usersBlockedMe").doc(blockerUid).set({
        val: true,
    });
  
      return { success: true };
    } catch (error) {
      console.error("Error:", error);
      throw new functions.https.HttpsError("internal", "Something went wrong.");
    }
});

export const unblockUser = functions.https.onCall(async (data, context) => {
  try {
    const { unblockerUid, unblockedUid } = data;

    // Check if the request is authenticated
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "Authentication required."
      );
    }

    // Get references to the user documents
    const unblockerUserRef = admin.firestore().collection("users").doc(unblockerUid);
    const unblockedUserRef = admin.firestore().collection("users").doc(unblockedUid);

    // Delete the documents from 'usersIBlocked' and 'usersBlockedMe' subcollections
    await unblockerUserRef.collection("usersIBlocked").doc(unblockedUid).delete();
    await unblockedUserRef.collection("usersBlockedMe").doc(unblockerUid).delete();

    return { success: true };
  } catch (error) {
    console.error("Error:", error);
    throw new functions.https.HttpsError("internal", "Something went wrong.");
  }
});


  


// export const helloWorld = onRequest((request, response) => {
//     // debugger;
//     logger.info("Hello logs!", { structuredData: true });
//     response.send("Hello from Firebase!");
// });
