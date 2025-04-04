
# 📋 User & Moderator Commands


## 👤 Commands for Regular Users

### `/start`
Displays the main menu with the following buttons:

- **My ID** – shows your user ID.  
- **Server Control** – opens a submenu to perform actions:
  - 🔌 **Power On** (`poweron`)
  - ⚡ **Shutdown** (`shutdown`)
  - 🔁 **Reboot** (`reboot`)
  - 🔍 **Check Status** – verifies the server status

---

### `/register`
User registration via 2FA:

1. Enter the one-time code provided by the moderator.
2. Receive a QR code or secret code for Google Authenticator.
3. Confirm by entering the code from Google Authenticator.
4. **Note:** The QR code and secret are deleted after the process.

---

## 🛠️ Commands & Buttons for Moderators

### 🔁 Change Group
- Allows the moderator to switch to a different working group.
- **Requires 2FA confirmation.**

---

### `/add_moderator_standart`
- Adds the moderator's ID to the pending administrators table (`pending_admins`).
- *For a one-time registration, simply add your ID.*

---

### `/clear_users`
- Deletes all regular users.
- ❗ *Accessible to moderators only.*
- **Requires 2FA confirmation.**

---

### `create one-time code`
- Generates a one-time code for a selected group.
- *Moderator-only action; requires 2FA confirmation.*

---

### `list one-time codes`
- Displays all active one-time codes with options to delete them.

---

### `/stop_bot`
- Stops the bot and deletes all tables.
- ❗ *Accessible to moderators only; requires 2FA confirmation.*

---

### `create group`
- Creates a new group by prompting for:
  - Group name (identifier)
  - Hetzner API token
  - Signature
  - **Requires 2FA confirmation.**

---

### `add moderator`
- Adds a new moderator: after entering the moderator’s ID, it is recorded in the `pending_admins` table.

---

### `list groups`
- Shows a list of groups with participants and their roles.
- Displays either the signature or the group name.

---

### `/register_admin`
- Registers a moderator as an administrator via 2FA.
- (Moderators added in `pending_admins` execute this command to complete registration.)

---

### `manage moderators`
- Displays a list of registered administrators with options to remove them.

---

### `unblock user`
- Shows a list of blocked users for unblocking.
- **Requires 2FA confirmation.**

---

### `add server`
- Adds a server to the selected group by entering its ID and name.

---

### **User Registration Process**
- **Step 1:** Execute `/register` to register as a regular user using a one-time code and 2FA.
- **Step 2:** The user enters the one-time code provided by the moderator.
- **Step 3:** The user receives a QR code (or secret code) which is used to configure the authenticator.
- **Step 4:** If scanning the QR code isn't possible, the user can copy it.
- **Step 5:** After adding the code to the authenticator, the user confirms activation by sending the code back to the bot.
- **Step 6:** Finally, the QR code and secret are deleted.

### **Moderator Registration Process**
- **Step 1:** An active moderator clicks the "add moderator" button and enters the new moderator’s ID. This ID is then added to the `pending_admins` table.
- **Step 2:** The moderator whose ID was added then executes `/register_admin` and registers in a similar manner to a regular user—however, one-time codes are not required.
