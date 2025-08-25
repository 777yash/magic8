import sys
import os
import random
from PySide6.QtCore import QObject, Property, Signal, Slot, QTimer, QUrl
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtGui import QGuiApplication

RESPONSES = [
    "It is certain.",
    "It is decidedly so.",
    "Without a doubt.",
    "Yes – definitely.",
    "You may rely on it.",
    "As I see it, yes.",
    "Most likely.",
    "Outlook good.",
    "Yes.",
    "Signs point to yes.",
    "Reply hazy, try again.",
    "Ask again later.",
    "Better not tell you now.",
    "Cannot predict now.",
    "Concentrate and ask again.",
    "Don't count on it.",
    "My reply is no.",
    "My sources say no.",
    "Outlook not so good.",
    "Very doubtful."
]

class Logic(QObject):
    isThinkingChanged = Signal()
    answerTextChanged = Signal()

    def __init__(self):
        super().__init__()
        self._isThinking = False
        self._answerText = "Ask any question to begin."

    @Property(bool, notify=isThinkingChanged)
    def isThinking(self):
        return self._isThinking

    @Property(str, notify=answerTextChanged)
    def answerText(self):
        return self._answerText

    @Slot(str)
    def ask(self, question: str):
        q = (question or "").strip()
        if not q:
            self._answerText = "Please enter a question."
            self.answerTextChanged.emit()
            return
        self._isThinking = True
        self.isThinkingChanged.emit()
        self._answerText = "Thinking..."
        self.answerTextChanged.emit()
        QTimer.singleShot(900, self._reveal)

    @Slot()
    def reset(self):
        self._isThinking = False
        self.isThinkingChanged.emit()
        self._answerText = "Ask any question to begin."
        self.answerTextChanged.emit()

    def _reveal(self):
        self._isThinking = False
        self.isThinkingChanged.emit()
        self._answerText = f"Magic 8 Ball says: {random.choice(RESPONSES)}"
        self.answerTextChanged.emit()

def main():
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    logic = Logic()
    # Expose backend as context property
    engine.rootContext().setContextProperty("logic", logic)

    # Load QML from project root
    qml_file = os.path.join(os.path.dirname(os.path.dirname(__file__)), "ui", "Main.qml")
    engine.load(QUrl.fromLocalFile(qml_file))
    
    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())

if __name__ == "__main__":
    main()
