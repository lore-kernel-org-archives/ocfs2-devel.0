Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95652C433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed, 12 Jan 2022 11:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=w7wvs2yQSCjTCu0M5OHHY4LH8AoXpZ+caA3b46bwUs4=;
 b=18IBDTWLTcPj/XhIFEklF0cwCoAAhhG1eDDXs8nHKBb/UzMopyhvcAeSS0Al+Qmsxgq37rodzIW9
   /OGzHwSWSZ4rHPe7CDOyqfLrKZYKqDFUI/dBccpyPhKiCS2WHQsoQS7L4WMq8kb4vG1GV+2XhDWD
   YtNw45LdR7mUEHeOfwX8P2+T0rE0HueBOQ+TsY0s4sX1ZbFpThpA3Fwq08aD0XcVQFAMUVZmUty6
   07mJgKYeXUlRKaDW07+wi2Ii1bLyGIPvvZBANVGOUpF6sVZCeYeFmGuuoEKaDVW494CHTZ+MRNMC
   tMiVu3Zv7X56f2Eg5+ffI40PPHkdohTiKPxXaQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=w7wvs2yQSCjTCu0M5OHHY4LH8AoXpZ+caA3b46bwUs4=;
 b=gi9wVJ3BhT2g6CewcS0NvqCiZyQ61x0CWbtpnVAmriVUWB3QxY/K6GTnzBM7N0c8xFcP24fjWfWW
   6/1RBkepjVcqHKK5aoocNLhGYJ8gTV5eMfR7CYspJTHC4zywlqPIvGmKb0ODZnrV2sMhFqUVWajR
   tyfSbKmwHaOXqe3w4V0Sr7mMVLD5tJAIEAhO9I9sNSA4ENalzaIEVx64sdhy7s8aVQW4gEp/RJrN
   Ybfq+5VVklbChlh7vaxyN5tvqH77s2F4E8WkGViMakQyE6wrgNzsiyhAI/szaveXhBrc82BiQ7vG
   RtkuwRYg1T0XQ1PcxvvvzcX6+oB75/t0dd0X+A==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20211209 64bit (built Dec  9
 2021))
 with ESMTP id <0R5L00NZ2GSMHJ50@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 12 Jan 2022 11:19:34 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
Message-id: <5c820350-3dd0-5bb5-66a4-6bedb119525f@linux.alibaba.com>
Date: Wed, 12 Jan 2022 19:19:16 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Content-language: en-US
To: cgel.zte@gmail.com, mark@fasheh.com
References: <20220112081408.667411-1-chi.minghao@zte.com.cn>
In-reply-to: <20220112081408.667411-1-chi.minghao@zte.com.cn>
X-Source-IP: 115.124.30.132
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10224
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=282
 bulkscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0 spamscore=0
 suspectscore=0 priorityscore=163 mlxscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120074 domainage_hfrom=8308
Cc: Minghao Chi <chi.minghao@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
 ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH] fs/ocfs2: remove redundant ret variable
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R601e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04400;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0V1f1q5U_1641986356;
X-ServerName: out30-132.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: Y7zQv9eBolNnpWk5JIG0-fEcTHePmDcR
X-Proofpoint-ORIG-GUID: Y7zQv9eBolNnpWk5JIG0-fEcTHePmDcR
Reporting-Meta:
 AAF2/SPp/KNrZAbMMYMsmQHx1fTN0UKkvhuDdsVevWDWrvasUqc8+hObqsK8JxuK
 BsjwUtFxPeouzUvNJYq1NPe7r1cHzHtLVnkQ9SF0QIYb9t3WUDlq6CRjs266MNKm
 utjWkcj8SLvzAXV5jTYL0gZrpeRV5FUHnKI0Hb2C0kedQBOODLX2qmNkwXJynSU0
 bFrrhg35Fz/9aRCotliXOzfxg1yw9Cndz13UX8KgEW6eItKqHccsZqHfRmErRFXX
 vYFHcq4WLkquQfPfZ2KF3qbTROboJB5NBuTxV/2HW8MVVWZXFy9+/EAJNmAYcUWJ
 5MsmBdD/hV9XCtmj9tj6pk3IEUwB8PyZL3I0bHijGMHD+hva0vR59tLaDnDQp9JG
 twjZP23PEYTj+6RZtVxNJzxD+QwgewuRGo69t1UXlcy1vweSiz2U+RJVoOOrFfmW
 oD8UuIMCh0ZuooGOQed8UsVZeLn77yVa2adF+ObhqwXmn+q6T817QWd9Ha4yVAxw
 ujXmqT4j/BPuD9CaeyhILJeAUR98tAqaA8H63z1u+oHo

This is obviously not right as you remove the extent tree initialization.

Thanks,
Joseph

On 1/12/22 4:14 PM, cgel.zte@gmail.com wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Return value from ocfs2_add_clusters_in_btree() directly instead
> of taking this in another redundant variable.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
> ---
>  fs/ocfs2/file.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index fc5f780fa235..9a46dcef448c 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -540,15 +540,11 @@ int ocfs2_add_inode_data(struct ocfs2_super *osb,
>  			 struct ocfs2_alloc_context *meta_ac,
>  			 enum ocfs2_alloc_restarted *reason_ret)
>  {
> -	int ret;
>  	struct ocfs2_extent_tree et;
>  
> -	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), fe_bh);
> -	ret = ocfs2_add_clusters_in_btree(handle, &et, logical_offset,
> +	return ocfs2_add_clusters_in_btree(handle, &et, logical_offset,
>  					  clusters_to_add, mark_unwritten,
>  					  data_ac, meta_ac, reason_ret);
> -
> -	return ret;
>  }
>  
>  static int ocfs2_extend_allocation(struct inode *inode, u32 logical_start,

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
