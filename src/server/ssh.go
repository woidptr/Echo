package server

import (
	"echo/src/tui"
	"log"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/ssh"
	"github.com/charmbracelet/wish"
	"github.com/charmbracelet/wish/bubbletea"
	"github.com/charmbracelet/wish/logging"
)

func teaHandler(s ssh.Session) (tea.Model, []tea.ProgramOption) {
	m := tui.NewAppModel()

	return m, []tea.ProgramOption{tea.WithAltScreen()}
}

func Start(port string) error {
	s, err := wish.NewServer(
		wish.WithAddress("0.0.0.0:"+port),
		wish.WithHostKeyPath("/data/term_info_ed25519"),
		wish.WithMiddleware(
			bubbletea.Middleware(teaHandler),
			logging.Middleware(),
		),
	)

	if err != nil {
		return err
	}

	log.Printf("Starting SSH server on port %s", port)

	return s.ListenAndServe()
}
