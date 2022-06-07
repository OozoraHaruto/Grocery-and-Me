rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    function checkUserExists(){
      return exists(/databases/$(database)/documents/Users/$(request.auth.uid));
    }
    function checkUserIsOwnerForCurrentDoc(){
      return resource.data.creator == path('/databases/(default)/documents/Users/'+request.auth.uid);
    }
    function checkUserIsOwnerOrSharedWithForCurrentDoc(){
    	let owner = resource.data.creator == path('/databases/(default)/documents/Users/'+request.auth.uid);
      let sharedWith = path('/databases/(default)/documents/Users/'+request.auth.uid) in
      									resource.data.sharedToUsers;
      return owner || sharedWith
    }
    function checkUserIsOwnerOrSharedWith(documentPath){
    	let owner = get(path('/databases/(default)/documents/'+documentPath)).data.creator
      					 == path('/databases/(default)/documents/Users/'+request.auth.uid);
    	let sharedWith = path('/databases/(default)/documents/Users/'+request.auth.uid) in
      				get(path('/databases/(default)/documents/'+documentPath)).data.sharedToUsers;

      return owner || sharedWith;
    }
    // function checkCurrentUserIsDocumentKey(userId){
    // 	return request.auth.uid == userId
    // }

  	match /Users/{userId} {
  		allow read, create;
      allow update, delete:
        if request.auth.uid == userId;
  	}

    match /Lists/{listId}{
    	allow read:
    	  if checkUserIsOwnerOrSharedWithForCurrentDoc();
    	allow create:
        if checkUserExists();
      allow update, delete:
        if checkUserIsOwnerForCurrentDoc();
    }
    match /Lists/{deckId}/Items/{itemId}{
    	allow read, create, update, delete:
        if checkUserIsOwnerOrSharedWith('Lists/'+deckId);
    }

    // match /{document=**} {
    //   allow read, write
    // }
  }
}