Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B555C433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed, 13 Apr 2022 13:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=j153zaxPMazB+mXVyPirqNv02KWbbhYxy3Vyp51xSoM=;
 b=pnnas/vEFrUUu33iUqWJtaU+J6aF643+vJQadCQNYS0ZmSxv4Q02O1NnvdzI2WCDoEoeawjIPvb4
   gjxtm7n/ObyepfgIA4o/jbwshs75/y7482Yp765Keli1rwOSPO7+v7OD/aveLwicma3+8bKXsWdI
   vCxX4BjRD5ra1/sUF//3juHByuyU9r8PtJVf6NVTT6dRNWefuc1PGya8AbNveWyLgSAQBXCnBj95
   oT+9GfLrPNxoGCbbr/vY3m83CDPxdVwJZKCtmOFdvFyLhZE7AlD45q9Th3O81378oWo758k8Jj4c
   yX64IEZZ4TJOG0t4zmL8Sqs5GHv4Sc3Ly8Rm6g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=j153zaxPMazB+mXVyPirqNv02KWbbhYxy3Vyp51xSoM=;
 b=NLCh+hmmswsqJOipWgYqrA3hISSCt7klAn953A/0D3mEae1AMsbmmuWHlJ8PKjMvdbGAFWd/3MVW
   u4vTVS2/FY98ORI38IIk4NPP1YMLrG0mG1PCm3IppYPFEqqh+/0yIJ/K0Vg+zQUlVGjz/wzdgxDU
   Y/6vpoJLCK1C6MNQtM81vIRMppbFQ0DgUO7lZBJT52epwjj2z43F9iA9x4JjAnwWsgbqHP1Lt1WF
   Cd89S1hLo79Zm8dshfwizB2i/EWP613yhS5PbZyhdfDNLwx89EY46/EsOyvuipbWi6Tl+umQVH1o
   TAQcMXmW6LIG3h3IFTpylFETZOEAaP65IYdpXg==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAA00GV96G09Y70@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 13 Apr 2022 13:50:24 +0000 (GMT)
Message-id: <dcceb610-3c1b-d46c-493b-c836317e6d4b@linux.alibaba.com>
Date: Wed, 13 Apr 2022 19:37:59 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20220413082957.28774-1-heming.zhao@suse.com>
 <20220413082957.28774-6-heming.zhao@suse.com>
In-reply-to: <20220413082957.28774-6-heming.zhao@suse.com>
X-Source-IP: 115.124.30.130
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10315
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 clxscore=119 mlxlogscore=999 lowpriorityscore=0 adultscore=0 bulkscore=0
 phishscore=0 priorityscore=30 spamscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204130063 domainage_hfrom=8399
Subject: Re: [Ocfs2-devel] [PATCH v2 5/5] ocfs2: rewrite error handling of
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R211e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04395;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0V9zYtdA_1649849879;
X-ServerName: out30-130.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 2toCdX-MJijzhJGNiO3kShf0_MplzRPI
X-Proofpoint-GUID: 2toCdX-MJijzhJGNiO3kShf0_MplzRPI
Reporting-Meta:
 AAFlXPWGD5eKB91uR0e73AjaDAsScpunomaRcCTkbc2kiJQAd5Mxn9pPzTvQun/l
 NTMLIupS+pkQj4iYDMPFS9kqSOGYEM5w4pBY+5F2AshzljfNA0pRolSYLSGGCUyN
 M8pfQTxa53yvR/KLcSUpXLhi3SDwLyAIcy3R5H2Xz3skil2fSVBiTmcFrT8PsIQu
 DOR98lN3M/MyJZ//CfXQSW/JsBysBOP0WKKXvUvIfu6/I+5GsW3zG3T2GOQFlXw8
 RERhMyerjirYHXrsnOnUL9IddpGE4wPGyx+a0EfAGXw0WomdJDdcU0u1PiCvoFwG
 NmlOFxD6oIMYtK0eBOCToNEaxwJTOSRC+k0NNiC6LRysq1boEBjX0W+KLZOP4cV+
 rn/rsPs++ht8Mry9hcRCp6SgRjQjayJ+dQcObZ4IENRf3eOz6YjqiOe3nN6/pFwu
 Pe7fzII3piIB4n7uVvp4ez0iUFvpuvaqdC8Os/0WhaHiSYpmca6ofMWDe7w7uISj
 oG3qZJfXjBedvysusqDdTIQyFTOkzF3EoUi+W7pD+xOr

It mostly looks good to me.
Have you done error injection test after this patchset applied?
I'm afraid ocfs2-test can't cover this as of now.

Thanks,
Joseph

On 4/13/22 4:29 PM, Heming Zhao wrote:
> Current ocfs2_fill_super() uses one goto label "read_super_error" to
> handle all error cases. And with previous serial patches, the error
> handling should fork more branches to handle different error cases.
> This patch rewrite the error handling of ocfs2_fill_super.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/super.c | 67 +++++++++++++++++++++++-------------------------
>  1 file changed, 32 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 5e860d7162d7..72673d40d29c 100644
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
