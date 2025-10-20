import 'package:flutter/material.dart';
import 'package:lenco_flutter/lenco_flutter.dart';

void main() {
  runApp(const LencoExampleApp());
}

class LencoExampleApp extends StatelessWidget {
  const LencoExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lenco Flutter Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LencoExampleHome(),
    );
  }
}

class LencoExampleHome extends StatefulWidget {
  const LencoExampleHome({super.key});

  @override
  State<LencoExampleHome> createState() => _LencoExampleHomeState();
}

class _LencoExampleHomeState extends State<LencoExampleHome> {
  late LencoClient lenco;
  List<LencoAccount> accounts = [];
  List<LencoTransaction> transactions = [];
  List<Bank> banks = [];
  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  // Form controllers
  final _apiKeyController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankCodeController = TextEditingController();
  final _amountController = TextEditingController();
  final _narrationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with sandbox API key for demo
    _apiKeyController.text = 'your-sandbox-api-key';
    _bankCodeController.text = '044'; // Access Bank
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _accountNumberController.dispose();
    _bankCodeController.dispose();
    _amountController.dispose();
    _narrationController.dispose();
    lenco.close();
    super.dispose();
  }

  void _initializeClient() {
    if (_apiKeyController.text.isEmpty) {
      _showError('Please enter your API key');
      return;
    }

    try {
      lenco = LencoClient.sandbox(apiKey: _apiKeyController.text);
      _showSuccess('Client initialized successfully');
    } catch (e) {
      _showError('Failed to initialize client: $e');
    }
  }

  Future<void> _getAccounts() async {
    if (!_isClientInitialized()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final accountsList = await lenco.accounts.getAccounts();
      setState(() {
        accounts = accountsList;
        successMessage = 'Retrieved ${accountsList.length} accounts';
      });
    } on LencoException catch (e) {
      _showError('Failed to get accounts: ${e.message}');
    } catch (e) {
      _showError('Unexpected error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _getTransactions() async {
    if (!_isClientInitialized() || accounts.isEmpty) {
      _showError('Please get accounts first');
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final transactionsList = await lenco.transactions.getTransactions(
        accountId: accounts.first.id,
        limit: 10,
      );
      setState(() {
        transactions = transactionsList;
        successMessage = 'Retrieved ${transactionsList.length} transactions';
      });
    } on LencoException catch (e) {
      _showError('Failed to get transactions: ${e.message}');
    } catch (e) {
      _showError('Unexpected error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _getBanks() async {
    if (!_isClientInitialized()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final banksList = await lenco.payments.getBanks();
      setState(() {
        banks = banksList;
        successMessage = 'Retrieved ${banksList.length} banks';
      });
    } on LencoException catch (e) {
      _showError('Failed to get banks: ${e.message}');
    } catch (e) {
      _showError('Unexpected error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _verifyAccount() async {
    if (!_isClientInitialized()) return;

    if (_accountNumberController.text.isEmpty ||
        _bankCodeController.text.isEmpty) {
      _showError('Please enter account number and bank code');
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final accountName = await lenco.payments.verifyAccountName(
        accountNumber: _accountNumberController.text,
        bankCode: _bankCodeController.text,
      );
      _showSuccess('Account verified: $accountName');
    } on LencoException catch (e) {
      _showError('Failed to verify account: ${e.message}');
    } catch (e) {
      _showError('Unexpected error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _makePayment() async {
    if (!_isClientInitialized() || accounts.isEmpty) {
      _showError('Please initialize client and get accounts first');
      return;
    }

    if (_amountController.text.isEmpty ||
        _accountNumberController.text.isEmpty ||
        _bankCodeController.text.isEmpty) {
      _showError('Please fill in all required fields');
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final paymentRequest = PaymentRequest(
        accountId: accounts.first.id,
        amount: _amountController.text,
        recipientAccountNumber: _accountNumberController.text,
        recipientBankCode: _bankCodeController.text,
        narration: _narrationController.text.isNotEmpty
            ? _narrationController.text
            : 'Test payment',
      );

      final payment = await lenco.payments.initiatePayment(paymentRequest);
      _showSuccess(
          'Payment initiated: ${payment.reference} (Status: ${payment.status})');
    } on LencoException catch (e) {
      _showError('Failed to make payment: ${e.message}');
    } catch (e) {
      _showError('Unexpected error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool _isClientInitialized() {
    try {
      return lenco.config.apiKey.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  void _showError(String message) {
    setState(() {
      errorMessage = message;
      successMessage = null;
    });
  }

  void _showSuccess(String message) {
    setState(() {
      successMessage = message;
      errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lenco Flutter Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // API Key Configuration
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Configuration',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _apiKeyController,
                      decoration: const InputDecoration(
                        labelText: 'API Key',
                        hintText: 'Enter your Lenco API key',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _initializeClient,
                      child: const Text('Initialize Client'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Action Buttons
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'API Operations',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: isLoading ? null : _getAccounts,
                          child: const Text('Get Accounts'),
                        ),
                        ElevatedButton(
                          onPressed: isLoading ? null : _getTransactions,
                          child: const Text('Get Transactions'),
                        ),
                        ElevatedButton(
                          onPressed: isLoading ? null : _getBanks,
                          child: const Text('Get Banks'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Payment Form
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Operations',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _accountNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Recipient Account Number',
                        hintText: '1234567890',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _bankCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Bank Code',
                        hintText: '044 (Access Bank)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Amount (in kobo)',
                        hintText: '10000',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _narrationController,
                      decoration: const InputDecoration(
                        labelText: 'Narration (Optional)',
                        hintText: 'Payment description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: isLoading ? null : _verifyAccount,
                          child: const Text('Verify Account'),
                        ),
                        ElevatedButton(
                          onPressed: isLoading ? null : _makePayment,
                          child: const Text('Make Payment'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Loading Indicator
            if (isLoading)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),

            // Error Message
            if (errorMessage != null)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          errorMessage!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Success Message
            if (successMessage != null)
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          successMessage!,
                          style: TextStyle(color: Colors.green.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Accounts List
            if (accounts.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Accounts',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ...accounts.map((account) => ListTile(
                            title: Text(account.name),
                            subtitle: Text(
                                '${account.bankAccount.accountNumber} - ${account.bankAccount.bank.name}'),
                            trailing: Text('₦${account.availableBalance}'),
                            leading: const Icon(Icons.account_balance),
                          )),
                    ],
                  ),
                ),
              ),

            // Transactions List
            if (transactions.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recent Transactions',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ...transactions.map((transaction) => ListTile(
                            title: Text(transaction.description),
                            subtitle: Text(
                                '${transaction.type.toUpperCase()} - ${transaction.reference}'),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('₦${transaction.amount}'),
                                Text(
                                  transaction.status,
                                  style: TextStyle(
                                    color: transaction.status == 'completed'
                                        ? Colors.green
                                        : Colors.orange,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            leading: Icon(
                              transaction.type == 'credit'
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: transaction.type == 'credit'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          )),
                    ],
                  ),
                ),
              ),

            // Banks List
            if (banks.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Supported Banks',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ...banks.take(10).map((bank) => ListTile(
                            title: Text(bank.name),
                            subtitle: Text('Code: ${bank.code}'),
                            leading: const Icon(Icons.account_balance),
                          )),
                      if (banks.length > 10)
                        Text('... and ${banks.length - 10} more banks'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
