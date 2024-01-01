// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticket_booking/Controller/custom_button.dart';
import 'package:ticket_booking/Controller/custom_textfield.dart';
import 'package:ticket_booking/Model/ticket_data.dart';

class TicketBookingPage extends StatefulWidget {
  final Map<String, dynamic> movieDetails;

  const TicketBookingPage({super.key, required this.movieDetails});

  @override
  _TicketBookingPageState createState() => _TicketBookingPageState();
}

class _TicketBookingPageState extends State<TicketBookingPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    contactNumberController.dispose();
    dateController.dispose();
    timeController.dispose();
    contactNumberController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String selectedDate = dateController.text;
      String selectedTime = timeController.text;

      bool isSlotAvailable =
          await checkSlotAvailability(selectedDate, selectedTime);

      if (isSlotAvailable) {
        await saveBookingToFirestore(selectedDate, selectedTime);

        // Show booking confirmed dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Booking Confirmed'),
              content: Text('Your booking has been confirmed!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(); // Close current page
                  },
                  child: Text('OK'),
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
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Booking'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Movie Title: ${widget.movieDetails['title']}',
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              CustomTextField(
                  leadingIcon: Icons.person,
                  hintText: 'Name',
                  controller: nameController),
              CustomTextField(
                  leadingIcon: Icons.mail,
                  hintText: 'Email',
                  controller: emailController),
              CustomTextField(
                  leadingIcon: Icons.phone,
                  hintText: 'Contact No.',
                  controller: contactNumberController),
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
}
