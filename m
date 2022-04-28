Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E1EFC433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Apr 2022 11:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9fd6Zx6hf3soYPx3AwEf+OhdFe1YOYLbPCp6o0XSSCk=;
 b=YP/1UHqYcOYwwGz5DT+TQH92ACH88wT22hQJyrAHrTdAHwyoxhirmPi5aeHLixwjgmNQy/IUlGPZ
   X9fQfCw7YlKb5Z7OfvYsZ2X9grfQFWXG2PNEjw4r9GlFdVMDf2qJGsATMD6eFWeQLzDicuIF1Swz
   PY5wZDWx1JFjhWq2p2+UY3/D9omL/C/scmm5aCsYuTbsQWuvofPpOvRzuRA9uURtX2T7vXpX7Zyq
   9G7CIfZUU5YN9DnmcqBkJRavY4IDvTSXXUdWI639uPMopaRkJ27ZND+DXnIS7VFnJcd4O6cia5DO
   wcfkptsFPzlX0XcCkVj1R4lqaMiiaG3AfLp/GQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9fd6Zx6hf3soYPx3AwEf+OhdFe1YOYLbPCp6o0XSSCk=;
 b=r83ll1kfJbOozkE42VnD+O9yNe4v6LX3UiZ2C74PfO35CA+3HqJEqDefbnHDyvzxOKFZf1h5AI7o
   oR+fl+yF5oSu7zAdXTdUWOdogLNszDjWXw0p5cZAOVA/hBGU6p872SCwkwF7hDcMJSXiUU8qtXFZ
   isC4w2bQ1YYJcxyTaj08Fejnb3XRuRbOvd3JeHby96mvjAdBG0WwoMZUmwpBCKw1AAjg9liggTX6
   9jPIk9CrB/B6ucqFfB3//15mP/+MrSMB1LinMJ7jLNCrFob8z+veqh2xMrRookrW5yp9+6xr7rSm
   M/rFaF5Q6E22WNzOsbxuIPIMEf16etUzhbyWMQ==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RB100D9YSNIA920@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 28 Apr 2022 11:45:18 +0000 (GMT)
Message-id: <5457b8fb-2915-1db0-63ca-e3f53ef74d99@linux.alibaba.com>
Date: Thu, 28 Apr 2022 19:44:59 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com,
 akpm <akpm@linux-foundation.org>
References: <20220424130952.2436-1-heming.zhao@suse.com>
 <20220424130952.2436-5-heming.zhao@suse.com>
In-reply-to: <20220424130952.2436-5-heming.zhao@suse.com>
X-Source-IP: 47.90.199.4
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10330
 signatures=694622
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 priorityscore=0 bulkscore=0 mlxscore=0 adultscore=0
 clxscore=49 spamscore=0 impostorscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280072 domainage_hfrom=8414
Subject: Re: [Ocfs2-devel] [PATCH v3 4/5] ocfs2: ocfs2_mount_volume does
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R101e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04357;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0VBah.6E_1651146299;
X-ServerName: out199-4.us.a.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: pgSyY3orEguVqXJmQ1VRQRmwNjhKdnEe
X-Proofpoint-GUID: pgSyY3orEguVqXJmQ1VRQRmwNjhKdnEe
Reporting-Meta:
 AAHz+cmyrjfHqN5fBwuj0cSaSs7MLRYyqVdPmzpYLy+RAVFd1T3s3f4PCuK4UTHg
 YjoByyO19EDbxKM+bC71w2o+v5J/03teVzdRkb4oiXE7Y4sR6ZCH7t8ivfJEZfs1
 huYnvbP4tZnYkw0/2VsCsy/J+s7zWhvjsT9JoBRubNEi/ZCHkOFZUdCwT6ughM8E
 cyLojvsCYo0eaJ+2PlZmBamvdak+q4kxTCCgjlODafsGtVWCSoOKNnWoXf3cyBpO
 uF5BU/jas8RP1OM/ovPh9KYFuw6LDLPQ642CjbT/RpIuYnn0Ro3Abj1Iub4nS6dq
 Silow5JPSfnc0EScniUU9e5RDtOJjkJJjEv+4NOenUnF0aC3EHSy55nhRomx2a10
 +elpZi0wxfygkIGG1xR6MlggankHOy0PNgChZOu3ZpQz/cX5xi4yHPTfxlGcbdsO
 q91vRI9Ihn/btD4yR3UQ7fq6gz8m+dviJYW9DdnfCXtLTzSqOAY1f+O958ga3zcS
 8v1bB6/JJTYOygd7feLTZGImHOGY4+sjp8Of/Mjpp5Q=



On 4/24/22 9:09 PM, Heming Zhao wrote:
> After this patch, when error, ocfs2_fill_super doesn't take care to
> release resources which are allocated in ocfs2_mount_volume.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/super.c | 35 +++++++++++++++++++++++------------
>  1 file changed, 23 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 758ea3313f88..1cf18ed8cf1b 100644
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
> @@ -1817,44 +1816,56 @@ static int ocfs2_mount_volume(struct super_block *sb)
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
> +	/* before journal shutdown, we should release slot_info */
> +	ocfs2_free_slot_info(osb);
> +	ocfs2_journal_shutdown(osb);
> +out_super_lock:
> +	ocfs2_super_unlock(osb, 1);
> +out_dlm:
> +	ocfs2_dlm_shutdown(osb, 0);
> +out:
>  	return status;
>  }
>  

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
