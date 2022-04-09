Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99B97C433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon, 11 Apr 2022 08:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=wWGXKkmIwkqoVa+DQ+l+K9r3Iy4G2g3lDS1lnTnmlys=;
 b=K1I4iMK2D1nLE6hehPyXeMMi/uHUB4r2g0vYyr1yrYPUOhzhzrklTdcKO0nCOcIE+mo2uT6dXVz8
   b4KRDuseCOhxwA7x9B2irE3bx/3+ZSGA32+KpyE3rGgvURTd1ySKZjztJVN2DFPryvCdCZ37EF7P
   PICjWpXYzzNSstabEg8KmsyHmFSEx9qxV9D5E1168kJNabklm3QGYV6KOs37+wScXe216lU2tpbp
   HDt691AHMUlnjQVYlH6llNR8+GmEm/7CdCOiMEeqtCJylAz/cWPPBMQHjqun2sX8H81ro+XcUOc3
   sPXVNWPVwg8ah1HLEhqyA6gcdQnbfLEtFsQbdg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=wWGXKkmIwkqoVa+DQ+l+K9r3Iy4G2g3lDS1lnTnmlys=;
 b=KvsCoJyhlU+PwzdwsKCpkSRtdWbKKdAv9TdJlJ1cTJtYcy05OJklEVEWp58bMlYEzwujfv//DaQY
   zwOISEFvwOQoqgBCdQ9/EvrSgBipho5fc0EezAaE7eY7CPLP7+ZSmv249kYXQ6qYPOdwxSS/4VuJ
   ufW/JVzfezGMTgxfrQS8xZxIm+BFKWnmwYUrANg78CmY8neS13ISzSGDKQ3O9da30IF22Xxxrxm6
   G+cxoiyHFk5ewMipMx4abxOt0cm0+CmhqxPYdakU+UcLgUnlNy4UDa1Bu4KCDFwm4Bitmb/lYy33
   2Y5fEo5mTJjas/QT07v7rx4/yDoxlplXFgMFQw==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA600M121FZWS20@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 11 Apr 2022 08:11:59 +0000 (GMT)
Message-id: <c917d4bf-3405-08b5-41a3-60579733fde1@linux.alibaba.com>
Date: Sat, 9 Apr 2022 22:02:16 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20220408103012.1419-1-heming.zhao@suse.com>
 <20220408103012.1419-6-heming.zhao@suse.com>
In-reply-to: <20220408103012.1419-6-heming.zhao@suse.com>
X-Source-IP: 115.124.30.45
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10312
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 clxscore=47 lowpriorityscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 priorityscore=95
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204090094 domainage_hfrom=8395
Subject: Re: [Ocfs2-devel] [PATCH v1 5/5] ocfs2: rewrite error handling of
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R181e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04357;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0V9aU5m1_1649512936;
X-ServerName: out30-45.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: llvy53wS6K59tVLVy1lHf-iTy4ocr6D9
X-Proofpoint-GUID: llvy53wS6K59tVLVy1lHf-iTy4ocr6D9
Reporting-Meta:
 AAEXJPEe5fxAJu1qhY6lT/OfZctz4ra6H2uizssuLyP9P3toHV8uKmtDKXBCmY2o
 xciKFVL2I+Uf08fxVDerDRpqIORVKdJNQwfULeonv7bxPAR8aYPJyJWRu5mak4N5
 vrIJBAQFkz4xopjKIkW/QFn66jVElS0ZjE1pzVpcaFDze4siYJ+0sWIu4C/EeaoQ
 alxQZBqWrjmmw/4erP5G0h8TrlQi2FCSMnXomSCkmvpgIza35AcTCLoykxPTXFJ2
 eu1hA8cEdBq3IlGu6hMbFSWM4OtYCHmMtq1l6sk5ia5rWvXGY54IWl4Ll0/mKhvU
 4muDFAQW1f4OZm1p50KjOKCZURsmAkPGnqO6fyfCk01oNMRtX0M0qzAXFzEK+Kqk
 W9RIbzaFmnnzH6YzOyCzlWQhGjbOEBreXfXbr67fdsxp4h8PFEKscJjZrwDjDcmC
 au7I0dlgVJuClMAArYgTj3/E5UPnDp+pw00nM7fjZ2GBA7BfXH7DPSB6Q2yylyzH
 MWUK7snrKS4uYpeWWA49F3SP/cxrYCKroQ99SqqBVyzvcw==



On 4/8/22 6:30 PM, Heming Zhao wrote:
> current ocfs2_fill_super error handling is very simple, and includes
> kernel crash possibility.
> 
> e.g.
> 
> ocfs2_fill_super
>   ocfs2_initialize_super // fails in check max_slots & return
> 
> Then osb->osb_mount_event is not properly initialized, and then will
> crash at wake_up(&osb->osb_mount_event) in goto label read_super_error.
> 
With patch 3, this case won't exist any more.

> For fixing the issue and enhancing error handling, we rewrite error
> handling of ocfs2_fill_super.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/super.c | 67 ++++++++++++++++++++++++------------------------
>  1 file changed, 33 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index d4b7a29cb364..c3efd9ad49ac 100644
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
> +		goto out_journal;
>  	}
>  
>  	osb->osb_dev_kset = kset_create_and_add(sb->s_id, NULL,
> @@ -1110,7 +1104,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  	if (!osb->osb_dev_kset) {
>  		status = -ENOMEM;
>  		mlog(ML_ERROR, "Unable to create device kset %s.\n", sb->s_id);
> -		goto read_super_error;
> +		goto out_journal;
>  	}
>  
>  	/* Create filecheck sysfs related directories/files at
> @@ -1119,14 +1113,13 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  		status = -ENOMEM;
>  		mlog(ML_ERROR, "Unable to create filecheck sysfs directory at "
>  			"/sys/fs/ocfs2/%s/filecheck.\n", sb->s_id);
> -		goto read_super_error;
> +		goto out_journal;
>  	}
>  
>  	root = d_make_root(inode);
>  	if (!root) {
>  		status = -ENOMEM;
> -		mlog_errno(status);
> -		goto read_super_error;
> +		goto out_journal;
>  	}
>  
>  	sb->s_root = root;
> @@ -1178,17 +1171,23 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	return status;
>  
> -read_super_error:
> -	brelse(bh);
> +out_journal:

rename it to out_dismount?

> +	mlog_errno(status);
> +	atomic_set(&osb->vol_state, VOLUME_DISABLED);
> +	wake_up(&osb->osb_mount_event);
> +	ocfs2_dismount_volume(sb, 1);
>  
> -	if (status)
> -		mlog_errno(status);
> +	return status;

Or remove mlog_errno() before and then just goto out?

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

Seems we have to take care all resources in ocfs2_initialize_super()?

> +out:
> +	mlog_errno(status);
>  
As I described in your previous mail, ocfs2_sb_probe() may return error
with non-NULL bh, so we should brelse here.

Thanks,
Joseph

>  	return status;
>  }

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
