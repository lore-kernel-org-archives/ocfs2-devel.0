Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03A91C433F5
	for <ocfs2-devel@archiver.kernel.org>; Tue, 28 Dec 2021 01:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PIJ902cFw4BDYGEOpDcL0lYdkyM9/GJB0goc5LeqNLw=;
 b=A7glG6+RKe3NsC5nHLOS8DqVMveoydKqToD5k1fEz1n8DLrC7YAMt3pXq8qhRgDx39I2WW1HA9TT
   apNpSrqUop8bQcAMqIi8dum5CQsjuFG2yoE5k+rQKaFk7pTc8vOq/DWpXwnmKYpkgt72ThAFOA/1
   jV6zHUzpNsnmNGE1RSGDj3hS5IMN6XLXEnIPJQghnZrwg8MXV1sj6qUgCGV/fhIJvLojCVn59Wdl
   Cj5xgLUmy554m2A53ypkMjO6qxGlwe3F0jxXBD4LjgPiWLdukXT969WMAA3U7H1a8TXy0+JtkonD
   MSjNH3MyI+io9PwcI4aU3AafJ9xmCaQ6D9SVwg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PIJ902cFw4BDYGEOpDcL0lYdkyM9/GJB0goc5LeqNLw=;
 b=G8jpF4qJZKbJLaVYMOdaFcL7Ov02Iszi5T1Tz9nmqysYCSbcW1MwV5bf6AqCMLej75TI1S77ARaP
   jDdDHB48mEVJjBfD2BB6pI4cSOraM6WW1HrN3WpcdOe44ALHtn0NPskzqM/uWOqyEPPxsYhGItsF
   +iUXSntB1xCSL+ljYHdQgiNP+v9XiRGhP+FvnYhRlE4GNFC9lCsQya3ntafosbR7lxaTSUGx7cfJ
   OnNgOv+vkrzuAicATn8/O9vXr6ohRhlizr4JufCymkbN5h+MII+sZXq8y2YVPT0ARS679Ll16BfA
   RuKYNUfQ2+kCy5vKINx3+h1Kdk2Q+3QAOOxiBA==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20211209 64bit (built Dec  9
 2021))
 with ESMTP id <0R4S00G9CYFPM490@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 28 Dec 2021 01:50:13 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
Message-id: <f88a34a6-abe8-69e2-33e0-350a0a76eea7@linux.alibaba.com>
Date: Tue, 28 Dec 2021 09:49:49 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Content-language: en-US
To: Colin Ian King <colin.i.king@gmail.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
 akpm <akpm@linux-foundation.org>
References: <20211228013719.620923-1-colin.i.king@gmail.com>
In-reply-to: <20211228013719.620923-1-colin.i.king@gmail.com>
X-Source-IP: 115.124.30.45
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10210
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 priorityscore=158 clxscore=243
 phishscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112280007 domainage_hfrom=8293
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: remove redundant assignment to
	pointer root_bh
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R161e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04395;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0V0.gs9J_1640656189;
X-ServerName: out30-45.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: lo3_VidHc1dVAijc5h5XR9LCrpA-wkKz
X-Proofpoint-ORIG-GUID: lo3_VidHc1dVAijc5h5XR9LCrpA-wkKz
Reporting-Meta:
 AAEVVtCM8/AWE73CH9jiFbh9OicWLfjiWyRjnIB7GrCmL9vmV6Q2upS+17Q7Qp/r
 HABNmvLA2OaWxfc0v5aHFa2d88vr8CHpIAGsI/jIybSVdA/bE4Yoxy15O6AlawLs
 Kf+ZmG8Zvi6q8pAdOx9+Zos2dXYnIHYOT9lMFJRkKQgayGQMd8+e8LgNLLs24ecM
 9Zd0xzQGUlGY3lTpeje+wwsvc4JXHlC4N6EgIl8T9PHJzAuT06Yw8QqoRDMHvH65
 85bbhcHT5TpXeC0Wx2fdVBgS/k+XcjvLd3S2h4GdGLGuh4XmRLac7U+UkLGmlMYI
 ez5SR06+9viKbCBhOJedWCf84++He6WENlw5uEi6Hiy8z7O6E3PGmMUWfCr9Geh0
 OAMCoVOPFy2b6DSJvnjCVcmCHPNLmFf3uO1IvyXZbf7noCi4GS4RXi9/FUunTqMv
 vr08h40dHJEoSe/XV0GYOGLlbGi2OeTg5dxZ8u63aHQRw8cjCjdFOyJjWD+q7qwR
 idGNWDZ8twRhvPwcPslO3P+bnjMPR2FptRVXPDoBgfQ=



On 12/28/21 9:37 AM, Colin Ian King wrote:
> Pointer root_bh is being initialized with a value that is not read,
> it is being re-assigned later on closer to its use. The early
> initialization is redundant and can be removed.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index bb247bc349e4..bf9357123bc5 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -2040,7 +2040,7 @@ static void ocfs2_complete_edge_insert(handle_t *handle,
>  	int i, idx;
>  	struct ocfs2_extent_list *el, *left_el, *right_el;
>  	struct ocfs2_extent_rec *left_rec, *right_rec;
> -	struct buffer_head *root_bh = left_path->p_node[subtree_index].bh;
> +	struct buffer_head *root_bh;
>  
>  	/*
>  	 * Update the counts and position values within all the

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
