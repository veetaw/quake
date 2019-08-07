String capitalize(String str) => str == null
    ? null
    : str.isEmpty ? str : str[0].toUpperCase() + str.substring(1).toLowerCase();

String capitalizeAll(String str) => str == null
    ? null
    : str.isEmpty ? str : str.split(" ").map(capitalize).join(" ");
