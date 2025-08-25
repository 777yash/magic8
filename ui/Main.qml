import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5

ApplicationWindow {
    id: win
    width: 560
    height: 420
    visible: true
    title: "Magic 8 Ball"
    color: "#0f1115"

    Component.onCompleted: question.forceActiveFocus()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 14

        Label {
            text: "Magic 8 Ball"
            color: "#E6E8EC"
            font.pixelSize: 22
            Layout.alignment: Qt.AlignHCenter
        }

        // Card with shadow
        Item {
            id: cardWrapper
            Layout.fillWidth: true
            Layout.preferredHeight: 220

            Rectangle {
                anchors.centerIn: card
                width: card.width
                height: card.height
                radius: card.radius + 2
                color: "#101626"
                opacity: 0.22
                y: 10
                z: 1
            }

            Rectangle {
                id: card
                anchors.fill: parent
                radius: 14
                color: "#141923"
                border.color: "#1f2633"
                border.width: 1
                z: 2
            }
        }

        // Content over the card
        Item {
            anchors.fill: cardWrapper
            anchors.margins: 16

            ColumnLayout {
                anchors.fill: parent
                spacing: 12

                // Header with icon (using a simple circle as fallback)
                RowLayout {
                    spacing: 10
                    Layout.fillWidth: true

                    // Your actual icon
                    Image {
                        id: ballIcon
                        source: "../assets/icons/ball.png"  // Try PNG first (more compatible)
                        // If you prefer SVG: source: "../assets/icons/ball.svg"
                        width: 24
                        height: 24
                        fillMode: Image.PreserveAspectFit
                        onStatusChanged: {
                            if (status === Image.Error) {
                                console.warn("Icon failed to load:", source)
                                console.warn("Make sure the file exists at:", source)
                            } else if (status === Image.Ready) {
                                console.log("Icon loaded successfully:", source)
                            }
                        }

                        // Fallback: show a simple rectangle if image fails to load
                        Rectangle {
                            anchors.fill: parent
                            visible: parent.status === Image.Error
                            color: "#2563EB"
                            radius: 12
                            border.color: "#60A5FA"
                            border.width: 2
                            Text {
                                anchors.centerIn: parent
                                text: "8"
                                color: "white"
                                font.pixelSize: 14
                                font.bold: true
                            }
                        }
                    }


                    Label {
                        text: "Ask wisely."
                        color: "#98A2B3"
                        font.pixelSize: 13
                    }
                }

                // Single-line input: type the question here
                TextField {
                    id: question
                    placeholderText: "Ask your question..."
                    color: "#E6E8EC"
                    placeholderTextColor: "#7C8799"
                    font.pixelSize: 15
                    Layout.fillWidth: true
                    selectByMouse: true
                    background: Rectangle {
                        radius: 10
                        color: "#0f131a"
                        border.color: "#273043"
                        border.width: 1
                    }
                }

                // Status row: spinner + text
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Item {
                        id: spinner
                        width: 18
                        height: 18
                        visible: logic && logic.isThinking

                        Canvas {
                            anchors.fill: parent
                            onPaint: {
                                var ctx = getContext("2d");
                                ctx.reset();
                                ctx.lineWidth = 2;
                                ctx.strokeStyle = "#60A5FA";
                                ctx.beginPath();
                                ctx.arc(width/2, height/2, 7, 0, Math.PI * 1.2);
                                ctx.stroke();
                            }
                        }

                        RotationAnimator on rotation {
                            running: logic && logic.isThinking
                            from: 0; to: 360
                            duration: 900
                            loops: Animation.Infinite
                            easing.type: Easing.InOutQuad
                        }
                    }

                    Label {
                        id: status
                        text: logic ? (logic.isThinking ? "Thinking..." : logic.answerText) : "Loading..."
                        color: logic && logic.isThinking ? "#93C5FD" : "#E6E8EC"
                        font.pixelSize: 14
                        wrapMode: Text.Wrap
                        Layout.fillWidth: true
                        Behavior on text { NumberAnimation { duration: 200 } }
                    }
                }
            }
        }

        // Buttons row 1
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Button {
                id: askBtn
                text: "Ask"
                Layout.fillWidth: true
                onClicked: logic && logic.ask(question.text)
                background: Rectangle { radius: 10; color: askBtn.down ? "#1D4ED8" : "#2563EB" }
                contentItem: Text { text: askBtn.text; color: "white"; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
            }

            Button {
                id: clearBtn
                text: "Clear"
                Layout.preferredWidth: 120
                onClicked: {
                    question.text = ""
                    logic && logic.reset()
                    question.forceActiveFocus()
                }
                background: Rectangle { radius: 10; color: "#0f141d"; border.color: "#253044"; border.width: 1 }
                contentItem: Text { text: clearBtn.text; color: "#E5E7EB"; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
            }
        }

        // Buttons row 2
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Button {
                id: playBtn
                text: "Play Again"
                Layout.fillWidth: true
                onClicked: {
                    question.text = ""
                    logic && logic.reset()
                    question.forceActiveFocus()
                }
                background: Rectangle { radius: 10; color: "#0f141d"; border.color: "#253044"; border.width: 1 }
                contentItem: Text { text: playBtn.text; color: "#E5E7EB"; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
            }

            Button {
                id: quitBtn
                text: "Quit"
                Layout.preferredWidth: 120
                onClicked: Qt.quit()
                background: Rectangle { radius: 10; color: "#dc2626" }
                contentItem: Text { text: quitBtn.text; color: "white"; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
            }
        }

        Item { Layout.fillHeight: true }
    }

    // Shortcuts
    Shortcut { sequence: "Enter"; onActivated: askBtn.clicked() }
    Shortcut { sequence: "Ctrl+L"; onActivated: clearBtn.clicked() }
    Shortcut { sequence: "Esc"; onActivated: Qt.quit() }
}
