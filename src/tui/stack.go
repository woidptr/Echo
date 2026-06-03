package tui

import tea "github.com/charmbracelet/bubbletea"

type SceneStack struct {
	screens []tea.Model
}

func NewSceneStack(initialScreen tea.Model) *SceneStack {
	return &SceneStack{
		screens: []tea.Model{initialScreen},
	}
}

func (s *SceneStack) Push(m tea.Model) {
	s.screens = append(s.screens, m)
}

func (s *SceneStack) Pop() bool {
	if len(s.screens) > 1 {
		s.screens = s.screens[:len(s.screens)-1]
		return true
	}

	s.screens = nil
	return false
}

func (s *SceneStack) GetTopScreen() tea.Model {
	if len(s.screens) == 0 {
		return nil
	}

	return s.screens[len(s.screens)-1]
}
