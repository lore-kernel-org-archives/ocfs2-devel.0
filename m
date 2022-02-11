Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D610C433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri, 11 Feb 2022 04:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=P9mqJaJT183QRnxLvn7MPpEW+yMdSoWZwZiljF94iec=;
 b=1mRc/nnDcxZmZyzBba2tEroBeOxfkiaLxh8KryDTwPcnrQa2umChHf5+iR7/8TDQq1O1busri0Uf
   DmpiU/blzL51wUuce28P+jDFa/y8mO3KaPmanAYbZYOiFqWF1eI4VWLL0UFzfAodB2T/MyHxen3f
   RT2okkKByY83hSHJ4JHuZQkXBmvJevH4AyFne7NhhyPJDG1qh2ktqehN2b7S+Y7tJcVAYGV3DZaS
   LCRI2bGZvs9OEsxeLxxdKsEjTTiQzyRTxe6QB5PQssOUBFHJt0IMsUaXQSGcEMopm1GHeteTblMH
   NzUJGKsfLReLGXGytJkr7nPoXmh5rDP3AhaE6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=P9mqJaJT183QRnxLvn7MPpEW+yMdSoWZwZiljF94iec=;
 b=ra0xwEabRlDRF5FHBKbiIvmF0c+3Eo7VI2MR+/8WZa2ViKuWZXradX4jj0UQ4HPM5g9XZAulCn77
   MdczwWvQJCek8XlVOhfn83PRdookAHzs9u2TdHmUgvN3zcYspLQ4tt41vfNDzrV55f9Ttw6IV+Od
   tiV1L3FXBtbBr3LN/ZwTzw+2EniCWixwMMF+Z894FdAcNwK5Ti19rpLgt2Y9Pwvp5SzNyCaE4uSc
   Pl3r/LmQDsiHG0dn3xq1Q8GvjAztrnD66OsTMVAe+PAPDk2y4PBUfg1TEbgNhisS/FCoSzlcBcMz
   ETBZ/rOzJTTQL/O6OBhI4xwfQRMK0pLrq1Hcsw==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220119 64bit (built Jan 19
 2022))
 with ESMTPS id <0R7400GEYGJQJKG0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 11 Feb 2022 04:02:14 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
Message-id: <4791ccfd-ecf0-ed90-fc4c-b6effd56fbdd@linux.alibaba.com>
Date: Fri, 11 Feb 2022 12:01:52 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Content-language: en-US
To: Hongnan Li <hongnan.li@linux.alibaba.com>, ocfs2-devel@oss.oracle.com,
 akpm <akpm@linux-foundation.org>
References: <20220211031146.106288-1-hongnan.li@linux.alibaba.com>
In-reply-to: <20220211031146.106288-1-hongnan.li@linux.alibaba.com>
X-Source-IP: 115.124.30.130
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10254
 signatures=673431
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 priorityscore=30 clxscore=180 spamscore=0 impostorscore=0 mlxscore=0
 malwarescore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202110019 domainage_hfrom=8338
Subject: Re: [Ocfs2-devel] [PATCH] fs/ocfs2: fix comments mentioning i_mutex
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R761e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04394;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0V47F0Wv_1644552112;
X-ServerName: out30-130.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: B7tZ86aXR7IcW2cuBkqWzmY5evThf-Uu
X-Proofpoint-ORIG-GUID: B7tZ86aXR7IcW2cuBkqWzmY5evThf-Uu
Reporting-Meta:
 AAHcXrmDM+k9sDDumEXNNox0mLVlgQaELkdPyB/QirIsfjQhz6HgWGHc5b9ftmEr
 iYZ1q+aXn/diS+JOel+dNIoh/PhfJ5NUokEGQdMiEMxL8k2GS4brBOe50rTDrl4s
 GtT+ZxgnVmC0cwc0efILu6MX7Nc86hZs/rw0qolYShaJx3f91TxSoBgWhrNKpJFS
 B/yGxfqAB1quOGcK6ZYUjgsjaiyZ8R230q4hqmfk33jjdwfkY1NigrGosBkfy+Nh
 fIWxb66Qk5JqE1JV+d13Svut97/89CRZKWyw0W5UhdsiHXsFWw0nDBDdrFFtJq7J
 P+P7tsLn6JhzfbG5UJeeSVIYz7VYQCbsdaRusd1WIiRcSQTNnVtrkvqYk+W6wWTr
 9uVoqK0NRnWzRdCjsuNpNyUB2YvxQrh3jcTyCjxGGNhVP46DopXqcLvdRc3r8PhR
 ER/+AYSmJZxfHyijAH7f8bCmpWlrY1JJxmQZbduE43dUv6Tfv3OG9UStCg7SURrG
 NcJBY8Vq4wdbdxPu75yO6abCi9crXgTGjg9t9o4lEa8=



On 2/11/22 11:11 AM, Hongnan Li wrote:
> From: hongnanli <hongnan.li@linux.alibaba.com>
> 
> inode->i_mutex has been replaced with inode->i_rwsem long ago. Fix
> comments still mentioning i_mutex.
> 
> Signed-off-by: hongnanli <hongnan.li@linux.alibaba.com>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/alloc.c               | 2 +-
>  fs/ocfs2/aops.c                | 2 +-
>  fs/ocfs2/cluster/nodemanager.c | 2 +-
>  fs/ocfs2/dir.c                 | 4 ++--
>  fs/ocfs2/file.c                | 4 ++--
>  fs/ocfs2/inode.c               | 2 +-
>  fs/ocfs2/localalloc.c          | 6 +++---
>  fs/ocfs2/namei.c               | 2 +-
>  fs/ocfs2/ocfs2.h               | 4 ++--
>  fs/ocfs2/quota_global.c        | 2 +-
>  fs/ocfs2/xattr.c               | 2 +-
>  11 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index bf9357123bc5..49f41074baad 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -5981,7 +5981,7 @@ static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
>  	return status;
>  }
>  
> -/* Expects you to already be holding tl_inode->i_mutex */
> +/* Expects you to already be holding tl_inode->i_rwsem */
>  int __ocfs2_flush_truncate_log(struct ocfs2_super *osb)
>  {
>  	int status;
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 498da317580a..c23e1c243cc6 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -2311,7 +2311,7 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>  
>  	down_write(&oi->ip_alloc_sem);
>  
> -	/* Delete orphan before acquire i_mutex. */
> +	/* Delete orphan before acquire i_rwsem. */
>  	if (dwc->dw_orphaned) {
>  		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
>  
> diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
> index 625c92521416..27fee68f860a 100644
> --- a/fs/ocfs2/cluster/nodemanager.c
> +++ b/fs/ocfs2/cluster/nodemanager.c
> @@ -689,7 +689,7 @@ static struct config_group *o2nm_cluster_group_make_group(struct config_group *g
>  	struct o2nm_node_group *ns = NULL;
>  	struct config_group *o2hb_group = NULL, *ret = NULL;
>  
> -	/* this runs under the parent dir's i_mutex; there can be only
> +	/* this runs under the parent dir's i_rwsem; there can be only
>  	 * one caller in here at a time */
>  	if (o2nm_single_cluster)
>  		return ERR_PTR(-ENOSPC);
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index f2cc1ff29e6d..81c3d65d68fe 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -1957,7 +1957,7 @@ int ocfs2_readdir(struct file *file, struct dir_context *ctx)
>  }
>  
>  /*
> - * NOTE: this should always be called with parent dir i_mutex taken.
> + * NOTE: this should always be called with parent dir i_rwsem taken.
>   */
>  int ocfs2_find_files_on_disk(const char *name,
>  			     int namelen,
> @@ -2003,7 +2003,7 @@ int ocfs2_lookup_ino_from_name(struct inode *dir, const char *name,
>   * Return 0 if the name does not exist
>   * Return -EEXIST if the directory contains the name
>   *
> - * Callers should have i_mutex + a cluster lock on dir
> + * Callers should have i_rwsem + a cluster lock on dir
>   */
>  int ocfs2_check_dir_for_entry(struct inode *dir,
>  			      const char *name,
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index fc5f780fa235..d940e1a633a1 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -270,7 +270,7 @@ int ocfs2_update_inode_atime(struct inode *inode,
>  
>  	/*
>  	 * Don't use ocfs2_mark_inode_dirty() here as we don't always
> -	 * have i_mutex to guard against concurrent changes to other
> +	 * have i_rwsem to guard against concurrent changes to other
>  	 * inode fields.
>  	 */
>  	inode->i_atime = current_time(inode);
> @@ -1068,7 +1068,7 @@ static int ocfs2_extend_file(struct inode *inode,
>  	/*
>  	 * The alloc sem blocks people in read/write from reading our
>  	 * allocation until we're done changing it. We depend on
> -	 * i_mutex to block other extend/truncate calls while we're
> +	 * i_rwsem to block other extend/truncate calls while we're
>  	 * here.  We even have to hold it for sparse files because there
>  	 * might be some tail zeroing.
>  	 */
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 6c2411c2afcf..5739dc301569 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -713,7 +713,7 @@ static int ocfs2_remove_inode(struct inode *inode,
>  /*
>   * Serialize with orphan dir recovery. If the process doing
>   * recovery on this orphan dir does an iget() with the dir
> - * i_mutex held, we'll deadlock here. Instead we detect this
> + * i_rwsem held, we'll deadlock here. Instead we detect this
>   * and exit early - recovery will wipe this inode for us.
>   */
>  static int ocfs2_check_orphan_recovery_state(struct ocfs2_super *osb,
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index 5f6bacbeef6b..c4426d12a2ad 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -606,7 +606,7 @@ int ocfs2_complete_local_alloc_recovery(struct ocfs2_super *osb,
>  
>  /*
>   * make sure we've got at least bits_wanted contiguous bits in the
> - * local alloc. You lose them when you drop i_mutex.
> + * local alloc. You lose them when you drop i_rwsem.
>   *
>   * We will add ourselves to the transaction passed in, but may start
>   * our own in order to shift windows.
> @@ -636,7 +636,7 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
>  
>  	/*
>  	 * We must double check state and allocator bits because
> -	 * another process may have changed them while holding i_mutex.
> +	 * another process may have changed them while holding i_rwsem.
>  	 */
>  	spin_lock(&osb->osb_lock);
>  	if (!ocfs2_la_state_enabled(osb) ||
> @@ -1029,7 +1029,7 @@ enum ocfs2_la_event {
>  /*
>   * Given an event, calculate the size of our next local alloc window.
>   *
> - * This should always be called under i_mutex of the local alloc inode
> + * This should always be called under i_rwsem of the local alloc inode
>   * so that local alloc disabling doesn't race with processes trying to
>   * use the allocator.
>   *
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 2c46ff6ba4ea..c75fd54b9185 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -476,7 +476,7 @@ static int ocfs2_mknod(struct user_namespace *mnt_userns,
>  		ocfs2_free_alloc_context(meta_ac);
>  
>  	/*
> -	 * We should call iput after the i_mutex of the bitmap been
> +	 * We should call iput after the i_rwsem of the bitmap been
>  	 * unlocked in ocfs2_free_alloc_context, or the
>  	 * ocfs2_delete_inode will mutex_lock again.
>  	 */
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index bb62cc2e0211..337527571461 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -355,7 +355,7 @@ struct ocfs2_super
>  	struct delayed_work		la_enable_wq;
>  
>  	/*
> -	 * Must hold local alloc i_mutex and osb->osb_lock to change
> +	 * Must hold local alloc i_rwsem and osb->osb_lock to change
>  	 * local_alloc_bits. Reads can be done under either lock.
>  	 */
>  	unsigned int local_alloc_bits;
> @@ -430,7 +430,7 @@ struct ocfs2_super
>  	atomic_t			osb_tl_disable;
>  	/*
>  	 * How many clusters in our truncate log.
> -	 * It must be protected by osb_tl_inode->i_mutex.
> +	 * It must be protected by osb_tl_inode->i_rwsem.
>  	 */
>  	unsigned int truncated_clusters;
>  
> diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
> index f033de733adb..273f65e0aaba 100644
> --- a/fs/ocfs2/quota_global.c
> +++ b/fs/ocfs2/quota_global.c
> @@ -36,7 +36,7 @@
>   * should be obeyed by all the functions:
>   * - any write of quota structure (either to local or global file) is protected
>   *   by dqio_sem or dquot->dq_lock.
> - * - any modification of global quota file holds inode cluster lock, i_mutex,
> + * - any modification of global quota file holds inode cluster lock, i_rwsem,
>   *   and ip_alloc_sem of the global quota file (achieved by
>   *   ocfs2_lock_global_qf). It also has to hold qinfo_lock.
>   * - an allocation of new blocks for local quota file is protected by
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index dd784eb0cd7c..95d0611c5fc7 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -7205,7 +7205,7 @@ int ocfs2_reflink_xattrs(struct inode *old_inode,
>   * Used for reflink a non-preserve-security file.
>   *
>   * It uses common api like ocfs2_xattr_set, so the caller
> - * must not hold any lock expect i_mutex.
> + * must not hold any lock expect i_rwsem.
>   */
>  int ocfs2_init_security_and_acl(struct inode *dir,
>  				struct inode *inode,

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
