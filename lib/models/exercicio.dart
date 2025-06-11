class Exercicio {
  String nome;
  String descricao;
  String grupoMuscular;
  int duracaoEmMinutos; // Nova métrica: duração do exercício em minutos

  Exercicio({
    required this.nome,
    required this.descricao,
    required this.grupoMuscular,
    required this.duracaoEmMinutos,
  });
}
