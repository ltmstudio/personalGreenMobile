class ApiEndpoints {
  static const baseUrl = 'https://staging.hub.dom-connect.ru/api/v2/';

  // static const crmBaseUrl = 'https://staging.hub.dom-connect.ru';
  static const sendOtp = 'auth/attempt';
  static const login = 'auth/confirm';
  static const profile = 'auth/profile';
  static const refresh = 'auth/refresh';

  static const logout = 'logout';

  static const crmAvailable = 'crm/available';
  static const collections = 'engineer_api/tickets';
  static const dictionaries = 'engineer_api/tickets/dictionaries';
  static const createTicket = 'engineer_api/tickets';
  static const addresses = 'engineer_api/addresses';
}
