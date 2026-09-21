# 1. Evolución de los modelos de lenguaje

## 1.1. ¿Qué es un modelo de lenguaje?

Un modelo de lenguaje (Language Model, LM) es un sistema computacional diseñado para representar regularidades del lenguaje y estimar la probabilidad de determinadas secuencias de unidades lingüísticas. En los modelos modernos, estas unidades suelen denominarse tokens y pueden corresponder a palabras completas, fragmentos de palabras, signos de puntuación u otros elementos de una representación textual.

Su funcionamiento se basa en identificar relaciones estadísticas y contextuales a partir de los datos utilizados durante el entrenamiento. Por ejemplo, cuando recibe una oración incompleta, un modelo puede estimar qué token tiene mayor probabilidad de aparecer a continuación considerando el contexto previo.

Los modelos de lenguaje no surgieron con los asistentes conversacionales actuales. Su evolución comprende enfoques estadísticos, modelos neuronales y arquitecturas de aprendizaje profundo. Esta evolución permitió pasar de sistemas con una capacidad limitada para representar el contexto a modelos capaces de producir respuestas extensas, resumir documentos, traducir idiomas y generar código.

En ingeniería de software, los modelos de lenguaje resultan relevantes porque pueden interpretar instrucciones escritas en lenguaje natural y producir representaciones útiles para tareas de programación, documentación y análisis de información.

## 1.2. De los modelos de lenguaje a los modelos de lenguaje grandes

Un modelo de lenguaje grande (Large Language Model, LLM) es un modelo neuronal entrenado con grandes cantidades de datos y recursos computacionales para desarrollar capacidades generales de procesamiento y generación del lenguaje.

El término "grande" se relaciona principalmente con la escala del modelo, aunque su comportamiento también depende de la arquitectura, la calidad y cantidad de los datos, el procedimiento de entrenamiento y los recursos computacionales disponibles.

La investigación sobre leyes de escalamiento ha mostrado relaciones entre el rendimiento de los modelos, su tamaño, el volumen de datos y el cómputo destinado al entrenamiento. Esto contribuyó al desarrollo de sistemas con mayores capacidades de generalización y adaptación a diferentes tareas.

A diferencia de una aplicación programada exclusivamente para responder a un conjunto cerrado de preguntas, un LLM puede recibir instrucciones nuevas y generar respuestas relacionadas con problemas que no fueron definidos individualmente mediante reglas escritas por una persona desarrolladora.

No obstante, el aumento de escala no garantiza por sí solo respuestas correctas. Los modelos pueden producir información inexacta, interpretar incorrectamente una instrucción o generar código que requiere revisión y pruebas.

## 1.3. Modelos con razonamiento explícito

Los modelos con razonamiento explícito son sistemas entrenados para dedicar recursos adicionales a la resolución de problemas que requieren varios pasos de análisis.

Su desarrollo responde a la necesidad de abordar tareas en las que una respuesta inmediata puede resultar insuficiente, como problemas matemáticos, programación, planificación y análisis de situaciones con múltiples restricciones.

Es importante distinguir el aumento del tamaño de un modelo de las técnicas utilizadas para desarrollar sus capacidades de razonamiento. Un modelo no adquiere automáticamente un procedimiento de razonamiento más eficaz únicamente por incrementar su número de parámetros.

Las mejoras pueden depender de métodos específicos de entrenamiento y de cómputo adicional durante la inferencia. Este último permite dedicar más recursos a la resolución de una solicitud antes de producir la respuesta final.

Por tanto, el razonamiento debe analizarse como una capacidad relacionada tanto con el entrenamiento como con la forma en que se utiliza el modelo al momento de responder.

## 1.4. Evolución de la interacción entre usuarios e inteligencia artificial

En las primeras experiencias de uso generalizado de asistentes conversacionales, la interacción se realizaba principalmente mediante una interfaz de texto. El usuario escribía una solicitud, proporcionaba manualmente la información necesaria y recibía una respuesta.

En un entorno de desarrollo, esto implicaba copiar fragmentos de código desde un editor, pegarlos en el navegador y trasladar manualmente las modificaciones sugeridas al proyecto original.

Posteriormente, comenzaron a incorporarse asistentes dentro de los entornos de desarrollo. Esta integración permitió utilizar el contexto de los archivos abiertos, consultar información del proyecto y generar modificaciones relacionadas con el código existente.

La integración con herramientas representa un cambio importante: el modelo deja de limitarse a producir texto para que una persona ejecute todas las acciones y pasa a participar en flujos de trabajo donde un sistema externo puede realizar operaciones concretas bajo condiciones de autorización.

Sin embargo, esta capacidad no significa que el modelo posea acceso directo al sistema operativo. La interacción con archivos y aplicaciones requiere componentes adicionales que ejecuten las operaciones solicitadas.

## 1.5. Relación de esta evolución con MCP

El Model Context Protocol (MCP) se relaciona con esta etapa de evolución porque establece un mecanismo estandarizado para conectar aplicaciones que utilizan modelos de lenguaje con herramientas y fuentes de información externas.

En lugar de depender exclusivamente del texto que una persona copia en una conversación, una aplicación compatible puede descubrir herramientas publicadas por un servidor MCP y ponerlas a disposición del asistente.

En la práctica desarrollada, esta integración se observa cuando GitHub Copilot utiliza el servidor MCP Filesystem para listar, leer, crear, modificar y buscar archivos.

La operación no ocurre porque el modelo haya obtenido acceso directo al disco duro. Ocurre porque existe una aplicación cliente conectada a un servidor que publica herramientas para realizar operaciones específicas.

Esta diferencia permite comprender la transición desde los asistentes conversacionales aislados hacia entornos de desarrollo que integran modelos, herramientas y mecanismos de autorización.

## Referencias

Kaplan, J., McCandlish, S., Henighan, T., Brown, T., Chess, B., Child, R., Gray, S., Radford, A., Wu, J., & Amodei, D. (2020). *Scaling laws for neural language models*. arXiv. https://arxiv.org/abs/2001.08361

OpenAI. (2024, 12 de septiembre). *Learning to reason with LLMs*. https://openai.com/index/learning-to-reason-with-llms/

Model Context Protocol. (2026, 28 de julio). *The 2026-07-28 specification*. https://blog.modelcontextprotocol.io/posts/2026-07-28/