Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF6E0C433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed,  6 Apr 2022 09:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=y5TAIeVPM9qJn/9AWl9GMUZ+VNjQDiW7FC6TzYQmuA8=;
 b=Ob6UXVn9HTkv+QdLbV3PnTq4sx0vrZ7rP59WkK2ELUVu2bnMDkVbEVHR+qqyRKiRqU0wYDuqX4RN
   PwvmzrfJ71DtXp3XvdemqHn0DR0iHU2wl3CMPA1EnY4jdzxHtHpdCFm5OWU/0GxKA+m7vMMErwNu
   TG2n0Z2fGxn33qhVmVnlDUkoYFonQd3VomfErBmyr2/ssQsYEUQxEUY7+t/rK8mrlqkbVis08/LF
   zl6LkSk5eaukCXX6WDceNipN4ZoYHzkdBW0PYgTM7WtcRVlbvgZZkIa4iepdZYAVpGWA5Umzqwl/
   5bZHq/hB3KzIZ4KBJf5QsnDGh3e0QoE5TzXkSw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=y5TAIeVPM9qJn/9AWl9GMUZ+VNjQDiW7FC6TzYQmuA8=;
 b=U2MYNUvOeyMnxL18XwbPEsEZ6oN13B15BJWRxCicac3Ga47eTmJ6KHZ4MSTyDaJ/LfVAtft0Sui1
   3OAGjAv3xZElXGmEEuv7fnccP6dyrFBO94Qalhz9zEB5pUCHY/sfagaeGKVeV4J7rCsW6ZdQwVGQ
   em3x9Gbix2YW20u+BFd3qxsMU4cCGq8wKEkZXmo9rJJSO9IhCAAcwhALZqSb74OzT611zPLX2v2M
   2ztnlbabf6N6cDMR1kDtz6MiOqzlE89EqWruxQd7DEcA4n5BJf/DQ3pkorOBACEewOlY2FDkUPEx
   TzXFDT3JmxsoLC1kRnj5psXEhXUh+LDVQZ9Vyw==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9W0031AVLZD4F0@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 06 Apr 2022 09:27:35 +0000 (GMT)
Message-id: <f0bee20d-9f3d-0fce-e20b-0a24e3d7025c@linux.alibaba.com>
Date: Wed, 6 Apr 2022 17:27:07 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20220404164055.1434-1-heming.zhao@suse.com>
In-reply-to: <20220404164055.1434-1-heming.zhao@suse.com>
X-Source-IP: 115.124.30.42
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10308
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 phishscore=0 impostorscore=0
 bulkscore=0 priorityscore=180 suspectscore=0 spamscore=0 clxscore=130
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204060043 domainage_hfrom=8392
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: fix error handling during mounting
	stage
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
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01424;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0V9LOUsJ_1649237227;
X-ServerName: out30-42.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: ifrmMA27Yqawn7OYh_NVngxTk3xGbXd_
X-Proofpoint-GUID: ifrmMA27Yqawn7OYh_NVngxTk3xGbXd_
Reporting-Meta:
 AAHmGpPeWskFdxA9XN8dNQDMCMHjBjq3ZDgFMVYtsfZirvADX0Y9QelhtaO708g9
 jAmjss6qKwXhNWJkyZQJ+fFbvMOpH2X+h1PYtNC2zrXJXAi6AtuPiGsGLabUOOqN
 MDbj1qB19RrjCuMvTOX9CZL+vCkeyff34hrfwb3HMHdmmWyYTyhFOUY2GruJ5jMU
 NK9rCCGw7msETJtqkIi9w++3WMstAwF8PtTd+uYjSP4n2Xr7WErnHkOIlhTdXJDs
 Uh31lG9233jlySbnadgW/DMhPzR59XPdOFNZ6Rrj4kgUvgui20cFOWzkE/xzLAKS
 janC2y8so8Kr92hKLI7vvFQDiQjCe+ZvsU1U58POPx4Wi82rg7AmrwRGNGNds4Jb
 CActeQSWcrULHKyeotUw7QPuyaZiCLcg6k6E5XMOWbqQNqvZ/4JJUgNAqqkp7xbm
 MOglpHPM7IiMWuYYTKL8ADzwLtsKDMtY2i3tvGL+MD+LX96Zr72VbwfUIEM8S0Q+
 g1lNDri01Ga9FMwL3HDSQ3Tx5s0n/XKPG3+pqo+m42E=



On 4/5/22 12:40 AM, Heming Zhao wrote:
> This is draft version, It only passed compiling & mount/umount test.
> I want to know if my idea is acceptable for maintainers.
> 
> There left one issue: mounting crash when no dlm connection. I still
> can't find out a better solution without directly free inode memory.
> So I marked the related function (ocfs2_release_system_inodes) with
> comment: "/* FIXME crash when no journal */"
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/reservations.c |   4 +-
>  fs/ocfs2/reservations.h |   2 +-
>  fs/ocfs2/super.c        | 156 +++++++++++++++++++++++++---------------
>  3 files changed, 99 insertions(+), 63 deletions(-)
> 
> diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
> index 769e466887b0..a9d1296d736d 100644
> --- a/fs/ocfs2/reservations.c
> +++ b/fs/ocfs2/reservations.c
> @@ -198,7 +198,7 @@ void ocfs2_resv_set_type(struct ocfs2_alloc_reservation *resv,
>  	resv->r_flags |= flags;
>  }
>  
> -int ocfs2_resmap_init(struct ocfs2_super *osb,
> +void ocfs2_resmap_init(struct ocfs2_super *osb,
>  		      struct ocfs2_reservation_map *resmap)
>  {
>  	memset(resmap, 0, sizeof(*resmap));
> @@ -207,8 +207,6 @@ int ocfs2_resmap_init(struct ocfs2_super *osb,
>  	resmap->m_reservations = RB_ROOT;
>  	/* m_bitmap_len is initialized to zero by the above memset. */
>  	INIT_LIST_HEAD(&resmap->m_lru);
> -
> -	return 0;
>  }
>  
>  static void ocfs2_resv_mark_lru(struct ocfs2_reservation_map *resmap,
> diff --git a/fs/ocfs2/reservations.h b/fs/ocfs2/reservations.h
> index 677c50663595..6e5559d6940d 100644
> --- a/fs/ocfs2/reservations.h
> +++ b/fs/ocfs2/reservations.h
> @@ -81,7 +81,7 @@ void ocfs2_resv_discard(struct ocfs2_reservation_map *resmap,
>   * Only possible return value other than '0' is -ENOMEM for failure to
>   * allocation mirror bitmap.
>   */
> -int ocfs2_resmap_init(struct ocfs2_super *osb,
> +void ocfs2_resmap_init(struct ocfs2_super *osb,
>  		      struct ocfs2_reservation_map *resmap);
>  
>  /**
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 477cdf94122e..04d7bc7e1110 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -112,6 +112,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  				  struct buffer_head *bh,
>  				  int sector_size,
>  				  struct ocfs2_blockcheck_stats *stats);
> +static void ocfs2_uninitialize_super(struct ocfs2_super *osb);
>  static int ocfs2_get_sector(struct super_block *sb,
>  			    struct buffer_head **bh,
>  			    int block,
> @@ -458,6 +459,7 @@ static int ocfs2_init_global_system_inodes(struct ocfs2_super *osb)
>  			continue;
>  		new = ocfs2_get_system_file_inode(osb, i, osb->slot_num);
>  		if (!new) {
> +			/* FIXME crash when no journal */

I don't have better idea at moment, so we may factor out part of journal init
and put bofore.

>  			ocfs2_release_system_inodes(osb);
>  			status = ocfs2_is_soft_readonly(osb) ? -EROFS : -EINVAL;
>  			mlog_errno(status);
> @@ -488,6 +490,7 @@ static int ocfs2_init_local_system_inodes(struct ocfs2_super *osb)
>  			continue;
>  		new = ocfs2_get_system_file_inode(osb, i, osb->slot_num);
>  		if (!new) {
> +			/* FIXME crash when no journal */
>  			ocfs2_release_system_inodes(osb);
>  			status = ocfs2_is_soft_readonly(osb) ? -EROFS : -EINVAL;
>  			mlog(ML_ERROR, "status=%d, sysfile=%d, slot=%d\n",
> @@ -989,28 +992,27 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	if (!ocfs2_parse_options(sb, data, &parsed_options, 0)) {
>  		status = -EINVAL;
> -		goto read_super_error;
> +		goto finally;
>  	}
>  
>  	/* probe for superblock */
>  	status = ocfs2_sb_probe(sb, &bh, &sector_size, &stats);
>  	if (status < 0) {
>  		mlog(ML_ERROR, "superblock probe failed!\n");
> -		goto read_super_error;
> +		goto finally;
>  	}
>  
>  	status = ocfs2_initialize_super(sb, bh, sector_size, &stats);
> -	osb = OCFS2_SB(sb);
> -	if (status < 0) {
> -		mlog_errno(status);
> -		goto read_super_error;
> -	}
>  	brelse(bh);
>  	bh = NULL;
> +	if (status < 0) {
> +		goto finally;
> +	}
> +	osb = OCFS2_SB(sb);
>  
>  	if (!ocfs2_check_set_options(sb, &parsed_options)) {
>  		status = -EINVAL;
> -		goto read_super_error;
> +		goto super_out;
>  	}
>  	osb->s_mount_opt = parsed_options.mount_opt;
>  	osb->s_atime_quantum = parsed_options.atime_quantum;
> @@ -1027,7 +1029,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	status = ocfs2_verify_userspace_stack(osb, &parsed_options);
>  	if (status)
> -		goto read_super_error;
> +		goto super_out;
>  
>  	sb->s_magic = OCFS2_SUPER_MAGIC;
>  
> @@ -1041,7 +1043,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  			status = -EACCES;
>  			mlog(ML_ERROR, "Readonly device detected but readonly "
>  			     "mount was not specified.\n");
> -			goto read_super_error;
> +			goto super_out;
>  		}
>  
>  		/* You should not be able to start a local heartbeat
> @@ -1050,7 +1052,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  			status = -EROFS;
>  			mlog(ML_ERROR, "Local heartbeat specified on readonly "
>  			     "device.\n");
> -			goto read_super_error;
> +			goto super_out;
>  		}
>  
>  		status = ocfs2_check_journals_nolocks(osb);
> @@ -1061,7 +1063,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  				     "unavailable.\n");
>  			else
>  				mlog_errno(status);
> -			goto read_super_error;
> +			goto super_out;
>  		}
>  
>  		ocfs2_set_ro_flag(osb, 1);
> @@ -1079,7 +1081,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  	status = ocfs2_verify_heartbeat(osb);
>  	if (status < 0) {
>  		mlog_errno(status);
> -		goto read_super_error;
> +		goto super_out;
>  	}
>  
>  	osb->osb_debug_root = debugfs_create_dir(osb->uuid_str,
> @@ -1094,15 +1096,14 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	status = ocfs2_mount_volume(sb);
>  	if (status < 0)
> -		goto read_super_error;
> +		goto debugfs_out;
>  
>  	if (osb->root_inode)
>  		inode = igrab(osb->root_inode);
>  
>  	if (!inode) {
>  		status = -EIO;
> -		mlog_errno(status);
> -		goto read_super_error;
> +		goto journal_out;
>  	}
>  
>  	osb->osb_dev_kset = kset_create_and_add(sb->s_id, NULL,
> @@ -1110,7 +1111,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  	if (!osb->osb_dev_kset) {
>  		status = -ENOMEM;
>  		mlog(ML_ERROR, "Unable to create device kset %s.\n", sb->s_id);
> -		goto read_super_error;
> +		goto journal_out;
>  	}
>  
>  	/* Create filecheck sysfs related directories/files at
> @@ -1119,14 +1120,13 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  		status = -ENOMEM;
>  		mlog(ML_ERROR, "Unable to create filecheck sysfs directory at "
>  			"/sys/fs/ocfs2/%s/filecheck.\n", sb->s_id);
> -		goto read_super_error;
> +		goto journal_out;
>  	}
>  
>  	root = d_make_root(inode);
>  	if (!root) {
>  		status = -ENOMEM;
> -		mlog_errno(status);
> -		goto read_super_error;
> +		goto journal_out;
>  	}
>  
>  	sb->s_root = root;
> @@ -1178,17 +1178,22 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	return status;
>  
> -read_super_error:
> -	brelse(bh);
> +journal_out:
> +	mlog_errno(status);
> +	atomic_set(&osb->vol_state, VOLUME_DISABLED);
> +	wake_up(&osb->osb_mount_event);
> +	ocfs2_dismount_volume(sb, 1);
>  
> -	if (status)
> -		mlog_errno(status);
> +	return status;
>  
> -	if (osb) {
> -		atomic_set(&osb->vol_state, VOLUME_DISABLED);
> -		wake_up(&osb->osb_mount_event);
> -		ocfs2_dismount_volume(sb, 1);
> -	}
> +debugfs_out:
> +	debugfs_remove_recursive(osb->osb_debug_root);
> +super_out:
> +	/* FIXME crash when no journal */
> +	ocfs2_release_system_inodes(osb);
> +	ocfs2_uninitialize_super(osb);
> +finally:

Missing brelse(bh) since it will goto here if ocfs2_sb_probe()
fails.
Suggest we name the label as out_xxx, and I have to take more
time to review the above changes.

> +	mlog_errno(status);
>  
>  	return status;
>  }
> @@ -1803,11 +1808,10 @@ static int ocfs2_get_sector(struct super_block *sb,
>  static int ocfs2_mount_volume(struct super_block *sb)
>  {
>  	int status = 0;
> -	int unlock_super = 0;
>  	struct ocfs2_super *osb = OCFS2_SB(sb);
>  
>  	if (ocfs2_is_hard_readonly(osb))
> -		goto leave;
> +		goto finally;
>  
>  	mutex_init(&osb->obs_trim_fs_mutex);
>  
> @@ -1817,44 +1821,54 @@ static int ocfs2_mount_volume(struct super_block *sb)
>  		if (status == -EBADR && ocfs2_userspace_stack(osb))
>  			mlog(ML_ERROR, "couldn't mount because cluster name on"
>  			" disk does not match the running cluster name.\n");
> -		goto leave;
> +		goto finally;
>  	}
>  
>  	status = ocfs2_super_lock(osb, 1);
>  	if (status < 0) {
>  		mlog_errno(status);
> -		goto leave;
> +		goto dlm_out;
>  	}
> -	unlock_super = 1;
>  
>  	/* This will load up the node map and add ourselves to it. */
>  	status = ocfs2_find_slot(osb);
>  	if (status < 0) {
>  		mlog_errno(status);
> -		goto leave;
> +		goto super_lock;
>  	}
>  
>  	/* load all node-local system inodes */
>  	status = ocfs2_init_local_system_inodes(osb);
>  	if (status < 0) {
>  		mlog_errno(status);
> -		goto leave;
> +		goto super_lock;
>  	}
>  
>  	status = ocfs2_check_volume(osb);
>  	if (status < 0) {
>  		mlog_errno(status);
> -		goto leave;
> +		goto system_inodes;
>  	}
>  
>  	status = ocfs2_truncate_log_init(osb);
> -	if (status < 0)
> +	if (status < 0) {
>  		mlog_errno(status);
> +		goto journal_shutdown;
> +	}
>  
> -leave:
> -	if (unlock_super)
> -		ocfs2_super_unlock(osb, 1);
> +	ocfs2_super_unlock(osb, 1);
> +	return status;
>  
> +journal_shutdown:
> +	ocfs2_journal_shutdown(osb);
> +system_inodes:
> +	/* FIXME crash when no journal */
> +	ocfs2_release_system_inodes(osb);
> +super_lock:
> +	ocfs2_super_unlock(osb, 1);
> +dlm_out:
> +	ocfs2_dlm_shutdown(osb, 0);
> +finally:
>  	return status;
>  }
>  
> @@ -2110,17 +2124,13 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  
>  	init_waitqueue_head(&osb->osb_mount_event);
>  
> -	status = ocfs2_resmap_init(osb, &osb->osb_la_resmap);
> -	if (status) {
> -		mlog_errno(status);
> -		goto bail;
> -	}
> +	ocfs2_resmap_init(osb, &osb->osb_la_resmap);
>  
>  	osb->vol_label = kmalloc(OCFS2_MAX_VOL_LABEL_LEN, GFP_KERNEL);
>  	if (!osb->vol_label) {
>  		mlog(ML_ERROR, "unable to alloc vol label\n");
>  		status = -ENOMEM;
> -		goto bail;
> +		goto recovery_map;
>  	}
>  
>  	osb->slot_recovery_generations =
> @@ -2129,7 +2139,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	if (!osb->slot_recovery_generations) {
>  		status = -ENOMEM;
>  		mlog_errno(status);
> -		goto bail;
> +		goto vol_label;
>  	}
>  
>  	init_waitqueue_head(&osb->osb_wipe_event);
> @@ -2139,7 +2149,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	if (!osb->osb_orphan_wipes) {
>  		status = -ENOMEM;
>  		mlog_errno(status);
> -		goto bail;
> +		goto slot_recovery_gen;
>  	}
>  
>  	osb->osb_rf_lock_tree = RB_ROOT;
> @@ -2155,13 +2165,13 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  		mlog(ML_ERROR, "couldn't mount because of unsupported "
>  		     "optional features (%x).\n", i);
>  		status = -EINVAL;
> -		goto bail;
> +		goto orphan_wipes;
>  	}
>  	if (!sb_rdonly(osb->sb) && (i = OCFS2_HAS_RO_COMPAT_FEATURE(osb->sb, ~OCFS2_FEATURE_RO_COMPAT_SUPP))) {
>  		mlog(ML_ERROR, "couldn't mount RDWR because of "
>  		     "unsupported optional features (%x).\n", i);
>  		status = -EINVAL;
> -		goto bail;
> +		goto orphan_wipes;
>  	}
>  
>  	if (ocfs2_clusterinfo_valid(osb)) {
> @@ -2182,7 +2192,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  			     "cluster stack label (%s) \n",
>  			     osb->osb_cluster_stack);
>  			status = -EINVAL;
> -			goto bail;
> +			goto orphan_wipes;
>  		}
>  		memcpy(osb->osb_cluster_name,
>  			OCFS2_RAW_SB(di)->s_cluster_info.ci_cluster,
> @@ -2208,7 +2218,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  		mlog(ML_ERROR, "Volume has invalid cluster size (%d)\n",
>  		     osb->s_clustersize);
>  		status = -EINVAL;
> -		goto bail;
> +		goto orphan_wipes;
>  	}
>  
>  	total_blocks = ocfs2_clusters_to_blocks(osb->sb,
> @@ -2220,14 +2230,14 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  		mlog(ML_ERROR, "Volume too large "
>  		     "to mount safely on this system");
>  		status = -EFBIG;
> -		goto bail;
> +		goto orphan_wipes;
>  	}
>  
>  	if (ocfs2_setup_osb_uuid(osb, di->id2.i_super.s_uuid,
>  				 sizeof(di->id2.i_super.s_uuid))) {
>  		mlog(ML_ERROR, "Out of memory trying to setup our uuid.\n");
>  		status = -ENOMEM;
> -		goto bail;
> +		goto orphan_wipes;
>  	}
>  
>  	strlcpy(osb->vol_label, di->id2.i_super.s_label,
> @@ -2247,7 +2257,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	if (!osb->osb_dlm_debug) {
>  		status = -ENOMEM;
>  		mlog_errno(status);
> -		goto bail;
> +		goto uuid_str;
>  	}
>  
>  	atomic_set(&osb->vol_state, VOLUME_INIT);
> @@ -2256,7 +2266,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	status = ocfs2_init_global_system_inodes(osb);
>  	if (status < 0) {
>  		mlog_errno(status);
> -		goto bail;
> +		goto dlm_out;
>  	}
>  
>  	/*
> @@ -2267,7 +2277,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	if (!inode) {
>  		status = -EINVAL;
>  		mlog_errno(status);
> -		goto bail;
> +		goto system_inodes;
>  	}
>  
>  	osb->bitmap_blkno = OCFS2_I(inode)->ip_blkno;
> @@ -2280,19 +2290,47 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	status = ocfs2_init_slot_info(osb);
>  	if (status < 0) {
>  		mlog_errno(status);
> -		goto bail;
> +		goto system_inodes;
>  	}
>  
>  	osb->ocfs2_wq = alloc_ordered_workqueue("ocfs2_wq", WQ_MEM_RECLAIM);
>  	if (!osb->ocfs2_wq) {
>  		status = -ENOMEM;
>  		mlog_errno(status);
> +		goto slot_info;
>  	}
>  
> +	return status;
> +
> +slot_info:
> +	ocfs2_free_slot_info(osb);
> +system_inodes:
> +	/* FIXME crash when no journal */
> +	ocfs2_release_system_inodes(osb);
> +dlm_out:
> +	ocfs2_put_dlm_debug(osb->osb_dlm_debug);
> +uuid_str:
> +	kfree(osb->uuid_str);
> +orphan_wipes:
> +	kfree(osb->osb_orphan_wipes);
> +slot_recovery_gen:
> +	kfree(osb->slot_recovery_generations);
> +vol_label:
> +	kfree(osb->vol_label);
> +recovery_map:
> +	kfree(osb->recovery_map);
>  bail:
> +	kfree(osb);
>  	return status;
>  }
Could we split ocfs2_initialize_super() changes as a single patch?
Also suggest we name the label as out_xxx.

>  
> +static void ocfs2_uninitialize_super(struct ocfs2_super *osb)
> +{
> +	kfree(osb->recovery_map);
> +	ocfs2_delete_osb(osb);
> +	kfree(osb);
> +}

Since ocfs2_initialize_super() does more than above, I don't think
the name is quite suitable here.
If we the above operations are enough, I suggest just open code in
error handling.

Thanks,
Joseph 

> +
>  /*
>   * will return: -EAGAIN if it is ok to keep searching for superblocks
>   *              -EINVAL if there is a bad superblock

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
