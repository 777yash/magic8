// ui/Main.qml
import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5

ApplicationWindow {
    id: win
    width: 560
    height: 720
    visible: true
    title: "Magic 8 Ball"
    color: "#0f1115"

    // Provided by Python after load
    property var logic

    // Optional fonts (remove if not present)
    FontLoader { id: inter; source: "../assets/fonts/Inter-Regular.ttf" }
    FontLoader { id: interSemi; source: "../assets/fonts/Inter-SemiBold.ttf" }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 18

        Label {
            text: "Magic 8 Ball"
            color: "#E6E8EC"
            font.family: interSemi.status === FontLoader.Ready ? interSemi.name : font.family
            font.pixelSize: 26
            Layout.alignment: Qt.AlignHCenter
        }

        // Card with soft shadow (no effects modules needed)
        Item {
            id: cardWrapper
            Layout.fillWidth: true
            Layout.preferredHeight: 420

            // Soft shadow rectangle behind the card
            Rectangle {
                anchors.centerIn: card
                width: card.width
                height: card.height
                radius: card.radius + 2
                color: "#101626"
                opacity: 0.22
                y: 10
                z: 1
                visible: true
            }

            // Main card surface
            Rectangle {
                id: card
                anchors.fill: parent
                radius: 20
                color: "#141923"
                border.color: "#1f2633"
                border.width: 1
                z: 2
            }
        }

        // Content overlay on top of the card
        Item {
            anchors.fill: cardWrapper
            anchors.margins: 20

            ColumnLayout {
                anchors.fill: parent
                spacing: 14

                // Icon row (make sure the file exists; switch to .png if SVG support is absent)
                RowLayout {
                    spacing: 10
                    Layout.fillWidth: true
                    visible: true

                    Image {
                        id: ballIcon
                        // If SVG doesn’t show, use: "../assets/icons/ball.png"
                        source: "../assets/icons/ball.svg"
                        width: 28
                        height: 28
                        fillMode: Image.PreserveAspectFit
                        onStatusChanged: {
                            if (status === Image.Error) {
                                console.warn("Icon failed to load:", source)
                            }
                        }
                    }

                    Label {
                        text: "Ask wisely."
                        color: "#98A2B3"
                        font.pixelSize: 13
                        font.family: inter.status === FontLoader.Ready ? inter.name : font.family
                    }
                }

                TextArea {
                    id: question
                    placeholderText: "Ask your question..."
                    wrapMode: Text.Wrap
                    color: "#E6E8EC"
                    placeholderTextColor: "#7C8799"
                    font.family: inter.status === FontLoader.Ready ? inter.name : font.family
                    font.pixelSize: 15
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    selectByMouse: true

                    background: Rectangle {
                        radius: 12
                        color: "#0f131a"
                        border.color: "#273043"
                        border.width: 1
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    // Animated spinner (no external modules)
                    Item {
                        id: spinner
                        width: 18; height: 18
                        visible: win.logic && win.logic.isThinking

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
                            running: win.logic && win.logic.isThinking
                            from: 0; to: 360
                            duration: 900
                            loops: Animation.Infinite
                            easing.type: Easing.InOutQuad
                        }
                    }

                    Label {
                        id: status
                        text: win.logic ? (win.logic.isThinking ? "Thinking..." : win.logic.answerText) : "Loading..."
                        color: win.logic && win.logic.isThinking ? "#93C5FD" : "#E6E8EC"
                        font.pixelSize: 14
                        font.family: inter.status === FontLoader.Ready ? inter.name : font.family
                        wrapMode: Text.Wrap
                        Layout.fillWidth: true
                        Behavior on text { NumberAnimation { duration: 220; easing.type: Easing.InOutQuad } }
                    }
                }
            }
        }

        // Buttons row 1
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Button {
                id: askBtn
                text: "Ask"
                Layout.fillWidth: true
                contentItem: Text {
                    text: askBtn.text
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 15
                    font.family: interSemi.status === FontLoader.Ready ? interSemi.name : font.family
                }
                background: Rectangle {
                    radius: 12
                    color: askBtn.down ? "#1D4ED8" : "#2563EB"
                }
                onClicked: win.logic && win.logic.ask(question.text)
            }

            Button {
                id: clearBtn
                text: "Clear"
                Layout.preferredWidth: 140
                contentItem: Text {
                    text: clearBtn.text
                    color: "#E5E7EB"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 15
                    font.family: interSemi.status === FontLoader.Ready ? interSemi.name : font.family
                }
                background: Rectangle {
                    radius: 12
                    color: clearBtn.down ? "#0b111a" : "#0f141d"
                    border.color: "#253044"
                    border.width: 1
                }
                onClicked: {
                    question.text = ""
                    win.logic && win.logic.reset()
                    question.forceActiveFocus()
                }
            }
        }

        // Buttons row 2
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Button {
                id: playBtn
                text: "Play Again"
                Layout.fillWidth: true
                contentItem: Text {
                    text: playBtn.text
                    color: "#E5E7EB"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 15
                    font.family: interSemi.status === FontLoader.Ready ? interSemi.name : font.family
                }
                background: Rectangle {
                    radius: 12
                    color: playBtn.down ? "#0b111a" : "#0f141d"
                    border.color: "#253044"
                    border.width: 1
                }
                onClicked: {
                    question.text = ""
                    win.logic && win.logic.reset()
                    question.forceActiveFocus()
                }
            }

            Button {
                id: quitBtn
                text: "Quit"
                Layout.preferredWidth: 140
                contentItem: Text {
                    text: quitBtn.text
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 15
                    font.family: interSemi.status === FontLoader.Ready ? interSemi.name : font.family
                }
                background: Rectangle {
                    radius: 12
                    color: quitBtn.down ? "#b91c1c" : "#dc2626"
                }
                onClicked: Qt.quit()
            }
        }

        Item { Layout.fillHeight: true }
    }

    // Keyboard shortcuts
    Shortcut { sequence: "Enter"; onActivated: askBtn.clicked() }
    Shortcut { sequence: "Ctrl+L"; onActivated: clearBtn.clicked() }
    Shortcut { sequence: "Esc"; onActivated: Qt.quit() }
}
