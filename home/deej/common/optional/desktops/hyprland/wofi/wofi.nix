{
  programs.wofi.enable = true;
  programs.wofi.settings = {
    "width" = 900;
    "height" = 350;
    "location" = "center";
    "show" = "drun";
    "prompt" = "Search...";
    "filter_rate" = 100;
    "allow_markup" = true;
    "no_actions" = true;
    "halign" = "fill";
    "orientation" = "vertical";
    "content_halign" = "fill";
    "insensitive" = true;
    "allow_images" = true;
    "image_size" = 40;
    "columns" = 2;
  };

  programs.wofi.style = ''
    @define-color background rgba(0,0,0, 0.15);
    @define-color foreground rgb(220, 220, 220);
    @define-color outline rgba(255, 255, 255, 0.15);
    @define-color accent rgb(226, 204, 219);
    @define-color textbox rgba(255, 255, 255, 0.05);
    @define-color highlight rgba(255, 255, 255, 0.1);

    * {
        all:unset;
    }

    window {
        background: rgba(200,200,200,0.05);
        border-radius: 10px;
        border: 1px solid @outline;
        font-family: Inter Nerd Font;
        font-weight: 200;
    }

    #outer-box {
        padding: 2em;
    }

    #input {
        padding:1em .75em;
        margin: 0em .25em;
        font-size:1.5em;
        background: rgba(200,200,200,0.05);
        border: 1px solid transparent;
        box-shadow: inset 0 -.15rem @accent;
        transition: background-color .30s ease-in-out;
    }

    #input image {
        margin-right:-1em;
        color:transparent;
    }

    #input:focus {
        background:@highlight;
        border: 1px solid @outline;
    }

    #scroll {
        margin-top: 1.5em;
    }

    #entry {
        border: 1px solid transparent;
        padding:1em;
        margin: .25rem;
        font-weight: normal;
        box-shadow: inset 0rem 0px rgba(0, 0, 0, 0);
        transition: box-shadow .30s ease-in-out, background-color .30s ease-in-out;
    }

    #entry image {
        margin-right: .75em;
    }

    #entry:selected {
        background-color: @highlight;
        border: 1px solid @outline;
        box-shadow: inset .2rem 0px @accent;

    }
  '';
}
