Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37F6FEB64D7
	for <ocfs2-devel@archiver.kernel.org>; Fri, 23 Jun 2023 08:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1qyCEZ5OOkxjJ9nC6WQ0kp7Ac7DP6/ol3JvdFVJvM6E=;
 b=CA6QyXAuuTl1q0rnBr6rbwWNjjiypqpFDAMnAsDBHTlb0whniiVywn2GdzQ7sOX2aED6RbCYUI5z
   mbHVcV7PUslttboMImS6ySBUe9/bkIuddw16b9FLoSsjlaFfwMbEfrFmcWxmFsEF5CuccpZVluMy
   I6+BvZGODkNnDMFGbNEQFHqa9VzAURCyS0GlU676lgLOPYtcNdjAEWQPt01szeGTEMtF7vGDoyGD
   rhhIFIqqf1AK01Lfi5PF1Mslu4Al2TpG0NPQaomjWcWWuE43DdFJaC4hSTEdFxJNFly+4BjwEBxc
   d9H5eW6mET1DH6ftJ0VSif0pQT2wAc2N8xNUpA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1qyCEZ5OOkxjJ9nC6WQ0kp7Ac7DP6/ol3JvdFVJvM6E=;
 b=C7lDjT+oVpe0H6jOACK9WaFak3NcOc2JVXNuntNWHcrsEbaj/OLtpee16eyh7sFWrORHttTOxlEH
   R8dkgt6COzWbXLiptq09ZVxhh7jTijZyR1StRK/RvmkPu47he6Ac0LxaFp57iRFaZdN8g4f5KNws
   A9RaqRM/9NhLelHyNh1+a4MUFfrgqN4I0HCMo4pFUD8eTgK4p/Crb6a8LAMZWR7HkBNvUV2DZpSr
   gSKU4lkRWWTVvwbuRmOsfqn+cAgw1H7ElHd3LM+9IlOyH8Q4QFQutxdoJQ22fTyay+IkHJpa/zcG
   bA0ZMaLtEVoEIddbPEUseYd6mOaqbkCxkOHn2g==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWP004QB52T8HD0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 23 Jun 2023 08:04:05 +0000 (GMT)
Message-id: <6f0dfe19-426a-19cd-05f2-7184377b4862@linux.alibaba.com>
Date: Fri, 23 Jun 2023 16:03:38 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Content-language: en-US
To: Colin Ian King <colin.i.king@gmail.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
 akpm <akpm@linux-foundation.org>
References: <20230622102736.2831126-1-colin.i.king@gmail.com>
In-reply-to: <20230622102736.2831126-1-colin.i.king@gmail.com>
X-Source-IP: 115.124.30.112
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10749
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 priorityscore=0 impostorscore=0 clxscore=27 suspectscore=0 bulkscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306230071 domainage_hfrom=8835
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH][next] ocfs2: remove redundant assignment to
 variable bit_off
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R121e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045192;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0VllSQm1_1687507418;
X-ServerName: out30-112.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: W26EIvsdAsitzJNqdjlkAQKc9FC9Fypa
X-Proofpoint-ORIG-GUID: W26EIvsdAsitzJNqdjlkAQKc9FC9Fypa
Reporting-Meta:
 AAGvGGrXTl1x2M3NCorJrlwhwajEnKBkfcvJyi3jPsJwVSvHqNaq+EHZ7QXrFIlc
 ov4Ovgt2TNGtr1cxDJux3seCZTjDaBUS6XNAoC+vixlXF8F+hIqw8HPRhZQJeejU
 ibBo7JSX7EcwfS6/GVSuOqZUBWubhzhNEfKTFNDPgNJELKB+nQrPFeEH4mB4K4M8
 X8OXH7FgggBBkd1dr0/LESklw193W+dKn4wApPRTpK1w2TTTXfDAda9XP8Gvvb1A
 u+fxo/gdmDf4AMhPx310+aMRmXuTjfLPdCdapec8MJUkNwnIGCj8GtyG3Xg7ASzs
 h5MChr5y3ksD1TgAgHzeaFtDbzFtbok+3lXmocmlIHFS2CpuGGgicM2DSMAlkggt
 +TYGKtmE1pJOLJLL8sBnUw514J1WbcHPbIX2+FZon6Ry0TCrETjv1flZe548iwEg
 QtKD+1xbCUYHgGFBVMYKV47TnFTixLLoPEFpyIkLAFajzMGmHL+slq7cD5rEwg68
 8eZzm0cRi7u2XrpDWskIA7FxkHvrZAmv9P1vmGLxBWoA



On 6/22/23 6:27 PM, Colin Ian King wrote:
> Variable bit_off is being assigned a value that is never read, it is
> being re-assigned a new value in the following while loop. Remove the
> assignment. Cleans up clang scan build warning:
> 
> fs/ocfs2/localalloc.c:976:18: warning: Although the value stored to
> 'bit_off' is used in the enclosing expression, the value is never
> actually read from 'bit_off' [deadcode.DeadStores]
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/localalloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index c4426d12a2ad..c803c10dd97e 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -973,7 +973,7 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
>  	la_start_blk = ocfs2_clusters_to_blocks(osb->sb,
>  						le32_to_cpu(la->la_bm_off));
>  	bitmap = la->la_bitmap;
> -	start = count = bit_off = 0;
> +	start = count = 0;
>  	left = le32_to_cpu(alloc->id1.bitmap1.i_total);
>  
>  	while ((bit_off = ocfs2_find_next_zero_bit(bitmap, left, start))

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
