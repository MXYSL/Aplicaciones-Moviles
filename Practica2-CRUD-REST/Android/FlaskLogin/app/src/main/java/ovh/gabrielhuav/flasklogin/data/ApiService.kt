package ovh.gabrielhuav.flasklogin.data

import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.DELETE
import retrofit2.http.GET
import retrofit2.http.Header
import retrofit2.http.POST
import retrofit2.http.PUT
import retrofit2.http.Path

interface ApiService {

    @POST("register")
    suspend fun register(
        @Body request: RegisterRequest
    ): Response<MessageResponse>

    @POST("login")
    suspend fun login(
        @Body request: LoginRequest
    ): Response<LoginResponse>

    @GET("tasks")
    suspend fun getTasks(
        @Header("Authorization") token: String
    ): Response<TasksResponse>

    @POST("tasks")
    suspend fun createTask(
        @Header("Authorization") token: String,
        @Body task: TaskRequest
    ): Response<TaskResponse>

    @PUT("tasks/{id}")
    suspend fun updateTask(
        @Header("Authorization") token: String,
        @Path("id") id: Int,
        @Body task: TaskRequest
    ): Response<TaskResponse>

    @DELETE("tasks/{id}")
    suspend fun deleteTask(
        @Header("Authorization") token: String,
        @Path("id") id: Int
    ): Response<MessageResponse>
}