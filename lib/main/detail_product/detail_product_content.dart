import 'package:app_desafio_inovacao/core/utils/line.dart';
import 'package:app_desafio_inovacao/main/detail_product/detail_product_bloc.dart';
import 'package:app_desafio_inovacao/main/detail_product/detail_product_event.dart';
import 'package:app_desafio_inovacao/main/request/request_page.dart';
import 'package:app_desafio_inovacao/models/datasheet_model.dart';
import 'package:app_desafio_inovacao/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailProductContent extends StatelessWidget {
  final Product product;

  DetailProductContent({@required this.product});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: <Widget>[
      Line(),
      _slider(product.images),
      Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            product.name,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          )),
//      description(),
      datasheet(context)
    ]));
  }

  Widget _slider(List images) {
    return Container(
        width: double.infinity,
        height: 300.0,
        child: DefaultTabController(
            length: product.images.length <= 1 ? 1 : product.images.length,
            child: PageView(
                children: images
                    .map((item) => Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(item),
                                  fit: BoxFit.contain)),
                          width: double.infinity,
                          height: 300.0,
                        ))
                    .toList())));
  }

  Widget description() {
    return Column(children: <Widget>[
      ListTile(title: Text('Apresentação do produto')),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(product.description))
    ]);
  }

  Widget datasheet(context) {
    print('product.dataSheet ${product.dataSheet}');
    return Column(children: <Widget>[
      ListTile(
          title: Text('Ficha Tecnica',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500))),
      Padding(
          padding: const EdgeInsets.only(bottom: 56.0),
          child: Column(
              children: product.dataSheet
                  .asMap()
                  .map((index, value) => MapEntry(
                      index,
                      itemDatasheet(
                          context: context,
                          index: index,
                          dataSheet: value,
                          product: product)))
                  .values
                  .toList()))
    ]);
  }

  Widget itemDatasheet(
      {@required BuildContext context,
      @required int index,
      @required DataSheet dataSheet,
      @required Product product}) {
    return InkWell(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext bc) {
                return Container(
                    child: Wrap(children: <Widget>[
                  ListTile(
                    title: Text('Atributo "${dataSheet.attribute}" selecionado',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500)),
                  ),
                  ListTile(
                      leading: Icon(
                        Icons.edit,
                        color: Colors.amber.shade700,
                      ),
                      title: Text('Deseja sugerir uma alteração?',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.amber.shade700)),
                      onTap: () async {
                        Navigator.pop(context);
                        final changed = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RequestPage(
                                    product: product.id,
                                    idDataSheet: dataSheet.id,
                                    initialAttribute: dataSheet.attribute,
                                    initialValue: dataSheet.value)));

                        if (changed == true) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Solicitação de alteração enviada com sucesso!'),
                            duration: Duration(seconds: 3),
                          ));
                        }
                      }),
                  ListTile(
                      leading: Icon(Icons.warning, color: Colors.red),
                      title: Text('Informação enganosa',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.red)),
                      onTap: () {
                        BlocProvider.of<DetailProductBloc>(context).dispatch(
                            Report(
                                idDataSheet: dataSheet.id,
                                product: product.id));
                        Navigator.pop(context);
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('Informação reportada com sucesso'),
                            duration: Duration(seconds: 3)));
                      })
                ]));
              });
        },
        child: Container(
            height: 56.0,
            color: index % 2 == 0 ? Colors.transparent : Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Row(children: <Widget>[
              Flexible(
                  flex: 1,
                  child: Container(
                      constraints: BoxConstraints.expand(),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(dataSheet.attribute ?? '',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500))
                          ]))),
              Flexible(
                  flex: 1,
                  child: Container(
                      constraints: BoxConstraints.expand(),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(dataSheet.value ?? '',
                                style: TextStyle(fontSize: 16))
                          ])))
            ])));
  }
}
