// ==============================
// CONFIGURACIÓN
// ==============================
bool silentAimEnabled = false
bool autoKillEnabled = false
bool espEnabled = false

Enemy target = null
Player player
List<Enemy> enemies

// ==============================
// OBTENER ENEMIGO MÁS CERCANO
// ==============================
function GetClosestEnemy():
    closest = null
    closestDist = VERY_BIG_NUMBER

    for enemy in enemies:
        if enemy.isAlive:
            dist = Distance(player.position, enemy.position)
            if dist < closestDist:
                closestDist = dist
                closest = enemy

    return closest

// ==============================
// ACTUALIZACIÓN CADA 0.1s (Optimización)
// ==============================
every 0.1 seconds:
    if silentAimEnabled or autoKillEnabled:
        target = GetClosestEnemy()

// ==============================
// SISTEMA DE DISPARO (Silent Aim)
// ==============================
function OnPlayerShoot():
    if silentAimEnabled AND target != null:
        bullet.direction = Normalize(target.position - player.position)
    else:
        bullet.direction = player.forwardDirection

    SpawnBullet(bullet)

// ==============================
// SISTEMA DE LANZAR CUCHILLO
// ==============================
function OnPlayerThrowKnife():
    knife = CreateKnife()

    if silentAimEnabled AND target != null:
        knife.direction = Normalize(target.position - player.position)
    else:
        knife.direction = player.forwardDirection

    LaunchKnife(knife)

// ==============================
// SISTEMA DE AUTO-KILL
// ==============================
every frame:
    if autoKillEnabled:
        for enemy in enemies:
            if enemy.isAlive:
                enemy.health = 0

// ==============================
// SISTEMA ESP (VER ENEMIGOS)
// ==============================
function DrawESP():
    if not espEnabled:
        return

    for enemy in enemies:
        if enemy.isAlive:
            screenPos = WorldToScreen(enemy.position)

            if screenPos.isOnScreen:
                DrawBox(screenPos.x, screenPos.y, colorRed)

// ==============================
// INTERFACE DE USUARIO (UI)
// ==============================
function DrawUI():
    if Toggle("Silent Aim"): silentAimEnabled = not silentAimEnabled
    if Toggle("Auto Kill"): autoKillEnabled = not autoKillEnabled
    if Toggle("Ver Enemigos (ESP)"): espEnabled = not espEnabled
