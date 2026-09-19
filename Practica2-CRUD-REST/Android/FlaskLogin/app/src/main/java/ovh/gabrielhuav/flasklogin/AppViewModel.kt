package ovh.gabrielhuav.flasklogin

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.launch
import ovh.gabrielhuav.flasklogin.data.LoginRequest
import ovh.gabrielhuav.flasklogin.data.RegisterRequest
import ovh.gabrielhuav.flasklogin.data.RetrofitClient
import ovh.gabrielhuav.flasklogin.data.Task
import ovh.gabrielhuav.flasklogin.data.TaskRequest

class AppViewModel : ViewModel() {

    var token by mutableStateOf<String?>(null)
        private set

    var username by mutableStateOf("")
        private set

    var tasks by mutableStateOf<List<Task>>(emptyList())
        private set

    var isLoading by mutableStateOf(false)
        private set

    var message by mutableStateOf("")
        private set

    var isError by mutableStateOf(false)
        private set


    fun clearMessage() {
        message = ""
        isError = false
    }


    fun register(
        username: String,
        password: String,
        onSuccess: () -> Unit
    ) {
        viewModelScope.launch {

            isLoading = true
            clearMessage()

            try {

                val response = RetrofitClient.api.register(
                    RegisterRequest(username, password)
                )

                if (response.isSuccessful) {

                    message =
                        response.body()?.message
                            ?: "Usuario registrado"

                    isError = false
                    onSuccess()

                } else {

                    message =
                        "No fue posible registrar el usuario"

                    isError = true
                }

            } catch (e: Exception) {

                message =
                    "Error de conexión: ${e.message}"

                isError = true

            } finally {
                isLoading = false
            }
        }
    }


    fun login(
        usernameInput: String,
        password: String,
        onSuccess: () -> Unit
    ) {
        viewModelScope.launch {

            isLoading = true
            clearMessage()

            try {

                val response = RetrofitClient.api.login(
                    LoginRequest(
                        usernameInput,
                        password
                    )
                )

                if (response.isSuccessful) {

                    val body = response.body()

                    if (body != null) {

                        token = body.access_token
                        username = body.username

                        message = "Sesión iniciada"
                        isError = false

                        onSuccess()
                    }

                } else {

                    message = "Credenciales incorrectas"
                    isError = true
                }

            } catch (e: Exception) {

                message =
                    "Error de conexión: ${e.message}"

                isError = true

            } finally {
                isLoading = false
            }
        }
    }


    fun loadTasks() {

        val currentToken = token ?: return

        viewModelScope.launch {

            isLoading = true

            try {

                val response =
                    RetrofitClient.api.getTasks(
                        "Bearer $currentToken"
                    )

                if (response.isSuccessful) {

                    tasks =
                        response.body()?.tasks
                            ?: emptyList()

                    isError = false

                } else {

                    message =
                        "No se pudieron obtener las tareas"

                    isError = true
                }

            } catch (e: Exception) {

                message =
                    "Error de conexión: ${e.message}"

                isError = true

            } finally {
                isLoading = false
            }
        }
    }


    fun createTask(
        titulo: String,
        descripcion: String
    ) {

        val currentToken = token ?: return

        viewModelScope.launch {

            isLoading = true

            try {

                val response =
                    RetrofitClient.api.createTask(
                        "Bearer $currentToken",
                        TaskRequest(
                            titulo = titulo,
                            descripcion = descripcion
                        )
                    )

                if (response.isSuccessful) {

                    message = "Tarea creada"
                    isError = false

                    loadTasks()

                } else {

                    message =
                        "No se pudo crear la tarea"

                    isError = true
                }

            } catch (e: Exception) {

                message =
                    "Error de conexión: ${e.message}"

                isError = true

            } finally {
                isLoading = false
            }
        }
    }


    fun updateTask(
        task: Task,
        titulo: String,
        descripcion: String,
        completada: Boolean
    ) {

        val currentToken = token ?: return

        viewModelScope.launch {

            isLoading = true

            try {

                val response =
                    RetrofitClient.api.updateTask(
                        "Bearer $currentToken",
                        task.id,
                        TaskRequest(
                            titulo,
                            descripcion,
                            completada
                        )
                    )

                if (response.isSuccessful) {

                    message = "Tarea actualizada"
                    isError = false

                    loadTasks()

                } else {

                    message =
                        "No se pudo actualizar la tarea"

                    isError = true
                }

            } catch (e: Exception) {

                message =
                    "Error de conexión: ${e.message}"

                isError = true

            } finally {
                isLoading = false
            }
        }
    }


    fun deleteTask(task: Task) {

        val currentToken = token ?: return

        viewModelScope.launch {

            isLoading = true

            try {

                val response =
                    RetrofitClient.api.deleteTask(
                        "Bearer $currentToken",
                        task.id
                    )

                if (response.isSuccessful) {

                    message = "Tarea eliminada"
                    isError = false

                    loadTasks()

                } else {

                    message =
                        "No se pudo eliminar la tarea"

                    isError = true
                }

            } catch (e: Exception) {

                message =
                    "Error de conexión: ${e.message}"

                isError = true

            } finally {
                isLoading = false
            }
        }
    }


    fun logout() {

        token = null
        username = ""
        tasks = emptyList()

        message = "Sesión cerrada"
        isError = false
    }
}