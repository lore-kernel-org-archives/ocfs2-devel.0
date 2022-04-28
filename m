Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FA8AC433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Apr 2022 11:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4NTHz2DQKH40oGtpShlZLebCDhgP9/G0Pobt23sYyrw=;
 b=X7iRvHNbYFXlnevpDtRFfd98PJlgjd57EMp8gX/yCAGN7c/c5n8IyJNO3DlUly8w9jg6iJ91cJu4
   S/zoWjD71HP7u7BSf/QTzSKs/2TZM1YF34UuBpP7+DUb3dVbXl7XHZw9dAMXFAK3pHx7uwIjvdEb
   mJJiwjtJsDBKsKICLuhzCnG0/+EpGYS0wbkWXP0H5gn30b08FmofLpQNg4btxGOH0ppEjRpfisDn
   BRcl4DaFPH4bSw6ChJAIq8+cV1p3bHrC4Pvuo/Fp4Hsqxj48hfcvUWL5+bqht5+SK/sacq0Z9G0F
   94WAbUvI2N11YNrj83wsuhhxPwmSDpeOs7OLdQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4NTHz2DQKH40oGtpShlZLebCDhgP9/G0Pobt23sYyrw=;
 b=Scd8vGgsw/Y42J+3qmNYocuac2Os7vKT+YBKVVbHJqdP2y8pcuiRs2pGtY/Qya88jkKQOUsMXZLP
   56OQ/j6tPZUhNxhSkHV9L2T7rgaggar1pKuSdF/SshyUkW+CeY/XVckwPKZDqeWFFxJ1Q75p1je1
   DsmLXIh3QOMP4A0GL8G32PtLJMFO5sGy9KLiek6vorZg1QVZ91pwpqd36aFmR9chHpvUDoy245rp
   3d8xDsgCUTEwi1Q3A1khp9/GZV4ioDMa0ngOZT7bJnygOOd/4c7/290GOADTRig3VrgatJiiXxYE
   Rdu6kURjCwgexs+Kf3oMTVjwej3UYzOVwb+vaQ==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RB1002CCSWDXDA0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 28 Apr 2022 11:50:37 +0000 (GMT)
Message-id: <cba3b476-4973-57e2-eb2e-617871cc5966@linux.alibaba.com>
Date: Thu, 28 Apr 2022 19:50:19 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com,
 akpm <akpm@linux-foundation.org>
References: <20220424130952.2436-1-heming.zhao@suse.com>
 <20220424130952.2436-6-heming.zhao@suse.com>
In-reply-to: <20220424130952.2436-6-heming.zhao@suse.com>
X-Source-IP: 115.124.30.56
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10330
 signatures=694622
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=30
 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 spamscore=0 impostorscore=0 malwarescore=0 clxscore=121 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280073 domainage_hfrom=8414
Subject: Re: [Ocfs2-devel] [PATCH v3 5/5] ocfs2: rewrite error handling of
	ocfs2_fill_super
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R141e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0VBah0RM_1651146619;
X-ServerName: out30-56.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: ME6JHQO2TOp2T8wezR6WRcbyjyk3CBa4
X-Proofpoint-GUID: ME6JHQO2TOp2T8wezR6WRcbyjyk3CBa4
Reporting-Meta:
 AAEGS2B2KjE90Jj0y2FIN4P7ds47MdjLR/rl8LX9YgHOHdIv4b7ZfF2scnjJGrer
 GwZfA7z34UsBi8NslT1I0ZL2sdtscrArDeabjR1nR19k+Z1Lswl0/d0accdwaTms
 8CGiMP5JGARH4ESFnL+2j3HFCNcDKbNybd2WKCiT8l797IxHUBAtXPx3bv5qalVl
 mvH1/4BJ5tUHz9UdImN7dS7fBxM+Z+sFCXxqdc5bn3NKCqliZMj4My7NkRAiac63
 Y+zghU8HEfL++LP5AcK3MsCQfi9pq2Vxp1sdfu3iahoVXzztlTqwuZr8aRBwvSZN
 Otb8V7W10FzFlrTzbLH7JtQuppP46w7tgkSVSM/ypxWZxYwZZudvPRsfoKryorKv
 mx4SZXFM/Xw1aOqnojF5bZe6h3QmJsWnC93KFnH9Tt8rk/3LBC2ypuPbHOpjBoiK
 yc3Rcsyfo+r8D22L+fX6152YZyD3E8F5RWKSXprRHP0tQpsigxG6aVSgYqT1Q2tc
 stDVT+sHexbtTyLHeFZSJxRP3BHOjWrRdFSdk2Txbxk=



On 4/24/22 9:09 PM, Heming Zhao wrote:
> Current ocfs2_fill_super() uses one goto label "read_super_error" to
> handle all error cases. And with previous serial patches, the error
> handling should fork more branches to handle different error cases.
> This patch rewrite the error handling of ocfs2_fill_super.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/super.c | 67 +++++++++++++++++++++++-------------------------
>  1 file changed, 32 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 1cf18ed8cf1b..f7298816d8d9 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -989,28 +989,27 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	if (!ocfs2_parse_options(sb, data, &parsed_options, 0)) {
>  		status = -EINVAL;
> -		goto read_super_error;
> +		goto out;
>  	}
>  
>  	/* probe for superblock */
>  	status = ocfs2_sb_probe(sb, &bh, &sector_size, &stats);
>  	if (status < 0) {
>  		mlog(ML_ERROR, "superblock probe failed!\n");
> -		goto read_super_error;
> +		goto out;
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
> +	if (status < 0)
> +		goto out;
> +
> +	osb = OCFS2_SB(sb);
>  
>  	if (!ocfs2_check_set_options(sb, &parsed_options)) {
>  		status = -EINVAL;
> -		goto read_super_error;
> +		goto out_super;
>  	}
>  	osb->s_mount_opt = parsed_options.mount_opt;
>  	osb->s_atime_quantum = parsed_options.atime_quantum;
> @@ -1027,7 +1026,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	status = ocfs2_verify_userspace_stack(osb, &parsed_options);
>  	if (status)
> -		goto read_super_error;
> +		goto out_super;
>  
>  	sb->s_magic = OCFS2_SUPER_MAGIC;
>  
> @@ -1041,7 +1040,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  			status = -EACCES;
>  			mlog(ML_ERROR, "Readonly device detected but readonly "
>  			     "mount was not specified.\n");
> -			goto read_super_error;
> +			goto out_super;
>  		}
>  
>  		/* You should not be able to start a local heartbeat
> @@ -1050,7 +1049,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  			status = -EROFS;
>  			mlog(ML_ERROR, "Local heartbeat specified on readonly "
>  			     "device.\n");
> -			goto read_super_error;
> +			goto out_super;
>  		}
>  
>  		status = ocfs2_check_journals_nolocks(osb);
> @@ -1059,9 +1058,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  				mlog(ML_ERROR, "Recovery required on readonly "
>  				     "file system, but write access is "
>  				     "unavailable.\n");
> -			else
> -				mlog_errno(status);
> -			goto read_super_error;
> +			goto out_super;
>  		}
>  
>  		ocfs2_set_ro_flag(osb, 1);
> @@ -1077,10 +1074,8 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  	}
>  
>  	status = ocfs2_verify_heartbeat(osb);
> -	if (status < 0) {
> -		mlog_errno(status);
> -		goto read_super_error;
> -	}
> +	if (status < 0)
> +		goto out_super;
>  
>  	osb->osb_debug_root = debugfs_create_dir(osb->uuid_str,
>  						 ocfs2_debugfs_root);
> @@ -1094,15 +1089,14 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	status = ocfs2_mount_volume(sb);
>  	if (status < 0)
> -		goto read_super_error;
> +		goto out_debugfs;
>  
>  	if (osb->root_inode)
>  		inode = igrab(osb->root_inode);
>  
>  	if (!inode) {
>  		status = -EIO;
> -		mlog_errno(status);
> -		goto read_super_error;
> +		goto out_dismount;
>  	}
>  
>  	osb->osb_dev_kset = kset_create_and_add(sb->s_id, NULL,
> @@ -1110,7 +1104,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  	if (!osb->osb_dev_kset) {
>  		status = -ENOMEM;
>  		mlog(ML_ERROR, "Unable to create device kset %s.\n", sb->s_id);
> -		goto read_super_error;
> +		goto out_dismount;
>  	}
>  
>  	/* Create filecheck sysfs related directories/files at
> @@ -1119,14 +1113,13 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  		status = -ENOMEM;
>  		mlog(ML_ERROR, "Unable to create filecheck sysfs directory at "
>  			"/sys/fs/ocfs2/%s/filecheck.\n", sb->s_id);
> -		goto read_super_error;
> +		goto out_dismount;
>  	}
>  
>  	root = d_make_root(inode);
>  	if (!root) {
>  		status = -ENOMEM;
> -		mlog_errno(status);
> -		goto read_super_error;
> +		goto out_dismount;
>  	}
>  
>  	sb->s_root = root;
> @@ -1178,17 +1171,21 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	return status;
>  
> -read_super_error:
> -	brelse(bh);
> -
> -	if (status)
> -		mlog_errno(status);
> +out_dismount:
> +	atomic_set(&osb->vol_state, VOLUME_DISABLED);
> +	wake_up(&osb->osb_mount_event);
> +	ocfs2_dismount_volume(sb, 1);
> +	goto out;
>  
> -	if (osb) {
> -		atomic_set(&osb->vol_state, VOLUME_DISABLED);
> -		wake_up(&osb->osb_mount_event);
> -		ocfs2_dismount_volume(sb, 1);
> -	}
> +out_debugfs:
> +	debugfs_remove_recursive(osb->osb_debug_root);
> +out_super:
> +	ocfs2_release_system_inodes(osb);
> +	kfree(osb->recovery_map);
> +	ocfs2_delete_osb(osb);
> +	kfree(osb);
> +out:
> +	mlog_errno(status);
>  
>  	return status;
>  }

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
