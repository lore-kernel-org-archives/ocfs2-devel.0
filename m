Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 627DCC43334
	for <ocfs2-devel@archiver.kernel.org>; Sun, 12 Jun 2022 14:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PxPOcZewvgFuSQO3wPq9qIn/DpPslLsdeUGR5AEhS3E=;
 b=wnUrb9UTvrU5qA67HArseCs1Sptk5MIZWnRfHwURW16qo8tr64QkD4vvllqAKcanK62uS8i0q1jB
   OdwnkZaZx2Ag8oISLH6UE3fVpVibW+stGwmz0ZdtlqP4iP0AF39qIohsrq+KPUALJcouakPUohsj
   KrpvXfWm+dFavQ+4z4HRhrQN5+6z/ecV0UuULSt02oUV+jk35zEAgN/PfNHtwqCz+S0ZCm6fCWAE
   3Wh6heaNIHauXcplVkE96IsclUC1iLUaeEZe5HiO4+XVX5r20uunIUFSaOmVfKBsodc3dDRq9AfH
   QU/EzrnuWeJNg2b0LbF6VqX1jawVkBKFdewLUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PxPOcZewvgFuSQO3wPq9qIn/DpPslLsdeUGR5AEhS3E=;
 b=JYlgx6qnbTtXAheSt/mg9ltEp9OHGgyifspYQrV8GpjMA3ZmTCObxEIePMecYSZpkKtj/aVXNbsG
   llu7FIUTYen63zSPfyOUJ5KKThpjrxViO0DAlsABSVGU04gf6CJRqGClNJshXQj9RbWdskDXwJtn
   PHG5cck2mwmQNJXGR2XVZgkW16DNQSUtupEKBWDIs7j82egbY9RBwjjX4wVKg/hyl2xV62Zl1+Zi
   701o093bzEOrYJWLK8BouyDF2uhrtAj8vFkJJ99RK9S6sIgg9MfUgg1SJu4RhW/a+nmnpS1EJ1RB
   HzFMRMjAoIn76W1jLtK7Ptnm13YnYsmCZ3yVSQ==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220531 64bit (built May 31
 2022))
 with ESMTPS id <0RDD00EQHBNAJ040@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 12 Jun 2022 14:16:22 +0000 (GMT)
Message-id: <09b33ef3-b93a-5b50-d87d-8667ed993e5d@linux.alibaba.com>
Date: Sun, 12 Jun 2022 22:16:02 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20220608104808.18130-1-heming.zhao@suse.com>
 <20220608104808.18130-2-heming.zhao@suse.com>
In-reply-to: <20220608104808.18130-2-heming.zhao@suse.com>
X-Source-IP: 115.124.30.56
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10376
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 malwarescore=0 phishscore=0 priorityscore=0 clxscore=86 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206120068 domainage_hfrom=8459
Subject: Re: [Ocfs2-devel] [PATCH 1/1] ocfs2: fix ocfs2_find_slot repeats alloc
 same slot issue
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R181e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04400;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0VG6C4mT_1655043362;
X-ServerName: out30-56.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: tl9DgDoGCP8-euuhrEud6v9p8p769c9X
X-Proofpoint-GUID: tl9DgDoGCP8-euuhrEud6v9p8p769c9X
Reporting-Meta:
 AAE477RIuiM0ZsBPta0OSEaeilzVW1lg3IXeAN7I8Olmj/wrUEcf4OUgvbo6tFkR
 tW0P3HuWunzTuVxgaLv/uSBZHEeGkhyhRBWjRuMfq6n1Y+uetrUeIE+JRcROxGCv
 f65pgrsvvdGxcAoed9MQB3Ua8ogfPgsXnN0CZKSIOxnYa7TWLRp5DUjVYCfZodMk
 ZQBF6ZvpAdaZLcNUyMp9tX5mdZ/e4ZvIS1ZKHfTErh9T7yg6FRtXC1f+37iqLGp3
 7IUnv59VrGETT8NjXQ7eCuR9WoE6FhPbAxdmTcuauGbqe76/7ZaWHCXIJgN8VGQM
 1zq01OBFrfBslCQzHUVQZjmnV3RcBib5jBWsdHqMGF/Knu+sPXgkcoECDW91+obC
 7L+04o/suATIU1lr5dLov5odRgLdU3anL/bf5CHwUOgLLeMlz+0kDyFeiLG+T6Ff
 hBp7W3PtSyJ6sgzzte0qaqgWt8VhqHBFXSd3AC3fzLkrgCGi98P6C/xqEFFgu4uK
 1dTPk6CMcJLRr6Kpqr1fVBEoQ7AxqcENuHgnV0ewDFs=

Hi,

Why can't use local mount? I don't remember if we discuss about this.

Thanks,
Joseph

On 6/8/22 6:48 PM, Heming Zhao wrote:
> Below commit log copied from Junxiao's patch:
> https://oss.oracle.com/pipermail/ocfs2-devel/2022-June/000107.html
> 
> Junxiao planed to revert commit 912f655d78c5("ocfs2: mount shared volume
> without ha stack"), but maintainer & I preferred to keep and fix this bug.
> 
> -------------------------- snip  --------------------------
> This commit introduced a regression that can cause mount hung.
> The changes in __ocfs2_find_empty_slot causes that any node with
> none-zero node number can grab the slot that was already taken by
> node 0, so node 1 will access the same journal with node 0, when it
> try to grab journal cluster lock, it will hung because it was already
> acquired by node 0.
> It's very easy to reproduce this, in one cluster, mount node 0 first,
> then node 1, you will see the following call trace from node 1.
> 
> [13148.735424] INFO: task mount.ocfs2:53045 blocked for more than 122 seconds.
> [13148.739691]       Not tainted 5.15.0-2148.0.4.el8uek.mountracev2.x86_64 #2
> [13148.742560] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [13148.745846] task:mount.ocfs2     state:D stack:    0 pid:53045 ppid: 53044 flags:0x00004000
> [13148.749354] Call Trace:
> [13148.750718]  <TASK>
> [13148.752019]  ? usleep_range+0x90/0x89
> [13148.753882]  __schedule+0x210/0x567
> [13148.755684]  schedule+0x44/0xa8
> [13148.757270]  schedule_timeout+0x106/0x13c
> [13148.759273]  ? __prepare_to_swait+0x53/0x78
> [13148.761218]  __wait_for_common+0xae/0x163
> [13148.763144]  __ocfs2_cluster_lock.constprop.0+0x1d6/0x870 [ocfs2]
> [13148.765780]  ? ocfs2_inode_lock_full_nested+0x18d/0x398 [ocfs2]
> [13148.768312]  ocfs2_inode_lock_full_nested+0x18d/0x398 [ocfs2]
> [13148.770968]  ocfs2_journal_init+0x91/0x340 [ocfs2]
> [13148.773202]  ocfs2_check_volume+0x39/0x461 [ocfs2]
> [13148.775401]  ? iput+0x69/0xba
> [13148.777047]  ocfs2_mount_volume.isra.0.cold+0x40/0x1f5 [ocfs2]
> [13148.779646]  ocfs2_fill_super+0x54b/0x853 [ocfs2]
> [13148.781756]  mount_bdev+0x190/0x1b7
> [13148.783443]  ? ocfs2_remount+0x440/0x440 [ocfs2]
> [13148.785634]  legacy_get_tree+0x27/0x48
> [13148.787466]  vfs_get_tree+0x25/0xd0
> [13148.789270]  do_new_mount+0x18c/0x2d9
> [13148.791046]  __x64_sys_mount+0x10e/0x142
> [13148.792911]  do_syscall_64+0x3b/0x89
> [13148.794667]  entry_SYSCALL_64_after_hwframe+0x170/0x0
> [13148.797051] RIP: 0033:0x7f2309f6e26e
> [13148.798784] RSP: 002b:00007ffdcee7d408 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> [13148.801974] RAX: ffffffffffffffda RBX: 00007ffdcee7d4a0 RCX: 00007f2309f6e26e
> [13148.804815] RDX: 0000559aa762a8ae RSI: 0000559aa939d340 RDI: 0000559aa93a22b0
> [13148.807719] RBP: 00007ffdcee7d5b0 R08: 0000559aa93a2290 R09: 00007f230a0b4820
> [13148.810659] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffdcee7d420
> [13148.813609] R13: 0000000000000000 R14: 0000559aa939f000 R15: 0000000000000000
> [13148.816564]  </TASK>
> 
> To fix it, we can just fix __ocfs2_find_empty_slot. But original commit
> introduced the feature to mount ocfs2 locally even it is cluster based,
> that is a very dangerous, it can easily cause serious data corruption,
> there is no way to stop other nodes mounting the fs and corrupting it.
> Setup ha or other cluster-aware stack is just the cost that we have to
> take for avoiding corruption, otherwise we have to do it in kernel.
> -------------------------- snip  --------------------------
> 
> ** analysis **
> 
> Under Junxiao's call trace, in __ocfs2_find_empty_slot(), the 'if'
> accessment is wrong. sl_node_num could be 0 at o2cb env.
> 
> with current information, the trigger flow (may):
> 1>
> node1 with 'node_num = 0' for mounting. it will succeed.
> at this time, slotmap extent block will contains es_valid:1 &
> es_node_num:0 for node1
> then ocfs2_update_disk_slot() will write back slotmap info to disk.
> 
> 2>
> then, node2 with 'node_num = 1' for mounting
> 
> ocfs2_find_slot
>  + ocfs2_update_slot_info //read slotmap info from disk
>  |  + set si->si_slots[0].es_valid = 1 & si->si_slots[0].sl_node_num = 0
>  |
>  + __ocfs2_node_num_to_slot //will return -ENOENT.
>     __ocfs2_find_empty_slot
>      + search preferred (node_num:1) failed
>      + 'si->si_slots[0].sl_node_num' is false. trigger 'break' condition.
>      + return slot 0 will cause node2 grab node1 journal dlm lock, then trigger hung.
> 
> ** how to fix **
> 
> For simplifing code logic design, We make a rule:
> If last mount didn't do umount, (eg: crash happened), the next mount MUST
> be same mount type.
> 
> All possible cases, when enter ocfs2_find_slot():
> 
> 1. all slots are empty, [cluster|nocluster] mode mount will succeed.
>    this is clean ocfs2 volume case.
> 
> 2. for nocluster mount action
>    - slot 0 is empty, but another slot is not empty:
>      - mount failure. (there should be in clustered env, deny mixed mount case)
>    - slot 0 is not empty, all other slots are empty:
>      - slot 0 is nocluster type: mount success  (may crash last time)
>      - slot 0 is cluster type: mount failure (deny mixed mount case)
> 
> 3. for cluster mount action
>    - slot 0 is empty, but another slot is not empty:
>      - mount success
>    - slot 0 is not empty, all other slots are empty:
>      - slot 0 is nocluster type: mount failure (deny mixed mount case)
>      - slot 0 is cluster type: mount success (may crash last time)
> 
> above with simplified form:
> 1.
> clean parition => nocluster/cluster@any_node    - success
> 
> 2.
> cluster@any_node => nocluster@any_node          - failure
> nocluster@node1 => crash => nocluster@node1     - success
> nocluster@node2 => nocluster@node1              - success [*]
> cluster@any_node => crash => nocluster@any_node - failure
> 
> 3.
> cluster@any_node => cluster@any_node            - success
> cluster@any_node => crash => cluster@any_node   - success
> nocluster@any_node => crash => cluster@any_node - failure
> 
> [*]: this is the only risk to corrupt data. we allow this case happen:
> - node2 may crash or borken, and fails to bootup anymore.
> - node2 fails to access ocfs2 volume, needs to manage from another node.
> - mount.ocfs2 will give special warning for this case.
> 
> Fixes: 912f655d78c5("ocfs2: mount shared volume without ha stack")
> Reported-by: Junxiao Bi <junxiao.bi@oracle.com>
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/dlmglue.c  |  3 ++
>  fs/ocfs2/ocfs2_fs.h |  3 ++
>  fs/ocfs2/slot_map.c | 70 ++++++++++++++++++++++++++++++++++++---------
>  3 files changed, 62 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 801e60bab955..6b017ae46145 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -3403,6 +3403,9 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
>  	ocfs2_lock_res_free(&osb->osb_nfs_sync_lockres);
>  	ocfs2_lock_res_free(&osb->osb_orphan_scan.os_lockres);
>  
> +	if (ocfs2_mount_local(osb))
> +		return;
> +
>  	ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
>  	osb->cconn = NULL;
>  
> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> index 638d875eccc7..4fe42e638309 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -534,6 +534,9 @@ struct ocfs2_slot_map {
>   */
>  };
>  
> +#define OCFS2_SLOTMAP_CLUSTER   1
> +#define OCFS2_SLOTMAP_NOCLUSTER 2
> +
>  struct ocfs2_extended_slot {
>  /*00*/	__u8	es_valid;
>  	__u8	es_reserved1[3];
> diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
> index 0b0ae3ebb0cf..a5c06d3ecb27 100644
> --- a/fs/ocfs2/slot_map.c
> +++ b/fs/ocfs2/slot_map.c
> @@ -26,7 +26,7 @@
>  
>  
>  struct ocfs2_slot {
> -	int sl_valid;
> +	u8 sl_valid;
>  	unsigned int sl_node_num;
>  };
>  
> @@ -52,11 +52,11 @@ static void ocfs2_invalidate_slot(struct ocfs2_slot_info *si,
>  }
>  
>  static void ocfs2_set_slot(struct ocfs2_slot_info *si,
> -			   int slot_num, unsigned int node_num)
> +			   int slot_num, unsigned int node_num, u8 valid)
>  {
>  	BUG_ON((slot_num < 0) || (slot_num >= si->si_num_slots));
>  
> -	si->si_slots[slot_num].sl_valid = 1;
> +	si->si_slots[slot_num].sl_valid = valid;
>  	si->si_slots[slot_num].sl_node_num = node_num;
>  }
>  
> @@ -75,7 +75,8 @@ static void ocfs2_update_slot_info_extended(struct ocfs2_slot_info *si)
>  		     i++, slotno++) {
>  			if (se->se_slots[i].es_valid)
>  				ocfs2_set_slot(si, slotno,
> -					       le32_to_cpu(se->se_slots[i].es_node_num));
> +					       le32_to_cpu(se->se_slots[i].es_node_num),
> +						   le32_to_cpu(se->se_slots[i].es_valid));
>  			else
>  				ocfs2_invalidate_slot(si, slotno);
>  		}
> @@ -97,7 +98,7 @@ static void ocfs2_update_slot_info_old(struct ocfs2_slot_info *si)
>  		if (le16_to_cpu(sm->sm_slots[i]) == (u16)OCFS2_INVALID_SLOT)
>  			ocfs2_invalidate_slot(si, i);
>  		else
> -			ocfs2_set_slot(si, i, le16_to_cpu(sm->sm_slots[i]));
> +			ocfs2_set_slot(si, i, le16_to_cpu(sm->sm_slots[i]), OCFS2_SLOTMAP_CLUSTER);
>  	}
>  }
>  
> @@ -252,16 +253,14 @@ static int __ocfs2_find_empty_slot(struct ocfs2_slot_info *si,
>  	int i, ret = -ENOSPC;
>  
>  	if ((preferred >= 0) && (preferred < si->si_num_slots)) {
> -		if (!si->si_slots[preferred].sl_valid ||
> -		    !si->si_slots[preferred].sl_node_num) {
> +		if (!si->si_slots[preferred].sl_valid) {
>  			ret = preferred;
>  			goto out;
>  		}
>  	}
>  
>  	for(i = 0; i < si->si_num_slots; i++) {
> -		if (!si->si_slots[i].sl_valid ||
> -		    !si->si_slots[i].sl_node_num) {
> +		if (!si->si_slots[i].sl_valid) {
>  			ret = i;
>  			break;
>  		}
> @@ -270,6 +269,20 @@ static int __ocfs2_find_empty_slot(struct ocfs2_slot_info *si,
>  	return ret;
>  }
>  
> +static int __ocfs2_find_used_slot(struct ocfs2_slot_info *si)
> +{
> +	int i, ret = -ENOENT;
> +
> +	for (i = 0; i < si->si_num_slots; i++) {
> +		if (si->si_slots[i].sl_valid) {
> +			ret = i;
> +			break;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
>  int ocfs2_node_num_to_slot(struct ocfs2_super *osb, unsigned int node_num)
>  {
>  	int slot;
> @@ -449,17 +462,45 @@ int ocfs2_find_slot(struct ocfs2_super *osb)
>  {
>  	int status;
>  	int slot;
> +	int nocluster_mnt = 0;
>  	struct ocfs2_slot_info *si;
>  
>  	si = osb->slot_info;
>  
>  	spin_lock(&osb->osb_lock);
>  	ocfs2_update_slot_info(si);
> +	slot = __ocfs2_find_used_slot(si);
> +	if (slot == 0 && (si->si_slots[0].sl_valid == OCFS2_SLOTMAP_NOCLUSTER))
> +		nocluster_mnt = 1;
>  
> -	if (ocfs2_mount_local(osb))
> -		/* use slot 0 directly in local mode */
> -		slot = 0;
> -	else {
> +	/*
> +	 * We set a rule:
> +	 * if last mount didn't do unmount, (eg: crash happened), the next mount
> +	 * MUST be same mount type.
> +	 */
> +	if (ocfs2_mount_local(osb)) {
> +		/* empty slotmap, or partition didn't unmount last time */
> +		if ((slot == -ENOENT) || nocluster_mnt) {
> +			/* use slot 0 directly in local mode */
> +			slot = 0;
> +			nocluster_mnt = 1;
> +		} else {
> +			spin_unlock(&osb->osb_lock);
> +			mlog(ML_ERROR, "found clustered mount slot in noclustered env!\n");
> +			mlog(ML_ERROR, "please clean slotmap info for mount.\n");
> +			mlog(ML_ERROR, "eg. remount then unmount with clustered mode\n");
> +			status = -EINVAL;
> +			goto bail;
> +		}
> +	} else {
> +		if (nocluster_mnt) {
> +			spin_unlock(&osb->osb_lock);
> +			mlog(ML_ERROR, "found noclustered mount slot in clustered env!\n");
> +			mlog(ML_ERROR, "please clean slotmap info for mount.\n");
> +			mlog(ML_ERROR, "eg. remount then unmount with noclustered mode\n");
> +			status = -EINVAL;
> +			goto bail;
> +		}
>  		/* search for ourselves first and take the slot if it already
>  		 * exists. Perhaps we need to mark this in a variable for our
>  		 * own journal recovery? Possibly not, though we certainly
> @@ -481,7 +522,8 @@ int ocfs2_find_slot(struct ocfs2_super *osb)
>  			       slot, osb->dev_str);
>  	}
>  
> -	ocfs2_set_slot(si, slot, osb->node_num);
> +	ocfs2_set_slot(si, slot, osb->node_num, nocluster_mnt ?
> +					OCFS2_SLOTMAP_NOCLUSTER : OCFS2_SLOTMAP_CLUSTER);
>  	osb->slot_num = slot;
>  	spin_unlock(&osb->osb_lock);
>  

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
