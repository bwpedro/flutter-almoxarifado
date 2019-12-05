// FROM JSON
class User {
  final int id;
  final String nome;
  final String cpf;
  final String email;
  final String senha;
  final String cargo;

  User({this.id, this.nome, this.cpf, this.email, this.senha, this.cargo});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nome: json['nome'],
      cpf: json['cpf'],
      email: json['email'],
      senha: json['senha'],
      cargo: json['cargo'],
    );
  }
}

class RetiradasAbertas {
  final int idRetirada;
  final String nomePeca;
  final String status;

  RetiradasAbertas({this.idRetirada, this.nomePeca, this.status});

  factory RetiradasAbertas.fromJson(Map<String, dynamic> json) {
    return RetiradasAbertas(
        idRetirada: json['idRetirada'],
        nomePeca: json['nomePeca'],
        status: json['status']);
  }
}

class Peca {
  final int id;
  final String nome;
  final int qtdDisponivel;
  final int qtdMinima;

  Peca({
    this.id,
    this.nome,
    this.qtdDisponivel,
    this.qtdMinima,
  });

  factory Peca.fromJson(Map<String, dynamic> json) {
    return Peca(
      id: json['id'],
      nome: json['nome'],
      qtdDisponivel: json['qtdDisponivel'],
      qtdMinima: json['qtdMinima'],
    );
  }
}

class PecasRepor {
  final String nomePeca;
  final int idPeca;
  final String dataAviso;
  final int idAviso;

  PecasRepor({this.nomePeca, this.idPeca, this.dataAviso, this.idAviso});

  factory PecasRepor.fromJson(Map<String, dynamic> json) {
    return PecasRepor(
      nomePeca: json['nomePeca'],
      idPeca: json['idPeca'],
      dataAviso: json['dataAviso'],
      idAviso: json['idAviso'],
    );
  }
}

class HistoricoResult {
  final String nome;
  final String dataPedido;

  HistoricoResult({this.nome, this.dataPedido});

  factory HistoricoResult.fromJson(Map<String, dynamic> json) {
    return HistoricoResult(
        nome: json['nomePeca'], dataPedido: json['dataPedido']);
  }
}

class PedidosAbertos {
  final int idPeca;
  final String nomePeca;
  final String dataPedido;
  final int qtdRequerida;
  final int idRetirada;

  PedidosAbertos(
      {this.idPeca,
      this.nomePeca,
      this.dataPedido,
      this.qtdRequerida,
      this.idRetirada});

  factory PedidosAbertos.fromJson(Map<String, dynamic> json) {
    return PedidosAbertos(
      idPeca: json['idPeca'],
      nomePeca: json['nomePeca'],
      dataPedido: json['dataPedido'],
      qtdRequerida: json['qtdRequerida'],
      idRetirada: json['idRetirada'],
    );
  }
}

// TO JSON

class AcceptRequest {
  final int idAlmoxarife;
  final int idRetirada;

  AcceptRequest({this.idAlmoxarife, this.idRetirada});

  Map<String, dynamic> toJson() {
    return {
      'idAlmoxarife': idAlmoxarife,
      'idRetirada': idRetirada,
    };
  }
}

class CreateUser {
  final String nome;
  final String cpf;
  final String email;
  final String senha;
  final String cargo;

  CreateUser({this.nome, this.cpf, this.email, this.senha, this.cargo});

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'cpf': cpf,
      'email': email,
      'senha': senha,
      'cargo': cargo,
    };
  }
}

class BuscarPeca {
  final int idRetirada;

  BuscarPeca({this.idRetirada});

  Map<String, dynamic> toJson() {
    return {
      'idRetirada': idRetirada,
    };
  }
}

class RequestPeca {
  final int idPeca;
  final int idFuncionario;
  final int qtdRequerida;

  RequestPeca({this.idPeca, this.idFuncionario, this.qtdRequerida});

  Map<String, dynamic> toJson() {
    return {
      'idPeca': idPeca,
      'idFuncionario': idFuncionario,
      'qtdRequerida': qtdRequerida,
    };
  }
}

class ReporPeca {
  final int qtdRepor;
  final int idPeca;
  final int idAviso;

  ReporPeca({
    this.qtdRepor,
    this.idPeca,
    this.idAviso,
  });

  Map<String, dynamic> toJson() {
    return {
      'qtdRepor': qtdRepor,
      'idPeca': idPeca,
      'idAviso': idAviso,
    };
  }
}
