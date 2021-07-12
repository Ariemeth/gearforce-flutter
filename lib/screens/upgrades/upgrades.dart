import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:provider/provider.dart';

class UpgradesDialog extends StatelessWidget {
  UpgradesDialog({
    Key? key,
    required this.roster,
  }) : super(key: key);

  final UnitRoster roster;

  @override
  Widget build(BuildContext context) {
    //TODO do I need to get data?  unitcore's reference their frame and the unit
    //upgrades file has a function to retrieve available unit upgrades by frame
    final data = Provider.of<Data>(context);
    final unit = Provider.of<Unit>(context);
    final unitMods =
        data.availableUnitMods(roster.faction.value!, unit.core.frame);

    var dialog = SimpleDialog(
      title: Center(
        child: Row(
          children: [
            Text(
              'Upgrades available to this ',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              unit.core.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      children: [
        Column(
          children: [
            Column(
                // create listview with available upgrades
                children: [
                  Text(
                    'Unit Upgrades',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  unitMods.length > 0
                      ? Container(
                          width: 400,
                          height: 40,
                          child: ListView.builder(
                              itemCount: unitMods.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  children: [
                                    Checkbox(
                                        value:
                                            unit.hasMod(unitMods[index].name),
                                        onChanged: (bool? newValue) {
                                          if (newValue!) {
                                            unit.addUnitMod(unitMods[index]);
                                          } else {
                                            unit.removeUnitMod(
                                                unitMods[index].name);
                                          }
                                        }),
                                    Text(
                                      '${unitMods[index].name}: ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                    ...unitMods[index].description.map((e) {
                                      if (unitMods[index].description[
                                              unitMods[index]
                                                      .description
                                                      .length -
                                                  1] ==
                                          e) {
                                        return Text(
                                          e,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        );
                                      }
                                      return Text(
                                        '$e, ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      );
                                    }).toList()
                                  ],
                                );
                              }),
                        )
                      : const Center(child: Text('no upgrades available')),
                ]),
          ],
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, null);
          },
          child: Center(
            child: Text(
              'Done',
              style: TextStyle(fontSize: 24, color: Colors.green),
            ),
          ),
        ),
      ],
    );
    return dialog;
  }
}
