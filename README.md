# ArmShell 🐚

[![Architecture: ARM 32-bit](https://img.shields.io/badge/Architecture-ARM%2032--bit-blue.svg)](#)
[![Language: Assembly](https://img.shields.io/badge/Language-ARM%20Assembly-green.svg)](#)
[![Platform: Linux](https://img.shields.io/badge/Platform-Linux-lightgrey.svg)](#)

**ArmShell** is a minimalist, educational command-line interpreter implemented entirely in 32-bit ARM Assembly. This project was built to explore the fundamental mechanics of how a Unix-like shell interacts with the Linux kernel through system calls, process forking, and program execution.

## 🎯 Project Objective
The goal of this project is to move away from high-level abstractions and implement the core "Process Lifecycle" of a shell from scratch:
1.  **Prompting:** Utilizing `sys_write` to communicate with `stdout`.
2.  **Input Capture:** Utilizing `sys_read` to capture user input into memory buffers.
3.  **Process Orchestration:** Implementing the `fork()`, `execve()`, and `wait4()` pattern to spawn and manage child processes.

## 🛠 Technical Architecture
ArmShell operates on the **ARM EABI (Embedded Application Binary Interface)**. The program follows a continuous execution loop:

### The Execution Loop
| Stage | Logic | System Call | Register Usage (32-bit) |
| :--- | :--- | :--- | :--- |
| **1. Display** | Print the `$` prompt to the terminal. | `sys_write` (4) | `r0=1`, `r1=&buf`, `r2=len`, `r7=4` |
| **2. Read** | Capture user string from `stdin`. | `sys_read` (3) | `r0=0`, `r1=&buf`, `r2=max_len`, `r7=3` |
| **3. Fork** | Clone the current process into a child. | `sys_fork` (291)* | `r7=291` |
| **4. Execute**| Replace child process with target binary.| `sys_execve` (11) | `r0=&path`, `r1=&argv`, `r2=&envp`, `r7=11` |

*\*Note: Syscall numbers may vary slightly depending on the specific ARM Linux kernel version/ABI being used.*

## 🚀 Getting Started

### Prerequisites
To build and run this on an x86_64 machine (via emulation), you will need:
* `arm-linux-gnueabi-as` (ARM 32-bit Assembler)
* `arm-linux-gnueabi-ld` (ARM 32-bit Linker)
* `qemu-arm` (QEMU ARM Emulator)

### Building the Project
```bash
# 1. Assemble the source code
arm-linux-gnueabi-as -o armshell.o armshell.s

# 2. Link the object file into an executable
arm-linux-gnueabi-ld -o armshell armshell.o
```

### Running the Shell
You can run the shell directly on an ARM device (like a Raspberry Pi) or via QEMU on a standard PC:
```bash
qemu-arm ./armshell
```

## 🧠 Key Challenges Overcome
* **Memory Management:** Managing input buffers within the `.data` and `.bss` sections without the luxury of high-level string libraries.
* **Process Branching:** Handling the logic branch where `r0` returns `0` (child) vs a `PID` (parent).
* **Register Precision:** Ensuring strict adherence to the ARM calling convention for 32-bit registers (`r0`-`r12`).

## 🗺 Roadmap
- [ ] **Argument Parsing:** Implementing a parser to split input strings into an `argv` array.
- [ ] **Built-in Commands:** Adding `cd` (change directory) and `exit` functionality.
- [ ] **Redirection:** Implementing `sys_dup2` for pipe (`|`) and redirection (`>`) support.

## 📜 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### 💡 Tips for your Repo:
1.  **The `.s` file:** Ensure your code uses `r0`, `r1`, etc., instead of `x0`, `x1` (which are 64-bit).
2.  **The `Makefile`:** If you want to impress people, add a file named `Makefile` to the repo so they can just type `make` to build it.
3.  **Screenshots/GIFs:** If possible, use a tool like *Asciinema* to record your terminal running the shell and embed that GIF in the README. It makes the project feel "alive."
