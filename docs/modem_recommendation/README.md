# Modem Recommendation Report  
### Upanzi Probe Connectivity Evaluation  

---

## Introduction  

Throughout the design of the **Upanzi Probe**, we experimented with various modem types to ensure reliable cellular connectivity.  
While Balena’s cellular configuration is well-documented, our primary challenge was identifying an **ideal modem** — one that is reliable, plug-and-play, and compatible with our Raspberry Pi–based architecture for remote deployment.  

---

## Defining the Ideal Modem  

Based on our experience, the ideal modem for this setup must meet the following key criteria:

1. **4G Support**  
   To accurately measure network capacity, the modem must support 4G LTE connections.

2. **Plug-and-Play Compatibility**  
   Since our devices are deployed remotely, we require modems that automatically connect without user intervention or additional software.

3. **No Packet Route Obfuscation**  
   The modem should not hide or mask packet routes through internal firmware or NAT-level routing.  
   We require transparent, end-to-end visibility for accurate path measurements.

> These are the primary technical hurdles that have affected smooth deployment.

---

## Types of Modems Tested  

### 1. Ethernet-over-USB Mode (RNDIS)  

These modems behave like virtual Ethernet interfaces and appear as `enx...` on Linux.  

**Pros:**  
- Generally support 4G LTE  
- Simple plug-and-play setup  

**Cons:**  
- Firmware inconsistencies across identical models  
- Occasional detection failures  
- Some versions obscure packet routes via built-in NAT  

> ⚠️ Even identical models may behave differently due to firmware variations.

---

### 2. True GSM Modems  

These use **AT commands** via serial interfaces.  

**Pros:**  
- Transparent IP layer (no NAT interference)  
- Easier to manage using `ModemManager` and `mmcli`  

**Cons:**  
- Some are limited to 3G only  
- Often require user-initiated connections  

> While transparent, 3G-only modems are unsuitable for high-bandwidth measurements.

---

## D-Link Modem (Recommended)  

Among all tested devices, the **D-Link 4G LTE USB Adapter** consistently delivered the best performance across all metrics.  

**Pros:**  
- Supports 4G LTE  
- Plug-and-play with Raspberry Pi (no extra configuration)  
- Exposes a clean network path without route masking  
- Minimal firmware mismatch risk (uses MBIM / QMI interface standards)  

**Cons:**  
- None encountered  

---

## Recommendation  

We **strongly recommend the D-Link 4G LTE USB Adapter** for all Upanzi Probe deployments.  

✅ **Key Advantages:**  
- Reliable 4G connectivity  
- True GSM behavior  
- Plug-and-play support  
- No packet-level interference  

---

## Summary  

| Feature | D-Link 4G LTE USB Adapter | Other Modems (Tested) |
|:--|:--:|:--:|
| 4G Support | ✅ | ⚠️ (Partial) |
| Plug-and-Play | ✅ | ⚠️ Requires manual setup |
| Transparent Routing | ✅ | ❌ (NAT interference) |
| Raspberry Pi Compatibility | ✅ | ⚠️ Inconsistent |
| Firmware Reliability | ✅ | ❌ Varies by model |

---

## References  

- *Mira 2025 Notebook – Modem Recommendation Report (Upanzi Probe Connectivity Evaluation)*  
- BalenaOS Configuration Guide  
- Upanzi Pod Measurements v4.3  

---

> 📌 For best results, pair this modem with **balenaOS 5.0.1** and Raspberry Pi–based deployments.  
> For setup examples and environmental configuration, see the [Upanzi Pod Measurements README](../../README.md).