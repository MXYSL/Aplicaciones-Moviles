package ovh.gabrielhuav.flasklogin

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.lifecycle.viewmodel.compose.viewModel

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.ui.Alignment

import kotlinx.coroutines.launch

import ovh.gabrielhuav.flasklogin.ui.screens.LoginScreen
import ovh.gabrielhuav.flasklogin.ui.screens.RegisterScreen
import ovh.gabrielhuav.flasklogin.ui.screens.TasksScreen
import ovh.gabrielhuav.flasklogin.ui.theme.FlaskLoginTheme


class MainActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContent {

            FlaskLoginTheme {

                val appViewModel: AppViewModel = viewModel()

                MainApp(appViewModel)

            }
        }
    }
}


@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MainApp(
    viewModel: AppViewModel
) {

    // Pantalla actual
    var currentScreen by remember {
        mutableStateOf("login")
    }

    // Estado del menú lateral
    val drawerState = rememberDrawerState(
        initialValue = DrawerValue.Closed
    )

    // Permite abrir y cerrar el menú
    val scope = rememberCoroutineScope()


    // =====================================================
    // NAVEGACIÓN
    // =====================================================

    fun navigateTo(screen: String) {

        viewModel.clearMessage()

        when (screen) {

            "login" -> {

                // Si había una sesión activa, la cerramos
                if (viewModel.token != null) {
                    viewModel.logout()
                }

                currentScreen = "login"
            }

            "register" -> {

                if (viewModel.token != null) {
                    viewModel.logout()
                }

                currentScreen = "register"
            }

            "tasks" -> {

                if (viewModel.token != null) {

                    currentScreen = "tasks"

                    viewModel.loadTasks()

                } else {

                    currentScreen = "login"
                }
            }

            "logout" -> {

                viewModel.logout()

                currentScreen = "login"
            }
        }

        // Cerrar el menú después de seleccionar una opción
        scope.launch {
            drawerState.close()
        }
    }


    // =====================================================
    // MENÚ LATERAL
    // =====================================================

    ModalNavigationDrawer(

        drawerState = drawerState,

        drawerContent = {

            ModalDrawerSheet {

                Spacer(
                    modifier = Modifier.height(24.dp)
                )

                Text(
                    text = "CRUD REST",
                    style = MaterialTheme.typography.headlineMedium,
                    modifier = Modifier.padding(20.dp)
                )

                Text(
                    text = "Aplicación móvil de tareas",
                    style = MaterialTheme.typography.bodyMedium,
                    modifier = Modifier.padding(
                        start = 20.dp,
                        bottom = 16.dp
                    )
                )

                HorizontalDivider()

                Spacer(
                    modifier = Modifier.height(12.dp)
                )


                // INICIO DE SESIÓN

                NavigationDrawerItem(

                    label = {
                        Text("Inicio de sesión")
                    },

                    selected = currentScreen == "login",

                    onClick = {
                        navigateTo("login")
                    },

                    modifier = Modifier.padding(
                        horizontal = 12.dp
                    )
                )


                // REGISTRO

                NavigationDrawerItem(

                    label = {
                        Text("Registro de usuario")
                    },

                    selected = currentScreen == "register",

                    onClick = {
                        navigateTo("register")
                    },

                    modifier = Modifier.padding(
                        horizontal = 12.dp
                    )
                )


                // OPERACIONES CRUD

                NavigationDrawerItem(

                    label = {
                        Text("Operaciones CRUD")
                    },

                    selected = currentScreen == "tasks",

                    onClick = {
                        navigateTo("tasks")
                    },

                    modifier = Modifier.padding(
                        horizontal = 12.dp
                    )
                )


                // CERRAR SESIÓN

                if (viewModel.token != null) {

                    Spacer(
                        modifier = Modifier.height(12.dp)
                    )

                    HorizontalDivider()

                    Spacer(
                        modifier = Modifier.height(12.dp)
                    )

                    NavigationDrawerItem(

                        label = {
                            Text("Cerrar sesión")
                        },

                        selected = false,

                        onClick = {
                            navigateTo("logout")
                        },

                        modifier = Modifier.padding(
                            horizontal = 12.dp
                        )
                    )
                }


                Spacer(
                    modifier = Modifier.weight(1f)
                )

                HorizontalDivider()

                Text(
                    text = if (viewModel.token != null) {

                        "Sesión: ${viewModel.username}"

                    } else {

                        "Sin sesión iniciada"
                    },

                    style = MaterialTheme.typography.bodySmall,

                    modifier = Modifier.padding(20.dp)
                )

            }
        }

    ) {


        // =================================================
        // CONTENIDO PRINCIPAL
        // =================================================

        Scaffold(

            topBar = {

                TopAppBar(

                    title = {

                        Text(
                            text = when (currentScreen) {

                                "login" -> "Iniciar sesión"

                                "register" -> "Registro"

                                "tasks" -> "Mis tareas"

                                else -> "CRUD REST"
                            }
                        )
                    },

                    navigationIcon = {

                        TextButton(

                            onClick = {

                                scope.launch {

                                    drawerState.open()

                                }
                            }

                        ) {

                            Text("☰ MENÚ")

                        }
                    }
                )
            }

        ) { paddingValues ->

            Column(

                modifier = Modifier
                    .fillMaxSize()
                    .padding(paddingValues)

            ) {


                // =========================================
                // MENSAJES DE ÉXITO O ERROR
                // =========================================

                if (viewModel.message.isNotEmpty()) {

                    Surface(

                        color = if (viewModel.isError) {

                            MaterialTheme.colorScheme.errorContainer

                        } else {

                            MaterialTheme.colorScheme.primaryContainer

                        },

                        modifier = Modifier.fillMaxWidth()

                    ) {

                        Row(

                            modifier = Modifier.padding(12.dp),

                            verticalAlignment = Alignment.CenterVertically

                        ) {

                            Text(

                                text = viewModel.message,

                                modifier = Modifier.weight(1f)

                            )

                            TextButton(

                                onClick = {
                                    viewModel.clearMessage()
                                }

                            ) {

                                Text("X")

                            }
                        }
                    }
                }


                // =========================================
                // PANTALLAS
                // =========================================

                when (currentScreen) {


                    // LOGIN

                    "login" -> {

                        LoginScreen(

                            viewModel = viewModel,

                            onLoginSuccess = {

                                currentScreen = "tasks"

                                viewModel.loadTasks()

                            },

                            onRegisterClick = {

                                viewModel.clearMessage()

                                currentScreen = "register"

                            }
                        )
                    }


                    // REGISTRO

                    "register" -> {

                        RegisterScreen(

                            viewModel = viewModel,

                            onRegisterSuccess = {

                                currentScreen = "login"

                            },

                            onLoginClick = {

                                viewModel.clearMessage()

                                currentScreen = "login"

                            }
                        )
                    }


                    // CRUD

                    "tasks" -> {

                        if (viewModel.token != null) {

                            TasksScreen(

                                viewModel = viewModel

                            )

                        } else {

                            LoginScreen(

                                viewModel = viewModel,

                                onLoginSuccess = {

                                    currentScreen = "tasks"

                                    viewModel.loadTasks()

                                },

                                onRegisterClick = {

                                    currentScreen = "register"

                                }
                            )
                        }
                    }
                }
            }
        }
    }
}