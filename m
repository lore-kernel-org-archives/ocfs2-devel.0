Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66C26C433EF
	for <ocfs2-devel@archiver.kernel.org>; Fri, 25 Mar 2022 03:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+tlRz9UE8DZLsLMqkz4nZystyQkU8PDPgp5Al8qaGzc=;
 b=qGg/ALoWeTLmzPCYb/uMDGCCojond/rgY/h3fK9x7eCp5lBi7tfFJ9f6rYTpAgVpdZvubsRTm2/0
   Us9NeZuFE7bkOldyOAsC62zTlxSyxdBWonC+wfn7b7vOkiLO71DQvMGhAHwHMa61QCDbpU/mfQYd
   ftCnEn5WXFtbZBkrqqGqLI4ZvrvGQXDzctZAQ8RKpSw2nQDcocfBKfke3oGkrsVOxtM83xph+W5S
   rr3hGI+VindsM+7e7Y/tCbwmmqUApsdHPzt8qu4LWa9Uayf5PV/LQMgyWB0jSqkJ1Z9+4eMpCE5K
   kEPT4GsXIc4zMIhE4AdQtlEuwFNA8ebX9/e6sA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+tlRz9UE8DZLsLMqkz4nZystyQkU8PDPgp5Al8qaGzc=;
 b=eTMgUbIKZCNDgpB800ZdvVDhB3ZVEc240IuWwm5vja1a54jDB+WvByzt4PazwkjgF3E1LfKDTwcp
   kO76KTSMNvieXj6fLkG5VDiPsD5lwm/cWTWVt2N9lIdKcXzkO6H+dNPxnGe2jiMC9HkktT40HeDk
   f/oapEwyRHW5rCyfFt7on0brXzJ9nJojXco14sIbPsQuH7kwrVoRRxEhiqy8FNvwGYVSTDT8fU3l
   z69G5JcgTftBeHItFF23kCJ9sGmnHx0S+j721A8YrXTYMFDKkjmjex2D1K7qUxBQLX0JnCknItxF
   z+/eN0O9TDTdOnAblgM4ixtDdEUf4eR2NGGG+g==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R9A00A0U6EO1630@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 25 Mar 2022 03:16:00 +0000 (GMT)
Message-id: <9de48770-7dfa-1dd8-5eab-5fc0ac0499d5@linux.alibaba.com>
Date: Fri, 25 Mar 2022 11:15:24 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Content-language: en-US
To: Jakob Koschel <jakobkoschel@gmail.com>, Mark Fasheh <mark@fasheh.com>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20220324071650.61168-1-jakobkoschel@gmail.com>
In-reply-to: <20220324071650.61168-1-jakobkoschel@gmail.com>
X-Source-IP: 115.124.30.132
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10296
 signatures=694973
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=60
 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 adultscore=0 clxscore=141 impostorscore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203250013 domainage_hfrom=8380
Cc: Masahiro Yamada <masahiroy@kernel.org>, linux-kernel@vger.kernel.org,
 "Bos, H.J." <h.j.bos@vu.nl>, Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
 Cristiano Giuffrida <c.giuffrida@vu.nl>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Mike Rapoport <rppt@kernel.org>,
 Miguel Ojeda <ojeda@kernel.org>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: replace usage of found with dedicated
 list iterator variable
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
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04400;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=13; SR=0;
 TI=SMTPD_---0V87tFIC_1648178124;
X-ServerName: out30-132.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: hBKXzW1d0KD7jA1J4OND4-xghhOnZDmJ
X-Proofpoint-GUID: hBKXzW1d0KD7jA1J4OND4-xghhOnZDmJ
Reporting-Meta:
 AAFDlfRmuefoHxOGhoIEUl/qxzDggD4DnUatGQplfgviUySv8k8b8a3E22K/dj4W
 pdOF9QXKPo1wiqoHOmQDktqJ9sbIoqZ8z7YleZ0PMM5hU+l/KxUOohIWUNdikHMa
 GNSPlAg4wp45DO2CIG5uumqTwylTo76/Cd41PqRVAwJg6nAgfBR9+IBsjlYUrFXc
 4PcWpqwLv/GjooLfznF4kcYxLNyblnpBo3mTtJLymGWeN4K2EMKkixaHckie4srF
 OdwQcz7GLp06Fg3c+g625us+3FY9O6qDwxbqRjEOjfwixqx2GvYdNcn1M2tmFTpa
 yBX2T56yYiUJEXX4bUPe70brds73EBy5UboLiY+Nocb76Vkc0okWUKCLQ0Hc0XDw
 claal/wU9o2pOm4+YUAe8JkRauH52TR09F8Zuuv41f6Ic9Ys8NhFylyZjbrtBj8K
 ZBtaS6T1UbUmXSSWTqo8/n0oby6z/Vm/7XKXC3k4fyorMI7CVaRQPqa8rf+Ih9Ss
 EruCUA+OUv8UkCtsLivtlI8pEBeuUPPU5s2gTAAU9x1c



On 3/24/22 3:16 PM, Jakob Koschel wrote:
> To move the list iterator variable into the list_for_each_entry_*()
> macro in the future it should be avoided to use the list iterator
> variable after the loop body.
> 
> To *never* use the list iterator variable after the loop it was
> concluded to use a separate iterator variable instead of a
> found boolean [1].
> 
> This removes the need to use a found variable and simply checking if
> the variable was set, can determine if the break/goto was hit.
> 
> Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/
> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/dlm/dlmunlock.c | 21 ++++++++++-----------
>  fs/ocfs2/quota_local.c   | 10 +++++-----
>  2 files changed, 15 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmunlock.c b/fs/ocfs2/dlm/dlmunlock.c
> index 61103b2d69fb..7318e4794ef9 100644
> --- a/fs/ocfs2/dlm/dlmunlock.c
> +++ b/fs/ocfs2/dlm/dlmunlock.c
> @@ -392,9 +392,9 @@ int dlm_unlock_lock_handler(struct o2net_msg *msg, u32 len, void *data,
>  	struct dlm_ctxt *dlm = data;
>  	struct dlm_unlock_lock *unlock = (struct dlm_unlock_lock *)msg->buf;
>  	struct dlm_lock_resource *res = NULL;
> -	struct dlm_lock *lock = NULL;
> +	struct dlm_lock *lock = NULL, *iter;
>  	enum dlm_status status = DLM_NORMAL;
> -	int found = 0, i;
> +	int i;
>  	struct dlm_lockstatus *lksb = NULL;
>  	int ignore;
>  	u32 flags;
> @@ -437,7 +437,6 @@ int dlm_unlock_lock_handler(struct o2net_msg *msg, u32 len, void *data,
>  	}
>  
>  	queue=&res->granted;
> -	found = 0;
>  	spin_lock(&res->spinlock);
>  	if (res->state & DLM_LOCK_RES_RECOVERING) {
>  		spin_unlock(&res->spinlock);
> @@ -461,21 +460,21 @@ int dlm_unlock_lock_handler(struct o2net_msg *msg, u32 len, void *data,
>  	}
>  
>  	for (i=0; i<3; i++) {
> -		list_for_each_entry(lock, queue, list) {
> -			if (lock->ml.cookie == unlock->cookie &&
> -		    	    lock->ml.node == unlock->node_idx) {
> -				dlm_lock_get(lock);
> -				found = 1;
> +		list_for_each_entry(iter, queue, list) {
> +			if (iter->ml.cookie == unlock->cookie &&
> +			    iter->ml.node == unlock->node_idx) {
> +				dlm_lock_get(iter);
> +				lock = iter;
>  				break;
>  			}
>  		}
> -		if (found)
> +		if (lock)
>  			break;
>  		/* scan granted -> converting -> blocked queues */
>  		queue++;
>  	}
>  	spin_unlock(&res->spinlock);
> -	if (!found) {
> +	if (!lock) {
>  		status = DLM_IVLOCKID;
>  		goto not_found;
>  	}
> @@ -505,7 +504,7 @@ int dlm_unlock_lock_handler(struct o2net_msg *msg, u32 len, void *data,
>  	dlm_kick_thread(dlm, res);
>  
>  not_found:
> -	if (!found)
> +	if (!lock)
>  		mlog(ML_ERROR, "failed to find lock to unlock! "
>  			       "cookie=%u:%llu\n",
>  		     dlm_get_lock_cookie_node(be64_to_cpu(unlock->cookie)),
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index 0e4b16d4c037..38cc75bd3127 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -923,19 +923,19 @@ static struct ocfs2_quota_chunk *ocfs2_find_free_entry(struct super_block *sb,
>  {
>  	struct mem_dqinfo *info = sb_dqinfo(sb, type);
>  	struct ocfs2_mem_dqinfo *oinfo = info->dqi_priv;
> -	struct ocfs2_quota_chunk *chunk;
> +	struct ocfs2_quota_chunk *chunk = NULL, *iter;
>  	struct ocfs2_local_disk_chunk *dchunk;
>  	int found = 0, len;
>  
> -	list_for_each_entry(chunk, &oinfo->dqi_chunk, qc_chunk) {
> +	list_for_each_entry(iter, &oinfo->dqi_chunk, qc_chunk) {
>  		dchunk = (struct ocfs2_local_disk_chunk *)
> -						chunk->qc_headerbh->b_data;
> +						iter->qc_headerbh->b_data;
>  		if (le32_to_cpu(dchunk->dqc_free) > 0) {
> -			found = 1;
> +			chunk = iter;
>  			break;
>  		}
>  	}
> -	if (!found)
> +	if (!chunk)
>  		return NULL;
>  
>  	if (chunk->qc_num < oinfo->dqi_chunks - 1) {
> 
> base-commit: f443e374ae131c168a065ea1748feac6b2e76613

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
