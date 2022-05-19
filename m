Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77780C433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu, 19 May 2022 02:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=//AGgTD/o/6ICWatO9TUOVo6sRBGJzRSLBI17Dzv4mk=;
 b=JBgBntBJgAqB9gyBWixnfIeYA8qmMO1k7EsVTEhe1ojOUueQylKL+rYT6I5RSfvqj+EdgaPvZI++
   jTQh2KNcPvGXmqSh6iqnFYovd/EOBY3a2sZ1UrTb4rF5IaQ9HqGWZIX8R3MnXowSxbZyWi66uKvd
   VOQrm9xzOKcJyD7zYJ5Js3S+Opy7coFRrPxZzdC16lG6JkLAbfLhGi6AqaJLAWE1oQeaTPTzTJN+
   lwXuLdBtignv4A41xE4ZNtq0QIOYKIqvIVMh24YIN4+NeoHg/N9ZIHuzoKmTELLQuwJRb0698ODQ
   jGXkhF7rLJS9c4J+T13rpk9X9W/E229qUOgflQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=//AGgTD/o/6ICWatO9TUOVo6sRBGJzRSLBI17Dzv4mk=;
 b=p6NXAXNL0Roi/GwsIj2QhHAov/57zx1dw9FiVFN5EGxNBwfNOHnMNpODUZg4TLZtV3QRApuHtyCq
   QKHy9E/olL54xZHxKrVqRq1TD+zGVe3/6FW/nVssbHswQl13hHf0umQdUnoZMcIvl9T1FxLiTa5p
   q6BExNc0AHYcuUMH9rfSKs6A1nJg35P3m9se/9uEycgO8OmDnT1vgyw5rXvSDi0kOTi34d7MOei3
   VdLYdAXub/R4EjuARpp/VYNaDBVVG2H4PeQXEc/uhSJO63Ugy52nCDsVquw7Vd2wM/ywLl6WlSBE
   AhQhvcFzdaY/9RMJLdr3N8/7bCIqNcZFxiTx2Q==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220413 64bit (built Apr 13
 2022))
 with ESMTPS id <0RC300M1WXK8TH00@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 19 May 2022 02:00:08 +0000 (GMT)
Message-id: <fdb51e1f-a002-bce6-00f6-7377989c96e4@linux.alibaba.com>
Date: Thu, 19 May 2022 09:59:54 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-language: en-US
To: Junxiao Bi <junxiao.bi@oracle.com>, ocfs2-devel@oss.oracle.com
References: <20220518235224.87100-1-junxiao.bi@oracle.com>
 <20220518235224.87100-2-junxiao.bi@oracle.com>
In-reply-to: <20220518235224.87100-2-junxiao.bi@oracle.com>
X-Source-IP: 115.124.30.131
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10351
 signatures=593597
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=175
 mlxlogscore=999 adultscore=0 spamscore=0 phishscore=0 priorityscore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205190013 domainage_hfrom=8435
Subject: Re: [Ocfs2-devel] [PATCH v2 2/2] ocfs2: dlmfs: fix error handling of
 user_dlm_destroy_lock
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R151e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0VDiIzQU_1652925594;
X-ServerName: out30-131.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: eXeTcxEMjVEEI5lY-YD46S11AT5UgtUW
X-Proofpoint-ORIG-GUID: eXeTcxEMjVEEI5lY-YD46S11AT5UgtUW
Reporting-Meta:
 AAG1UkSll2ZD1BrX4oTrZ3JxLMo2uBLSfDtyiuLMtPvMZk3ex+coxU+2QFJZwk4Q
 2aOw6otmDEajJiqLKcmeBUNXQMZ6ATycaniz5H7F7A3UO7Z2iI862tBWwc/Ziy0Y
 i0f1DVji6h2c2HsH6WA3voNesUAD2h5SKUr8YvmJ87i/o1GtrhGC04zBXoErYfxO
 eQ6U597lyl2DaVTqgPchJ9CWsepOHEESe1wmDkdwkygLnncLC6c4/mPSuWhJZJnz
 ufBNsPHGmZCZmtGaQRUVAt4IxnvMa/vt9v5P0As0FmZKf8+0ra1bJugzkc7TxY4G
 i1Po4HoKkxTY9Ytnm8HOH7pAWBew+Hqv41AONLVozr1ykDl1CCtWDHGNq9Qlx6vb
 kOhTCQ0J8UwvdVdSLaiq6vpN6E5zPln1MYvxDFvlxqzEnbr81EWkXY7xzkFjRUl1
 4yYBEoaDS/pQr4PpERT2AwTg2wAr6aQ2wW14vtkxt4QbxLE70IRo9r5bvfDRfAJ1
 HgSews8fL0NS+bCIqHUWl5HsXmIwlFRLPY50snmk+aMN



On 5/19/22 7:52 AM, Junxiao Bi wrote:
> When user_dlm_destroy_lock failed, it didn't clean up the flags it set
> before exit. For USER_LOCK_IN_TEARDOWN, if this function fails because
> of lock is still in used, next time when unlink invokes this function,
> it will return succeed, and then unlink will remove inode and dentry if
> lock is not in used(file closed), but the dlm lock is still linked in dlm
> lock resource, then when bast come in, it will trigger a panic due to
> user-after-free. See the following panic call trace.
> To fix this, USER_LOCK_IN_TEARDOWN should be reverted if fail. And also
> error should be returned if USER_LOCK_IN_TEARDOWN is set to let user know
> that unlink fail.
> 
> For the case of ocfs2_dlm_unlock failure, besides USER_LOCK_IN_TEARDOWN,
> USER_LOCK_BUSY is also required to be cleared.
> Even though spin lock is released in between, but USER_LOCK_IN_TEARDOWN
> is still set, for USER_LOCK_BUSY, if before every place that waits on
> this flag, USER_LOCK_IN_TEARDOWN is checked to bail out, that will make
> sure no flow waits on the busy flag set by user_dlm_destroy_lock(),
> then we can simplely revert USER_LOCK_BUSY when ocfs2_dlm_unlock fails.
> Fix user_dlm_cluster_lock() which is the only function not following this.
> 
> [  941.336392] (python,26174,16):dlmfs_unlink:562 ERROR: unlink
> 004fb0000060000b5a90b8c847b72e1, error -16 from destroy
> [  989.757536] ------------[ cut here ]------------
> [  989.757709] kernel BUG at fs/ocfs2/dlmfs/userdlm.c:173!
> [  989.757876] invalid opcode: 0000 [#1] SMP
> [  989.758027] Modules linked in: ksplice_2zhuk2jr_ib_ipoib_new(O)
> ksplice_2zhuk2jr(O) mptctl mptbase xen_netback xen_blkback xen_gntalloc
> xen_gntdev xen_evtchn cdc_ether usbnet mii ocfs2 jbd2 rpcsec_gss_krb5
> auth_rpcgss nfsv4 nfsv3 nfs_acl nfs fscache lockd grace ocfs2_dlmfs
> ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue configfs bnx2fc
> fcoe libfcoe libfc scsi_transport_fc sunrpc ipmi_devintf bridge stp llc
> rds_rdma rds bonding ib_sdp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad
> rdma_cm ib_cm iw_cm falcon_lsm_serviceable(PE) falcon_nf_netcontain(PE)
> mlx4_vnic falcon_kal(E) falcon_lsm_pinned_13402(E) mlx4_ib ib_sa ib_mad
> ib_core ib_addr xenfs xen_privcmd dm_multipath iTCO_wdt iTCO_vendor_support
> pcspkr sb_edac edac_core i2c_i801 lpc_ich mfd_core ipmi_ssif i2c_core ipmi_si
> ipmi_msghandler
> [  989.760686]  ioatdma sg ext3 jbd mbcache sd_mod ahci libahci ixgbe dca ptp
> pps_core vxlan udp_tunnel ip6_udp_tunnel megaraid_sas mlx4_core crc32c_intel
> be2iscsi bnx2i cnic uio cxgb4i cxgb4 cxgb3i libcxgbi ipv6 cxgb3 mdio
> libiscsi_tcp qla4xxx iscsi_boot_sysfs libiscsi scsi_transport_iscsi wmi
> dm_mirror dm_region_hash dm_log dm_mod [last unloaded:
> ksplice_2zhuk2jr_ib_ipoib_old]
> [  989.761987] CPU: 10 PID: 19102 Comm: dlm_thread Tainted: P           OE
> 4.1.12-124.57.1.el6uek.x86_64 #2
> [  989.762290] Hardware name: Oracle Corporation ORACLE SERVER
> X5-2/ASM,MOTHERBOARD,1U, BIOS 30350100 06/17/2021
> [  989.762599] task: ffff880178af6200 ti: ffff88017f7c8000 task.ti:
> ffff88017f7c8000
> [  989.762848] RIP: e030:[<ffffffffc07d4316>]  [<ffffffffc07d4316>]
> __user_dlm_queue_lockres.part.4+0x76/0x80 [ocfs2_dlmfs]
> [  989.763185] RSP: e02b:ffff88017f7cbcb8  EFLAGS: 00010246
> [  989.763353] RAX: 0000000000000000 RBX: ffff880174d48008 RCX:
> 0000000000000003
> [  989.763565] RDX: 0000000000120012 RSI: 0000000000000003 RDI:
> ffff880174d48170
> [  989.763778] RBP: ffff88017f7cbcc8 R08: ffff88021f4293b0 R09:
> 0000000000000000
> [  989.763991] R10: ffff880179c8c000 R11: 0000000000000003 R12:
> ffff880174d48008
> [  989.764204] R13: 0000000000000003 R14: ffff880179c8c000 R15:
> ffff88021db7a000
> [  989.764422] FS:  0000000000000000(0000) GS:ffff880247480000(0000)
> knlGS:ffff880247480000
> [  989.764685] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  989.764865] CR2: ffff8000007f6800 CR3: 0000000001ae0000 CR4:
> 0000000000042660
> [  989.765081] Stack:
> [  989.765167]  0000000000000003 ffff880174d48040 ffff88017f7cbd18
> ffffffffc07d455f
> [  989.765442]  ffff88017f7cbd88 ffffffff816fb639 ffff88017f7cbd38
> ffff8800361b5600
> [  989.765717]  ffff88021db7a000 ffff88021f429380 0000000000000003
> ffffffffc0453020
> [  989.765991] Call Trace:
> [  989.766093]  [<ffffffffc07d455f>] user_bast+0x5f/0xf0 [ocfs2_dlmfs]
> [  989.766287]  [<ffffffff816fb639>] ? schedule_timeout+0x169/0x2d0
> [  989.766475]  [<ffffffffc0453020>] ? o2dlm_lock_ast_wrapper+0x20/0x20
> [ocfs2_stack_o2cb]
> [  989.766738]  [<ffffffffc045303a>] o2dlm_blocking_ast_wrapper+0x1a/0x20
> [ocfs2_stack_o2cb]
> [  989.767010]  [<ffffffffc0864ec6>] dlm_do_local_bast+0x46/0xe0 [ocfs2_dlm]
> [  989.767217]  [<ffffffffc084f5cc>] ? dlm_lockres_calc_usage+0x4c/0x60
> [ocfs2_dlm]
> [  989.767466]  [<ffffffffc08501f1>] dlm_thread+0xa31/0x1140 [ocfs2_dlm]
> [  989.767662]  [<ffffffff816f78da>] ? __schedule+0x24a/0x810
> [  989.767834]  [<ffffffff816f78ce>] ? __schedule+0x23e/0x810
> [  989.768006]  [<ffffffff816f78da>] ? __schedule+0x24a/0x810
> [  989.768178]  [<ffffffff816f78ce>] ? __schedule+0x23e/0x810
> [  989.768349]  [<ffffffff816f78da>] ? __schedule+0x24a/0x810
> [  989.768521]  [<ffffffff816f78ce>] ? __schedule+0x23e/0x810
> [  989.768693]  [<ffffffff816f78da>] ? __schedule+0x24a/0x810
> [  989.768893]  [<ffffffff816f78ce>] ? __schedule+0x23e/0x810
> [  989.769067]  [<ffffffff816f78da>] ? __schedule+0x24a/0x810
> [  989.769241]  [<ffffffff810ce4d0>] ? wait_woken+0x90/0x90
> [  989.769411]  [<ffffffffc084f7c0>] ? dlm_kick_thread+0x80/0x80 [ocfs2_dlm]
> [  989.769617]  [<ffffffff810a8bbb>] kthread+0xcb/0xf0
> [  989.769774]  [<ffffffff816f78da>] ? __schedule+0x24a/0x810
> [  989.769945]  [<ffffffff816f78da>] ? __schedule+0x24a/0x810
> [  989.770117]  [<ffffffff810a8af0>] ? kthread_create_on_node+0x180/0x180
> [  989.770321]  [<ffffffff816fdaa1>] ret_from_fork+0x61/0x90
> [  989.770492]  [<ffffffff810a8af0>] ? kthread_create_on_node+0x180/0x180
> [  989.770689] Code: d0 00 00 00 f0 45 7d c0 bf 00 20 00 00 48 89 83 c0 00 00
> 00 48 89 83 c8 00 00 00 e8 55 c1 8c c0 83 4b 04 10 48 83 c4 08 5b 5d c3 <0f>
> 0b 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 55 41 54 53 48 83
> [  989.771892] RIP  [<ffffffffc07d4316>]
> __user_dlm_queue_lockres.part.4+0x76/0x80 [ocfs2_dlmfs]
> [  989.772174]  RSP <ffff88017f7cbcb8>
> [  989.772704] ---[ end trace ebd1e38cebcc93a8 ]---
> [  989.772907] Kernel panic - not syncing: Fatal exception
> [  989.773173] Kernel Offset: disabled
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/dlmfs/userdlm.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/dlmfs/userdlm.c b/fs/ocfs2/dlmfs/userdlm.c
> index af0be612589c..617c92e7b925 100644
> --- a/fs/ocfs2/dlmfs/userdlm.c
> +++ b/fs/ocfs2/dlmfs/userdlm.c
> @@ -433,6 +433,11 @@ int user_dlm_cluster_lock(struct user_lock_res *lockres,
>  	}
>  
>  	spin_lock(&lockres->l_lock);
> +	if (lockres->l_flags & USER_LOCK_IN_TEARDOWN) {
> +		spin_unlock(&lockres->l_lock);
> +		status = -EAGAIN;
> +		goto bail;
> +	}
>  
>  	/* We only compare against the currently granted level
>  	 * here. If the lock is blocked waiting on a downconvert,
> @@ -595,7 +600,7 @@ int user_dlm_destroy_lock(struct user_lock_res *lockres)
>  	spin_lock(&lockres->l_lock);
>  	if (lockres->l_flags & USER_LOCK_IN_TEARDOWN) {
>  		spin_unlock(&lockres->l_lock);
> -		return 0;
> +		goto bail;
>  	}
>  
>  	lockres->l_flags |= USER_LOCK_IN_TEARDOWN;
> @@ -609,12 +614,17 @@ int user_dlm_destroy_lock(struct user_lock_res *lockres)
>  	}
>  
>  	if (lockres->l_ro_holders || lockres->l_ex_holders) {
> +		lockres->l_flags &= ~USER_LOCK_IN_TEARDOWN;
>  		spin_unlock(&lockres->l_lock);
>  		goto bail;
>  	}
>  
>  	status = 0;
>  	if (!(lockres->l_flags & USER_LOCK_ATTACHED)) {
> +		/*
> +		 * lock is never requested, leave USER_LOCK_IN_TEARDOWN set
> +		 * to avoid new lock request coming in.
> +		 */
>  		spin_unlock(&lockres->l_lock);
>  		goto bail;
>  	}
> @@ -624,6 +634,10 @@ int user_dlm_destroy_lock(struct user_lock_res *lockres)
>  
>  	status = ocfs2_dlm_unlock(conn, &lockres->l_lksb, DLM_LKF_VALBLK);
>  	if (status) {
> +		spin_lock(&lockres->l_lock);
> +		lockres->l_flags &= ~USER_LOCK_IN_TEARDOWN;
> +		lockres->l_flags &= ~USER_LOCK_BUSY;
> +		spin_unlock(&lockres->l_lock);
>  		user_log_dlm_error("ocfs2_dlm_unlock", status, lockres);
>  		goto bail;
>  	}

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
