# Circuits
Idea for a way to quickly input circuit diagrams with only a keyboard. Made with Processing.

## Controls
- You start in selection mode. Use the arrow keys to move the sqaure cursor.
- <kbd>Space</kbd> to enter drawing mode.
- Select a component type with the following keys
  - Resistor <kbd>r</kbd>
  - Capacitor <kbd>c</kbd>
  - Inductor <kbd>l</kbd>
  - Battery Cell<kbd>b</kbd>
  - Open Circuit <kbd>o</kbd>
  - Voltage source<kbd>v</kbd>
  - Dependant voltage source <kbd>Shift</kbd><kbd>V</kbd>
  - Current source <kbd>i</kbd>
  - Dependant current source <kbd>Shift</kbd><kbd>I</kbd>
  - Bipolar Junction Transistor <kbd>t</kbd>
  - Feild Effect Transistor <kbd>f</kbd>
  - Ground <kbd>g</kbd>
  - Wire <kbd>;</kbd> (Default)
- Use the arrow keys to set the ending position for the current component, then <kbd>Space</kbd> to place it.
- Some components will enter label mode to enter a value or variable name. Use the arrow keys or enter key to continue to draw mode.
- Exit drawing mode with <kbd>ESC</kbd> or <kbd>Enter</kbd> to go back to selection mode. Certain components, such as an open circuit, will exit to selection mode automatically.

Use <kbd>u</kbd> for undo, and <kbd>Shift</kbd><kbd>R</kbd> to redo.

Press a key multiple times for simular components, e.g. press <kbd>b</kbd> twice for a two-cell battery, or <kbd>t</kbd> twice to change between a PNP and NPN transistor.

You may use the <kbd>w</kbd><kbd>a</kbd><kbd>s</kbd><kbd>d</kbd> keys instead of the arrows, however you will not be able to exit label mode with these keys.

## To do
- Add floating notes.
- Crop exported image so that circuit sits in screen center.
- Change how i/o is implemented to stop unexpected behavior with code char duality.
- Center component labels.
- Make inductor symbol more fancy
- Use super sampling.

<img width="502" alt="2017-04-16 at 8 24 03 pm" src="https://cloud.githubusercontent.com/assets/12654833/25069929/19e05b20-22e3-11e7-889d-64357f088005.png">
