import os
import random

from dotenv import load_dotenv
from flask import Flask
from flask import render_template
from prometheus_flask_exporter import PrometheusMetrics

load_dotenv()

app = Flask(__name__)
metrics = PrometheusMetrics(app)

# TODO - get version from poetry
metrics.info("app_info", "Application info", version="1.0.12")

COLOR_PAIRS = [
    # background-color, text-color
    ("#54478C", "#FFFFFF"),
    ("#2C699A", "#FFFFFF"),
    ("#048BA8", "#FFFFFF"),
    ("#0DB39E", "#000000"),
    ("#16DB93", "#000000"),
    ("#83E377", "#000000"),
    ("#B9E769", "#000000"),
    ("#EFEA5A", "#000000"),
    ("#F1C453", "#000000"),
    ("#F29E4C", "#FFFFFF"),
    ("#FFCA3A", "#000000"),
    ("#8AC926", "#000000"),
    ("#1982C4", "#FFFFFF"),
]

PHARSES = [
    "Все, что существует, существует в какой-то мере",
    "Не всё то истина, что существует",
    "Существует столько истин, сколько есть точек зрения",
    "Истина всегда где-то рядом",
    "Бытие предшествует сущности",
    "Бытие предшествует мышлению",
    "Познание есть сомнение",
    "Всё знать нельзя",
    "Не существует одной истины",
    "Главное — не то, как они нас побеждают, а то, как мы им проигрываем",
    "Кто свинья, тот не медведь",
    "Память — хорошая штука, если не имеешь дело с прошлым",
    "Надо улучшать то, что есть, а не ухудшать, чего нет",
    "Какие львы, такие совы",
    "Шорты — как брюки. Только короче",
    "Лучше голова коня, чем таблица умножения",
    "Нельзя положить то, что уже положено",
    "Настоящее — это прошлое в будущем",
    "Чтобы себя сдерживать, нужно сначала себя не сдерживать",
]


@app.route("/")
def main():
    return render_template(
        "content.html",
        phrase=random.choice(PHARSES),
        project_name="Phrase app",
        color=random.choice(COLOR_PAIRS),
    )


@app.route("/ping")
def ping():
    return "pong"


@app.route("/env")
def env():
    return f"ENV_VARIABLE = {os.environ['ENV_VARIABLE']}"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
