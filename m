Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9C44C433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed, 13 Apr 2022 13:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=StYfFsN1ail6aWIPitX7M6xuok62kWeYcbBsBikFmCI=;
 b=2xy27AOUNFYPqBsJamewa9Sa5sYSIrbTo0rASDu48tpTQze6A/4Ae1fYeDYZq8AQiR16+ipb9PhM
   43zvEa5IGPb9bVfdESpoySS9RN6jnWGEaDoCb11BqIkpi6JRzV2pfsFRyxjQeWm2L7gVZcXN7B9D
   fwpD2jct0GmtbjTKLaQMYAjbPU1CP5zoFfHCNrUx5/u4BAbrvtJCTkYU7LWxrWjjl3rspfN01g9j
   X7TVvT0qzRrFgQOV4RZCnJ0OZC659Xiu8RvBhEUqo2ERhk5xof7rAz8g4By16JWVptjTbX4FnX/e
   vAMRDDr65a/37LlNgOGcETJ2eaBJFe2Pm+vC+A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=StYfFsN1ail6aWIPitX7M6xuok62kWeYcbBsBikFmCI=;
 b=foCGMH8RJ5q2TB9kBhoYV8HirGlkGMacCHnsCY5XB2Yh3PipgxKcvAjKibmiAuDjEbGkqVY6mPle
   GBTpfZVCOEUVOy4T+tgW3VQzl6QpSO21LhyHbv4CAjTKY6LoHsHtWFlm2H/XvVG7hUyHjynVR5GU
   wyvLrHNV5u4QNGYa6YAbolBq30CBtWkGr5itX3cfYxR45DNY+7Y1vjDaI2z4TeI2OhXRIUfbKg1g
   tLxQy9oiTwedzSEO196zhj7fZtddynA7CMRhl+CVTyYFaXodHDJVIgGok3Qj+G7itJqvEyNszbz8
   o7Qq4Hp8ybGOQEI0MZyYNjD37ks0Obs598foYA==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAA00N266DOLQB0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 13 Apr 2022 13:49:00 +0000 (GMT)
Message-id: <283d3a96-67e8-6abf-3b38-151082f30f27@linux.alibaba.com>
Date: Wed, 13 Apr 2022 19:25:03 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20220413082957.28774-1-heming.zhao@suse.com>
 <20220413082957.28774-5-heming.zhao@suse.com>
In-reply-to: <20220413082957.28774-5-heming.zhao@suse.com>
X-Source-IP: 115.124.30.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10315
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 malwarescore=0 suspectscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=999 clxscore=-14 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204130062 domainage_hfrom=8399
Subject: Re: [Ocfs2-devel] [PATCH v2 4/5] ocfs2: ocfs2_mount_volume does
 cleanup job before return error
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
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04357;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0V9zdM4u_1649849103;
X-ServerName: out30-133.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: NuvASQwvTKm6go6BD9d9oxG945IPqbCR
X-Proofpoint-GUID: NuvASQwvTKm6go6BD9d9oxG945IPqbCR
Reporting-Meta:
 AAGJshq6bVlt3S2xdj4TIKB3gUK0jJsMQT8LEkTO7S96cWCO2SG9ujnajdDcjOMz
 DaUB+w70LXncxZDrvfj4IrnkPeBqRoH0wfsCQagiNFUkaaFxVEV+7vkbTh/Oo1kn
 6JQK8Gf9XxrMuQ1yzrPRIT7SROdYWe0vhDlR+xi5vMSTZs3P7jP+2y7mle6WSlom
 80Ex0mNo5II/z7vwo3CWrl68xX8Y2wmMSi9KYSO2Lx2KJQvDsJcBOBDPIa4bsi1Y
 huXxMiujY0n7mIAdZPC7oRnZlm4vAIXuvkmI9nyMFUTpx39/9/400Nhfl2iCJFSB
 WgZY6IpPDNyPPpsaZ0gIjYCsTGIazMeFmqVU6zZiayAW73H9NZ1/kNZAFVP8v/cv
 cijeCaeskMenEIVAQhWIA7Es6O2haLHctlmw8QrLXhnHtbU6X4UuCCVqXkB2XHcw
 qCfN7xEDUB0MdnBkIomUnLyH7JnuAvjsKxCJ33Tl+i+bVbVdUbVkUOHgAm9li8Fn
 uTdwpHP/dCY5DP8CicasGoz9MwE2ZsncfI+ivHJSub9X



On 4/13/22 4:29 PM, Heming Zhao wrote:
> After this patch, when error, ocfs2_fill_super doesn't take care to
> release resources which are allocated in ocfs2_mount_volume.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/super.c | 42 +++++++++++++++++++++++++++---------------
>  1 file changed, 27 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 4302c3e9598c..5e860d7162d7 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1803,11 +1803,10 @@ static int ocfs2_get_sector(struct super_block *sb,
>  static int ocfs2_mount_volume(struct super_block *sb)
>  {
>  	int status = 0;
> -	int unlock_super = 0;
>  	struct ocfs2_super *osb = OCFS2_SB(sb);
>  
>  	if (ocfs2_is_hard_readonly(osb))
> -		goto leave;
> +		goto out;
>  
>  	mutex_init(&osb->obs_trim_fs_mutex);
>  
> @@ -1817,44 +1816,54 @@ static int ocfs2_mount_volume(struct super_block *sb)
>  		if (status == -EBADR && ocfs2_userspace_stack(osb))
>  			mlog(ML_ERROR, "couldn't mount because cluster name on"
>  			" disk does not match the running cluster name.\n");
> -		goto leave;
> +		goto out;
>  	}
>  
>  	status = ocfs2_super_lock(osb, 1);
>  	if (status < 0) {
>  		mlog_errno(status);
> -		goto leave;
> +		goto out_dlm;
>  	}
> -	unlock_super = 1;
>  
>  	/* This will load up the node map and add ourselves to it. */
>  	status = ocfs2_find_slot(osb);
>  	if (status < 0) {
>  		mlog_errno(status);
> -		goto leave;
> +		goto out_super_lock;
>  	}
>  
>  	/* load all node-local system inodes */
>  	status = ocfs2_init_local_system_inodes(osb);
>  	if (status < 0) {
>  		mlog_errno(status);
> -		goto leave;
> +		goto out_super_lock;
>  	}
>  
>  	status = ocfs2_check_volume(osb);
>  	if (status < 0) {
>  		mlog_errno(status);
> -		goto leave;
> +		goto out_system_inodes;
>  	}
>  
>  	status = ocfs2_truncate_log_init(osb);
> -	if (status < 0)
> +	if (status < 0) {
>  		mlog_errno(status);
> +		goto out_system_inodes;
> +	}
>  
> -leave:
> -	if (unlock_super)
> -		ocfs2_super_unlock(osb, 1);
> +	ocfs2_super_unlock(osb, 1);
> +	return 0;
>  
> +out_system_inodes:
> +	if (osb->local_alloc_state == OCFS2_LA_ENABLED)
> +		ocfs2_shutdown_local_alloc(osb);
> +	ocfs2_release_system_inodes(osb);
> +	ocfs2_journal_shutdown(osb);
> +out_super_lock:
> +	ocfs2_super_unlock(osb, 1);
> +out_dlm:
> +	ocfs2_dlm_shutdown(osb, 0);
> +out:
>  	return status;
>  }
>  
> @@ -2393,14 +2402,17 @@ static int ocfs2_verify_volume(struct ocfs2_dinode *di,
>  	return status;
>  }
>  
> +/*
> + * If this function returns failure, caller responds to release
> + * here alloced resources.
> + */
>  static int ocfs2_check_volume(struct ocfs2_super *osb)
>  {
>  	int status;
>  	int dirty;
>  	int local;
> -	struct ocfs2_dinode *local_alloc = NULL; /* only used if we
> -						  * recover
> -						  * ourselves. */
> +    /* only used if we recover ourselves. */

Malformed. Actually I don't think we have to touch this function.

Thanks,
Joseph

> +	struct ocfs2_dinode *local_alloc = NULL;
>  
>  	/* Init our journal object. */
>  	status = ocfs2_journal_init(osb, &dirty);

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
