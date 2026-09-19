package ovh.gabrielhuav.flasklogin.data

data class RegisterRequest(
    val username: String,
    val password: String
)

data class MessageResponse(
    val message: String
)

data class LoginRequest(
    val username: String,
    val password: String
)

data class LoginResponse(
    val message: String,
    val username: String,
    val access_token: String
)

data class Task(
    val id: Int,
    val titulo: String,
    val descripcion: String,
    val completada: Boolean
)

data class TaskRequest(
    val titulo: String,
    val descripcion: String,
    val completada: Boolean = false
)

data class TaskResponse(
    val message: String,
    val task: Task
)

data class TasksResponse(
    val tasks: List<Task>
)