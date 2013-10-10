From: Fengguang Wu <fengguang.wu@intel.com>
Date: Thu, 10 Oct 2013 08:24:01 -0000
Subject: [Ocfs2-devel] [XFS on bad superblock] BUG: unable to handle
 kernel NULL pointer dereference at 00000003
In-Reply-To: <20131010080652.GW4446@dastard>
References: <20131010005900.GE2025@devil.localdomain>
	<20131010011640.GA5726@localhost> <20131010014117.GA6017@localhost>
	<20131010031515.GT4446@dastard> <20131010032637.GA12725@localhost>
	<20131010033300.GA12952@localhost>
	<20131010033834.GA13141@localhost> <20131010042820.GA5663@dastard>
	<20131010060334.GA17576@localhost> <20131010080652.GW4446@dastard>
Message-ID: <20131010082350.GA31385@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, Ben Myers <bpm@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>

Dave,

>> This is an easily reproducible bug. And I further confirmed it in
>> two ways:
>>
>> 1) turn off XFS, build 39 commits and boot them 2000+ times
>>
>> => no single mount error
>
>That doesn't tell you it is an XFS error. Absence of symptoms !=
>absence of bug.

True.

>> 2) turn off all other filesystems, build 2 kernels on v3.12-rc3
>>    v3.12-rc4 and boot them
>> 
>> => half boots have oops
>
>Again, it doesn't tell you that it is an XFS bug. XFS is well known
>for exposing bugs in less used block devices, and you are definitely
>using devices that are unusual and not commonly tested by filesystem
>developers (e.g. zram, nbd, etc).
>

Yeah, it's possible that your commit exposed a bug in the less used
nbd/zram devices.

> You need to refine the test down from "throw shit at the wall, look
> at what sticks" to a simple, reproducable test case. I can't
> reproduce your systems or testing, so you need to provide a test
> case I can use. Otherwise we're just wasting time....

You may try the attached script. The initrd used in the script will be
sent to you in a private email. Here is an example run on my side:

wfg at bee /kernel/i386-randconfig-c4-0920-XFS/v3.12-rc4% kvm-0day.sh vmlinuz-3.12.0-rc4

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-rc4 (kbuild at cairo) (gcc version 4.8.1 (Debian 4.8.1-8) ) #2 Thu Oct 10 12:55:12 CST 2013
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f1840-0x000f184f] mapped at [c00f1840]
[    0.000000]   mpc: f1850-f193c
[    0.000000] initial memory mapped: [mem 0x00000000-0x01ffffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0fa00000-0x0fbfffff]
[    0.000000]  [mem 0x0fa00000-0x0fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0f9fffff]
[    0.000000]  [mem 0x0c000000-0x0f9fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x01ab4000, 0x01ab4fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x0fce4000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000f16b0 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe3f0 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0fffe430 01137 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffff6a0 00899 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0ffff5b0 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0ffff570 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 480 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] Using ACPI for processor (LAPIC) configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000]   mpc: f1850-f193c
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, APIC LINT 01
[    0.000000] Processors: 1
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 192f9c0
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64924
[    0.000000] Kernel command line: debug sched_debug ignore_loglevel apic=debug dyndbg="func kobject_release +p" sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal root=/dev/ram0 rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 243224K/261744K available (6465K kernel code, 636K rwdata, 2860K rodata, 540K init, 380K bss, 18520K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe1000 - 0xfffff000   ( 120 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xfffdf000   ( 759 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc19bd000 - 0xc1a44000   ( 540 kB)
[    0.000000]       .data : 0xc165079c - 0xc19bc100   (3502 kB)
[    0.000000]       .text : 0xc1000000 - 0xc165079c   (6465 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: HWalign=128, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=cf408000 soft=cf40a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.009999] Calibrating delay loop (skipped) preset value.. 5389.47 BogoMIPS (lpj=8978360)
[    0.013344] pid_max: default: 32768 minimum: 301
[    0.016707] Security Framework initialized
[    0.020007] SELinux:  Initializing.
[    0.021495] SELinux:  Starting in enforcing mode
[    0.023359] Mount-cache hash table entries: 512
[    0.024724] Initializing cgroup subsys debug
[    0.026673] Initializing cgroup subsys devices
[    0.027736] Initializing cgroup subsys freezer
[    0.029211] Initializing cgroup subsys net_cls
[    0.030103] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.030103] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.030103] tlb_flushall_shift: 6
[    0.033340] CPU: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.039054] ACPI: Core revision 20130725
[    0.041016] ACPI: All ACPI Tables successfully acquired
[    0.043347] ACPI: setting ELCR to 0200 (from 0c00)
[    0.044803] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.046741] Getting VERSION: 50014
[    0.047808] Getting VERSION: 50014
[    0.048829] Getting ID: 0
[    0.050013] Getting ID: f000000
[    0.053355] Getting LVT0: 8700
[    0.054332] Getting LVT1: 8400
[    0.055358] enabled ExtINT on CPU#0
[    0.056386] Using local APIC timer interrupts.
[    0.056386] calibrating APIC timer ...
[    0.059999] ... lapic delta = 6251177
[    0.059999] ... PM-Timer delta = 358038
[    0.059999] ... PM-Timer result ok
[    0.059999] ..... delta 6251177
[    0.059999] ..... mult: 268486034
[    0.059999] ..... calibration result: 3333961
[    0.059999] ..... CPU clock speed is 2694.1278 MHz.
[    0.059999] ..... host bus clock speed is 1000.0961 MHz.
[    0.060221] devtmpfs: initialized
[    0.067170] EVM: security.selinux
[    0.070005] EVM: security.SMACK64
[    0.073335] EVM: security.capability
[    0.074681] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.076733] regulator-dummy: no parameters
[    0.080077] NET: Registered protocol family 16
[    0.083881] EISA bus registered
[    0.086674] cpuidle: using governor ladder
[    0.093340] cpuidle: using governor menu
[    0.097085] ACPI: bus type PCI registered
[    0.103486] PCI : PCI BIOS area is rw and x. Use pci=nobios if you want it NX.
[    0.110008] PCI: PCI BIOS revision 2.10 entry at 0xfd4e3, last bus=0
[    0.113337] PCI: Using configuration type 1 for base access
[    0.119335] bio: create slab <bio-0> at 0
[    0.120164] ACPI: Added _OSI(Module Device)
[    0.122332] ACPI: Added _OSI(Processor Device)
[    0.123339] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.130008] ACPI: Added _OSI(Processor Aggregator Device)
[    0.137301] ACPI: EC: Look up EC in DSDT
[    0.141802] ACPI: Interpreter enabled
[    0.146698] ACPI: (supports S0 S5)
[    0.153352] ACPI: Using PIC for interrupt routing
[    0.155258] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.163035] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.163352] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.170156] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.173383] PCI host bridge to bus 0000:00
[    0.176681] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.180010] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.181925] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.183342] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.186674] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    0.190060] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.192433] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.193810] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.199222] pci 0000:00:01.1: reg 0x20: [io  0xc060-0xc06f]
[    0.201705] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.207217] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.213354] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.216872] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.224129] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.227687] pci 0000:00:02.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    0.242966] pci 0000:00:02.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.243634] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.248000] pci 0000:00:03.0: reg 0x10: [io  0xc040-0xc05f]
[    0.251272] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.260012] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.267094] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.276675] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.284644] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.296696] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.299414] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    0.300814] pci 0000:00:05.0: reg 0x10: [mem 0xfebe0000-0xfebe000f]
[    0.310473] pci_bus 0000:00: on NUMA node 0
[    0.312530] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.316724] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.324589] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.327605] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.330760] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.337209] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.340014] ACPI: \_SB_.PCI0: notify handler is installed
[    0.346702] Found 1 acpi root devices
[    0.348875] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.353341] vgaarb: loaded
[    0.356670] vgaarb: bridge control possible 0000:00:02.0
[    0.358744] SCSI subsystem initialized
[    0.360051] libata version 3.00 loaded.
[    0.361562] ACPI: bus type USB registered
[    0.363366] usbcore: registered new interface driver usbfs
[    0.365275] usbcore: registered new interface driver hub
[    0.370053] usbcore: registered new device driver usb
[    0.376842] Linux video capture interface: v2.00
[    0.378624] pps_core: LinuxPPS API ver. 1 registered
[    0.380005] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.383353] PTP clock support registered
[    0.386691] EDAC MC: Ver: 3.0.0
[    0.388143] PCI: Using ACPI for IRQ routing
[    0.390008] PCI: pci_cache_line_size set to 64 bytes
[    0.392012] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.393341] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.396803] NetLabel: Initializing
[    0.398090] NetLabel:  domain hash size = 128
[    0.400006] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.402214] NetLabel:  unlabeled traffic allowed by default
[    0.406750] nfc: nfc_init: NFC Core ver 0.1
[    0.408569] NET: Registered protocol family 39
[    0.410475] Switched to clocksource kvm-clock
[    0.414524] FS-Cache: Loaded
[    0.417646] CacheFiles: Loaded
[    0.422134] pnp: PnP ACPI init
[    0.425707] ACPI: bus type PNP registered
[    0.430534] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.437204] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.444104] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.448500] pnp 00:03: [dma 2]
[    0.449978] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.453402] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.455911] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.458580] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.461418] pnp: PnP ACPI: found 7 devices
[    0.465490] ACPI: bus type PNP unregistered
[    0.891139] mdacon: MDA with 8K of memory detected.
[    0.891167] Console: switching consoles 13-16 to MDA-2
[    0.929106] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.930967] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.934546] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.936457] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.938381] NET: Registered protocol family 2
[    0.942350] TCP established hash table entries: 2048 (order: 2, 16384 bytes)
[    0.948934] TCP bind hash table entries: 2048 (order: 1, 8192 bytes)
[    0.955236] TCP: Hash tables configured (established 2048 bind 2048)
[    0.957375] TCP: reno registered
[    0.958558] UDP hash table entries: 256 (order: 0, 4096 bytes)
[    0.960214] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
[    0.962258] NET: Registered protocol family 1
[    0.963814] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.965449] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.967214] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.969216] pci 0000:00:02.0: Boot video device
[    0.970546] PCI: CLS 0 bytes, default 64
[    0.972011] Trying to unpack rootfs image as initramfs...
[    3.704294] Freeing initrd memory: 3120K (cfce4000 - cfff0000)
[    4.542943] DMA-API: preallocated 65536 debug entries
[    4.544630] DMA-API: debugging enabled by kernel config
[    4.546903] PCLMULQDQ-NI instructions are not detected.
[    4.551188] The force parameter has not been set to 1. The Iris poweroff handler will not be installed.
[    4.554505] audit: initializing netlink socket (disabled)
[    4.556148] type=2000 audit(1378709071.679:1): initialized
[    4.560694] zbud: loaded
[    4.561780] VFS: Disk quotas dquot_6.5.2
[    4.563094] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    4.565275] DLM installed
[    4.566311] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, debug enabled
[    4.571933] msgmni has been set to 481
[    4.574423] Key type asymmetric registered
[    4.577873] Asymmetric key parser 'x509' registered
[    4.584026] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    4.587225] io scheduler noop registered
[    4.588552] io scheduler cfq registered (default)
[    4.592872] test_string_helpers: Running tests...
[    4.597353] Console: switching consoles 13-16 to MDA-2
[    4.602613] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    4.604884] ACPI: Power Button [PWRF]
[    4.606449] r3964: Philips r3964 Driver $Revision: 1.10 $
[    4.608431] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.632507] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    4.635419] STMicroelectronics ASC driver initialized
[    4.637237] serial: Freescale lpuart driver
[    4.638862] DoubleTalk PC - not found
[    4.641556] Non-volatile memory driver v1.3
[    4.645790] toshiba: not a supported Toshiba laptop
[    4.649152] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
[    4.651565] platform pc8736x_gpio.0: no device found
[    4.653277] nsc_gpio initializing
[    4.654537] telclk_interrupt = 0xf non-mcpbl0010 hw.
[    4.658127] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    4.662545] Hangcheck: Using getrawmonotonic().
[    4.664433] parport_pc 00:04: reported by Plug and Play ACPI
[    4.669069] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[    4.671733] Floppy drive(s): fd0 is 1.44M
[    5.044165] brd: module loaded
[    5.046742] loop: module loaded
[    5.048762] nbd: registered device at major 43
[    5.051541] rbd: loaded rbd (rados block device)
[    5.052990] dummy-irq: no IRQ given.  Use irq=N
[    5.054421] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    5.068604] usbcore: registered new interface driver viperboard
[    5.070557] Uniform Multi-Platform E-IDE driver
[    5.072449] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    5.075405] ide-gd driver 1.18
[    5.076633] ide-cd driver 5.00
[    5.078267] Loading iSCSI transport class v2.0-870.
[    5.083361] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    5.088677] SCSI Media Changer driver v0.25
[    5.090655] FDC 0 is a S82078B
[    5.203864] parport0: AVR Butterfly
[    5.204841] parport0: cannot grant exclusive access for device spi-lm70llp
[    5.206214] spi-lm70llp: spi_lm70llp probe fail, status -12
[    5.207656] HSI/SSI char device loaded
[    5.208823] slcan: serial line CAN interface driver
[    5.209715] slcan: 10 dynamic interface channels.
[    5.210766] CAN device driver interface
[    5.212200] usbcore: registered new interface driver ems_usb
[    5.213767] usbcore: registered new interface driver kvaser_usb
[    5.214696] usbcore: registered new interface driver peak_usb
[    5.216438] usbcore: registered new interface driver usb_8dev
[    5.217794] parport0: cannot grant exclusive access for device ks0108
[    5.219920] ks0108: ERROR: parport didn't register new device
[    5.222171] aoe: cannot create debugfs directory
[    5.224392] aoe: AoE v85 initialised.
[    5.225729] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.227802] ehci-pci: EHCI PCI platform driver
[    5.229450] ehci-platform: EHCI generic platform driver
[    5.231650] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.234425] ohci-pci: OHCI PCI platform driver
[    5.236730] ohci-platform: OHCI generic platform driver
[    5.242681] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    5.245332] Warning! fusbh200_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    5.248428] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    5.249630] 4Warning! fotg210_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    5.252873] usbcore: registered new interface driver cdc_acm
[    5.255834] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[    5.259138] usbcore: registered new interface driver usblp
[    5.260879] usbcore: registered new interface driver cdc_wdm
[    5.262756] usbcore: registered new interface driver usbtmc
[    5.264581] usbcore: registered new interface driver mdc800
[    5.266404] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
[    5.270083] usbcore: registered new interface driver appledisplay
[    5.272221] usbcore: registered new interface driver cypress_cy7c63
[    5.274528] usbcore: registered new interface driver cytherm
[    5.279863] usbcore: registered new interface driver emi26 - firmware loader
[    5.287058] usbcore: registered new interface driver emi62 - firmware loader
[    5.289347] usbcore: registered new interface driver idmouse
[    5.291324] usbcore: registered new interface driver isight_firmware
[    5.294315] usbcore: registered new interface driver usblcd
[    5.296120] usbcore: registered new interface driver ldusb
[    5.297943] usbcore: registered new interface driver usbled
[    5.299786] usbcore: registered new interface driver legousbtower
[    5.301874] usbcore: registered new interface driver rio500
[    5.303973] usbcore: registered new interface driver usb_ehset_test
[    5.305968] usbcore: registered new interface driver trancevibrator
[    5.310702] usbcore: registered new interface driver uss720
[    5.312513] uss720: v0.6:USB Parport Cable driver for Cables using the Lucent Technologies USS720 Chip
[    5.315571] uss720: NOTE: this is a special purpose driver to allow nonstandard
[    5.318118] uss720: protocols (eg. bitbang) over USS720 usb to parallel cables
[    5.321289] uss720: If you just want to connect to a printer, use usblp instead
[    5.324257] usbcore: registered new interface driver usbsevseg
[    5.326456] usbcore: registered new interface driver yurex
[    5.328188] usbcore: registered new interface driver sisusb
[    5.330336] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 May 2005
[    5.334168] dummy_hcd dummy_hcd.0: Dummy host controller
[    5.336651] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus number 1
[    5.339206] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    5.341354] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.343620] usb usb1: Product: Dummy host controller
[    5.345149] usb usb1: Manufacturer: Linux 3.12.0-rc4 dummy_hcd
[    5.348215] usb usb1: SerialNumber: dummy_hcd.0
[    5.349858] hub 1-0:1.0: USB hub found
[    5.351214] hub 1-0:1.0: 1 port detected
[    5.352862] using random self ethernet address
[    5.354345] using random host ethernet address
[    5.356061] usb0: HOST MAC 36:b4:03:5f:55:37
[    5.357421] usb0: MAC a6:68:b9:e8:fd:59
[    5.358670] g_ncm gadget: NCM Gadget
[    5.359994] g_ncm gadget: g_ncm ready
[    5.361294] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    5.364764] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.366325] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.369790] mousedev: PS/2 mouse device common for all mice
[    5.371710] evbug: Connected device: input0 (Power Button at LNXPWRBN/button/input0)
[    5.374538] usbcore: registered new interface driver usb_acecad
[    5.376398] usbcore: registered new interface driver aiptek
[    5.378959] usbcore: registered new interface driver gtco
[    5.381462] usbcore: registered new interface driver hanwang
[    5.383608] usbcore: registered new interface driver kbtab
[    5.385306] usbcore: registered new interface driver i2c-diolan-u2c
[    5.387402] i2c-parport-light: adapter type unspecified
[    5.389128] usbcore: registered new interface driver i2c-tiny-usb
[    5.391061] isa i2c-pca-isa.0: Please specify I/O base
[    5.392582] pps_ldisc: PPS line discipline registered
[    5.394529] pps_parport: parallel port PPS client
[    5.398296] parport0: cannot grant exclusive access for device pps_parport
[    5.400199] pps_parport: couldn't register with parport0
[    5.401884] Driver for 1-wire Dallas network protocol.
[    5.403914] usbcore: registered new interface driver DS9490R
[    5.406731] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
[    5.411616] applesmc: supported laptop not found!
[    5.412831] applesmc: driver init failed (ret=-19)!
[    5.415056] mixcomwd: No card detected, or port not available
[    5.416697] acquirewdt: WDT driver for Acquire single board computer initialising
[    5.418720] acquirewdt: I/O address 0x0043 already in use
[    5.420367] acquirewdt: probe of acquirewdt failed with error -5
[    5.422788] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    5.425510] evbug: Connected device: input1 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
[    5.428269] sc520_wdt: WDT driver for SC520 initialised. timeout=30 sec (nowayout=1)
[    5.430815] ib700wdt: WDT driver for IB700 single board computer initialising
[    5.433023] ib700wdt: failed to register misc device
[    5.434851] ib700wdt: probe of ib700wdt failed with error -16
[    5.437179] it87_wdt: no device
[    5.439384] sc1200wdt: build 20020303
[    5.443356] sc1200wdt: io parameter must be specified
[    5.444853] pc87413_wdt: Version 1.1 at io 0x2E
[    5.446447] pc87413_wdt: cannot register miscdev on minor=130 (err=-16)
[    5.448669] sbc8360: failed to register misc device
[    5.450215] sbc7240_wdt: timeout set to 30 seconds
[    5.451530] sbc7240_wdt: cannot register miscdev on minor=130 (err=-16)
[    5.453249] cpu5wdt: misc_register failed
[    5.454944] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Super I/O chip initialising
[    5.458140] w83697ug_wdt: No W83697UG/UF could be found
[    5.460795] w83877f_wdt: cannot register miscdev on minor=130 (err=-16)
[    5.463512] w83977f_wdt: driver v1.00
[    5.464699] w83977f_wdt: cannot register miscdev on minor=130 (err=-16)
[    5.467114] sbc_epx_c3: cannot register miscdev on minor=130 (err=-16)
[    5.469295] platform eisa.0: Probing EISA bus 0
[    5.471839] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    5.475812] hidraw: raw HID events driver (C) Jiri Kosina
[    5.478109] usbcore: registered new interface driver usbhid
[    5.479788] usbhid: USB HID core driver
[    5.481306] usbip_core: usbip_core_init:805: USB/IP Core v1.0.0
[    5.484297] vhci_hcd: vhci_hcd_probe:1000: name vhci_hcd id -1
[    5.486541] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
[    5.488631] vhci_hcd vhci_hcd: new USB bus registered, assigned bus number 2
[    5.491473] vhci_hcd: vhci_start:884: enter vhci_start
[    5.494205] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    5.497444] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.500775] usb usb2: Product: USB/IP Virtual Host Controller
[    5.502671] usb usb2: Manufacturer: Linux 3.12.0-rc4 vhci_hcd
[    5.504504] usb usb2: SerialNumber: vhci_hcd
[    5.506291] hub 2-0:1.0: USB hub found
[    5.509205] vhci_hcd: vhci_hub_control:247: typeReq a006 wValue 2900 wIndex 0
[    5.511658] vhci_hcd: vhci_hub_control:305:  GetHubDescriptor
[    5.513649] vhci_hcd: vhci_hub_control:398: port -1
[    5.515186] vhci_hcd: vhci_hub_control:405:  bye
[    5.516755] hub 2-0:1.0: 8 ports detected
[    5.518310] vhci_hcd: vhci_hub_control:247: typeReq a000 wValue 0 wIndex 0
[    5.520215] vhci_hcd: vhci_hub_control:309:  GetHubStatus
[    5.522031] vhci_hcd: vhci_hub_control:398: port -1
[    5.523691] vhci_hcd: vhci_hub_control:405:  bye
[    5.525390] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 1
[    5.528189] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    5.531213] vhci_hcd: vhci_hub_control:398: port 0
[    5.532794] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    5.535570] vhci_hcd: dump_port_status_diff:115:  +POWER
[    5.552811] vhci_hcd: dump_port_status_diff:119:
[    5.554366] vhci_hcd: vhci_hub_control:405:  bye
[    5.555933] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 2
[    5.558071] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    5.560094] vhci_hcd: vhci_hub_control:398: port 1
[    5.565285] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    5.568770] vhci_hcd: dump_port_status_diff:115:  +POWER
[    5.571392] vhci_hcd: dump_port_status_diff:119:
[    5.573594] vhci_hcd: vhci_hub_control:405:  bye
[    5.575083] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 3
[    5.576684] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    5.578658] vhci_hcd: vhci_hub_control:398: port 2
[    5.580312] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    5.582952] vhci_hcd: dump_port_status_diff:115:  +POWER
[    5.584687] vhci_hcd: dump_port_status_diff:119:
[    5.586202] vhci_hcd: vhci_hub_control:405:  bye
[    5.590466] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 4
[    5.592996] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    5.595828] vhci_hcd: vhci_hub_control:398: port 3
[    5.597444] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    5.601590] vhci_hcd: dump_port_status_diff:115:  +POWER
[    5.603574] vhci_hcd: dump_port_status_diff:119:
[    5.605506] vhci_hcd: vhci_hub_control:405:  bye
[    5.606885] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 5
[    5.608896] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    5.610842] vhci_hcd: vhci_hub_control:398: port 4
[    5.612533] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    5.615424] vhci_hcd: dump_port_status_diff:115:  +POWER
[    5.617160] vhci_hcd: dump_port_status_diff:119:
[    5.620139] vhci_hcd: vhci_hub_control:405:  bye
[    5.622448] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 6
[    5.624574] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    5.627767] vhci_hcd: vhci_hub_control:398: port 5
[    5.629255] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    5.632940] vhci_hcd: dump_port_status_diff:115:  +POWER
[    5.634707] vhci_hcd: dump_port_status_diff:119:
[    5.636277] vhci_hcd: vhci_hub_control:405:  bye
[    5.637966] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 7
[    5.639782] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    5.641750] vhci_hcd: vhci_hub_control:398: port 6
[    5.643371] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    5.646016] vhci_hcd: dump_port_status_diff:115:  +POWER
[    5.647766] vhci_hcd: dump_port_status_diff:119:
[    5.649263] vhci_hcd: vhci_hub_control:405:  bye
[    5.650844] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 8
[    5.653010] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    5.655626] vhci_hcd: vhci_hub_control:398: port 7
[    5.657206] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    5.660985] vhci_hcd: dump_port_status_diff:115:  +POWER
[    5.662454] vhci_hcd: dump_port_status_diff:119:
[    5.663942] vhci_hcd: vhci_hub_control:405:  bye
[    5.666895] vhci_hcd: vhci_hcd_probe:1034: bye
[    5.669013] vhci_hcd: vhci_hcd_init:1156: USB/IP 'Virtual' Host Controller (VHCI) Driver v1.0.0
[    5.719962] usb 1-1: new high-speed USB device number 2 using dummy_hcd
[    5.766626] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 1
[    5.768345] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 1
[    5.769821] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    5.771372] vhci_hcd: vhci_hub_control:398: port 0
[    5.772597] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    5.774687] vhci_hcd: dump_port_status_diff:115:   POWER
[    5.776104] vhci_hcd: dump_port_status_diff:119:
[    5.777341] vhci_hcd: vhci_hub_control:405:  bye
[    5.778580] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 2
[    5.780815] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 2
[    5.784781] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    5.790837] vhci_hcd: vhci_hub_control:398: port 1
[    5.794428] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    5.797196] vhci_hcd: dump_port_status_diff:115:   POWER
[    5.798807] vhci_hcd: dump_port_status_diff:119:
[    5.800391] vhci_hcd: vhci_hub_control:405:  bye
[    5.801861] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 3
[    5.803843] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 3
[    5.805654] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    5.811229] vhci_hcd: vhci_hub_control:398: port 2
[    5.815629] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    5.824177] vhci_hcd: dump_port_status_diff:115:   POWER
[    5.825956] vhci_hcd: dump_port_status_diff:119:
[    5.827563] vhci_hcd: vhci_hub_control:405:  bye
[    5.829054] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 4
[    5.833535] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 4
[    5.835471] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    5.837410] vhci_hcd: vhci_hub_control:398: port 3
[    5.840167] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    5.847093] vhci_hcd: dump_port_status_diff:115:   POWER
[    5.848997] vhci_hcd: dump_port_status_diff:119:
[    5.850687] vhci_hcd: vhci_hub_control:405:  bye
[    5.853370] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 5
[    5.855787] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 5
[    5.857590] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    5.859525] vhci_hcd: vhci_hub_control:398: port 4
[    5.862447] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    5.865068] vhci_hcd: dump_port_status_diff:115:   POWER
[    5.869419] vhci_hcd: dump_port_status_diff:119:
[    5.874347] vhci_hcd: vhci_hub_control:405:  bye
[    5.880360] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 6
[    5.889920] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 6
[    5.898444] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    5.904015] vhci_hcd: vhci_hub_control:398: port 5
[    5.906512] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    5.909405] vhci_hcd: dump_port_status_diff:115:   POWER
[    5.911958] vhci_hcd: dump_port_status_diff:119:
[    5.915682] vhci_hcd: vhci_hub_control:405:  bye
[    5.919821] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 7
[    5.921818] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 7
[    5.924374] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    5.926252] vhci_hcd: vhci_hub_control:398: port 6
[    5.927857] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    5.936804] vhci_hcd: dump_port_status_diff:115:   POWER
[    5.939741] vhci_hcd: dump_port_status_diff:119:
[    5.941302] vhci_hcd: vhci_hub_control:405:  bye
[    5.942860] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 8
[    5.944873] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 8
[    5.946738] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    5.948662] vhci_hcd: vhci_hub_control:398: port 7
[    5.950202] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    5.954008] vhci_hcd: dump_port_status_diff:115:   POWER
[    5.955716] vhci_hcd: dump_port_status_diff:119:
[    5.957219] vhci_hcd: vhci_hub_control:405:  bye
[    5.958867] tsc: Refined TSC clocksource calibration: 2693.467 MHz
[    5.986665] usb 1-1: New USB device found, idVendor=0525, idProduct=a4a1
[    5.988421] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.990337] usb 1-1: Product: NCM Gadget
[    5.991466] usb 1-1: Manufacturer: Linux 3.12.0-rc4 with dummy_udc
[    5.993314] g_ncm gadget: high-speed config #1: CDC Ethernet (NCM)
[    6.000054] usbip-host 1-1:1.0: Enter
[    6.001239] usbip-host 1-1:1.0: 1-1 is not in match_busid table... skip!
[    6.003340] usbip-host 1-1:1.1: Enter
[    6.004375] usbip-host 1-1:1.1: 1-1 is not in match_busid table... skip!
[    6.005974] usbip-host 1-1:1.0: Enter
[    6.007045] usbip-host 1-1:1.0: 1-1 is not in match_busid table... skip!
[    6.008843] usbip-host 1-1:1.1: Enter
[    6.009890] usbip-host 1-1:1.1: 1-1 is not in match_busid table... skip!
[    6.011466] usbcore: registered new interface driver usbip-host
[    6.012961] usbip_host: usbip_host_init:270: USB/IP Host Driver v1.0.0
[    6.014572] panel: could not claim access to parport0. Aborting.
[    6.022611] panel: driver version 0.9.5 not yet registered
[    6.028766] usbcore: registered new interface driver rts5139
[    6.032876] usbcore: registered new interface driver tranzport
[    6.034660] usbcore: registered new interface driver alphatrack
[    6.037021] usb usb2: vhci_bus_suspend
[    6.038414] vhci_hcd: vhci_hub_status:208: changed 0
[    6.040124] zram: Created 1 device(s) ...
[    6.041491] beceem: Beceem Communications Inc. WiMAX driver, 5.2.45
[    6.043435] Copyright 2010. Beceem Communications Inc
[    6.045056] usbcore: registered new interface driver usbbcm
[    6.046977] logger: created 256K log 'log_main'
[    6.048441] logger: created 256K log 'log_events'
[    6.050026] logger: created 256K log 'log_radio'
[    6.054068] logger: created 256K log 'log_system'
[    6.056362] usbcore: registered new interface driver gdm_wimax
[    6.058806] usbcore: registered new interface driver cedusb
[    6.060760] dgap: dgap-1.3-16, Digi International Part Number 40002347_C
[    6.063130] dgap: For the tools package or updated drivers please visit http://www.digi.com
[    6.066628]  fake-fmc-carrier: mezzanine 0
[    6.068517]       Manufacturer: fake-vendor
[    6.069843]       Product name: fake-design-for-testing
[    6.071617] fmc fake-design-for-testing-f001: Driver has no ID: matches all
[    6.076690] fmc_trivial: probe of fake-design-for-testing-f001 failed with error -95
[    6.084226] fmc fake-design-for-testing-f001: Driver has no ID: matches all
[    6.091683] fmc_chardev fake-design-for-testing-f001: Created misc device "fake-design-for-testing-f001"
[    6.095603] pktgen: Packet Generator for packet performance testing. Version: 2.74
[    6.453185] NET: Registered protocol family 26
[    6.456590] netem: version 1.3
[    6.459826] ipip: IPv4 over IPv4 tunneling driver
[    6.464525] gre: GRE over IPv4 demultiplexor driver
[    6.473774] ip_gre: GRE over IPv4 tunneling driver
[    6.480168] TCP: cubic registered
[    6.484521] Initializing XFRM netlink socket
[    6.490372] NET: Registered protocol family 10
[    6.497875] mip6: Mobile IPv6
[    6.501872] sit: IPv6 over IPv4 tunneling driver
[    6.506511] ip6_gre: GRE over IPv6 tunneling driver
[    6.508091] NET: Registered protocol family 17
[    6.509502] NET: Registered protocol family 4
[    6.510980] NET: Registered protocol family 5
[    6.512198] can: controller area network core (rev 20120528 abi 9)
[    6.514152] NET: Registered protocol family 29
[    6.515504] can: raw protocol (rev 20120528)
[    6.516537] can: broadcast manager protocol (rev 20120528 t)
[    6.518080] can: netlink gateway (rev 20130117) max_hops=1
[    6.523146] NET: Registered protocol family 33
[    6.528820] Key type rxrpc registered
[    6.533603] Key type rxrpc_s registered
[    6.538615] l2tp_core: L2TP core driver, V2.0
[    6.541825] NET: Registered protocol family 35
[    6.543779] DCCP: Activated CCID 2 (TCP-like)
[    6.545717] sctp: Hash tables configured (established 8192 bind 16384)
[    6.549925] NET: Registered protocol family 21
[    6.553285] Registered RDS/tcp transport
[    6.554865] 9pnet: Installing 9P2000 support
[    6.556362] Key type dns_resolver registered
[    6.559836] Key type ceph registered
[    6.561252] libceph: loaded (mon/osd proto 15/24)
[    6.565783] batman_adv: B.A.T.M.A.N. advanced 2013.4.0 (compatibility version 14) loaded
[    6.570250] Using IPI Shortcut mode
[    6.573085] registered taskstats version 1
[    6.574724] Key type trusted registered
[    6.576197] Key type encrypted registered
[    6.577931] IMA: No TPM chip found, activating TPM-bypass!
[    6.580079] hd: no drives specified - use hd=cyl,head,sectors on kernel command line
[    6.582951] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    6.584871] EDD information not available.
[    6.586720] Freeing unused kernel memory: 540K (c19bd000 - c1a44000)
[    6.590903] Write protecting the kernel text: 6468k
[    6.597190] Write protecting the kernel read-only data: 2864k
[    6.599859] NX-protecting the kernel data: 5820k
[    7.707009] end_request: I/O error, dev fd0, sector 0
[   10.475988] block nbd4: Attempted send on closed socket
[   10.478272] end_request: I/O error, dev nbd4, sector 0
[   10.492950] block nbd15: Attempted send on closed socket
[   10.498283] end_request: I/O error, dev nbd15, sector 0
[   10.504236] BUG: unable to handle kernel NULL pointer dereference at 00000004
[   10.507558] IP: [<c1034419>] pool_mayday_timeout+0x5f/0x9c
[   10.507558] *pdpt = 000000000ce6a001 *pde = 0000000000000000
[   10.507558] Oops: 0000 [#1]
[   10.507558] CPU: 0 PID: 516 Comm: mount Not tainted 3.12.0-rc4 #2
[   10.507558] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   10.507558] task: ccda7440 ti: cf40a000 task.ti: cce2e000
[   10.507558] EIP: 0060:[<c1034419>] EFLAGS: 00010046 CPU: 0
[   10.507558] EIP is at pool_mayday_timeout+0x5f/0x9c
[   10.507558] EAX: 00000000 EBX: c1931d50 ECX: 00000000 EDX: 00000000
[   10.507558] ESI: c10343ba EDI: cd5a3258 EBP: cf40bf94 ESP: cf40bf80
[   10.507558]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   10.507558] CR0: 8005003b CR2: 00000004 CR3: 0cdbd000 CR4: 000006b0
[   10.507558] Stack:
[   10.507558]  c1931d60 cf40bf90 00000100 c10343ba cf40bfc0 cf40bfa4 c102cd96 c1a52700
[   10.507558]  cf40bfc0 cf40bfd4 c102cf7e c1931d50 c1a53110 c1a52f10 cf40bfc0 c10343ba
[   10.507558]  cf40bfc0 cf40bfc0 00000001 c1a52588 00000100 cf40bff8 c1028f61 00000001
[   10.507558] Call Trace:
[   10.507558]  [<c10343ba>] ? need_to_create_worker+0x32/0x32
[   10.507558]  [<c102cd96>] call_timer_fn.isra.39+0x16/0x60
[   10.507558]  [<c102cf7e>] run_timer_softirq+0x144/0x15e
[   10.507558]  [<c10343ba>] ? need_to_create_worker+0x32/0x32
[   10.507558]  [<c1028f61>] __do_softirq+0x87/0x12b
[   10.507558]  [<c1028eda>] ? local_bh_enable_ip+0xa/0xa
[   10.507558]  <IRQ>
[   10.507558]  [<c10290c4>] ? irq_exit+0x3a/0x48
[   10.507558]  [<c1018818>] ? smp_apic_timer_interrupt+0x23/0x2c
[   10.507558]  [<c164f38d>] ? apic_timer_interrupt+0x2d/0x34
[   10.507558]  [<c126f5e2>] ? arch_local_irq_restore+0x5/0xb
[   10.507558]  [<c126f694>] ? spin_unlock_irqrestore.isra.4+0x8/0x14
[   10.507558]  [<c126f705>] ? nbd_end_request+0x65/0x6d
[   10.507558]  [<c126f784>] ? do_nbd_request+0x77/0xc1
[   10.507558]  [<c11abe4f>] ? __blk_run_queue_uncond+0x1e/0x27
[   10.507558]  [<c11abe6b>] ? __blk_run_queue+0x13/0x15
[   10.507558]  [<c11abfe8>] ? queue_unplugged.isra.56+0x13/0x1f
[   10.507558]  [<c11ad70b>] ? blk_flush_plug_list+0x140/0x14f
[   10.507558]  [<c11ad95f>] ? blk_finish_plug+0xd/0x27
[   10.507558]  [<c11051b6>] ? _xfs_buf_ioapply+0x236/0x24e
[   10.507558]  [<c110520f>] ? xfs_buf_iorequest+0x41/0x57
[   10.507558]  [<c110537d>] ? xfsbdstrat+0x1a/0x1c
[   10.507558]  [<c110551f>] ? xfs_buf_read_uncached+0x67/0x7a
[   10.507558]  [<c11122e8>] ? xfs_readsb+0x97/0x160
[   10.507558]  [<c111549b>] ? xfs_fs_fill_super+0x15e/0x29f
[   10.507558]  [<c109d9b7>] ? mount_bdev+0x105/0x14d
[   10.507558]  [<c1092b69>] ? slab_pre_alloc_hook.isra.66+0x1e/0x25
[   10.507558]  [<c1095412>] ? __kmalloc_track_caller+0xb8/0xe4
[   10.507558]  [<c10ae704>] ? alloc_vfsmnt+0xdc/0xff
[   10.507558]  [<c1113c4b>] ? xfs_fs_mount+0x10/0x12
[   10.507558]  [<c111533d>] ? xfs_finish_flags+0x13b/0x13b
[   10.507558]  [<c109db92>] ? mount_fs+0x55/0x123
[   10.507558]  [<c10af04e>] ? vfs_kern_mount+0x44/0xac
[   10.507558]  [<c10b0434>] ? do_mount+0x647/0x768
[   10.507558]  [<c107b0c7>] ? strndup_user+0x2c/0x3d
[   10.507558]  [<c10b05c6>] ? SyS_mount+0x71/0xa0
[   10.507558]  [<c164f19c>] ? syscall_call+0x7/0xb
[   10.507558] Code: 43 44 e8 5c 8c ff ff 58 5a 5b 5e 5f 5d c3 8b 43 10 8d 78 fc 8d 43 10 89 45 ec 8d 47 04 3b 45 ec 74 ca 89 f8 e8 44 f0 ff ff 89 c1 <8b> 50 04 83 7a 44 00 74 2c 8b 40 68 8d 71 68 39 f0 75 22 8b 72
[   10.507558] EIP: [<c1034419>] pool_mayday_timeout+0x5f/0x9c SS:ESP 0068:cf40bf80
[   10.507558] CR2: 0000000000000004
[   10.507558] ---[ end trace 838daf44c68f5508 ]---
[   10.507558] Kernel panic - not syncing: Fatal exception in interrupt
-------------- next part --------------
A non-text attachment was scrubbed...
Name: kvm-0day.sh
Type: application/x-sh
Size: 738 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20131010/efa9ea58/attachment-0001.sh 
