# silverblau

Imagen bootc personalizada basada en **Fedora Silverblue**, con Steam, códecs Mesa freeworld y algunos ajustes de escritorio.

## Contenido

- **Steam**
- **Códecs GStreamer**: `gstreamer1-plugins-bad-freeworld`, `gstreamer1-plugins-ugly`
- **Mesa freeworld** (VA-API + Vulkan, 64 y 32 bits) para AMD
- **Personalizaciones**:
  - Firefox eliminado
  - Ptyxis reemplazado por Consola

## Rebase desde Fedora Silverblue

En una instalación existente de Silverblue, ejecuta:

```bash
rpm-ostree rebase ostree-unverified-registry:ghcr.io/albertescanes/silverblau:latest
systemctl reboot
```

Tras el reinicio, para futuras actualizaciones basta con:

```bash
bootc upgrade
systemctl reboot
```
