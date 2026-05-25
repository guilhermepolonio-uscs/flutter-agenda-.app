import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda Polon',
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFF2F2F7)),
      home: const AgendaPage(),
    );
  }
}

class Task {
  String title;
  String hour;
  String date;
  Color color;
  bool done;

  Task({
    required this.title,
    required this.hour,
    required this.date,
    required this.color,
    this.done = false,
  });
}

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  final TextEditingController controller = TextEditingController();

  List<Task> tasks = [];

  Color selectedColor = Colors.blue;

  String selectedHour = "08:00";

  String selectedDate =
      "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";

  final List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];

  Future<void> pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        selectedHour =
            "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      setState(() {
        selectedDate = "${date.day}/${date.month}/${date.year}";
      });
    }
  }

  void addTask() {
    if (controller.text.isEmpty) return;

    setState(() {
      tasks.add(
        Task(
          title: controller.text,
          hour: selectedHour,
          date: selectedDate,
          color: selectedColor,
        ),
      );

      controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F7),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Agenda Polon",
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            // Campo texto
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),

              child: TextField(
                controller: controller,

                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Nome da tarefa",
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Data
            GestureDetector(
              onTap: pickDate,

              child: Container(
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    const Text("Selecionar data"),

                    Text(
                      selectedDate,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Hora
            GestureDetector(
              onTap: pickTime,

              child: Container(
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    const Text("Selecionar horário"),

                    Text(
                      selectedHour,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Cores
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: colors.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                  },

                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),

                    width: 35,
                    height: 35,

                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,

                      border: selectedColor == color
                          ? Border.all(color: Colors.black, width: 3)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Botão
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: addTask,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,

                  padding: const EdgeInsets.symmetric(vertical: 18),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),

                child: const Text(
                  "Adicionar",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Lista
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,

                itemBuilder: (context, index) {
                  final task = tasks[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),

                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(22),
                    ),

                    child: Row(
                      children: [
                        // Barra colorida
                        Container(
                          width: 8,
                          height: 70,

                          decoration: BoxDecoration(
                            color: task.color,

                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Infos
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                task.title,

                                style: TextStyle(
                                  fontSize: 20,

                                  decoration: task.done
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(task.hour),

                              Text(task.date),
                            ],
                          ),
                        ),

                        Checkbox(
                          value: task.done,

                          activeColor: task.color,

                          onChanged: (value) {
                            setState(() {
                              task.done = value!;
                            });
                          },
                        ),

                        IconButton(
                          onPressed: () {
                            setState(() {
                              tasks.removeAt(index);
                            });
                          },

                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
