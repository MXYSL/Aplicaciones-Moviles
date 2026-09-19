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
fun LoginScreen(
    viewModel: AppViewModel,
    onLoginSuccess: () -> Unit,
    onRegisterClick: () -> Unit
) {

    var username by remember { mutableStateOf("") }
    var password by remember { mutableStateOf("") }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(24.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {

        Text(
            text = "Bienvenido",
            style = MaterialTheme.typography.headlineLarge
        )

        Spacer(modifier = Modifier.height(8.dp))

        Text(
            text = "Inicia sesión para administrar tus tareas",
            style = MaterialTheme.typography.bodyMedium
        )

        Spacer(modifier = Modifier.height(32.dp))

        OutlinedTextField(
            value = username,
            onValueChange = { username = it },
            label = { Text("Usuario") },
            singleLine = true,
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(modifier = Modifier.height(16.dp))

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

        Spacer(modifier = Modifier.height(24.dp))

        Button(
            onClick = {
                viewModel.login(
                    usernameInput = username.trim(),
                    password = password,
                    onSuccess = onLoginSuccess
                )
            },
            enabled = !viewModel.isLoading &&
                    username.isNotBlank() &&
                    password.isNotBlank(),
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("INICIAR SESIÓN")
        }

        Spacer(modifier = Modifier.height(12.dp))

        TextButton(
            onClick = onRegisterClick
        ) {
            Text("¿No tienes cuenta? Regístrate")
        }

        if (viewModel.isLoading) {

            Spacer(modifier = Modifier.height(20.dp))

            CircularProgressIndicator()
        }
    }
}