package tui

import (
	"fmt"

	tea "github.com/charmbracelet/bubbletea"
)

type WelcomeScreen struct{}

func (w WelcomeScreen) Init() tea.Cmd {
	return nil
}

func (w WelcomeScreen) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	return w, nil
}

func (w WelcomeScreen) View() string {
	return fmt.Sprintf(
		"\n  Welcome to SSH TUI!\n\n" +
			"  Press 'ctrl+c' to quit.\n",
	)
}
