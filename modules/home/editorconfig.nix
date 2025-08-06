_: {
  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        indent_style = "space";
        indent_size = 2;
        end_of_line = "lf";
        charset = "utf-8";
        trim_trailing_whitespace = true;
        insert_final_newline = true;
      };

      "*.html,*.css,*.js,*.ts,*.jsx,*.tsx" = {
        indent_size = 2;
      };

      "*.json" = {
        indent_size = 2;
      };

      "*.nix" = {
        indent_size = 2;
      };

      "*.qml" = {
        indent_size = 4;
      };

      "Dockerfile" = {
        indent_size = 2;
      };
    };
  };
}
