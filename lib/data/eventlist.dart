import 'package:event_app/models/event.dart';
import 'package:event_app/models/event_category.dart';

List<Event> EventsList = [
  Event(
    id: "1",
    title: "Conferencia Internacional de IA",
    location: "Auditorio Principal, Facultad de Ingeniería",
    dateTime: DateTime(2024, 5, 15, 09, 30),
    description: "Únete a expertos internacionales en una conferencia sobre los últimos avances en Inteligencia Artificial y Machine Learning. Se abordarán temas como Deep Learning, Procesamiento de Lenguaje Natural y Ética en IA.",
    maxParticipants: 200,
    currentParticipants: 0,
    category: EventCategory.conference,
    isPastEvent: false,
    imageUrl: "assets/images/1.jpg", // Cambiar por una imagen apropiada
    rating: 4.8,
    totalRatings: 250,
  ),
  Event(
    id: "2",
    title: "Taller de Investigación Científica",
    location: "Laboratorio de Ciencias, Edificio B",
    dateTime: DateTime(2024, 7, 23, 14, 00),
    description: "Taller práctico sobre metodología de investigación, redacción de papers académicos y uso de herramientas estadísticas para investigación. Dirigido a estudiantes de postgrado.",
    maxParticipants: 30,
    currentParticipants: 25,
    category: EventCategory.workshop,
    isPastEvent: false,
    imageUrl: "assets/images/2.jpg", // Cambiar por una imagen apropiada
    rating: 4.9,
    totalRatings: 180,
  ),
  Event(
    id: "3",
    title: "Innovación en Educación Superior",
    location: "Sala de Conferencias, Biblioteca Central",
    dateTime: DateTime(2024, 6, 29, 10, 00),
    description: "Expertos en educación superior compartirán las últimas tendencias en metodologías de enseñanza, tecnología educativa y adaptación al aprendizaje híbrido post-pandemia.",
    maxParticipants: 100,
    currentParticipants: 45,
    category: EventCategory.course,
    isPastEvent: false,
    imageUrl: "assets/images/3.jpg", // Cambiar por una imagen apropiada
    rating: 0.0,
    totalRatings: 0,
  ),
  Event(
    id: "4",
    title: "Proyectos de Investigación",
    location: "Sala Multimedia, Facultad de Ciencias",
    dateTime: DateTime(2024, 8, 10, 15, 00),
    description: "Estudiantes de último año presentarán sus proyectos de investigación en diversas áreas. Excelente oportunidad para networking y conocer las últimas investigaciones.",
    maxParticipants: 150,
    currentParticipants: 0,
    category: EventCategory.conference,
    isPastEvent: false,
    imageUrl: "assets/images/1.jpg", // Cambiar por una imagen apropiada
    rating: 0.0,
    totalRatings: 0,
  ),
  Event(
    id: "5",
    title: "Python para Ciencia de Datos",
    location: "Laboratorio de Computación, Edificio A",
    dateTime: DateTime(2024, 9, 5, 08, 30),
    description: "Curso práctico de 3 días sobre Python aplicado a Ciencia de Datos. Se cubrirán bibliotecas como Pandas, NumPy y Scikit-learn.",
    maxParticipants: 40,
    currentParticipants: 15,
    category: EventCategory.course,
    isPastEvent: true,
    imageUrl: "assets/images/2.jpg", // Cambiar por una imagen apropiada
    rating: 0.0,
    totalRatings: 0,
  ),
];