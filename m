Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B9D2C433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu, 19 May 2022 02:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yUY/kPksuJzkEmz4/5QwquIlJfuMaDkQMsGLsxkKnTA=;
 b=gNpedponQPfJsn2ar3g5GzMMoo8eEFYDr2Q4hJ5jBEw5vx0Fv6qZ+lmc5vXxip3jm7BZ1L7QWPuu
   LIi22VDR7UPGMLL79K6kgYIvtVgzw8CHG+povffAryX8CIXaNVSBFN2EAscpBYdC0wT/mLFj59ZW
   lYYav1z+LFBER/3QXlLiVDa41MoUi9CLXyzNYMKLEJUYop5QwfP4UJxF6gF9h8/HL4BQMff9jVjx
   LzlQSHXy8H06J2ifva5qXtlat6OJEzHBFXDTXVTx5IDJdy3XPmzlc0TZPBlWg6YNM/efjFtkUwtp
   QEgFWc36Wzz9T5XzgAt+htdyAD7pzrB4cwqUsg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yUY/kPksuJzkEmz4/5QwquIlJfuMaDkQMsGLsxkKnTA=;
 b=cx+llXkp/1qnm5O9eWrvEafq5V2EWfnPeoua94Jd7RKEv4WtquiislBF9M1W2chIQmzTVNvPsZZd
   dELaFSatnKzN3UlsyfSonklo8mTIUw2ucYEO1Fv/rJvm6rC+rfPFPOEH632VIsMXvys5PYH+T/Y9
   MBS8nQEdz6YKdda4RKfeHu5ti+FZJw8uE6TmwsNA29r9xNwerTZmc3u1tjxnXsQq3KqyZaRvwLlO
   gIji26ab2++7oJFG6YmfVwPF53jZ+4Hs9QltcDpnAMlo4jK/fye2JAkQ1wmWbaTBU0uNaUzsndBK
   9u/V4EaE5wyleStvwrX7zAtENxINKWzUomnMCQ==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220413 64bit (built Apr 13
 2022))
 with ESMTPS id <0RC3007A4XK2X240@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 19 May 2022 02:00:02 +0000 (GMT)
Message-id: <430f13e8-e220-b666-3ec6-4b3994fedfcb@linux.alibaba.com>
Date: Thu, 19 May 2022 09:59:33 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-language: en-US
To: Junxiao Bi <junxiao.bi@oracle.com>, ocfs2-devel@oss.oracle.com,
 akpm <akpm@linux-foundation.org>
References: <20220518235224.87100-1-junxiao.bi@oracle.com>
In-reply-to: <20220518235224.87100-1-junxiao.bi@oracle.com>
X-Source-IP: 47.90.199.6
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10351
 signatures=593597
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=123
 mlxlogscore=999 adultscore=0 spamscore=0 phishscore=0 priorityscore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205190013 domainage_hfrom=8435
Subject: Re: [Ocfs2-devel] [PATCH v2 1/2] ocfs2: dlmfs: not clear
 USER_LOCK_ATTACHED when destroy lock
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
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04400;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0VDhxBrj_1652925573;
X-ServerName: out199-6.us.a.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: cipC2FXz0tQ-15RRI7jvssJOGOSG1e9U
X-Proofpoint-ORIG-GUID: cipC2FXz0tQ-15RRI7jvssJOGOSG1e9U
Reporting-Meta:
 AAEEdIglsh9O20OuOsS/hzffupFQF4hOgP7kjLLGWV80X+0vnnboQHBQ5mtu5d+a
 5QCDsIamRcecLGjczGz2vklj5/vMX9r3Gq4wRHtjLWqPQZ8vov7U9h2dlzu3il2F
 vhzZYKk2ZYwTxNbgwrCIbMYR1m5NBEY7qoam/Fk09WFkAq9UtvHSXMzWd2fZg4iC
 obpbjLWnnlpgzRtI+AOHR1PHnSiXxMtqgwI7Vykje8bB0pLZ8WfEE6rfXn+NASUx
 6lr5QEwPg1N09myf+XzVAA3FuWcgMud+gtZWtkPY3c6kWEPnp551mazjoHmyI5vY
 PB0SMf71qDxgTy/tVtGavZ6hSHtB0sGtBKwqWgcCrQSuhJJNrWfoVIHPEHP/bCAW
 XjNuaV+gMffA1zqI+pioqGyf+1a/z1GwE/y5nHt3Nazw8iC+y47p8X7HT0dE1/PQ
 5kUIxvnaEKfUxTdl/m2cDfgel0vs3xjwb5vylvWLS6TvkvlpIQM2y8Nz18a82DYq
 t7gaoF2T0MbFZ74V3efEO6pYua+PkGHBoveP2WXT7cTc



On 5/19/22 7:52 AM, Junxiao Bi wrote:
> The following function is the only place that check USER_LOCK_ATTACHED,
> this flag is set when lock request is granted through user_ast() and
> only the following function will clear it.
> 
> Checking of this flag here is to make sure ocfs2_dlm_unlock is not
> issued if this lock is never granted. For example, lock file is created
> and then get removed, open file never happens.
> 
> Clearing the flag here is not necessary because this is the only function
> that checks it, if another flow is executing user_dlm_destroy_lock(), it
> will bail out at the beginning because of USER_LOCK_IN_TEARDOWN and never
> check USER_LOCK_ATTACHED.
> Drop the clear, so we don't need take care it for the following
> error handling patch.
> 
> int user_dlm_destroy_lock(struct user_lock_res *lockres)
> {
>     ...
> 
>     status = 0;
>     if (!(lockres->l_flags & USER_LOCK_ATTACHED)) {
>         spin_unlock(&lockres->l_lock);
>         goto bail;
>     }
> 
>     lockres->l_flags &= ~USER_LOCK_ATTACHED;
>     lockres->l_flags |= USER_LOCK_BUSY;
>     spin_unlock(&lockres->l_lock);
> 
> 	status = ocfs2_dlm_unlock(conn, &lockres->l_lksb, DLM_LKF_VALBLK);
>     if (status) {
>         user_log_dlm_error("ocfs2_dlm_unlock", status, lockres);
>         goto bail;
>     }
> 	...
> }
> 
> V1 discussion with Joseph:
> https://lore.kernel.org/all/7b620c53-0c45-da2c-829e-26195cbe7d4e@linux.alibaba.com/T/
> 
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/dlmfs/userdlm.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/ocfs2/dlmfs/userdlm.c b/fs/ocfs2/dlmfs/userdlm.c
> index 29f183a15798..af0be612589c 100644
> --- a/fs/ocfs2/dlmfs/userdlm.c
> +++ b/fs/ocfs2/dlmfs/userdlm.c
> @@ -619,7 +619,6 @@ int user_dlm_destroy_lock(struct user_lock_res *lockres)
>  		goto bail;
>  	}
>  
> -	lockres->l_flags &= ~USER_LOCK_ATTACHED;
>  	lockres->l_flags |= USER_LOCK_BUSY;
>  	spin_unlock(&lockres->l_lock);
>  

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
