Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49508C43334
	for <ocfs2-devel@archiver.kernel.org>; Wed, 20 Jul 2022 02:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=d034bXecDAj2RVUkPCLyYrswuqEt9CXaaUHU0uPkEBY=;
 b=FLRg/Xisc70ZgTl0Ijrve9UGX677VJbe2gkdDUWTb70MEbfzuhD92Tj0E2gdXDwPOu/XdbhqDy8m
   jPnQ9ubO1j6OC98JLbVUeM4ByBTyA64z0lAtuLphimPg15sCOCionQg4r82UGnwxvEO61+0uAAp+
   Bzg2EdjV6OWlcPoshHkHktZYa1VthlRV45gftcKgiNblW241UM/QQLjLVvB32KrbrU9AHlZhZjKu
   /h7KCcqz4JUohgG0xiHUYbTT/tSGr165tiKGziqngXhwyp1OCzesY00vi8l3hO5sWT3g7tA9KGGg
   kXvtUf/5eEObIRNRasqpR2ySbg/d6Gt1FzNWAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=d034bXecDAj2RVUkPCLyYrswuqEt9CXaaUHU0uPkEBY=;
 b=jy3XrD5xGUtKUqLWlVgtaHYd9N0OfP9dx9pW2EjmZnbgL++tcZ7Ava598n9N/abVtnnvn5lyy2n7
   lgGgdffwa0jurTxJ/LuuA8L5TBjbQDD+5q7rgtr0H/bonCfQJVK2HesfgvReDvuXEtvSrTnX3Fki
   1KJwNRfI8Qoqij5/evTlTnze/CV6DurYJWtLnvLINe2WdOoGVATzd2GiDd0Q9UM4ZWDVUzlaE1pX
   AxFVliujQG2AprfEWQPyfkvSyzEdGP7vXjr6H5+HmMdVOzG+xh8sHahhtA/XT2rc12jT8DYjGMeP
   SWXHZqBThzXSvf9ivuPHfm/JzpLQfTc0sryCzw==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220621 64bit (built Jun 21
 2022))
 with ESMTPS id <0RFA00MG3R2P1A00@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 20 Jul 2022 02:04:01 +0000 (GMT)
Message-id: <d49c6cca-2980-41b1-0f59-32ddcbb1dfa2@linux.alibaba.com>
Date: Wed, 20 Jul 2022 10:03:43 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Content-language: en-US
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 akpm <akpm@linux-foundation.org>
References:
 <bd6796635e58f9c47cf857573c3b9474a00ce26a.1658224839.git.christophe.jaillet@wanadoo.fr>
In-reply-to:
 <bd6796635e58f9c47cf857573c3b9474a00ce26a.1658224839.git.christophe.jaillet@wanadoo.fr>
X-Source-IP: 115.124.30.57
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10413
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 clxscore=107 malwarescore=0 priorityscore=156
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207200006 domainage_hfrom=8497
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 1/3] ocfs2: Remove some useless functions
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R191e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046059;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0VJuib0B_1658282623;
X-ServerName: out30-57.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: wPZOUa4pTJhGaAZHMl8IKCkqrOT0WcoE
X-Proofpoint-ORIG-GUID: wPZOUa4pTJhGaAZHMl8IKCkqrOT0WcoE
Reporting-Meta:
 AAFgaCzzpdnxunPlQWeKpQaJBurxJA1vFEpHQiByCh0L+ou3FUW7tV2fDpxu/2lM
 eZ/S20/PvG0sxF6kBdwqXljajgFWBpGnY0bkmzWkFq7v+zqI8F4YOtZWPMCjGGSQ
 d/Co7nLr8PdAfBtKavtAt1wKhR85nOL4SqXGaQnPsgOjpPynBdIcMZouchZ2Fwy7
 Ygxx5Me50EX7rKvRstoasoitxC3yjtKHAHVKTNwwBE/Khk9uqSfy8LN3vhj0z+dj
 RZdz3incCgWTdwxE9W+vg6x+lKZAmRA8ahvZXzhhCyzyBEzTye0d0MeMupHFfZF1
 8dNsC/WzbfCiBHDlHnytURuEI0To8Ld+LkS8oDfHNZwA0J7YLaHJQOnVj2uQJUwX
 Ma0bTwgznFAeeg+IubnVIjb3nDHnJmIs+QPeXZmTCLwNkU8QnzAhoN4aLNGPeHAS
 mp67ykPAUVf5P68EA6K8YmY96sGmeNhFiVlHX1F0p7Ysoo/RIrYxWcIQr8sAYQyL
 r8pr2Gqd3fzWgJzsFUjX+wfd7SPy1qBOqKXPHf/7oJI=



On 7/19/22 6:01 PM, Christophe JAILLET wrote:
> __ocfs2_node_map_set_bit() and __ocfs2_node_map_set_bit() are just
> wrapper around set_bit() and clear_bit().
> 
> The leading __ also makes think that these functions are non-atomic just
> like __set_bit() and __clear_bit().
> 
> So, just remove these wrappers and call set_bit() and clear_bit()
> directly.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/heartbeat.c | 21 ++-------------------
>  1 file changed, 2 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/ocfs2/heartbeat.c b/fs/ocfs2/heartbeat.c
> index 9099d8fc7599..1d72e0788943 100644
> --- a/fs/ocfs2/heartbeat.c
> +++ b/fs/ocfs2/heartbeat.c
> @@ -24,11 +24,6 @@
>  
>  #include "buffer_head_io.h"
>  
> -static inline void __ocfs2_node_map_set_bit(struct ocfs2_node_map *map,
> -					    int bit);
> -static inline void __ocfs2_node_map_clear_bit(struct ocfs2_node_map *map,
> -					      int bit);
> -
>  /* special case -1 for now
>   * TODO: should *really* make sure the calling func never passes -1!!  */
>  static void ocfs2_node_map_init(struct ocfs2_node_map *map)
> @@ -65,12 +60,6 @@ void ocfs2_do_node_down(int node_num, void *data)
>  	ocfs2_recovery_thread(osb, node_num);
>  }
>  
> -static inline void __ocfs2_node_map_set_bit(struct ocfs2_node_map *map,
> -					    int bit)
> -{
> -	set_bit(bit, map->map);
> -}
> -
>  void ocfs2_node_map_set_bit(struct ocfs2_super *osb,
>  			    struct ocfs2_node_map *map,
>  			    int bit)
> @@ -79,16 +68,10 @@ void ocfs2_node_map_set_bit(struct ocfs2_super *osb,
>  		return;
>  	BUG_ON(bit >= map->num_nodes);
>  	spin_lock(&osb->node_map_lock);
> -	__ocfs2_node_map_set_bit(map, bit);
> +	set_bit(bit, map->map);
>  	spin_unlock(&osb->node_map_lock);
>  }
>  
> -static inline void __ocfs2_node_map_clear_bit(struct ocfs2_node_map *map,
> -					      int bit)
> -{
> -	clear_bit(bit, map->map);
> -}
> -
>  void ocfs2_node_map_clear_bit(struct ocfs2_super *osb,
>  			      struct ocfs2_node_map *map,
>  			      int bit)
> @@ -97,7 +80,7 @@ void ocfs2_node_map_clear_bit(struct ocfs2_super *osb,
>  		return;
>  	BUG_ON(bit >= map->num_nodes);
>  	spin_lock(&osb->node_map_lock);
> -	__ocfs2_node_map_clear_bit(map, bit);
> +	clear_bit(bit, map->map);
>  	spin_unlock(&osb->node_map_lock);
>  }
>  

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
