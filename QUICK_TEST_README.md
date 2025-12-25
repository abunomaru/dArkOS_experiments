# Teste Rápido RTL8188FU - Sem Compilação

Scripts simples para testar se o adaptador WiFi RTL8188FU já funciona no dArkOS sem precisar compilar driver.

## 🚀 Uso Rápido

### Opção 1: Menu Tools (Mais Fácil)

1. Copie o arquivo para o R36S (ou já está incluído em builds novas)
2. EmulationStation → **Tools** → **"Test RTL8188FU WiFi Adapter"**
3. Siga as instruções na tela
4. Conecte o adaptador
5. Teste se WiFi aparece

### Opção 2: Terminal

```bash
sudo ./test_rtl8188fu_quick.sh
```

## ❓ O que os scripts fazem?

✅ Adicionam regras udev para reconhecer o adaptador (VID:0bda PID:f179)
✅ Recarregam as regras USB
✅ Testam se o adaptador é detectado
✅ Verificam se interface WiFi aparece

❌ **NÃO** compilam ou instalam drivers
❌ **NÃO** modificam o kernel

## 📊 Resultados Possíveis

### ✅ Funciona (Kernel 6.2+)
Se você ver:
- Adaptador detectado com `lsusb`
- Interface `wlan0` aparece com `ip link show`
- **Pronto!** Use o menu WiFi normalmente

### ❌ Não Funciona (Kernel < 6.2)
Se o adaptador é detectado MAS não aparece interface WiFi:
- Você precisa do **driver completo**
- Use: **"Install RTL8188FU WiFi Driver"** no menu Tools
- Ou siga o guia completo: `RTL8188FU_INSTALL_GUIDE.md`

## 📁 Arquivos

| Arquivo | Descrição |
|---------|-----------|
| `test_rtl8188fu_quick.sh` | Script simples para terminal |
| `test_wifi_tools_menu.sh` | Script com interface dialog |
| `dArkOS_Tools/Test RTL8188FU WiFi Adapter.sh` | Versão para menu Tools |

## 🔧 O que fazer depois?

### Se funcionou:
Nada! Só usar o menu WiFi. 📡

### Se não funcionou:
Instalar o driver completo:
1. No PC: `./build_rtl8188fu_standalone.sh`
2. Copiar `rtl8188fu_install_package.tar.gz` para `/roms/tools/`
3. No R36S: Tools → **"Install RTL8188FU WiFi Driver"**

---

**Teste primeiro, compile depois!** ⚡
