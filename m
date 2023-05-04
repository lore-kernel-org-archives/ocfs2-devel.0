Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63226C77B75
	for <ocfs2-devel@archiver.kernel.org>; Thu,  4 May 2023 02:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XvIKja44+iF6A6nXHhqdTK/OPbhuKzRavQAPHroVjNs=;
 b=Xbpbmjyc0hvQ9LwXNov8LDVAbWWhWdyyw0NZGa3upkj+U5hpthNvmF4pdxVckmaJRsOFD0QjQ3Xs
   GKyMEtkIOpPlRvFtlQ+HIAhvD2w8ioaBaHrHJ1DmXdlyz19uiwfy6ozF/IaifR3k5W9+QUjWXnIQ
   gdJKw6nkneKFc7bv1Y5XOP3zKYdnhnbyHqC/alTqrVQ8g+7wNVX427t0xdDEeRfgGyihNPBECx+n
   YpV1mVSpEglh+BaXjLDbDvqKpo8DGbhKHoac1Yb30QdHRUWQjnS1QKdU6IBDF8Xyr22Z9IsapQP6
   NwPlk+Nf5dTbruGt26w2G3qTu1D3qme3OoDFnA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XvIKja44+iF6A6nXHhqdTK/OPbhuKzRavQAPHroVjNs=;
 b=qVvzV994TD6M+TAGLVdNGvF9ngjL4GFqaEmoEOh1t8/0t4qTBTBqp3dUfPzgxV01QqOLHdJjyeR7
   R7WXBl3rgpUOZtakQNbbj9eVtFOQmfbu1VF22e6H1hhar6C96QFCOFDMK2JXpmllj4e/25g+QHw6
   qw+vgpmxvmb6csNbfJamNk+w4+AOgiXVMkoIrwqmLF9WJ5Vv1f6OnmdWjpKbGnTNDlUyTrD4hu0o
   aFaugCDzn8a0i6H4IsdnWLmmWHbgwi10KOpQ6hSeXhsyoQLuPgLqkegxr2jTyM6YPPsVFySWrYLZ
   bObRHKW7MqYrDtW7WVSgOiiZjor+ov5bzva0HA==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RU40005B46UIUC0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 04 May 2023 02:28:06 +0000 (GMT)
Message-id: <5b3e7709-3a5e-d9bc-0e78-edc28b529d6e@linux.alibaba.com>
Date: Thu, 4 May 2023 10:27:46 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>
References: <20230430031302.15597-1-heming.zhao@suse.com>
 <20230430031302.15597-2-heming.zhao@suse.com>
In-reply-to: <20230430031302.15597-2-heming.zhao@suse.com>
X-Source-IP: 115.124.30.97
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10699
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 priorityscore=0
 clxscore=22 bulkscore=0 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2305040018 domainage_hfrom=8785
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 2/2] ocfs2: add error handling path when jbd2
 enter ABORT status
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R281e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046049;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0Vhap5oS_1683167266;
X-ServerName: out30-97.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: QEWYW9Jm4MYSaJ0fGX4Wu-12fPozfETd
X-Proofpoint-ORIG-GUID: QEWYW9Jm4MYSaJ0fGX4Wu-12fPozfETd
Reporting-Meta:
 AAGFENQaaLAoNQetH+5JUGKqPVbUjlZyx3EXTjXj54tqapuZHM/wGzF9o6F4x7EB
 +knq683AYTpZ957Jj+aliph+qYUZVWbIwaof7kkWLuasFT/kdhYgdogH4Qbwg5cz
 n3bU05E/Ay2jQ4F9kwLkeOEiKHxezxz4A7yKliRDUIHEPaW2bK7LXPhKQIaWybup
 o6qa6dpLvRQbpT0+PAh9v2EJ8F6EKFN6JLC+xwMDyGjWgPTtMiQE6Iz7SCLEwzNX
 bSIpHCAsqdgCUCfpXHnbm15MBmaGQeNM+sBYC4wg8t8llbolt/YCh7+Bgz4JHhJu
 HPviKhnZyCaAScyNDwAr+g75Hk33SEwkb0XRoBn7gvmjIS9pkXlfxxFRnnWyplJc
 XSMwVF0rwjzrJ9RZztCZZ3+EIrc56NNBfJqi1UIhjz5CVQuatse8Xwm7IfC4x8s7
 1S0jA0DIoey/DE8sNfi7ZKdVE3DB/KffMwp+jy8JyMzuvN2v+ReGXsFfMC1LQb4M
 1M+sDyZCw1PHbiCk6lBObNH9qskQgH2KI9c8ygc6NHY=



On 4/30/23 11:13 AM, Heming Zhao wrote:
> fstest generic cases 347 361 628 629 trigger a same issue:
> When jbd2 enter ABORT status, ocfs2 ignores it and keep going to commit
> journal.

What's the end user impact?

JBD2_ABORT indicates a fatal error happens, either in jounral layer or
filesystem. And we should not commit any further transactions.
It seems that we may unify the behavior like:

if (is_journal_aborted(journal))
	return -EROFS;

Thanks,
Joseph

> 
> This commit gives ocfs2 ability to handle jbd2 ABORT case.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/alloc.c      | 10 ++++++----
>  fs/ocfs2/journal.c    |  5 +++++
>  fs/ocfs2/localalloc.c |  3 +++
>  3 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 51c93929a146..d90961a1c433 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -6308,11 +6308,13 @@ void ocfs2_truncate_log_shutdown(struct ocfs2_super *osb)
>  
>  	if (tl_inode) {
>  		cancel_delayed_work(&osb->osb_truncate_log_wq);
> -		flush_workqueue(osb->ocfs2_wq);
> +		if (!is_journal_aborted(osb->journal->j_journal)) {
> +			flush_workqueue(osb->ocfs2_wq);
>  
> -		status = ocfs2_flush_truncate_log(osb);
> -		if (status < 0)
> -			mlog_errno(status);
> +			status = ocfs2_flush_truncate_log(osb);
> +			if (status < 0)
> +				mlog_errno(status);
> +		}
>  
>  		brelse(osb->osb_tl_bh);
>  		iput(osb->osb_tl_inode);
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 25d8072ccfce..2798067a2f66 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -312,11 +312,16 @@ static int ocfs2_commit_cache(struct ocfs2_super *osb)
>  	status = jbd2_journal_flush(journal->j_journal, 0);
>  	jbd2_journal_unlock_updates(journal->j_journal);
>  	if (status < 0) {
> +		if (is_journal_aborted(journal->j_journal)) {
> +			ocfs2_error(osb->sb, "jbd2 status: ABORT.\n");
> +			goto reset;
> +		}
>  		up_write(&journal->j_trans_barrier);
>  		mlog_errno(status);
>  		goto finally;
>  	}
>  
> +reset:
>  	ocfs2_inc_trans_id(journal);
>  
>  	flushed = atomic_read(&journal->j_num_trans);
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index c4426d12a2ad..e2e3400717b0 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -378,6 +378,9 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
>  	if (osb->ocfs2_wq)
>  		flush_workqueue(osb->ocfs2_wq);
>  
> +	if (is_journal_aborted(osb->journal->j_journal))
> +		goto out;
> +
>  	if (osb->local_alloc_state == OCFS2_LA_UNUSED)
>  		goto out;
>  

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
