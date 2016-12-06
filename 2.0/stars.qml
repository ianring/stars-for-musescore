//=============================================================================
//  AddStar v. 1.0
//
//  Copyright (C) 2016 Ian Ring
//
//  Borrowing code and following the example of AddNoteNameNoteHeads plugin by Jon Ensminger
//  Which in turn credits the shape_notes plugin by Nicolas Froment
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//=============================================================================

import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import MuseScore 1.0

MuseScore {
version:  "1.0"
description: qsTr("Adds a star modifier to a note or rest")
menuPath: "Plugins.Notes." + qsTr("Add Star")

property var starGlyph

function applyToNotesInSelection(func) {
	var cursor = curScore.newCursor();
	cursor.rewind(1);
	var startStaff;
	var endStaff;
	var endTick;
	var fullScore = false;
	if (!cursor.segment) { // no selection
		fullScore = true;
		startStaff = 0; // start with 1st staff
		endStaff = curScore.nstaves - 1; // and end with last
	} else {
		startStaff = cursor.staffIdx;
		cursor.rewind(2);
		if (cursor.tick == 0) {
			// this happens when the selection includes
			// the last measure of the score.
			// rewind(2) goes behind the last segment (where
			// there's none) and sets tick=0
			endTick = curScore.lastSegment.tick + 1;
		} else {
			endTick = cursor.tick;
		}
		endStaff = cursor.staffIdx;
	}
	console.log(startStaff + " - " + endStaff + " - " + endTick)

	for (var staff = startStaff; staff <= endStaff; staff++) {
		for (var voice = 0; voice < 4; voice++) {
			cursor.rewind(1); // sets voice to 0
			cursor.voice = voice; // voice has to be set after goTo
			cursor.staffIdx = staff;
			if (fullScore) {
				cursor.rewind(0) // if no selection, beginning of score
			}
			while (cursor.segment && (fullScore || cursor.tick < endTick)) {

				if (cursor.element) {
					addStar(cursor);
				}

				cursor.next();
			}
		}
	}
}

function transformDuration(durationType) {
	return (durationType / 4) * 5
}

function addStar(cursor) {
	var element = cursor.element;
	element.tickLen = transformDuration(element.tickLen);

	if (element && element.type == Element.CHORD) {
		// figure out placement of stars for a chord

		var notes = element.notes;
		for (var i = 0; i < notes.length; i++) {
			var note = notes[i];
			if (note) {

				// figure out where stars should go

			}
		}

	}

	if (element && element.type == Element.REST) {

		// figure out how to place a star beside the rest	
		starGlyph = newElement(Element.STAFF_TEXT);
		starGlyph.text = '\u2605';
		starGlyph.userOff = Qt.point(0,0);
		starGlyph.pos = Qt.point(note.pos.x + 2, note.pos.y);

		cursor.add(starGlyph);

	}

}

Dialog {
	id : readmeDialog
	title : qsTr("Instructions")
	width : 470
	Text {
		id : readmeText
		text : qsTr("<b>Description:</b>  Places a star modifier besode a note or rest, extending its duration by 1/4 of itself.<br/><br/>If a note already has a dot, the dot will be removed")
	}
	standardButtons: StandardButton.Cancel | StandardButton.Ok
	onAccepted : applyFunction();
	onRejected : Qt.quit();
}

function applyFunction() {
	curScore.startCmd();
	applyToNotesInSelection();
	curScore.endCmd();
	Qt.quit();
}

onRun: {
	if (typeof curScore === 'undefined') {
		Qt.quit();
	}
	readmeDialog.open();
}



}
