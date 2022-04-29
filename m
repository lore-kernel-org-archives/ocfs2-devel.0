Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CC99C433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri, 29 Apr 2022 02:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=NGqP3UKdroxxmH0n5hEeciddHCFExEtTHYhXtO9jzYM=;
 b=UbRs+ldLjHL1SxPvnfRwXWQgRQgkab0CKixqJXTorKusNYs4BHjwtjMFNbE8LsGPsE4LZx4XQ5HQ
   FGpv9nqCbzAd1qk7jXqw4HWyuMs1hwGMwb8ENB8yEmkimn+QVwA6/XcwS9ORV9jkAInaSDoKCOoQ
   bl2lXPfDdcFzsQbbq2423nsOpAG0pc9p9Yjz9w5dA8biYqsNg3fcUHkZfRXXWAv8NzPrcNKTapB7
   jmY+lzF54Izv081bpmEayVfGDMx41d1+w0KkXdcod/sQSRHVABLkavdkf9Z0Yssvq0r/h+ojMRzo
   kSUbtZe1lbVEvC3Z9ssT3C1hXn+LX5z62CrA4g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=NGqP3UKdroxxmH0n5hEeciddHCFExEtTHYhXtO9jzYM=;
 b=foiIUp7xmGAwMY+JQP9n2xAGaXaykspLVIpeGhBzI13Zo0zeT/W5/U1nPRD/gKrP+Zrmb8RYUQkd
   J8jBRE/0x6IJiNp0ou+z4BLoG3SJCtDjwphBNDfVLTgpMW3KL5Mt42q1ZhWIhzzF6CMty0AeF7Wb
   sbqLdcopAFO0IGaCZwFJeKNpyKDlS2fhALqwH2TvVUWuhkKYmjs+wpQqt0NL8vUALaQz2AKmSzxi
   1QSAAi7JAG2XBuEUKxPDiOpvy68wwo9yx5RF9Hwke+5u9VsDKIMHY2HNFqnzdouCGeKkiZp3sB10
   Sca8gqstHHvyONlFORAHqxAxgqaw9p7jNidrIw==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RB200EM6YFKXO20@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 29 Apr 2022 02:47:44 +0000 (GMT)
Message-id: <e868e056-1fb2-eb82-f98e-121c66f80e38@linux.alibaba.com>
Date: Fri, 29 Apr 2022 10:47:25 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-language: en-US
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 piaojun@huawei.com, mark@fasheh.com, junxiao.bi@oracle.com,
 jlbec@evilplan.org, heming.zhao@suse.com, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com
References: <20220428220012.34FD2C385A9@smtp.kernel.org>
In-reply-to: <20220428220012.34FD2C385A9@smtp.kernel.org>
X-Source-IP: 115.124.30.131
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10331
 signatures=591664
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=134
 bulkscore=0 phishscore=0 adultscore=0 priorityscore=90 mlxscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204290012 domainage_hfrom=8415
Subject: Re: [Ocfs2-devel] +
 ocfs2-rewrite-error-handling-of-ocfs2_fill_super.patch added to -mm tree
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R111e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04357;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=10; SR=0;
 TI=SMTPD_---0VBf.tfb_1651200445;
X-ServerName: out30-131.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: A0-Bo2rdlCFT0E3_FmHjAdG01vrqWjae
X-Proofpoint-GUID: A0-Bo2rdlCFT0E3_FmHjAdG01vrqWjae
Reporting-Meta:
 AAHUBiEeue7ceQftLIiCbx18QfIxF1HY5V1sAJBxS+U9/ePdHf1ZvqZXbOzdavn2
 LLxJKXq+W6htsuA7Q03rt5rq+nEYnA5LwErF+mk3pMqkzZpX9HTJglLv0v2SO8Hr
 hcHIcjClBjVFrxu7lmN5tpX2S/MfbAB0l4HvYE13RI6CctUdt+256l3Ahasf4h/4
 wNOR78/u2WE/S2YMx+Pwj4eUJvJZA21Ugj3oa9Cgz0S/lKQOqsnqV9ynx7xLBRkw
 PonJODUV0pm9Mkdre9e+S+LZACSyD2z0uBt67rtx3RMpAO4TPuNRAkMzHWmHH4bv
 0PhCc8t9331HXA2199E9ZyeLLQmnk48nV9kku9A599Ig98hXkiimYDktf1kjyCET
 GOky/bvOM/QuRZNOpjQUfFig7yQdUZE8UwQFEP3KpCM035GoYVDRdmrTIcuZMrkC
 Xcwnx0bF1kVURUbLsxUFzwhGaAfHLAob9xV52AXXWlRAL0ZbfHmnAw8beSl0bbwk
 k0yoIdiffanBfGaZ9YyiPMdJp0C6YNxFN3RdYH0hXRbc



On 4/29/22 6:00 AM, Andrew Morton wrote:
> The patch titled
>      Subject: ocfs2: rewrite error handling of ocfs2_fill_super
> has been added to the -mm tree.  Its filename is
>      ocfs2-rewrite-error-handling-of-ocfs2_fill_super.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-rewrite-error-handling-of-ocfs2_fill_super.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-rewrite-error-handling-of-ocfs2_fill_super.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
> Subject: ocfs2: rewrite error handling of ocfs2_fill_super
> 
> Current ocfs2_fill_super() uses one goto label "read_super_error" to
> handle all error cases.  And with previous serial patches, the error
> handling should fork more branches to handle different error cases.  This
> patch rewrite the error handling of ocfs2_fill_super.
> 
> Link: https://lkml.kernel.org/r/20220424130952.2436-6-heming.zhao@suse.com
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> Cc: Changwei Ge <gechangwei@live.cn>
> Cc: Gang He <ghe@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Joseph Qi <joseph.qi@linux.alibaba.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> Cc: Jun Piao <piaojun@huawei.com>
> Cc: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: Mark Fasheh <mark@fasheh.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/ocfs2/super.c |   67 +++++++++++++++++++++------------------------
>  1 file changed, 32 insertions(+), 35 deletions(-)
> 
> --- a/fs/ocfs2/super.c~ocfs2-rewrite-error-handling-of-ocfs2_fill_super
> +++ a/fs/ocfs2/super.c
> @@ -989,28 +989,27 @@ static int ocfs2_fill_super(struct super
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
> @@ -1027,7 +1026,7 @@ static int ocfs2_fill_super(struct super
>  
>  	status = ocfs2_verify_userspace_stack(osb, &parsed_options);
>  	if (status)
> -		goto read_super_error;
> +		goto out_super;
>  
>  	sb->s_magic = OCFS2_SUPER_MAGIC;
>  
> @@ -1041,7 +1040,7 @@ static int ocfs2_fill_super(struct super
>  			status = -EACCES;
>  			mlog(ML_ERROR, "Readonly device detected but readonly "
>  			     "mount was not specified.\n");
> -			goto read_super_error;
> +			goto out_super;
>  		}
>  
>  		/* You should not be able to start a local heartbeat
> @@ -1050,7 +1049,7 @@ static int ocfs2_fill_super(struct super
>  			status = -EROFS;
>  			mlog(ML_ERROR, "Local heartbeat specified on readonly "
>  			     "device.\n");
> -			goto read_super_error;
> +			goto out_super;
>  		}
>  
>  		status = ocfs2_check_journals_nolocks(osb);
> @@ -1059,9 +1058,7 @@ static int ocfs2_fill_super(struct super
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
> @@ -1077,10 +1074,8 @@ static int ocfs2_fill_super(struct super
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
> @@ -1094,15 +1089,14 @@ static int ocfs2_fill_super(struct super
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
> @@ -1110,7 +1104,7 @@ static int ocfs2_fill_super(struct super
>  	if (!osb->osb_dev_kset) {
>  		status = -ENOMEM;
>  		mlog(ML_ERROR, "Unable to create device kset %s.\n", sb->s_id);
> -		goto read_super_error;
> +		goto out_dismount;
>  	}
>  
>  	/* Create filecheck sysfs related directories/files at
> @@ -1119,14 +1113,13 @@ static int ocfs2_fill_super(struct super
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
> @@ -1178,17 +1171,21 @@ static int ocfs2_fill_super(struct super
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
> _
> 
> Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are
> 
> ocfs2-fix-mounting-crash-if-journal-is-not-alloced.patch
> ocfs2-change-return-type-of-ocfs2_resmap_init.patch
> ocfs2-ocfs2_initialize_super-does-cleanup-job-before-return-error.patch
> ocfs2-ocfs2_mount_volume-does-cleanup-job-before-return-error.patch
> ocfs2-rewrite-error-handling-of-ocfs2_fill_super.patch

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
