Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC6ECC433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue, 12 Apr 2022 22:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=p1xeSwZ0g58nIZwtXZXQRw3gl2RHQOJRvdYjxBZqtmk=;
 b=ts8q8gjWxyXPO8AlOw/gqw41gBgsr98jMa7gTO8WFXCjDX8hbX0QE6iEa+tv8vfgcZd0jtUib+Q/
   N9XwrZE//BvXpUy3hTsdH0YP7u+RqBgHj7swieREvZUNtgeJRISgSjNyfLjsstOHntQvLt5ag5ai
   nKtM5b0kby7Bv0w930yPVIaZzbL/bUvGQsx9ez1SS20CfOGCa8JnOMA8HYFJJHDPfrsTmkTrpvBe
   UfKseqFVNtP3yFuzbBt8FptXfwqyVtAwtu9kyCj6UCE2kf1tkg43ORZdlU/ftECsXjU+3Q8H2ixC
   7qWeUlwHxGOI13ZEFtrYsCkCmF8YHZFyKCG3Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=p1xeSwZ0g58nIZwtXZXQRw3gl2RHQOJRvdYjxBZqtmk=;
 b=U0756R/Rq6z4swZyCspqNaoiw6K6pGbvNZTnr/HvgMuE3JJz40YNIhb3ItBKmAPCowayrZZC+Wfi
   m904hlz/bR1xOaAY4fhjYjj3+f8/0dHqWkSF1+41xXWVdK9YtzglqW5xgOqxR/SEeXlSfyQ5mHC2
   gZod6n1c4AG8TlkYo/t1bfBbzbDTaxM0PJvLzs9j4IYO1sPrpfnArzPvrBz3eH2yoS06GysniT13
   KXXE5BHEYsVNsKBSi5OQi+XGGMIMF+RaYWfgC7/FsFHGuws+Ij3Gy/xzMQ1XAAt6IflmWJFji4H3
   +hPU3LU93pQgNTqVmVtDkKwBEyM5K9wGKzin0w==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA9002E10RXZ300@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 12 Apr 2022 22:50:21 +0000 (GMT)
Message-id: <5bd3a683-b0bd-b6b9-32c0-b57026f109aa@linux.alibaba.com>
Date: Sat, 9 Apr 2022 21:46:19 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20220408103012.1419-1-heming.zhao@suse.com>
 <20220408103012.1419-5-heming.zhao@suse.com>
In-reply-to: <20220408103012.1419-5-heming.zhao@suse.com>
X-Source-IP: 115.124.30.44
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10312
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
 phishscore=0 clxscore=11 adultscore=0 bulkscore=0 priorityscore=30
 suspectscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204090092 domainage_hfrom=8395
Subject: Re: [Ocfs2-devel] [PATCH v1 4/5] ocfs2: ocfs2_mount_volume does
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R181e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0V9aYvFs_1649511979;
X-ServerName: out30-44.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: bCGw6uZeC5E-O-rd8yh-o-oEgXQHyteW
X-Proofpoint-GUID: bCGw6uZeC5E-O-rd8yh-o-oEgXQHyteW
Reporting-Meta:
 AAEfS/KUd3YHYld2GUUE4sJVQI58DB3iIRlsQQ5deOYRVipZF6Ge0i24D9jhqKbb
 5+c8GOFmdE4zCtjO36DD7OJrvLk9WOWY86l6qZYNOEgD//z2miJo5wRDCV0OaUOX
 uJDEdOETV/L1E1eagqTKAdtlPPHSgSw1oK2kyEqRAaiqYpkPPYwV+BGqKZn4P46+
 Ih/r1TAN4nZUUbxuGN30kPutCw+ZvaFFJgpgpaRUOBz305gZoZtWA7cJgg5lgnpV
 3YHeyMzaSp4kBw8q2pFHlkPJ5FYorsuCAAatOC0/Iw4L1GXvCt0PhsdP7Mxnl3AX
 d2iOzoIp2EH43HvnVbgRZExkJF1iGfxcW03M1JsVX7KZ+lHFNQmIPMfov4jEU5AP
 Y/l24VKXOKVOuL4+EP0VvXVbSoLlOadlYGklU1Q8MkWyBCFUFRx1ULJWUkMtdpgO
 8r+mORr86QhJr5FuDdT8Qpy6cAxSlsyVq8AnCp6xi7VJUlKIW0S5Kt0aTAnB63Nt
 mcjbyWBQ8kq52JheTB070C7ZPLMecKTm7FluiuQ/9f4U



On 4/8/22 6:30 PM, Heming Zhao wrote:
> After this patch, when error, ocfs2_fill_super doesn't take care to
> release resources which are allocated in ocfs2_mount_volume.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/super.c | 32 ++++++++++++++++++++------------
>  1 file changed, 20 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 8443ba031dec..d4b7a29cb364 100644
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
> @@ -1817,44 +1816,53 @@ static int ocfs2_mount_volume(struct super_block *sb)
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
> +		goto out_journal_shutdown;

ocfs2_check_volume() not only does journal initialization,
but also local alloc.

> +	}
>  
> -leave:
> -	if (unlock_super)
> -		ocfs2_super_unlock(osb, 1);
> +	ocfs2_super_unlock(osb, 1);
> +	return status;
Explicitly return 0 may be better, which means this is the
normal path.

Thanks,
Joseph

>
> +out_journal_shutdown:
> +	ocfs2_journal_shutdown(osb);
> +out_system_inodes:
> +	ocfs2_release_system_inodes(osb);
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
