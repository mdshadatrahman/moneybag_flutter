/// Frequent Asked Question of MoneyBag
class FrequentAskedQuestion {
  const FrequentAskedQuestion({required this.question, required this.ans});

  final String question;
  final String ans;

  factory FrequentAskedQuestion.fromMap(Map<String, dynamic> map) {
    return FrequentAskedQuestion(
      question: map['question'] ?? '',
      ans: map['answer'] ?? '',
    );
  }

  static List<FrequentAskedQuestion> get data {
    return _questionData.map((m) => FrequentAskedQuestion.fromMap(m)).toList();
  }
}

const _questionData = [
  {
    "question": "What is MoneyBag?",
    "answer":
        "MoneyBag is a comprehensive financial solution designed specifically for educational institutions. It streamlines financial operations, providing a user-friendly platform for fee collection, payroll management, and more."
  },
  {
    "question": "How does MoneyBag support school infrastructure?",
    "answer":
        "MoneyBag goes beyond basic financial services. It actively supports the infrastructure of educational institutions by offering tailored solutions that enhance efficiency and contribute to overall growth."
  },
  {
    "question": "Are there special rates for the education sector?",
    "answer":
        "Yes, MoneyBag offers special rates exclusively for the education sector. We understand the financial challenges faced by schools and strive to provide affordable and accessible financial solutions."
  },
  {
    "question": "Is onboarding with MoneyBag free?",
    "answer":
        "Absolutely. MoneyBag believes in eliminating barriers to adoption. Onboarding is entirely free, ensuring a smooth transition for schools without incurring additional costs."
  },
  {
    "question": "How does MoneyBag ensure transparency?",
    "answer":
        "MoneyBag prioritizes transparency in financial transactions. Our platform provides a clear and open view of all financial activities, empowering schools with informed decision-making."
  },
  {
    "question": "What is the benefit of centralized record-keeping?",
    "answer":
        "Centralized record-keeping in MoneyBag streamlines processes, reduces errors, and enhances overall efficiency. It provides a consolidated view of financial data for better management."
  },
  {
    "question": "How does MoneyBag revolutionize the educational industry?",
    "answer":
        "MoneyBag introduces innovative financial solutions, reshaping how schools manage their finances. It brings a transformative approach, making financial operations more efficient and effective."
  },
  {
    "question": "Is MoneyBag cost-effective?",
    "answer":
        "Yes, MoneyBag is designed to be cost-effective. We minimize financial burdens by offering our services at a minimum cost, ensuring accessibility without compromising on quality."
  },
  {
    "question": "What does 360-degree service assurance mean?",
    "answer":
        "MoneyBag's 360-degree service assurance ensures a comprehensive approach to financial management. It covers every aspect, providing schools with a holistic and dependable solution."
  },
  {
    "question": "How can educational institutions benefit from MoneyBag?",
    "answer":
        "Educational institutions can benefit from MoneyBag by enjoying streamlined financial processes, cost-effective solutions, and a partner dedicated to their growth and success."
  }
];
