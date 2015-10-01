from garelay import celery_app


@celery_app.task(ignore_result=True)
def some_task(self):
    pass
