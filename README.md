# **Hyprnight**  

[Installation](#installation) | [Showcase](#hyprnight-preview) | [Keybinds](#basic-keybinds)  

---

## **Hyprnight Preview**  
Showcasing my **minimalist, manga-inspired Arch Linux setup**, built around the following:  

### **Core Components**  
- **Terminal:** Kitty  
- **Browser:** Zen-browser
- **File Manager:** Yazi  
- **Window Manager:** Hyprland  
- **Notification System:** Dunst
- **Volume Controls:** Swayosd
- **Status bar:** Waybar

### **Screenshots**  

- **Cava + Terminal with Fastfetch**  
  ![](https://github.com/user-attachments/assets/170831c5-1cb5-42f8-913d-a74d85204f26)  

- **Btop - System Resource Monitor**  
  ![](https://github.com/user-attachments/assets/08e643e8-98c7-45a5-bba5-a1a107e0a942)  

- **Wofi - The App Launcher**  
  ![](https://github.com/user-attachments/assets/ef18b834-f1ab-4abb-8c28-57f2661e8e10)  
  ![](https://github.com/user-attachments/assets/3a1ce6e4-3b9b-44d2-9070-d6023e3b4f05)  

- **SwayOSD & Dunst - Notifications Setup**  
  ![](https://github.com/user-attachments/assets/75101b2a-83f1-4039-b590-66f5a3892b23)  
  ![](https://github.com/user-attachments/assets/adfafd1a-c9d7-4ff8-843d-ebedf84ea7e7)  

- **Live Wallpaper Setup**  
  ![](https://github.com/user-attachments/assets/bc09c597-aa1c-4f42-8727-f13a238b5652)  

- **Yazi - Terminal File Manager**  
  ![](https://github.com/user-attachments/assets/658b57cc-c0fa-4dc5-b234-ccac13aadbd6)  

---

## **Installation**  
Clone the repository into your home directory and navigate into it:  
```bash
git clone https://github.com/MarceIine/Hyprnight.git --recursive $HOME/Hyprnight && cd $HOME/Hyprnight
```  

Run the setup script to **stow the dotfiles** into `.config`:  
```bash
./setup.sh -s
```  
🔹 **Note:** If `.config/` already exists, it will be renamed to `.config.bak`, and a new `.config/` folder with the dotfiles will be created.  

Run the install script to **install dependencies and configure Zsh**:  
```bash
./install_packages.bash
```  
This will:  
- Install **yay** and all required packages  
- Install **Oh My Zsh** and prompt you to set Zsh as your default shell  
- Stow a **custom Zsh configuration**  

🔹 **Note:** If you already have a `.zshrc` in `$HOME`, it will be **overwritten**.  

---

## **Post-Installation**  
After setup, set your **wallpaper** with `Super + U` to ensure Waybar functions correctly.  

To start **Waybar**, press:  
```bash
Super + W
```

🔹 **Note:** You won't need to do this every time—after relogging, it will start automatically. 

---

## 🔹 **Basic Keybinds**  

| Keybind | Action |
|---------|--------|
| **Super + R** | Open the browser 🌐 |
| **Super + U** | Open the wallpaper picker 🎨 |
| **Super + Enter** | Open the terminal 💻 |
| **Super + Q** | Close current activity ❌ |
| **Super + P** | Show all the keybinds |

---
