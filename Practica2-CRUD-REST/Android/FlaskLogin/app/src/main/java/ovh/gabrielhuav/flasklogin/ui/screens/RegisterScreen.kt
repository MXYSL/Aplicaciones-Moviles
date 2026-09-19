package ovh.gabrielhuav.flasklogin.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import ovh.gabrielhuav.flasklogin.AppViewModel

@Composable
fun RegisterScreen(
    viewModel: AppViewModel,
    onRegisterSuccess: () -> Unit,
    onLoginClick: () -> Unit
) {

    var username by remember { mutableStateOf("") }

    var password by remember { mutableStateOf("") }

    var confirmPassword by remember { mutableStateOf("") }

    var localError by remember { mutableStateOf("") }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(24.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {

        Text(
            text = "Crear cuenta",
            style = MaterialTheme.typography.headlineLarge
        )

        Spacer(modifier = Modifier.height(8.dp))

        Text(
            text = "Regístrate para comenzar a organizar tus tareas"
        )

        Spacer(modifier = Modifier.height(28.dp))

        OutlinedTextField(
            value = username,
            onValueChange = { username = it },
            label = { Text("Nombre de usuario") },
            singleLine = true,
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(modifier = Modifier.height(12.dp))

        OutlinedTextField(
            value = password,
            onValueChange = { password = it },
            label = { Text("Contraseña") },
            visualTransformation = PasswordVisualTransformation(),
            keyboardOptions = KeyboardOptions(
                keyboardType = KeyboardType.Password
            ),
            singleLine = true,
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(modifier = Modifier.height(12.dp))

        OutlinedTextField(
            value = confirmPassword,
            onValueChange = { confirmPassword = it },
            label = { Text("Confirmar contraseña") },
            visualTransformation = PasswordVisualTransformation(),
            keyboardOptions = KeyboardOptions(
                keyboardType = KeyboardType.Password
            ),
            singleLine = true,
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(modifier = Modifier.height(16.dp))

        if (localError.isNotEmpty()) {

            Text(
                text = localError,
                color = MaterialTheme.colorScheme.error
            )
        }

        Spacer(modifier = Modifier.height(12.dp))

        Button(
            onClick = {

                localError = ""

                when {

                    username.isBlank() -> {
                        localError = "Ingresa un usuario"
                    }

                    password.length < 6 -> {
                        localError =
                            "La contraseña debe tener al menos 6 caracteres"
                    }

                    password != confirmPassword -> {
                        localError =
                            "Las contraseñas no coinciden"
                    }

                    else -> {

                        viewModel.register(
                            username = username.trim(),
                            password = password,
                            onSuccess = onRegisterSuccess
                        )
                    }
                }
            },
            enabled = !viewModel.isLoading,
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("REGISTRAR USUARIO")
        }

        Spacer(modifier = Modifier.height(12.dp))

        TextButton(
            onClick = onLoginClick
        ) {
            Text("¿Ya tienes cuenta? Inicia sesión")
        }

        if (viewModel.isLoading) {

            Spacer(modifier = Modifier.height(20.dp))

            CircularProgressIndicator()
        }
    }
}