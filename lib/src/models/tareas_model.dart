class tareasModel {
  int? idTarea;
  String? nomTarea;
  String? dscTarea;
  String? fechaEntrega;
  String? entregada;

  tareasModel(
      {this.idTarea,
      this.nomTarea,
      this.dscTarea,
      this.fechaEntrega,
      this.entregada});
  factory tareasModel.fromMap(Map<String, dynamic> map) {
    return tareasModel(
        idTarea: map['idTarea'],
        nomTarea: map['nomTarea'],
        dscTarea: map['dscTarea'],
        fechaEntrega: map['fechaEntrega'],
        entregada: map['entregada']);
  }
  Map<String, dynamic> toMap() {
    return {
      'idTarea': idTarea,
      'nomTarea': nomTarea,
      'dscTarea': dscTarea,
      'fechaEntrega': fechaEntrega,
      'entregada': entregada
    };
  }
}
