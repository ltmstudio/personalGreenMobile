class ApiEndpoints {
  // static const baseUrl = 'https://hub.dom-connect.ru/api/v2/';
  static const baseUrl = 'https://staging.hub.dom-connect.ru/api/v2/';
  //
  // static const crmBaseUrl = 'https://staging.hub.dom-connect.ru';
  static const sendOtp = 'auth/attempt';
  static const login = 'auth/confirm';
  static const profile = 'auth/profile';
  static const refresh = 'auth/refresh';

  static const logout = 'auth/logout';

  static const crmAvailable = 'crm/available';
  static const collections = 'engineer_api/tickets';
  static const dictionaries = 'engineer_api/tickets/dictionaries';
  static const createTicket = 'engineer_api/tickets';
  static const getTicket = 'engineer_api/tickets';
  static const acceptTicket = 'engineer_api/tickets/:ticket_id/accept';
  static const rejectTicket = 'engineer_api/tickets/:ticket_id/reject';
  static const assignExecutor = 'engineer_api/tickets/:ticket_id/assign_executor';
  static const reportTicket = 'engineer_api/tickets/:ticket_id/report';
  static const addresses = 'engineer_api/addresses';
  static const employees = 'engineer_api/employee';
  static const isResponsible = 'engineer_api/is_responsible';
  static const contacts = 'engineer_api/contacts';
}
