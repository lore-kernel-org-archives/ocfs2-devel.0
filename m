From: Daniel Sobe <daniel.sobe@nxp.com>
Date: Tue, 7 May 2019 14:14:51 +0000
Subject: [Ocfs2-devel] [EXT] Re: [PATCH] fs/ocfs2: fix race
	in	ocfs2_dentry_attach_lock
In-Reply-To: <VI1PR04MB561473F3E4D67530CAE0AE26ED310@VI1PR04MB5614.eurprd04.prod.outlook.com>
References: <20190503170102.14775-1-wen.gang.wang@oracle.com>
	<42f392d4-4678-ec0f-751f-02a91d5746a4@oracle.com>
	<VI1PR04MB561473F3E4D67530CAE0AE26ED310@VI1PR04MB5614.eurprd04.prod.outlook.com>
Message-ID: <VI1PR04MB5614F311FA7242305DFCF36CED310@VI1PR04MB5614.eurprd04.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

About 30 minutes later this happened, I don't know whether it is related. Could it be related to not running the latest of the 4.19.X kernel?

May  7 15:51:07 drs1p001 kernel: [99859.583930] list_del corruption. prev->next should be ffff94bb01bda710, but was ffff94bacceda7c0
May  7 15:51:07 drs1p001 kernel: [99859.583951] ------------[ cut here ]------------
May  7 15:51:07 drs1p001 kernel: [99859.583951] kernel BUG at /kernelbuild/linux-4.19.28/lib/list_debug.c:53!
May  7 15:51:07 drs1p001 kernel: [99859.583960] invalid opcode: 0000 [#1] SMP PTI
May  7 15:51:07 drs1p001 kernel: [99859.583964] CPU: 1 PID: 38 Comm: khugepaged Tainted: G            E     4.19.0-0.bpo.4-amd64 #1 Debian 4.19.28-2~bpo9+1
May  7 15:51:07 drs1p001 kernel: [99859.583966] Hardware name: Dell Inc. OptiPlex 5040/0R790T, BIOS 1.2.7 01/15/2016
May  7 15:51:07 drs1p001 kernel: [99859.583974] RIP: 0010:__list_del_entry_valid+0x70/0x90
May  7 15:51:07 drs1p001 kernel: [99859.583976] Code: 7d e8 94 e8 90 c6 d0 ff 0f 0b 48 89 fe 48 c7 c7 30 7e e8 94 e8 7f c6 d0 ff 0f 0b 48 89 fe 48 c7 c7 68 7e e8 94 e8 6e c6 d0 ff <0f> 0b 48 89 fe 48 c7 c7 a8 7e e8 94 e8 5d c6 d0 ff 0f 0b 90 90 90
May  7 15:51:07 drs1p001 kernel: [99859.583980] RSP: 0018:ffffb96d00de7848 EFLAGS: 00010286
May  7 15:51:07 drs1p001 kernel: [99859.583982] RAX: 0000000000000054 RBX: ffff94bb01bda618 RCX: 0000000000000000
May  7 15:51:07 drs1p001 kernel: [99859.583984] RDX: 0000000000000000 RSI: ffff94bbd1a966a8 RDI: ffff94bbd1a966a8
May  7 15:51:07 drs1p001 kernel: [99859.583986] RBP: ffff94bb01bda710 R08: 0000000000000000 R09: 0000000000000471
May  7 15:51:07 drs1p001 kernel: [99859.583988] R10: ffffb96d00de7838 R11: ffffffff955ea6ed R12: ffff94bb01bda618
May  7 15:51:07 drs1p001 kernel: [99859.583990] R13: ffff94bb3e8327d8 R14: 0000000000000000 R15: ffff94bb730056c0
May  7 15:51:07 drs1p001 kernel: [99859.583992] FS:  0000000000000000(0000) GS:ffff94bbd1a80000(0000) knlGS:0000000000000000
May  7 15:51:07 drs1p001 kernel: [99859.583995] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
May  7 15:51:07 drs1p001 kernel: [99859.583997] CR2: 00007f5acb700e00 CR3: 0000000016c0a002 CR4: 00000000003606e0
May  7 15:51:07 drs1p001 kernel: [99859.583999] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
May  7 15:51:07 drs1p001 kernel: [99859.584001] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
May  7 15:51:07 drs1p001 kernel: [99859.584003] Call Trace:
May  7 15:51:07 drs1p001 kernel: [99859.584065]  ocfs2_remove_lockres_tracking+0x31/0x70 [ocfs2]
May  7 15:51:07 drs1p001 kernel: [99859.584081]  ocfs2_lock_res_free+0x44/0x260 [ocfs2]
May  7 15:51:07 drs1p001 kernel: [99859.584093]  ocfs2_dentry_lock_put+0x5f/0x70 [ocfs2]
May  7 15:51:07 drs1p001 kernel: [99859.584106]  ocfs2_dentry_iput+0x49/0x110 [ocfs2]
May  7 15:51:07 drs1p001 kernel: [99859.584110]  __dentry_kill+0xd3/0x180
May  7 15:51:07 drs1p001 kernel: [99859.584113]  dentry_kill+0x4d/0x1b0
May  7 15:51:07 drs1p001 kernel: [99859.584115]  shrink_dentry_list+0xc3/0x1d0
May  7 15:51:07 drs1p001 kernel: [99859.584117]  prune_dcache_sb+0x52/0x70
May  7 15:51:07 drs1p001 kernel: [99859.584121]  super_cache_scan+0x10c/0x190
May  7 15:51:07 drs1p001 kernel: [99859.584124]  do_shrink_slab+0x12a/0x2b0
May  7 15:51:07 drs1p001 kernel: [99859.584127]  shrink_slab+0x214/0x2b0
May  7 15:51:07 drs1p001 kernel: [99859.584130]  shrink_node+0xf0/0x470
May  7 15:51:07 drs1p001 kernel: [99859.584133]  do_try_to_free_pages+0xeb/0x370
May  7 15:51:07 drs1p001 kernel: [99859.584135]  try_to_free_pages+0xf4/0x1b0
May  7 15:51:07 drs1p001 kernel: [99859.584139]  __alloc_pages_slowpath+0x2ee/0xdb0
May  7 15:51:07 drs1p001 kernel: [99859.584144]  ? __switch_to_asm+0x40/0x70
May  7 15:51:07 drs1p001 kernel: [99859.584147]  __alloc_pages_nodemask+0x258/0x2a0
May  7 15:51:07 drs1p001 kernel: [99859.584150]  khugepaged+0xc9b/0x21d0
May  7 15:51:07 drs1p001 kernel: [99859.584156]  ? remove_wait_queue+0x60/0x60
May  7 15:51:07 drs1p001 kernel: [99859.584159]  kthread+0xf8/0x130
May  7 15:51:07 drs1p001 kernel: [99859.584162]  ? collapse_shmem+0xc50/0xc50
May  7 15:51:07 drs1p001 kernel: [99859.584164]  ? kthread_create_worker_on_cpu+0x70/0x70
May  7 15:51:07 drs1p001 kernel: [99859.584166]  ret_from_fork+0x35/0x40
May  7 15:51:07 drs1p001 kernel: [99859.584169] Modules linked in: tcp_diag(E) inet_diag(E) unix_diag(E) veth(E) ocfs2(E) quota_tree(E) ocfs2_dlmfs(E) ocfs2_stack_o2cb(E) ocfs2_dlm(E) ocfs2_nodemanager(E) ocfs2_stackglue(E) configfs(E) bridge(E) stp(E) llc(E) iptable_filter(E) overlay(E) snd_hda_codec_hdmi(E) rfkill(E) snd_hda_codec_realtek(E) snd_hda_codec_generic(E) fuse(E) intel_rapl(E) x86_pkg_temp_thermal(E) intel_powerclamp(E) coretemp(E) dell_wmi(E) mei_wdt(E) wmi_bmof(E) dell_smbios(E) sparse_keymap(E) i915(E) kvm_intel(E) dell_wmi_descriptor(E) snd_hda_intel(E) evdev(E) kvm(E) irqbypass(E) drm_kms_helper(E) crct10dif_pclmul(E) snd_hda_codec(E) crc32_pclmul(E) snd_hda_core(E) dcdbas(E) snd_hwdep(E) ghash_clmulni_intel(E) drm(E) intel_cstate(E) i2c_algo_bit(E) snd_pcm(E) intel_pch_thermal(E) intel_uncore(E) mei_me(E) pcspkr(E)
May  7 15:51:07 drs1p001 kernel: [99859.584208]  intel_rapl_perf(E) mei(E) snd_timer(E) iTCO_wdt(E) iTCO_vendor_support(E) snd(E) soundcore(E) sg(E) serio_raw(E) wmi(E) video(E) pcc_cpufreq(E) button(E) acpi_pad(E) drbd(E) lru_cache(E) libcrc32c(E) ip_tables(E) x_tables(E) autofs4(E) ext4(E) crc16(E) mbcache(E) jbd2(E) crc32c_generic(E) fscrypto(E) ecb(E) dm_mod(E) sr_mod(E) cdrom(E) sd_mod(E) crc32c_intel(E) aesni_intel(E) aes_x86_64(E) crypto_simd(E) cryptd(E) glue_helper(E) psmouse(E) xhci_pci(E) e1000(E) ahci(E) libahci(E) xhci_hcd(E) e1000e(E) libata(E) i2c_i801(E) usbcore(E) scsi_mod(E) usb_common(E) fan(E) thermal(E)
May  7 15:51:07 drs1p001 kernel: [99859.584243] ---[ end trace 2baf8e44ef57535a ]---



-----Original Message-----
From: ocfs2-devel-bounces@oss.oracle.com <ocfs2-devel-bounces@oss.oracle.com> On Behalf Of Daniel Sobe
Sent: Dienstag, 7. Mai 2019 15:53
To: Wengang Wang <wen.gang.wang@oracle.com>; 'ocfs2-devel at oss.oracle.com' <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [EXT] Re: [PATCH] fs/ocfs2: fix race in ocfs2_dentry_attach_lock

Caution: EXT Email

Hi Wengang,

I have applied your patch to the latest debian kernel in "stretch-backports", and been using it for 1..2 days. Today is the first time that I saw the pr_err() message:

May 07 15:23:19 drs1p001 kernel: race found in ocfs2_dentry_attach_lock dentry=0000000016c2f15c

I don't know whether it helps, but I thought I'll report it anyway. I don't remember any special activity at that time, just the same stuff I was doing all day.

Regards,

Daniel

-----Original Message-----
From: Wengang Wang <wen.gang.wang@oracle.com>
Sent: Freitag, 3. Mai 2019 19:03
To: 'ocfs2-devel at oss.oracle.com' <ocfs2-devel@oss.oracle.com>
Cc: Daniel Sobe <daniel.sobe@nxp.com>
Subject: [EXT] Re: [PATCH] fs/ocfs2: fix race in ocfs2_dentry_attach_lock

Caution: EXT Email

Daneil,

You could try this patch.
I didn't confirm yet if the patch helped or the problem didn't happen again where it happened (though I am sure the racing is there).

Anyone who is interested could take a pre-review on this patch.

Thanks,
Wengang

On 2019/5/3 10:01, Wengang Wang wrote:
> ocfs2_dentry_attach_lock() can be executed in parallel threads against 
> the same dentry. Make that race safe.
>
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>   fs/ocfs2/dcache.c | 27 +++++++++++++++++++++------
>   1 file changed, 21 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c index 
> 290373024d9d..980e571c163c 100644
> --- a/fs/ocfs2/dcache.c
> +++ b/fs/ocfs2/dcache.c
> @@ -227,12 +227,13 @@ int ocfs2_dentry_attach_lock(struct dentry *dentry,
>                            struct inode *inode,
>                            u64 parent_blkno)
>   {
> -     int ret;
> +     int ret, new_dl = 0;
>       struct dentry *alias;
> -     struct ocfs2_dentry_lock *dl = dentry->d_fsdata;
> +     struct ocfs2_dentry_lock *dl, *dl_free_on_race = NULL;
>
>       trace_ocfs2_dentry_attach_lock(dentry->d_name.len, dentry->d_name.name,
> -                                    (unsigned long long)parent_blkno, dl);
> +                                    (unsigned long long)parent_blkno,
> +                                    dentry->d_fsdata);
>
>       /*
>        * Negative dentry. We ignore these for now.
> @@ -243,11 +244,15 @@ int ocfs2_dentry_attach_lock(struct dentry *dentry,
>       if (!inode)
>               return 0;
>
> +     spin_lock(&dentry_attach_lock);
>       if (d_really_is_negative(dentry) && dentry->d_fsdata) {
>               /* Converting a negative dentry to positive
>                  Clear dentry->d_fsdata */
>               dentry->d_fsdata = dl = NULL;
> +     } else {
> +             dl = dentry->d_fsdata;
>       }
> +     spin_unlock(&dentry_attach_lock);
>
>       if (dl) {
>               mlog_bug_on_msg(dl->dl_parent_blkno != parent_blkno, @@
> -310,10 +315,20 @@ int ocfs2_dentry_attach_lock(struct dentry *dentry,
>
>   out_attach:
>       spin_lock(&dentry_attach_lock);
> -     dentry->d_fsdata = dl;
> -     dl->dl_count++;
> +     /* d_fsdata could be set by parallel thread */
> +     if (unlikely(dentry->d_fsdata)) {
> +             pr_err("race found in ocfs2_dentry_attach_lock dentry=%p\n", dentry);
> +             if (!alias)
> +                     dl_free_on_race = dl;
> +     } else {
> +             dentry->d_fsdata = dl;
> +             dl->dl_count++;
> +             if (!alias)
> +                     new_dl = 1;
> +     }
>       spin_unlock(&dentry_attach_lock);
>
> +     kfree(dl_free_on_race);
>       /*
>        * This actually gets us our PRMODE level lock. From now on,
>        * we'll have a notification if one of these names is @@ -330,7
> +345,7 @@ int ocfs2_dentry_attach_lock(struct dentry *dentry,
>        * We need to do this because error here means no d_instantiate(),
>        * which means iput() will not be called during dput(dentry).
>        */
> -     if (ret < 0 && !alias) {
> +     if (ret < 0 && new_dl) {
>               ocfs2_lock_res_free(&dl->dl_lockres);
>               BUG_ON(dl->dl_count != 1);
>               spin_lock(&dentry_attach_lock);
_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel at oss.oracle.com
https://urldefense.proofpoint.com/v2/url?u=https-3A__eur01.safelinks.protection.outlook.com_-3Furl-3Dhttps-253A-252F-252Foss.oracle.com-252Fmailman-252Flistinfo-252Focfs2-2Ddevel-26amp-3Bdata-3D02-257C01-257Cdaniel.sobe-2540nxp.com-257C22fe6bc868d34e30007d08d6d2f379a4-257C686ea1d3bc2b4c6fa92cd99c5c301635-257C0-257C0-257C636928340492660012-26amp-3Bsdata-3D1Qv9uYedq9E3CHsMIQrXKkpwsBwIm3T7drSXo7fhDVc-253D-26amp-3Breserved-3D0&d=DwIFAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=Rd9IyfD0a2EjTV-QrkRzjIic3B0-PdQh9axJJcf8RiQ&s=LLj-qXFaW7x6U_KIEV7vBL0QKZIrNC9x22-Svy_mS9k&e=
