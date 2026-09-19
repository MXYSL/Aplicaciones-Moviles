from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
from flask_jwt_extended import (
    JWTManager,
    create_access_token,
    jwt_required,
    get_jwt_identity
)
from datetime import timedelta
import os


app = Flask(__name__)


# =========================================================
# CONFIGURACIÓN
# =========================================================

# Base de datos SQLite
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///site.db"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

# Clave utilizada para firmar los tokens JWT.
# Se obtiene desde una variable de entorno.
app.config["JWT_SECRET_KEY"] = os.environ.get("JWT_SECRET_KEY")

# Tiempo de duración de la sesión
app.config["JWT_ACCESS_TOKEN_EXPIRES"] = timedelta(hours=1)


db = SQLAlchemy(app)
bcrypt = Bcrypt(app)
jwt = JWTManager(app)


# =========================================================
# MODELOS
# =========================================================

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)

    username = db.Column(
        db.String(50),
        unique=True,
        nullable=False
    )

    # Aquí se almacena únicamente el hash de la contraseña
    password = db.Column(
        db.String(128),
        nullable=False
    )

    # Relación de un usuario con sus tareas
    tasks = db.relationship(
        "Task",
        backref="user",
        lazy=True,
        cascade="all, delete-orphan"
    )


class Task(db.Model):
    id = db.Column(db.Integer, primary_key=True)

    titulo = db.Column(
        db.String(100),
        nullable=False
    )

    descripcion = db.Column(
        db.String(300),
        nullable=True
    )

    completada = db.Column(
        db.Boolean,
        default=False,
        nullable=False
    )

    # Usuario propietario de la tarea
    user_id = db.Column(
        db.Integer,
        db.ForeignKey("user.id"),
        nullable=False
    )


# =========================================================
# FUNCIÓN AUXILIAR
# =========================================================

def tarea_a_json(task):
    """
    Convierte un objeto Task en un diccionario
    que Flask puede regresar como JSON.
    """

    return {
        "id": task.id,
        "titulo": task.titulo,
        "descripcion": task.descripcion,
        "completada": task.completada
    }


# =========================================================
# ENDPOINT DE VERIFICACIÓN
# =========================================================

@app.route("/", methods=["GET"])
def hello():

    return jsonify({
        "message": "API REST funcionando"
    }), 200


# =========================================================
# REGISTRO
# =========================================================

@app.route("/register", methods=["POST"])
def register():

    data = request.get_json()

    if not data:
        return jsonify({
            "message": "No se recibieron datos"
        }), 400

    username = data.get("username")
    password = data.get("password")

    if not username or not password:
        return jsonify({
            "message": "Username y password son obligatorios"
        }), 400

    if len(password) < 6:
        return jsonify({
            "message": "La contraseña debe tener al menos 6 caracteres"
        }), 400

    # Comprobar que el usuario no exista
    if User.query.filter_by(username=username).first():

        return jsonify({
            "message": "El usuario ya existe"
        }), 400

    # Generar hash bcrypt
    hashed_password = bcrypt.generate_password_hash(
        password
    ).decode("utf-8")

    new_user = User(
        username=username,
        password=hashed_password
    )

    db.session.add(new_user)
    db.session.commit()

    return jsonify({
        "message": "Usuario creado exitosamente"
    }), 201


# =========================================================
# LOGIN
# =========================================================

@app.route("/login", methods=["POST"])
def login():

    data = request.get_json()

    if not data:
        return jsonify({
            "message": "No se recibieron datos"
        }), 400

    username = data.get("username")
    password = data.get("password")

    if not username or not password:
        return jsonify({
            "message": "Username y password son obligatorios"
        }), 400

    user = User.query.filter_by(
        username=username
    ).first()

    if not user or not bcrypt.check_password_hash(
        user.password,
        password
    ):
        return jsonify({
            "message": "Credenciales inválidas"
        }), 401

    # El ID se guarda dentro del token.
    # Se convierte a string por compatibilidad con JWT.
    access_token = create_access_token(
        identity=str(user.id)
    )

    return jsonify({
        "message": "Login exitoso",
        "username": user.username,
        "access_token": access_token
    }), 200


# =========================================================
# CREATE - CREAR TAREA
# =========================================================

@app.route("/tasks", methods=["POST"])
@jwt_required()
def create_task():

    user_id = int(get_jwt_identity())

    data = request.get_json()

    if not data:
        return jsonify({
            "message": "No se recibieron datos"
        }), 400

    titulo = data.get("titulo")
    descripcion = data.get("descripcion", "")

    if not titulo:
        return jsonify({
            "message": "El título es obligatorio"
        }), 400

    new_task = Task(
        titulo=titulo,
        descripcion=descripcion,
        completada=False,
        user_id=user_id
    )

    db.session.add(new_task)
    db.session.commit()

    return jsonify({
        "message": "Tarea creada",
        "task": tarea_a_json(new_task)
    }), 201


# =========================================================
# READ - CONSULTAR TODAS LAS TAREAS
# =========================================================

@app.route("/tasks", methods=["GET"])
@jwt_required()
def get_tasks():

    user_id = int(get_jwt_identity())

    # Un usuario solamente puede consultar sus propias tareas
    tasks = Task.query.filter_by(
        user_id=user_id
    ).all()

    return jsonify({
        "tasks": [
            tarea_a_json(task)
            for task in tasks
        ]
    }), 200


# =========================================================
# READ - CONSULTAR UNA TAREA
# =========================================================

@app.route("/tasks/<int:task_id>", methods=["GET"])
@jwt_required()
def get_task(task_id):

    user_id = int(get_jwt_identity())

    task = Task.query.filter_by(
        id=task_id,
        user_id=user_id
    ).first()

    if not task:
        return jsonify({
            "message": "Tarea no encontrada"
        }), 404

    return jsonify({
        "task": tarea_a_json(task)
    }), 200


# =========================================================
# UPDATE - ACTUALIZAR TAREA
# =========================================================

@app.route("/tasks/<int:task_id>", methods=["PUT"])
@jwt_required()
def update_task(task_id):

    user_id = int(get_jwt_identity())

    task = Task.query.filter_by(
        id=task_id,
        user_id=user_id
    ).first()

    if not task:
        return jsonify({
            "message": "Tarea no encontrada"
        }), 404

    data = request.get_json()

    if not data:
        return jsonify({
            "message": "No se recibieron datos"
        }), 400

    if "titulo" in data:
        if not data["titulo"]:
            return jsonify({
                "message": "El título no puede estar vacío"
            }), 400

        task.titulo = data["titulo"]

    if "descripcion" in data:
        task.descripcion = data["descripcion"]

    if "completada" in data:
        task.completada = bool(data["completada"])

    db.session.commit()

    return jsonify({
        "message": "Tarea actualizada",
        "task": tarea_a_json(task)
    }), 200


# =========================================================
# DELETE - ELIMINAR TAREA
# =========================================================

@app.route("/tasks/<int:task_id>", methods=["DELETE"])
@jwt_required()
def delete_task(task_id):

    user_id = int(get_jwt_identity())

    task = Task.query.filter_by(
        id=task_id,
        user_id=user_id
    ).first()

    if not task:
        return jsonify({
            "message": "Tarea no encontrada"
        }), 404

    db.session.delete(task)
    db.session.commit()

    return jsonify({
        "message": "Tarea eliminada"
    }), 200


# =========================================================
# EJECUCIÓN
# =========================================================

if __name__ == "__main__":

    # Crea automáticamente las tablas si todavía no existen
    with app.app_context():
        db.create_all()

    app.run(
        host="0.0.0.0",
        port=5000,
        debug=True
    )