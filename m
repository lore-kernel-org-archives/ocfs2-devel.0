Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1E55C433EF
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Jan 2022 01:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yzlBASBU13AoOe9Ag6VptaezS2Nv0UKTRUIcWX8TaIs=;
 b=dYwV/yjFLJhVp4ELIEjvaR0+8HWpwxi84cL0tvS/OBTy7PiEDij3IrgQrpRUMXzsbXl0rP5VbkbJ
   +ZZUm21hgxVJrgjBssOPnKCBLzeb9v+KoW3aQf+9v3ZAx2VZ2R8FC1ZsF4CaGYsCDdJ4UwbLDwa5
   eFZg6Z8B9Ys/V9fC45TgaDWGNnJMnXOUWwE4meBdG41K2OIgFFGqU2WyDw/DlIulyrMpXakf+DqX
   I0Z/0pqAc/s+k92FSabGyTKInauqYEx9eGQofJqSSGuRzoDowcBQMrrxo4d89KWb0gvwVsL30ZP9
   nU/1UI7bSk1b7lBgsIVNC1e+iDS7hOzYM5dNzw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yzlBASBU13AoOe9Ag6VptaezS2Nv0UKTRUIcWX8TaIs=;
 b=nTQI84o/b5uc7oTWtGCgNZ48J38wmKifYqyZ2J13c36RmMKIF0qUbFDiMGEHznISRg0UAbXHM/ts
   iZrP0dih7oWiIHJfl243RObiXNdqeX8uRTNvcG0CdrGcDhnFEEkWBkrCxnjGUvZSVvOzozRgdXnr
   w3nYNKPVisVtX8AJOxeXVEj015ljUP1PcgzBAbDyybPcyG0eSc9wHSAqjp4fx6aOPm1LLSXP58De
   DwXx4NMRm4nulyGh3t5wIa5I898SA72aQD3MtibaDqcvsrf0wOnV2YkJg1uAd7WhCusDYxfqh4bU
   yx2bQAeflT0s/At8KKs7OhCR/IPv4cPzivb6Nw==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220104 64bit (built Jan  4
 2022))
 with ESMTPS id <0R6100LLVEA8AI80@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Jan 2022 01:46:56 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
Message-id: <9e3793fa-76a9-8190-a090-5655c49a7352@linux.alibaba.com>
Date: Fri, 21 Jan 2022 09:46:35 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Content-language: en-US
To: akpm@linux-foundation.org, ocfs2-devel@oss.oracle.com
References: <20220114021641.13927-1-joseph.qi@linux.alibaba.com>
In-reply-to: <20220114021641.13927-1-joseph.qi@linux.alibaba.com>
X-Source-IP: 115.124.30.131
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 priorityscore=123 lowpriorityscore=0 adultscore=0 malwarescore=0 spamscore=0
 impostorscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 clxscore=261
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210009 domainage_hfrom=8317
Cc: CGEL ZTE <cgel.zte@gmail.com>, Minghao Chi <chi.minghao@zte.com.cn>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: cleanup some return variables
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R881e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04395;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=4; SR=0;
 TI=SMTPD_---0V2P3pWS_1642729595;
X-ServerName: out30-131.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: nHx00mdtij2lWNkNAakI_-VBMJBZjQ_v
X-Proofpoint-GUID: nHx00mdtij2lWNkNAakI_-VBMJBZjQ_v
Reporting-Meta:
 AAG747GFy50ZIM8OwYoUd/BxDYlYTzn00I6PMuF7U9/Ljx9NiE5TZLXjGcaCbn8x
 aOLWBo4VrMVDJ/J9Vkzv6w5a3rEQI81TU8pHaXCfzXn3vb2zn6kAgRv1jl/kFB5j
 zXBUywueL8IWtJx08d32KRN/cjLisKkun0mHEAbKTsOoceroEupaMHX/P/ACO9Tt
 /uvxldxpQqIUGk3WPAcyUUhDGHoewD+iNi5vlQSnBK+qDIk+MxmAFsvxpAo2WQvY
 hdFqgH9zRCPyiDA5ze0QMejIggJdc5UBZ9q1RsdTEp7w5G/Y1bbt22WAt9vl6eTG
 RZnFK1Dz6j5m8wQpYTx8DcT0KLcSmJfuUw8dr0Bav3ZfBAthLKUgleBlEFx2GVZC
 BTI1Pblq36Y6CqgJEzKCMvMnqRKkzxJHfmmQWsjP7+qx9e73XO/yDINnLEM+Ziiy
 aXET1odeoYZrZlr+qjyPkthXYrosnnotrBLTWxgEKQU5jNlO63YI4ebHmEVFG9y4
 f4hQhLuV/Z1b1mz8M3Qw9JxNgnUSOrDGBYrOoOWR1ts=

Hi Andrew,
Could you please consider add this to -mm tree?

Thanks,
Joseph

On 1/14/22 10:16 AM, Joseph Qi wrote:
> Simply return directly instead of assign the return value to another
> variable.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Cc: Minghao Chi <chi.minghao@zte.com.cn>
> Cc: CGEL ZTE <cgel.zte@gmail.com>
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/file.c       |  9 +++------
>  fs/ocfs2/stack_user.c | 18 ++++++------------
>  2 files changed, 9 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index fc5f780fa235..24321c44cd42 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -540,15 +540,12 @@ int ocfs2_add_inode_data(struct ocfs2_super *osb,
>  			 struct ocfs2_alloc_context *meta_ac,
>  			 enum ocfs2_alloc_restarted *reason_ret)
>  {
> -	int ret;
>  	struct ocfs2_extent_tree et;
>  
>  	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), fe_bh);
> -	ret = ocfs2_add_clusters_in_btree(handle, &et, logical_offset,
> -					  clusters_to_add, mark_unwritten,
> -					  data_ac, meta_ac, reason_ret);
> -
> -	return ret;
> +	return ocfs2_add_clusters_in_btree(handle, &et, logical_offset,
> +					   clusters_to_add, mark_unwritten,
> +					   data_ac, meta_ac, reason_ret);
>  }
>  
>  static int ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
> diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
> index 85a47621e0c0..a75e2b7d67f5 100644
> --- a/fs/ocfs2/stack_user.c
> +++ b/fs/ocfs2/stack_user.c
> @@ -683,28 +683,22 @@ static int user_dlm_lock(struct ocfs2_cluster_connection *conn,
>  			 void *name,
>  			 unsigned int namelen)
>  {
> -	int ret;
> -
>  	if (!lksb->lksb_fsdlm.sb_lvbptr)
>  		lksb->lksb_fsdlm.sb_lvbptr = (char *)lksb +
>  					     sizeof(struct dlm_lksb);
>  
> -	ret = dlm_lock(conn->cc_lockspace, mode, &lksb->lksb_fsdlm,
> -		       flags|DLM_LKF_NODLCKWT, name, namelen, 0,
> -		       fsdlm_lock_ast_wrapper, lksb,
> -		       fsdlm_blocking_ast_wrapper);
> -	return ret;
> +	return dlm_lock(conn->cc_lockspace, mode, &lksb->lksb_fsdlm,
> +			flags|DLM_LKF_NODLCKWT, name, namelen, 0,
> +			fsdlm_lock_ast_wrapper, lksb,
> +			fsdlm_blocking_ast_wrapper);
>  }
>  
>  static int user_dlm_unlock(struct ocfs2_cluster_connection *conn,
>  			   struct ocfs2_dlm_lksb *lksb,
>  			   u32 flags)
>  {
> -	int ret;
> -
> -	ret = dlm_unlock(conn->cc_lockspace, lksb->lksb_fsdlm.sb_lkid,
> -			 flags, &lksb->lksb_fsdlm, lksb);
> -	return ret;
> +	return dlm_unlock(conn->cc_lockspace, lksb->lksb_fsdlm.sb_lkid,
> +			  flags, &lksb->lksb_fsdlm, lksb);
>  }
>  
>  static int user_dlm_lock_status(struct ocfs2_dlm_lksb *lksb)

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
