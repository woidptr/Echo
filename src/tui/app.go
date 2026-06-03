package tui

import tea "github.com/charmbracelet/bubbletea"

type AppModel struct {
	stack *SceneStack

	state  int
	width  int
	height int
}

func NewAppModel() AppModel {
	firstScreen := WelcomeScreen{}

	return AppModel{
		stack: NewSceneStack(firstScreen),
	}
}

func (m AppModel) Init() tea.Cmd {
	return nil
}

func (m AppModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	activeScreen := m.stack.GetTopScreen()

	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.width = msg.Width
		m.height = msg.Height
	case tea.KeyMsg:
		switch msg.String() {
		case "ctrl+c":
			return m, tea.Quit
		}
	}

	var cmd tea.Cmd
	updatedScreen, cmd := activeScreen.Update(msg)
	m.stack.Push(updatedScreen)

	return m, cmd
}

func (m AppModel) View() string {
	if current := m.stack.GetTopScreen(); current != nil {
		return current.View()
	}

	return ""
}
