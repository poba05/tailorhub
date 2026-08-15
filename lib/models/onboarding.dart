class Onboarding {
  final String image;
  final String header;
  final String title;
  final String description;

  Onboarding({
    required this.image,
    required this.header,
    required this.title,
    required this.description,
  });
}

List<Onboarding> onboarding = [
  Onboarding(
    image: "lib/assets/images/hero_image2.png",
    header: "Client book",
    title: "Every client,\nperfectly kept.",
    description:
        "Names, numbers, notes and visit history —\norganised the way a master tailor thinks.",
  ),
  Onboarding(
    image: "lib/assets/images/hero_image1.jpg",
    header: "Measurements",
    title: "Measure once,\nreuse forever.",
    description:
        "Grouped measurement cards, saved\ntemplates, and a full history for every client.",
  ),
  Onboarding(
    image: "lib/assets/images/hero_image3.png",
    header: "workflow",
    title: "From cutting\nto collection.",
    description:
        "Track each garment through cutting, sewing\nand delivery with payments in step.",
  ),
];
