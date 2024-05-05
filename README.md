#  Conway-ish
## Experiments with GamePlayKit's Entity-Component system

Using my world-famous framework for getting SwiftUI, SpriteKit, and macOS to
play nice together (which seems to kindof turn out to be just placing a nearly
invisible view on your SpriteView).

- Mouse wheel to change zoom level
- Checkbox to turn the grid lines on/off
- Click "Clear All" to clear the existing grid, that is, "kill" all the life-forms
- Click "Sow Random" to place dots randomly around the grid and start Conwaying. Doesn't pre-clear
the existing grid
- Click "Place Gun" to see the Gosper's glider gun in action, as shown in the demo below. Doesn't pre-clear the
existing grid
- Click individual cell to toggle life form alive/dead
- Mouse-drag-select cells to toggle life forms in selected cells 

![](https://github.com/SaganRitual/Conway/blob/main/Demo.gif)
