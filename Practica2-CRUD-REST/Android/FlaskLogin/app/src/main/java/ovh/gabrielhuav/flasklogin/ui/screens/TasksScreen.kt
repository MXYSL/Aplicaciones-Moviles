package ovh.gabrielhuav.flasklogin.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import ovh.gabrielhuav.flasklogin.AppViewModel
import ovh.gabrielhuav.flasklogin.data.Task

@Composable
fun TasksScreen(
    viewModel: AppViewModel
) {

    var showCreateDialog by remember {
        mutableStateOf(false)
    }

    var editingTask by remember {
        mutableStateOf<Task?>(null)
    }

    var deletingTask by remember {
        mutableStateOf<Task?>(null)
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp)
    ) {

        Text(
            text = "Mis tareas",
            style = MaterialTheme.typography.headlineMedium
        )

        Spacer(modifier = Modifier.height(8.dp))

        Text(
            text = "Usuario: ${viewModel.username}",
            style = MaterialTheme.typography.bodyMedium
        )

        Spacer(modifier = Modifier.height(16.dp))

        Button(
            onClick = {
                showCreateDialog = true
            },
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("+ NUEVA TAREA")
        }

        Spacer(modifier = Modifier.height(12.dp))

        OutlinedButton(
            onClick = {
                viewModel.loadTasks()
            },
            enabled = !viewModel.isLoading,
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("ACTUALIZAR LISTA")
        }

        Spacer(modifier = Modifier.height(16.dp))

        if (viewModel.isLoading) {

            LinearProgressIndicator(
                modifier = Modifier.fillMaxWidth()
            )

            Spacer(modifier = Modifier.height(12.dp))
        }

        if (viewModel.tasks.isEmpty() && !viewModel.isLoading) {

            Text(
                text = "Todavía no tienes tareas. Crea la primera."
            )

        } else {

            LazyColumn(
                verticalArrangement = Arrangement.spacedBy(12.dp)
            ) {

                items(
                    items = viewModel.tasks,
                    key = { it.id }
                ) { task ->

                    TaskCard(
                        task = task,
                        enabled = !viewModel.isLoading,

                        onEdit = {
                            editingTask = task
                        },

                        onDelete = {
                            deletingTask = task
                        },

                        onCompletedChange = { completed ->

                            viewModel.updateTask(
                                task = task,
                                titulo = task.titulo,
                                descripcion = task.descripcion,
                                completada = completed
                            )
                        }
                    )
                }
            }
        }
    }

    // =====================================================
    // CREATE
    // =====================================================

    if (showCreateDialog) {

        TaskFormDialog(
            title = "Nueva tarea",
            initialTitle = "",
            initialDescription = "",

            onDismiss = {
                showCreateDialog = false
            },

            onSave = { titulo, descripcion ->

                viewModel.createTask(
                    titulo = titulo,
                    descripcion = descripcion
                )

                showCreateDialog = false
            }
        )
    }

    // =====================================================
    // UPDATE
    // =====================================================

    editingTask?.let { task ->

        TaskFormDialog(
            title = "Editar tarea",
            initialTitle = task.titulo,
            initialDescription = task.descripcion,

            onDismiss = {
                editingTask = null
            },

            onSave = { titulo, descripcion ->

                viewModel.updateTask(
                    task = task,
                    titulo = titulo,
                    descripcion = descripcion,
                    completada = task.completada
                )

                editingTask = null
            }
        )
    }

    // =====================================================
    // DELETE
    // =====================================================

    deletingTask?.let { task ->

        AlertDialog(
            onDismissRequest = {
                deletingTask = null
            },

            title = {
                Text("Eliminar tarea")
            },

            text = {
                Text(
                    "¿Deseas eliminar la tarea '${task.titulo}'?"
                )
            },

            confirmButton = {

                TextButton(
                    onClick = {

                        viewModel.deleteTask(task)

                        deletingTask = null
                    }
                ) {
                    Text("ELIMINAR")
                }
            },

            dismissButton = {

                TextButton(
                    onClick = {
                        deletingTask = null
                    }
                ) {
                    Text("CANCELAR")
                }
            }
        )
    }
}


// =========================================================
// TARJETA DE UNA TAREA
// =========================================================

@Composable
fun TaskCard(
    task: Task,
    enabled: Boolean,
    onEdit: () -> Unit,
    onDelete: () -> Unit,
    onCompletedChange: (Boolean) -> Unit
) {

    Card(
        modifier = Modifier.fillMaxWidth()
    ) {

        Column(
            modifier = Modifier.padding(16.dp)
        ) {

            Row(
                verticalAlignment = Alignment.CenterVertically
            ) {

                Checkbox(
                    checked = task.completada,
                    onCheckedChange = onCompletedChange,
                    enabled = enabled
                )

                Text(
                    text = task.titulo,
                    style = MaterialTheme.typography.titleMedium
                )
            }

            Spacer(modifier = Modifier.height(8.dp))

            Text(
                text = task.descripcion.ifBlank {
                    "Sin descripción"
                }
            )

            Spacer(modifier = Modifier.height(8.dp))

            Text(
                text = if (task.completada)
                    "Estado: Completada"
                else
                    "Estado: Pendiente"
            )

            Spacer(modifier = Modifier.height(12.dp))

            Row(
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {

                OutlinedButton(
                    onClick = onEdit,
                    enabled = enabled
                ) {
                    Text("EDITAR")
                }

                OutlinedButton(
                    onClick = onDelete,
                    enabled = enabled
                ) {
                    Text("ELIMINAR")
                }
            }
        }
    }
}


// =========================================================
// FORMULARIO PARA CREAR Y EDITAR
// =========================================================

@Composable
fun TaskFormDialog(
    title: String,
    initialTitle: String,
    initialDescription: String,
    onDismiss: () -> Unit,
    onSave: (String, String) -> Unit
) {

    var titulo by remember(initialTitle) {
        mutableStateOf(initialTitle)
    }

    var descripcion by remember(initialDescription) {
        mutableStateOf(initialDescription)
    }

    AlertDialog(
        onDismissRequest = onDismiss,

        title = {
            Text(title)
        },

        text = {

            Column {

                OutlinedTextField(
                    value = titulo,
                    onValueChange = {
                        titulo = it
                    },
                    label = {
                        Text("Título")
                    },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth()
                )

                Spacer(
                    modifier = Modifier.height(12.dp)
                )

                OutlinedTextField(
                    value = descripcion,
                    onValueChange = {
                        descripcion = it
                    },
                    label = {
                        Text("Descripción")
                    },
                    minLines = 2,
                    maxLines = 4,
                    modifier = Modifier.fillMaxWidth()
                )
            }
        },

        confirmButton = {

            Button(
                onClick = {

                    onSave(
                        titulo.trim(),
                        descripcion.trim()
                    )
                },

                enabled = titulo.isNotBlank()
            ) {
                Text("GUARDAR")
            }
        },

        dismissButton = {

            TextButton(
                onClick = onDismiss
            ) {
                Text("CANCELAR")
            }
        }
    )
}