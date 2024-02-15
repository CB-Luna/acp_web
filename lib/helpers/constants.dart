//////// ACP - Prod ////////
const String supabaseUrl = 'https://acp.arux.co';
const String anonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyAgCiAgICAicm9sZSI6ICJhbm9uIiwKICAgICJpc3MiOiAic3VwYWJhc2UiLAogICAgImlhdCI6IDE2NTc2OTU2MDAsCiAgICAiZXhwIjogMTgxNTQ2MjAwMAp9.8h6s6K2rRn20SOc7robvygAWNhZsSWD4xFRdIZMyYVI';
const redirectUrl = '$supabaseUrl/change-pass/#/change-password/token';
const themeId = String.fromEnvironment('themeId', defaultValue: '2');

String apiGatewayUrl = '$supabaseUrl/acp/api';

const int mobileSize = 800;
