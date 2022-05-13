Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2511DC433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri, 13 May 2022 02:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Ckab6/ckBWn4bkEDFDik1OGfiEaqHuQU6nu9q1Ot52o=;
 b=II5EdE3MzQa5ImoQuvAfdN7YHwZ0ZbyzF2NoF4sZMXStQZZQveuvZFzfqFnoREv7R2p+fUmX6Z/t
   fw/lM3FLuiipCQY7E/8hZNadQOTjHjz/2JGzRDYVOmIgtJjh/IkPbx9LaagsgKWGFPwux55fID54
   NlLCpC2FkmQOlnMiSTWiih00IyF+Ud2e3TrSOATXU5UdsuAX7euUfmfUXyknLCWoEIthSOr9xMFB
   mLz/xtUtmZ6HpWHk0GJxMC6aHKknz5o637QdO5/6QirY9nT1zlEEeix638QcxjDCpZvqDWBEW/J1
   WftrtXnOzc/ZOaFF2VEAzDMZuCrNxXuGRy4vGw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Ckab6/ckBWn4bkEDFDik1OGfiEaqHuQU6nu9q1Ot52o=;
 b=ZqaF5cx1H4qDm1PXzxNw6/xvTQ78a6QD2oCsWHyHD269ZrRgcCgrFPuYz6BZcwJet7DKfVPdyQvM
   9QdrfCd2NEkXlTqUu4kFNu1ib0+54+kd/ONTI/vUfFAF+1CX/2GOwGs1n+2Dip4twhowf27WHBa0
   xl13A0Mud6Y+Jl6oIZYLx4ZCQ/FqlG1teoN2d0FWJnKUChpS6ERnOW7bugoKUVdVp1VPtNniBxbj
   d8r0aCE5CmxPQ8E0wBGx2LF9OaRAYwnvKjJK0M21Lk+ARU1UJqxHI2OHzwM0ghdSg9ju1gj/bWe9
   Ec6ubSVJPgJBB2qU7vysHH6YlVih6SgtUo/Yjg==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220413 64bit (built Apr 13
 2022))
 with ESMTPS id <0RBS0033STTB2XB0@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 13 May 2022 02:05:35 +0000 (GMT)
Message-id: <cde723f1-db5b-d912-580e-04ddf6a0810a@linux.alibaba.com>
Date: Fri, 13 May 2022 10:05:04 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-language: en-US
To: Junxiao Bi <junxiao.bi@oracle.com>, ocfs2-devel@oss.oracle.com
References: <20220510232213.23435-1-junxiao.bi@oracle.com>
In-reply-to: <20220510232213.23435-1-junxiao.bi@oracle.com>
X-Source-IP: 115.124.30.54
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10345
 signatures=593597
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 clxscore=47 priorityscore=0 impostorscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205130010 domainage_hfrom=8429
Subject: Re: [Ocfs2-devel] [PATCH 1/2] ocfs2: dlmfs: not clear
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R101e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04357;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0VD124cd_1652407504;
X-ServerName: out30-54.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: ORIOM6_ZNLPa_bBKn2hMIWrYrjuxdqF2
X-Proofpoint-ORIG-GUID: ORIOM6_ZNLPa_bBKn2hMIWrYrjuxdqF2
Reporting-Meta:
 AAGAOA5CH4/DMOKZZ/jaQy56wKtGYXIMFB42Jg5384+N5B2Whkz8yh3tq4yMrKN0
 b+V7rftNudk1+3bDP8N965a4aCmjnx+zAK6+5IbV7Tx5C12Ng5O1mISD4+nw0pbQ
 Ei7Y4QBtIEnJa/YQj5CjaKdvM1YQbLaYsduFrNhjp92cwU3kgps1d/k7KxnhyxRx
 Td+SOGoUCGDvLGbQwbGYVlDwVHW8TSLIwahVs7XXpxfVDQcexVRguwGa1Z9uP7F2
 vedfqFlBaDPbdXrqlTh3B8qgWJNzWCy/S+W1qIqoBpew8r1Hj8n6OPWOEMb9nSvP
 fpx9v5hdnQER+6pN6ju2liTBR20fhi3E+HA0CQd9N8ivV66MoWOqQH/1pqNx1Kru
 1K+q3HdfWKXl3YfI6dZKvgl71Px92agVAtgoOmVDR/XNk7WDn1+VDiV1RKR6HqwU
 +g3rfja6XMDIxDykGP/8CS1W/fs8RgqVhzZcH0ZNKF0stlETTnKORyNLQ3gaj98y
 w5/fRXdvKeWeq3waE3DouHqwC8wcr1F2KDXTvv9lnHQ=



On 5/11/22 7:22 AM, Junxiao Bi wrote:
> The following function is the only place that check USER_LOCK_ATTACHED,
> this flag is set when lock request is granted through user_bast() and
> only the following function will clear it.
> 
user_ast?

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
Seems it depends on initializing lockres every time, but it seems this
is not true for directory now.

Thanks,
Joseph

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
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
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
