# Cheat-sheet de comandos Git

Referencia rápida de los comandos de Git usados a lo largo del curso.

## Configuración inicial
| Comando | Qué hace |
|---|---|
| `git config --global user.name "Nombre"` | Define el nombre que aparece en tus commits |
| `git config --global user.email "correo@ejemplo.com"` | Define el correo asociado a tus commits |
| `git clone <url>` | Descarga (clona) un repositorio remoto a tu máquina |

## Estado y cambios
| Comando | Qué hace |
|---|---|
| `git status` | Muestra qué archivos cambiaron, cuáles están listos para commit y cuáles no |
| `git diff` | Muestra línea por línea qué cambió en los archivos modificados |
| `git add <archivo>` | Prepara (stage) un archivo específico para el próximo commit |
| `git add .` | Prepara todos los archivos modificados/nuevos de la carpeta actual |
| `git restore --staged <archivo>` | Saca un archivo del área de stage (sin perder el cambio) |

## Guardar cambios (commits)
| Comando | Qué hace |
|---|---|
| `git commit -m "mensaje"` | Guarda los cambios preparados como un nuevo commit |
| `git log` | Muestra el historial de commits |
| `git log --oneline` | Muestra el historial en formato resumido (una línea por commit) |

## Sincronizar con el repo remoto (GitHub)
| Comando | Qué hace |
|---|---|
| `git pull origin main` | Trae y aplica los cambios del repo remoto a tu copia local |
| `git push origin main` | Sube tus commits locales al repo remoto |
| `git remote -v` | Muestra a qué repo remoto está conectada tu copia local |

## Ramas (branches)
| Comando | Qué hace |
|---|---|
| `git branch` | Lista las ramas locales |
| `git branch <nombre>` | Crea una rama nueva |
| `git checkout <nombre>` | Cambia a esa rama |
| `git checkout -b <nombre>` | Crea la rama y cambia a ella en un solo paso |
| `git merge <nombre>` | Fusiona esa rama dentro de la rama actual |

## Deshacer cosas
| Comando | Qué hace |
|---|---|
| `git checkout -- <archivo>` | Descarta los cambios locales de un archivo (vuelve a la última versión guardada) |
| `git reset --soft HEAD~1` | Deshace el último commit, pero mantiene los cambios en el área de stage |
| `git revert <hash>` | Crea un nuevo commit que deshace los cambios de un commit anterior (seguro para historial ya compartido) |
