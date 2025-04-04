// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import '1st_payment.dart';

class ReservationForm extends StatefulWidget {
  final String name;

  const ReservationForm({super.key, required this.name});

  @override
  State<ReservationForm> createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _phoneNumber;
  String? _ageGroup;
  String? _dateTime;
  String? _selectedDuration = '2 hours = 20\$';
  List<String> _selectedOptions = [];
  Map<String, dynamic>? _selectedMeetingPlace;

  final List<Map<String, dynamic>> _meetingPlaces = [
    {
      'imagePath': 'assets/icons/angkorwat.png',
      'title': 'Angkor Wat',
      'description': 'A UNESCO World Heritage Site. It is good for couples to visit.',
    },
    {
      'imagePath': 'assets/icons/aquarium.png',
      'title': 'Aquarium',
      'description': 'A great place to see beautiful fish and marine life.',
    },
     {
    'imagePath': 'assets/icons/cafe jrolong phnom.png',
    'title': 'Cafe Jrolong Pnhom',
    'description': 'A serene outdoor café with rustic bamboo architecture, lush greenery, and a peaceful garden setting under a bright blue sky.. Perfect for a date!',
  },
  {
    'imagePath': 'assets/icons/eden.png',
    'title': 'Eden',
    'description': 'A lively outdoor bar and restaurant with vibrant lighting, lush greenery, and a bustling crowd enjoying the night.it is a great place to hang out with partner and enjoy the nightlife.',
  
  },
  {
    'imagePath': 'assets/icons/movie.png',
    'title': 'Movie date',
    'description': 'movies are a great way to spend time together. Enjoy a movie with your partner!',
  },
  {
    'imagePath': 'assets/icons/keb viila.png',
    'title': 'Keb Villa',
    'description': 'A beautiful villa with a pool and a stunning view of the sunset. Perfect for a romantic getaway!',
  },
  {
    'imagePath': 'assets/icons/koh norea.png',
    'title': 'Koh Norea',
    'description': 'it is a great place to relax and enjoy the view of river with your partner and enjoy the sunset.',
  },
  {
    'imagePath': 'assets/icons/kirirom.png',
    'title': 'Kirirom national park',
    'description': 'A beautiful national park with stunning views and a variety of outdoor activities. Perfect for a day trip!',
  },
  {
    'imagePath': 'assets/icons/ktre ktrok.png',
    'title': 'ktre ktrok',
    'description': 'it is a old vibe cafe and restaurnt. Perfect for a romantic dinner!',
  },
  {
    'imagePath': 'assets/icons/pubstreet.png',
    'title': 'Pub street',
    'description': 'A lively street filled with bars, restaurants, and shops. Perfect for a night out!',
  },
];
    // Add more meeting places as needed


  final List<String> _durationOptions = [
    '2 hours = 20\$',
    '4 hours = 40\$',
    '5 hours = 50\$',
    '6 hours = 60\$',
    '8 hours = 80\$',
  ];

  final List<String> _optionalDating = [
    'Hand Holding Arms 10\$' ,
    'Lunch plan 7.5\$ / 1 time',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.pink),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Complete the form',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Complete the form',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                label: 'Name (real name)',
                hint: 'Write your real name (nicknames are not allowed)',
                onSaved: (value) => _name = value,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Phone number',
                hint: 'We will contact you via SMS or Call',
                keyboardType: TextInputType.phone,
                onSaved: (value) => _phoneNumber = value,
              ),
              const SizedBox(height: 16),
              _buildAgeGroupDropdown(),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Cast name',
                hint: widget.name,
                enabled: false,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Date reservation date & time',
                hint: '(Ex) 3 hours from 17:00 on Friday, December 24th',
                onSaved: (value) => _dateTime = value,
              ),
              const SizedBox(height: 16),
              _buildMeetingPlaceDropdown(),
              const SizedBox(height: 24),
              const Text(
                'Time and price',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._durationOptions.map((option) => 
                RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: _selectedDuration,
                  onChanged: (value) {
                    setState(() {
                      _selectedDuration = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                )
              ).toList(),
              const SizedBox(height: 24),
              const Text(
                'Optional dating',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._optionalDating.map((option) => 
                CheckboxListTile(
                  title: Text(option),
                  value: _selectedOptions.contains(option),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedOptions.add(option);
                      } else {
                        _selectedOptions.remove(option);
                      }
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                )
              ).toList(),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Important Note ▲\n'
                  'The date will end when you talk about touching during a date. '
                  'Please read and observe the prohibitions and terms of use listed on the site carefully.',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 12.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: _submitForm,
                  child: const Text(
                    'Submit Reservation',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    TextInputType? keyboardType,
    bool enabled = true,
    void Function(String?)? onSaved,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
            enabled: enabled,
          ),
          keyboardType: keyboardType,
          onSaved: onSaved,
          validator: (value) {
            if (enabled && (value == null || value.isEmpty)) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAgeGroupDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Age group',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: '20 to 25', child: Text('20 to 25')),
            DropdownMenuItem(value: '26 to 30', child: Text('26 to 30')),
            DropdownMenuItem(value: '31 to 35', child: Text('31 to 35')),
            DropdownMenuItem(value: '36 to 40', child: Text('36 to 40')),
            DropdownMenuItem(value: '41 to 45', child: Text('41 to 45')),
          ],
          hint: const Text('Select your age group'),
          onChanged: (value) {
            setState(() {
              _ageGroup = value;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Please select your age group';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildMeetingPlaceDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Meeting Place',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<Map<String, dynamic>>(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          items: _meetingPlaces.map((place) {
            return DropdownMenuItem<Map<String, dynamic>>(
              value: place,
              child: Text(place['title']),
            );
          }).toList(),
          hint: const Text('Select meeting place'),
          onChanged: (value) {
            setState(() {
              _selectedMeetingPlace = value;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Please select a meeting place';
            }
            return null;
          },
        ),
        if (_selectedMeetingPlace != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedMeetingPlace!['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(_selectedMeetingPlace!['description']),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Extract base price from _selectedDuration
        double basePrice = 0;
        if (_selectedDuration != null && _selectedDuration!.contains('\$')) {
          basePrice = double.parse(
            _selectedDuration!.split('=')[1].trim().replaceFirst('\$', ''),
          );
        }

        // Calculate optional services price
        double optionalPrice = 0;
        for (String option in _selectedOptions) {
          try {
            if (option.contains('\$')) {
              // Extract the price from the string
              String priceString = option.split('\$')[1].split(' ')[0].trim();
              optionalPrice += double.parse(priceString);
            }
          } catch (e) {
            debugPrint('Error parsing optional service price: $option');
          }
        }

        // Calculate total price
        double totalPrice = basePrice + optionalPrice;

        // Navigate to CheckoutScreen with reservation details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckoutScreen(
              companionName: widget.name,
              duration: _selectedDuration ?? 'Not specified',
              meetingPlace: _selectedMeetingPlace?['title'] ?? 'Not specified',
              optionalServices: _selectedOptions,
              totalPrice: totalPrice,
              phoneNumber: _phoneNumber ?? '',
              dateTime: _dateTime ?? '',
            ),
          ),
        );
      } catch (e) {
        // Handle parsing errors
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error calculating total price. Please check your inputs.')),
        );
      }
    }
  }
}