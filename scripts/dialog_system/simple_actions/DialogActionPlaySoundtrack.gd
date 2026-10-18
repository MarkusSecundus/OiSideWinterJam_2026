extends IDialogAction

func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	SoundManager.PlaySoundtrack()
	_default_perform(ctx, on_finished)
