String formatMarkets(String market) {
  switch (market) {
    case 'Volatility 10':
      return 'R_10';
    case 'Volatility 25':
      return 'R_25';
    case 'Volatility 50':
      return 'R_50';
    case 'Volatility 75':
      return 'R_75';
    case 'Volatility 100':
      return 'R_100';
    case 'Volatility 10 (1S)':
      return '1HZ10V';
    case 'Volatility 25 (1S)':
      return '1HZ25V';
    case 'Volatility 50 (1S)':
      return '1HZ50V';
    case 'Volatility 75 (1S)':
      return '1HZ75V';
    case 'Volatility 100 (1S)':
      return '1HZ100V';
    case 'Jump 10':
      return 'JD10';
    case 'Jump 25':
      return 'JD25';
    case 'Jump 50':
      return 'JD50';
    case 'Jump 75':
      return 'JD75';
    case 'Jump 100':
      return 'JD100';
    case 'Bear Market':
      return 'RDBEAR';
    case 'Bull Market':
      return 'RDBULL';

    default:
      return market.toLowerCase().replaceAll(' ', '_');
  }
}
