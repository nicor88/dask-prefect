import os

from prefect import task, Flow
import datetime
from time import sleep

from prefect.engine.executors import DaskExecutor


DASK_SCHEDULER_HOST = os.environ.get('DASK_SCHEDULER_HOST') or 'localhost'

@task
def extract():
    return [1, 2, 3]


@task
def transform(x):
    return [i * 10 for i in x]


@task(max_retries=3, retry_delay=datetime.timedelta(seconds=0))
def load(y):
    # raise Exception('sample exception')
    print("Received y: {}".format(y))


@task
def breath():
    print('breathing...')
    sleep(60)


with Flow("ETL") as flow:
    e = extract()
    t = transform(e)
    l = load(t)
    s = breath()


executor = DaskExecutor(address=f'tcp://{DASK_SCHEDULER_HOST}:8786')
flow.run(executor=executor)


def main():
    from prefect.schedules import IntervalSchedule

    every_minute = IntervalSchedule(start_date=datetime.datetime.utcnow(), interval=datetime.timedelta(minutes=1))
    flow.schedule = every_minute
    flow.run()


if __name__ == "__main__":
    main()
