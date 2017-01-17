From: Ben Hutchings <ben@decadent.org.uk>
Date: Tue, 17 Jan 2017 02:12:34 +0000
Subject: [Ocfs2-devel] Bug#841144: kernel BUG at
 /build/linux-Wgpe2M/linux-4.8.11/fs/ocfs2/alloc.c:1514!
In-Reply-To: <1484593932.866510527@webmail.futurefoam.com>
References: <1484593932.866510527@webmail.futurefoam.com>
Message-ID: <1484619154.2998.39.camel@decadent.org.uk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, 2017-01-16 at 13:12 -0600, Russell Mosemann wrote:
[...]
> Jan 15 17:31:03 vhost032 kernel: ------------[ cut here ]------------
> Jan 15 17:31:03 vhost032 kernel: kernel BUG at /build/linux-Wgpe2M/linux-4.8.11/fs/ocfs2/alloc.c:1514!

This is:

static int ocfs2_grow_tree(handle_t *handle, struct ocfs2_extent_tree *et,
                           int *final_depth, struct buffer_head **last_eb_bh,
                           struct ocfs2_alloc_context *meta_ac)
{
...
        BUG_ON(meta_ac == NULL);

> Jan 15 17:31:03 vhost032 kernel: invalid opcode: 0000 [#1] SMP
> Jan 15 17:31:03 vhost032 kernel: Modules linked in: vhost_net(E) vhost(E) macvtap(E) macvlan(E) tun(E) ocfs2(E) quota_tree(E) hmac(E) veth(E) iptable_filter(E) ip_tables(E) x_tables(E) nfsd(E) auth_rpcgss(E) nfs_acl(E) nfs(E) lockd(E) grace(E) fscache(E) sunrpc(E) ocfs2_dlmfs(E) ocfs2_stack_o2cb(E) ocfs2_dlm(E) ocfs2_nodemanager(E) ocfs2_stackglue(E) configfs(E) bridge(E) stp(E) llc(E) bonding(E) intel_rapl(E) sb_edac(E) edac_core(E) x86_pkg_temp_thermal(E) coretemp(E) ast(E) kvm_intel(E) ttm(E) drm_kms_helper(E) mxm_wmi(E) iTCO_wdt(E) kvm(E) iTCO_vendor_support(E) igb(E) evdev(E) irqbypass(E) drm(E) xhci_pci(E) dca(E) ehci_pci(E) xhci_hcd(E) crct10dif_pclmul(E) ehci_hcd(E) crc32_pclmul(E) i2c_algo_bit(E) e1000e(E) usbcore(E) ptp(E) mei_me(E) lpc_ich(E) ghash_clmulni_intel(E) i2c_i801(E) pcspkr(E) usb_common(E) sg(E)
> Jan 15 17:31:03 vhost032 kernel:??mei(E) shpchp(E) i2c_smbus(E) pps_core(E) mfd_core(E) ipmi_si(E) wmi(E) fjes(E) ipmi_msghandler(E) tpm_tis(E) tpm_tis_core(E) tpm(E) acpi_power_meter(E) acpi_pad(E) button(E) fuse(E) drbd(E) lru_cache(E) libcrc32c(E) crc32c_generic(E) autofs4(E) ext4(E) crc16(E) jbd2(E) fscrypto(E) mbcache(E) dm_mod(E) md_mod(E) sd_mod(E) crc32c_intel(E) aesni_intel(E) aes_x86_64(E) glue_helper(E) lrw(E) gf128mul(E) ablk_helper(E) cryptd(E) ahci(E) libahci(E) libata(E) scsi_mod(E)
> Jan 15 17:31:03 vhost032 kernel: CPU: 5 PID: 28586 Comm: qemu-system-x86 Tainted: G????????????E???4.8.0-0.bpo.2-amd64 #1 Debian 4.8.11-1~bpo8+1
> Jan 15 17:31:03 vhost032 kernel: Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./EPC612D4I, BIOS P2.10 03/31/2016
> Jan 15 17:31:03 vhost032 kernel: task: ffff8e6e8584d000 task.stack: ffff8e6d80790000
> Jan 15 17:31:03 vhost032 kernel: RIP: 0010:[<ffffffffc08bd232>]??[<ffffffffc08bd232>] ocfs2_grow_tree+0x6f2/0x780 [ocfs2]
> Jan 15 17:31:03 vhost032 kernel: RSP: 0018:ffff8e6d80793618??EFLAGS: 00010246
> Jan 15 17:31:03 vhost032 kernel: RAX: 0000000000000000 RBX: 0000000000000004 RCX: ffff8e6d80793790
> Jan 15 17:31:03 vhost032 kernel: RDX: ffff8e6d807936bc RSI: ffff8e6d80793968 RDI: ffff8e6ea5012690
> Jan 15 17:31:03 vhost032 kernel: RBP: ffff8e6d80793678 R08: 0000000000000000 R09: 0000000000141d0b
> Jan 15 17:31:03 vhost032 kernel: R10: 0000000001586960 R11: ffff8e6e36ab30c0 R12: 0000000000000001
> Jan 15 17:31:03 vhost032 kernel: R13: ffff8e6d80793828 R14: ffff8e6e36ab30c0 R15: 0000000000000001
> Jan 15 17:31:03 vhost032 kernel: FS:??00007f578affd700(0000) GS:ffff8e7cbf340000(0000) knlGS:0000000000000000
> Jan 15 17:31:03 vhost032 kernel: CS:??0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Jan 15 17:31:03 vhost032 kernel: CR2: ffffb0015a300238 CR3: 00000001f5579000 CR4: 00000000001426e0
> Jan 15 17:31:03 vhost032 kernel: Stack:
> Jan 15 17:31:03 vhost032 kernel:??ffff8e6d80793728 ffff8e6d80793728 ffffffffc092aa75 ffff8e6cb1fc0c30
> Jan 15 17:31:03 vhost032 kernel:??ffff8e6e81ddb548 ffffffff9e63ba27 00000000ab4b7e2a 0000000000000004
> Jan 15 17:31:03 vhost032 kernel:??0000000000000001 ffff8e6d80793828 ffff8e6d80793968 ffff8e6e78de1700
> Jan 15 17:31:03 vhost032 kernel: Call Trace:
> Jan 15 17:31:03 vhost032 kernel:??[<ffffffffc092aa75>] ? ocfs2_set_buffer_uptodate+0x35/0x4a0 [ocfs2]
> Jan 15 17:31:03 vhost032 kernel:??[<ffffffff9e63ba27>] ? __find_get_block+0xa7/0x110
> Jan 15 17:31:03 vhost032 kernel:??[<ffffffffc08bf087>] ? ocfs2_split_and_insert+0x307/0x490 [ocfs2]
> Jan 15 17:31:03 vhost032 kernel:??[<ffffffffc08c55ce>] ? ocfs2_split_extent+0x3ee/0x560 [ocfs2]
> Jan 15 17:31:03 vhost032 kernel:??[<ffffffffc08c59b3>] ? ocfs2_change_extent_flag+0x273/0x450 [ocfs2]
> Jan 15 17:31:03 vhost032 kernel:??[<ffffffffc08c5ca0>] ? ocfs2_mark_extent_written+0x110/0x1d0 [ocfs2]
> Jan 15 17:31:03 vhost032 kernel:??[<ffffffffc08ca0ad>] ? ocfs2_dio_end_io_write+0x44d/0x600 [ocfs2]

meta_ac is passed down from ocfs2_dio_end_io_write(), which allocates
it using ocfs2_lock_allocators()... but the latter only allocates it
conditionally.  It seems like the condition is wrong somehow.

I didn't see any relevant changes post-4.8 (though I did see a number
of unrelated bug fixes that maybe ought to go to stable).

The rest of the traceback is below; the whole bug report can be found
at https://bugs.debian.org/841144

Ben.

> Jan 15 17:31:03 vhost032 kernel:??[<ffffffffc08f0af0>] ? ocfs2_allocate_extend_trans+0x180/0x180 [ocfs2]
> Jan 15 17:31:03 vhost032 kernel:??[<ffffffffc08ca29b>] ? ocfs2_dio_end_io+0x3b/0x60 [ocfs2]
> Jan 15 17:31:03 vhost032 kernel:??[<ffffffff9e641748>] ? dio_complete+0x68/0x160
> Jan 15 17:31:03 vhost032 kernel:??[<ffffffff9e644729>] ? do_blockdev_direct_IO+0x2079/0x23f0
> Jan 15 17:31:03 vhost032 kernel:??[<ffffffffc08cdeb0>] ? ocfs2_write_end_nolock+0x560/0x560 [ocfs2]
> Jan 15 17:31:03 vhost032 kernel:??[<ffffffffc08c97b3>] ? ocfs2_direct_IO+0x83/0x90 [ocfs2]
> Jan 15 17:31:03 vhost032 kernel:??[<ffffffff9e581873>] ? generic_file_direct_write+0xb3/0x180
> Jan 15 17:31:03 vhost032 kernel:??[<ffffffff9e5819f6>] ? __generic_file_write_iter+0xb6/0x1e0
> Jan 15 17:31:03 vhost032 kernel:??[<ffffffffc08e88fe>] ? ocfs2_file_write_iter+0x44e/0xae0 [ocfs2]
> Jan 15 17:31:03 vhost032 kernel:??[<ffffffff9e6041a0>] ? do_iter_readv_writev+0xb0/0x130
> Jan 15 17:31:03 vhost032 kernel:??[<ffffffff9e604e02>] ? do_readv_writev+0x1a2/0x240
> Jan 15 17:31:03 vhost032 kernel:??[<ffffffffc08e84b0>] ? ocfs2_check_range_for_refcount+0x130/0x130 [ocfs2]
> Jan 15 17:31:03 vhost032 kernel:??[<ffffffff9e9ef7d1>] ? schedule+0x31/0x80
> Jan 15 17:31:03 vhost032 kernel:??[<ffffffff9e60524c>] ? do_pwritev+0x8c/0xc0
> Jan 15 17:31:03 vhost032 kernel:??[<ffffffff9e9f3b76>] ? system_call_fast_compare_end+0xc/0x96
> Jan 15 17:31:03 vhost032 kernel: Code: 24 28 48 c7 c1 dc 02 95 c0 ba 1c 06 00 00 48 c7 c6 d0 29 94 c0 31 c0 44 89 4c 24 18 e8 d8 43 d7 ff 44 8b 4c 24 18 e9 26 fc ff ff <0f> 0b 48 8b 04 24 48 83 38 00 75 6c f0 ff 43 60 48 8b 04 24 45
> Jan 15 17:31:03 vhost032 kernel: RIP??[<ffffffffc08bd232>] ocfs2_grow_tree+0x6f2/0x780 [ocfs2]
> Jan 15 17:31:03 vhost032 kernel:??RSP <ffff8e6d80793618>
> Jan 15 17:31:03 vhost032 kernel: ---[ end trace e760335b067a4ecc ]---
[...]

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
??????????????????????????????????????????????????????????????- Albert
Camus
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 833 bytes
Desc: This is a digitally signed message part
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20170117/cab54697/attachment.bin 
