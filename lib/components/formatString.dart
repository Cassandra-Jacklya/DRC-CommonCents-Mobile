  String formatTopicForAPI(String topic) {
    switch (topic) {
      case 'All':
        return 'All';
      case 'Blockchain':
        return 'blockchain';
      case 'Earnings':
        return 'earnings';
      case 'IPO':
        return 'ipo';
      case 'Mergers & Acquisition':
        return 'mergers_and_acquisitions';
      case 'Financial Markets':
        return 'financial_markets';
      case 'Econ - Fiscal Policy':
        return 'economy_fiscal';
      case 'Econ - Monetary Policy':
        return 'economy_monetary';
      case 'Econ - Macro/Overall':
        return 'economy_macro';
      case 'Finance':
        return 'finance';
      case 'Retail & Wholesale':
        return 'retail_wholesale';
      case 'Technology':
        return 'technology';
      default:
        return topic.toLowerCase().replaceAll(' ', '_');
    }
  }