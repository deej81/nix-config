{ pkgs, ... }: {
  xdg.desktopEntries = {
    "chatgpt" = {
      name = "ChatGPT";
      exec = "firefox --new-window \"https://chatgpt.com/?model=gpt-4o\" --kiosk";
      icon = ./chatgpt-icon.png;
      categories = [ "Utility" ];
      type="Application";
    };
  };
}
