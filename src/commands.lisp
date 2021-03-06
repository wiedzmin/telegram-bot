(in-package :telegram-bot-commands)

(defun get-username (resp)
  (let ((username (get-value resp :|message| :|from| :|username|))
        (id (get-value resp :|message| :|from| :|id|)))
    (when (integerp id)
      (setq id (write-to-string id)))
    (or username id)))

(defun get-chat-id (resp)
  (get-value resp :|message| :|from| :|id|))


(defun send-response (self income-msg text)
  (telegram-bot:send-message self (get-chat-id income-msg) text))


(defun help (self message)
  (send-response self message "
/help - show this help
/hello - make bot remember you
/saymyname - ensure that bot know you
/bye - remove you from bot memory
"))

(defun hello (self message)
  (telegram-bot:add-user self (get-username message) (get-chat-id message))
  (send-response self message (format nil "Added you as ~a~%" (get-username message))))

(defun say-my-name (self message)
  (let* ((username (get-username message))
		 (chat-id (get-value (telegram-bot::users self) username))
		 (response (if chat-id (format nil "You are ~a~%" username) (format nil "I dont know you"))))
	(send-response self message response)))

(defun bye (self message)
  (telegram-bot:del-user self (get-username message))
  (send-response self message (format nil "Removed ~a~%" (get-username message))))
