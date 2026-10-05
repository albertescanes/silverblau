# silverblau

Imagen bootc personalizada basada en **Fedora Silverblue**, con Steam, códecs Mesa freeworld y algunos ajustes de escritorio.

## ¿Qué incluye?

- **Steam** (paquete RPM)
- **Mesa freeworld** con códecs para AMD (64 y 32 bits)
  - `mesa-va-drivers-freeworld` (+ `.i686`)
  - Sustitución de `mesa-vulkan-drivers` por `mesa-vulkan-drivers-freeworld`
- **Ajustes varios**:
  - Elimina Firefox
  - Reemplaza `ptyxis` por `gnome-console`

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
