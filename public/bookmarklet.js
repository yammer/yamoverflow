(function(){
  try {
    var YAM_CONVERSATION_KEY = 'threadId'
      , YAM_OVERFLOW_URL = 'http://yamoverflow.dev/add/'
      , YAM_OVERFLOW_TAG = 'YAMOVERFLOW'
      , TAG_NAMES_CLASS = 'yj-tag-name'
      , ERROR_IMAGE_URL = 'http://cdn1.iconfinder.com/data/icons/'
        + 'crystalproject/crystal_project_256x256/actions/button_cancel.png'
      , UNTAGGED_CONVERSATION_ERROR_HTML = 'We are sorry, but before trying to '
        + 'save this conversation to <strong>Yam&nbsp;Overflow</strong> you should '
        + 'mark at least one reply with <code>#yamoverflow</code> tag by just '
        + 'mentioning <code>#yamoverflow</code> somewhere inside a reply.';

    var hashUrl = window.location.hash
      , threadId = hashUrl.split('=')[1]
      , tagNames = document.getElementsByClassName(TAG_NAMES_CLASS)
      , readyToProceed = false
      , pageOverlay = null
      , messageContainer = null
      , messageCloser = null
      , errorContainer = null
      , errorImage = null
      , errorMessage = null;

    for (var i = 0, ii = tagNames.length; i < ii; i++) {
      if (tagNames[i].innerText.toUpperCase() === YAM_OVERFLOW_TAG) {
        readyToProceed = true;
      }
    }

    if (readyToProceed) {
      window.location = YAM_OVERFLOW_URL + threadId;
    }
    else {
      pageOverlay = document.createElement('div');
      pageOverlay.style.position = 'fixed';
      pageOverlay.style.top = 0;
      pageOverlay.style.left = 0;
      pageOverlay.style.width = '100%';
      pageOverlay.style.height = '100%';
      pageOverlay.style.background = 'rgba(230, 230, 230, 0.8)';
      pageOverlay.style.zIndex = 9999;

      messageContainer = document.createElement('div');
      messageContainer.style.top = '40%';
      messageContainer.style.position = 'absolute';
      messageContainer.style.height = '150px';
      messageContainer.style.width = '100%';

      errorContainer = document.createElement('div');
      errorContainer.style.height = '100%';
      errorContainer.style.width = '600px';
      errorContainer.style.backgroundColor = 'white';
      errorContainer.style.padding = '25px';
      errorContainer.style.margin = 'auto';
      errorContainer.style.position = 'relative';
      if (errorContainer.style.boxShadow !== undefined) {
        errorContainer.style.boxShadow = '0 0 1em gray';
      }
      if (errorContainer.style.borderRadius !== undefined) {
        errorContainer.style.borderRadius = '5px';
      }

      errorImage = document.createElement('img');
      errorImage.src = ERROR_IMAGE_URL;
      errorImage.style.float = 'left';
      errorImage.style.marginRight = '20px';
      errorImage.width = '150';
      errorImage.height = '150';
      errorContainer.appendChild(errorImage);

      errorMessage = document.createElement('div');
      errorMessage.style.lineHeight = '1.8';
      errorMessage.style.fontSize = '115%';
      errorMessage.style.fontFamily = '"Helvetica Neue", Helvetica, Arial, sans-serif';
      errorMessage.innerHTML = UNTAGGED_CONVERSATION_ERROR_HTML;
      errorContainer.appendChild(errorMessage);

      messageCloser = document.createElement('div');
      messageCloser.style.position = 'absolute';
      messageCloser.style.top = 0;
      messageCloser.style.right = 0;
      messageCloser.style.marginTop = '-5px';
      messageCloser.innerHTML = '×';
      messageCloser.style.fontSize = '25px';
      messageCloser.style.cursor = 'pointer';
      messageCloser.addEventListener('click', function() {
        document.body.removeChild(pageOverlay);
      }, false);
      errorContainer.appendChild(messageCloser);

      messageContainer.appendChild(errorContainer);

      pageOverlay.appendChild(messageContainer);

      document.body.appendChild(pageOverlay);
    }
  } catch (e) {
    error.log(e);
  }
})();