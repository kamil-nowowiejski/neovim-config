return {
	"pocco81/auto-save.nvim",
		opts = {
			enabled = false,
			execution_message = { message = '', cleaning_interval = 1 },
            write_all_buffers = true,
            trigger_events = {"InsertLeave"}
		},
}
