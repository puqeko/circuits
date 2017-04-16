# Circuits
Idea for a way to quickly input circuit diagrams with only a keyboard. Made with Processing.

### To do
- Add notes/labels.
- Crop exported image so that circuit sits in screen center.
- Change how i/o is implemented to stop unexpected behavior with code char duality.
- Center component labels.
- Make inductor symbol more fancy
- Use super sampling.

<img width="501" alt="2017-04-15 at 7 54 15 pm" src="https://cloud.githubusercontent.com/assets/12654833/25061942/bae19b98-2215-11e7-8f0c-0771e79b28d9.png">

### Controls
- You start in selection mode. Use the arrow keys to move the sqaure cursor.
- <kbd>Space</kbd> to enter drawing mode.
- Select a component type with the following keys
  - Resistor <kbd>r</kbd>
  - Capacitor <kbd>c</kbd>
  - Inductor <kbd>i</kbd>
  - Battery Cell <kbd>b</kbd>
  - Open Circuit <kbd>o</kbd>
  - Wire <kbd>;</kbd> (Default)
- Use the arrow keys to set the ending position for the current component, then <kbd>Space</kbd> to place it.
- For components other than a wire, you enter label mode to enter a value or variable name. Use the arrow keys or enter key to continue to draw mode.
- Exit drawing mode with <kbd>ESC</kbd> or <kbd>Enter</kbd> to go back to selection mode. Certain components, such as an open circuit, will exit to selection mode automatically.

Use <kbd>u</kbd> for undo, and <kbd>Shift</kbd><kbd>R</kbd> to redo.
