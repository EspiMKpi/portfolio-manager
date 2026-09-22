# Network Programming (L3/L4 Sockets & Protocols) Reference Guide

This reference provides Python patterns for socket communication, custom protocol framing, asynchronous I/O, and Network Layer packet analysis for **Network Programming**.

---

## 1. Network Layer (L3) vs Transport Layer (L4) Concepts

- **Network Layer (L3)**: Logical addressing (IPv4/IPv6), routing, subnetting, ICMP (ping/traceroute), raw sockets, packet headers (TTL, Checksum, Flags).
- **Transport Layer (L4)**: Process-to-process communication, port numbers, reliability & flow control (TCP 3-way handshake, sliding window, sequence/ACK numbers) vs. lightweight datagrams (UDP).

---

## 2. Robust Protocol Framing Pattern (Preventing TCP Sticky Packet / Stream Fragmentation)

TCP is a **byte stream**, not a message stream. Without framing, messages can stick together or arrive in fragments. Always use **Length-Prefixed Framing**:

```python
import struct
import asyncio

HEADER_FORMAT = "!I"  # 4-byte big-endian unsigned integer (message length)
HEADER_SIZE = struct.calcsize(HEADER_FORMAT)

def pack_message(data: str) -> bytes:
    payload = data.encode("utf-8")
    header = struct.pack(HEADER_FORMAT, len(payload))
    return header + payload

async def read_message(reader: asyncio.StreamReader) -> str:
    # 1. Read exact 4-byte header
    header_bytes = await reader.readexactly(HEADER_SIZE)
    (length,) = struct.unpack(HEADER_FORMAT, header_bytes)

    # 2. Read exact payload of declared length
    payload_bytes = await reader.readexactly(length)
    return payload_bytes.decode("utf-8")
```

---

## 3. High-Performance Multi-Client Asyncio TCP Server

```python
import asyncio
from typing import Set

class ChatServer:
    def __init__(self, host: str = "127.0.0.1", port: int = 8888):
        self.host = host
        self.port = port
        self.clients: Set[asyncio.StreamWriter] = set()

    async def handle_client(self, reader: asyncio.StreamReader, writer: asyncio.StreamWriter):
        addr = writer.get_extra_info("peername")
        print(f"[+] New connection from {addr}")
        self.clients.add(writer)
        try:
            while True:
                msg = await read_message(reader)
                print(f"[{addr}] Received: {msg}")
                # Broadcast to other connected clients
                await self.broadcast(f"User {addr}: {msg}", exclude=writer)
        except (asyncio.IncompleteReadError, ConnectionResetError):
            print(f"[-] Connection dropped: {addr}")
        finally:
            self.clients.discard(writer)
            writer.close()
            await writer.wait_closed()

    async def broadcast(self, message: str, exclude: asyncio.StreamWriter = None):
        packet = pack_message(message)
        for client in list(self.clients):
            if client != exclude:
                try:
                    client.write(packet)
                    await client.drain()
                except Exception:
                    self.clients.discard(client)

    async def run(self):
        server = await asyncio.start_server(self.handle_client, self.host, self.port)
        print(f"🚀 Server listening on {self.host}:{self.port}")
        async with server:
            await server.serve_forever()

if __name__ == "__main__":
    asyncio.run(ChatServer().run())
```

---

## 4. Network Layer Packet Crafting & Sniffing with Scapy

For L3/L4 packet inspection and raw protocol analysis:

```python
from scapy.all import IP, TCP, ICMP, sr1, sniff

# 1. Craft and send a custom ICMP Echo Request (Ping)
def send_custom_ping(target_ip: str):
    packet = IP(dst=target_ip, ttl=64) / ICMP()
    response = sr1(packet, timeout=2, verbose=False)
    if response:
        print(f"✅ Received Reply from {response.src} | TTL: {response.ttl}")
    else:
        print("❌ Request timed out")

# 2. Sniff TCP SYN packets (Handshake detection)
def packet_callback(pkt):
    if pkt.haslayer(TCP) and pkt[TCP].flags == "S":
        print(f"🔔 SYN Packet: {pkt[IP].src}:{pkt[TCP].sport} -> {pkt[IP].dst}:{pkt[TCP].dport}")

# sniff(filter="tcp", prn=packet_callback, count=10)
```

---

## 5. Troubleshooting Common Network Errors

| Error | Root Cause | Solution |
| :--- | :--- | :--- |
| `EADDRINUSE` (Address already in use) | Previous server process didn't close port cleanly. | Set `SO_REUSEADDR`: `sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)` or kill old PID (`lsof -i :8888`). |
| `ECONNRESET` (Connection reset by peer) | Client terminated unexpectedly or closed before FIN handshake. | Wrap socket `recv()` in `try...except ConnectionResetError:` block. |
| `ETIMEDOUT` / Timeout | Firewall blocking port, routing issue, or host unreachable. | Check firewall (`ufw status`), verify routing table (`ip route`), or test connectivity with `nc -zv <host> <port>`. |
