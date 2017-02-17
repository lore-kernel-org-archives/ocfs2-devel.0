From: Ben Hutchings <ben@decadent.org.uk>
Date: Fri, 17 Feb 2017 00:37:29 +0000
Subject: [Ocfs2-devel] Bug#855210: kernel BUG at
 /home/zumbi/linux-4.9.2/fs/ocfs2/dlm/dlmast.c:306!
In-Reply-To: <1487169046.88728606@webmail.futurefoam.com>
References: <1487169046.88728606@webmail.futurefoam.com>
Message-ID: <1487291849.22520.10.camel@decadent.org.uk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, 2017-02-15 at 08:30 -0600, Russell Mosemann wrote:
[...]
> The server had unexpectedly rebooted. Upon reboot, several DRBD
> drives were resynching when the bug was exposed. The system was
> forced to reboot, again.
> 
> Feb 15 07:53:47 vhost172 kernel: block drbd1: helper command: /sbin/drbdadm after-resync-target minor-1 exit code 0 (0x0)
> Feb 15 07:54:07 vhost172 kernel: (kworker/u24:3,221,11):dlm_proxy_ast_handler:306 ERROR: bug expression: !dlm_domain_fully_joined(dl
> m)
> Feb 15 07:54:07 vhost172 kernel: (kworker/u24:3,221,11):dlm_proxy_ast_handler:306 ERROR: Domain 930824A27206493B9F8823F4B9D780E9 not
> ?fully joined!
> Feb 15 07:54:07 vhost172 kernel: ------------[ cut here ]------------
> Feb 15 07:54:07 vhost172 kernel: kernel BUG at /home/zumbi/linux-4.9.2/fs/ocfs2/dlm/dlmast.c:306!
> Feb 15 07:54:08 vhost172 kernel: invalid opcode: 0000 [#1] SMP
> Feb 15 07:54:08 vhost172 kernel: Modules linked in: ocfs2 quota_tree hmac veth iptable_filter ip_tables x_tables nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue configfs bridge stp llc bonding intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm xhci_pci ast xhci_hcd irqbypass crct10dif_pclmul ttm crc32_pclmul ehci_pci ghash_clmulni_intel drm_kms_helper ehci_hcd iTCO_wdt iTCO_vendor_support intel_cstate mxm_wmi evdev igb drm e1000e mei_me intel_uncore dca usbcore lpc_ich pcspkr sg ptp mei i2c_algo_bit intel_rapl_perf mfd_core pps_core i2c_i801 usb_common shpchp i2c_smbus ipmi_si ipmi_msghandler wmi fjes tpm_tis tpm_tis_core tpm acpi_power_meter acpi_pad button fuse drbd lru_cache libcrc32c crc32c_generic
> Feb 15 07:54:08 vhost172 kernel:? autofs4 ext4 crc16 jbd2 fscrypto mbcache dm_mod md_mod sd_mod crc32c_intel ahci libahci aesni_intel libata aes_x86_64 glue_helper lrw gf128mul ablk_helper cryptd scsi_mod
> Feb 15 07:54:08 vhost172 kernel: CPU: 11 PID: 221 Comm: kworker/u24:3 Not tainted 4.9.0-0.bpo.1-amd64 #1 Debian 4.9.2-2~bpo8+1
> Feb 15 07:54:08 vhost172 kernel: Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./EPC612D4I, BIOS P2.10 03/31/2016
> Feb 15 07:54:08 vhost172 kernel: Workqueue: o2net o2net_rx_until_empty [ocfs2_nodemanager]
> Feb 15 07:54:08 vhost172 kernel: task: ffff971bf59f8000 task.stack: ffffa95886d6c000
> Feb 15 07:54:08 vhost172 kernel: RIP: 0010:[<ffffffffc0ba14a4>]? [<ffffffffc0ba14a4>] dlm_proxy_ast_handler+0x734/0x770 [ocfs2_dlm]
> Feb 15 07:54:08 vhost172 kernel: RSP: 0018:ffffa95886d6fcf8? EFLAGS: 00010246
> Feb 15 07:54:08 vhost172 kernel: RAX: 0000000000000000 RBX: ffff970ddfcc0000 RCX: 0000000000000000
> Feb 15 07:54:08 vhost172 kernel: RDX: 0000000000000000 RSI: ffff971bff4ce008 RDI: ffff971bff4ce008
> Feb 15 07:54:08 vhost172 kernel: RBP: ffff970ded7a4c00 R08: 0000000000000478 R09: 0000000000ffff0a
> Feb 15 07:54:08 vhost172 kernel: R10: ffffa95886d6fc88 R11: 0000000000000478 R12: ffff971bf5346200
> Feb 15 07:54:08 vhost172 kernel: R13: eeeeeeeeeeeeeeef R14: 00000000f6664f90 R15: ffff971bf4c55500
> Feb 15 07:54:08 vhost172 kernel: FS:? 0000000000000000(0000) GS:ffff971bff4c0000(0000) knlGS:0000000000000000
> Feb 15 07:54:08 vhost172 kernel: CS:? 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Feb 15 07:54:08 vhost172 kernel: CR2: 00007f0b781c1162 CR3: 0000000021007000 CR4: 00000000001406e0
> Feb 15 07:54:08 vhost172 kernel: Stack:
> Feb 15 07:54:08 vhost172 kernel:? 00000000ffff3261 ffff971bf5346200 eeeeeeeeeeeeeeef 00000000000001f0
> Feb 15 07:54:08 vhost172 kernel:? 0000000000000246 ffffffff8aae79cd ffff971bf53462c0 ffffffffc0a047c9
> Feb 15 07:54:08 vhost172 kernel:? 1000000000000040 00000000ce37533f ffff971bf5346218 ffff970ddfcc0000
> Feb 15 07:54:08 vhost172 kernel: Call Trace:
> Feb 15 07:54:08 vhost172 kernel:? [<ffffffff8aae79cd>] ? mod_timer+0x18d/0x300
> Feb 15 07:54:08 vhost172 kernel:? [<ffffffffc0a047c9>] ? o2net_handler_tree_lookup+0x49/0xd0 [ocfs2_nodemanager]
> Feb 15 07:54:08 vhost172 kernel:? [<ffffffffc0a07804>] ? o2net_rx_until_empty+0x8b4/0xcd0 [ocfs2_nodemanager]
> Feb 15 07:54:08 vhost172 kernel:? [<ffffffff8aa9172b>] ? process_one_work+0x14b/0x410
> Feb 15 07:54:08 vhost172 kernel:? [<ffffffff8aa921e5>] ? worker_thread+0x65/0x4a0
> Feb 15 07:54:08 vhost172 kernel:? [<ffffffff8aa92180>] ? rescuer_thread+0x340/0x340
> Feb 15 07:54:08 vhost172 kernel:? [<ffffffff8aa7c689>] ? do_group_exit+0x39/0xb0
> Feb 15 07:54:08 vhost172 kernel:? [<ffffffff8aa974e0>] ? kthread+0xe0/0x100
> Feb 15 07:54:08 vhost172 kernel:? [<ffffffff8aa2476b>] ? __switch_to+0x2bb/0x700
> Feb 15 07:54:08 vhost172 kernel:? [<ffffffff8aa97400>] ? kthread_park+0x60/0x60
> Feb 15 07:54:08 vhost172 kernel:? [<ffffffff8affa435>] ? ret_from_fork+0x25/0x30
> Feb 15 07:54:08 vhost172 kernel: Code: 00 00 00 00 00 00 10 48 8d 7c 24 40 48 89 44 24 40 48 c7 c1 0a 20 bb c0 ba 32 01 00 00 48 c7 c6 30 89 ba c0 31 c0 e8 9c 11 e6 ff <0f> 0b 4d 89 e9 48 b8 ff ff ff ff ff ff ff 00 48 c7 44 24 40 40
> Feb 15 07:54:08 vhost172 kernel: RIP? [<ffffffffc0ba14a4>] dlm_proxy_ast_handler+0x734/0x770 [ocfs2_dlm]
> Feb 15 07:54:08 vhost172 kernel:? RSP <ffffa95886d6fcf8>
> Feb 15 07:54:08 vhost172 kernel: ---[ end trace c2285c3c100bca16 ]---
[...]

I didn't spot any relevant changes in later versions or on the list. 
The whole bug report (with some more system information) can be found
at <https://bugs.debian.org/855210>.

Ben.

-- 
Ben Hutchings
Any sufficiently advanced bug is indistinguishable from a feature.
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 833 bytes
Desc: This is a digitally signed message part
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20170217/c00c72cf/attachment.bin 
