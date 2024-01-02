// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:ticket_booking/Controller/custom_button.dart';
import 'package:ticket_booking/Controller/custom_textfield.dart';
import 'package:ticket_booking/Model/custom_colors.dart';

class TicketBookingPage extends StatefulWidget {
  final Map<String, dynamic> movieDetails;
  const TicketBookingPage({super.key, required this.movieDetails});

  @override
  TicketBookingPageState createState() => TicketBookingPageState();
}

class TicketBookingPageState extends State<TicketBookingPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController customerIDController = TextEditingController();
  TextEditingController noOfTicketsController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    contactNumberController.dispose();
    dateController.dispose();
    timeController.dispose();
    contactNumberController.dispose();
    customerIDController.dispose();
    noOfTicketsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: CustomColors.primaryColor,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            '${widget.movieDetails['title']}',
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextField(
                leadingIcon: Icons.person,
                hintText: 'Name',
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              CustomTextField(
                leadingIcon: Icons.mail,
                hintText: 'Email',
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!isValidEmail(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              CustomTextField(
                leadingIcon: Icons.phone,
                hintText: 'Contact No',
                controller: contactNumberController,
                prefixText: '+91 ',
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  } else if (value.length != 10) {
                    return 'Phone number should be +91 followed by 10 digits';
                  }
                  return null;
                },
              ),

              // IntlPhoneField(
              //   decoration: InputDecoration(
              //     hintText: 'Contact No.',
              //     hintStyle:
              //         TextStyle(color: Colors.white),
              //     border: OutlineInputBorder(
              //       borderSide:
              //           BorderSide(color: Colors.white),
              //       borderRadius:
              //           BorderRadius.circular(10.0),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(
              //           10.0),
              //       borderSide: BorderSide(
              //           color: Colors.white),
              //     ),
              //     contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
              //   ),
              //   initialCountryCode: 'IN',
              //   style: TextStyle(color: Colors.white),
              //   onChanged: (phone) {
              //     contactNumberController.text = phone.completeNumber;
              //   },
              //   validator: (value) {
              //     if (value == null) {
              //       return 'Please enter your phone number';
              //     }
              //     return null;
              //   },
              // ),
              CustomTextField(
                leadingIcon: Icons.person,
                hintText: 'Customer ID',
                controller: customerIDController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your ID';
                  }
                  return null;
                },
              ),
              CustomTextField(
                leadingIcon: Icons.date_range,
                hintText: 'Date',
                controller: dateController,
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2025),
                  );

                  if (pickedDate != null) {
                    dateController.text =
                        pickedDate.toString().substring(0, 10);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              CustomTextField(
                leadingIcon: Icons.timelapse_outlined,
                hintText: 'Time',
                controller: timeController,
                onTap: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (pickedTime != null) {
                    String period =
                        pickedTime.period == DayPeriod.am ? 'AM' : 'PM';
                    final formattedTime =
                        "${pickedTime.hourOfPeriod}:${pickedTime.minute} $period";
                    timeController.text = formattedTime;
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a time';
                  }
                  return null;
                },
              ),
              CustomTextField(
                leadingIcon: Icons.confirmation_num,
                hintText: 'Number of Tickets',
                controller: noOfTicketsController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select number of tickets';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              CustomButton(
                  onPressed: () {
                    _submitForm();
                  },
                  buttonText: 'Submit')
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   String randomString = randomAlphaNumeric(6);
  //   customerIDController.text = randomString;
  // }

  bool isValidEmail(String email) {
    final emailMatch = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailMatch.hasMatch(email);
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String selectedDate = dateController.text;
      String selectedTime = timeController.text;

      bool isSlotAvailable =
          await checkSlotAvailability(selectedDate, selectedTime);

      if (isSlotAvailable) {
        await saveBookingToFirestore(selectedDate, selectedTime);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'Booking Confirmed',
                style: TextStyle(color: Colors.white),
              ),
              content: const Text(
                'Your booking has been confirmed!',
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        showConflictWarning();
      }
    }
  }

  Future<bool> checkSlotAvailability(
      String selectedDate, String selectedTime) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('bookings')
        .where('date', isEqualTo: selectedDate)
        .where('time', isEqualTo: selectedTime)
        .get();

    return snapshot.docs.isEmpty;
  }

  Future<void> saveBookingToFirestore(
      String selectedDate, String selectedTime) async {
    await FirebaseFirestore.instance.collection('bookings').add({
      'customerName': nameController.text,
      'customerEmail': emailController.text,
      'contactNumber': contactNumberController.text,
      'movieTitle': widget.movieDetails['title'],
      'date': selectedDate,
      'time': selectedTime,
      'customerId': customerIDController.text,
      'noOfTickets': noOfTicketsController.text
    });
  }

  void showConflictWarning() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Warning',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'The selected date/time slot is not available.',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
