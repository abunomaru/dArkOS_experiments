# RTL8188FU WiFi - Instalação SIMPLES (Só Firmware)

Descobrimos que **NÃO PRECISA compilar driver!** Só falta o firmware.

---

## 🎮 OPÇÃO 1: Steam Deck (Automático)

**Mais fácil! Faz tudo sozinho.**

### No Steam Deck:

```bash
# 1. Baixar o script
curl -O https://raw.githubusercontent.com/abunomaru/dArkOS_experiments/claude/fix-wifi-adapter-P6EiP/install_firmware_steamdeck.sh

# 2. Tornar executável
chmod +x install_firmware_steamdeck.sh

# 3. Executar (vai pedir root)
sudo ./install_firmware_steamdeck.sh
```

O script vai:
1. Baixar o firmware automaticamente
2. Detectar o cartão SD do R36S
3. Montar a partição
4. Instalar o firmware
5. Desmontar

**Pronto!** Coloca o cartão no R36S e usa o WiFi.

---

## 📱 OPÇÃO 2: R36S (Menu Tools)

### Passo 1: Baixar o firmware

**Link direto:**
```
https://github.com/lwfinger/rtl8188fu/raw/master/firmware/rtl8188fufw.bin
```

Salve como: `rtl8188fufw.bin`

### Passo 2: Copiar pro cartão SD

Coloque `rtl8188fufw.bin` em `/roms/tools/` no cartão SD

### Passo 3: No R36S

1. EmulationStation → **Tools**
2. **"Install RTL8188FU WiFi Firmware"**
3. Conectar o adaptador WiFi
4. Usar menu WiFi normalmente

---

## 💻 OPÇÃO 3: Terminal Manual

Se preferir fazer na mão:

```bash
# No R36S (via SSH ou terminal)
cd /roms/tools/
sudo mkdir -p /lib/firmware/rtlwifi
sudo cp rtl8188fufw.bin /lib/firmware/rtlwifi/
```

Conecta o adaptador e pronto!

---

## ✅ Verificar se funcionou

```bash
# Ver se adaptador foi detectado
lsusb | grep 0bda:f179

# Ver se interface WiFi apareceu
ip link show

# Ver mensagens do kernel
dmesg | grep rtl8188
```

Deve aparecer interface `wlan0` ou similar.

---

## 🎯 RESUMO

**O que precisa:**
- 1 arquivo: `rtl8188fufw.bin` (15KB)
- Copiar para: `/lib/firmware/rtlwifi/`

**Métodos:**
1. **Steam Deck**: Roda script automático ✅ **MAIS FÁCIL**
2. **R36S Tools**: Usa menu EmulationStation
3. **Terminal**: Copia manualmente

**Não precisa:**
- ❌ Compilar driver
- ❌ Compilar kernel
- ❌ Instalar pacotes
- ❌ Fazer nada complicado

**Só firmware. É isso.** 📡

---

## 🔗 Links

**Firmware:**
- https://github.com/lwfinger/rtl8188fu/raw/master/firmware/rtl8188fufw.bin

**Scripts:**
- Steam Deck: `install_firmware_steamdeck.sh`
- R36S Tools: `Install RTL8188FU WiFi Firmware.sh`
- Terminal: `install_rtl8188fu_firmware_simple.sh`

---

**Créditos:** Descoberta do Discord - a_triant e chaoso85 🎉
