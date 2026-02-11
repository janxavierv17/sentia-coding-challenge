const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim}",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      },
      colors: {
        "sentia-green": "#00ffbc",
        "sentia-black": "#000000",
        "sentia-gray-100": "#f8f9fa",
        "sentia-gray-800": "#343a40",
        "sentia-cyan": "#0dcaf0",
        "sentia-blue": "#0d6efd",
        "sentia-red": "#dc3545",
        "sentia-yellow": "#ffc107",
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
  ],
};
