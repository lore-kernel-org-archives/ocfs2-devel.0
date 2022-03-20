Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CB6FC433F5
	for <ocfs2-devel@archiver.kernel.org>; Sun, 20 Mar 2022 13:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=HE/kh5Jqc2fb5DqiNt9CWm+V4YwVyiMfWsi+u2oreJI=;
 b=IJOZKqXCMRTCxfmc4kJV1COMqIpQmvipaUoTzeu8YXQ0g4Fp0wOxFPxK4QHcIbr7MvCMZY/kBgKj
   Z2KuyBCbY8VwCOzWoj04rwUM+rvFDOEvo6ZD8ocI/4Tes1zbQgMK6h+ylRUnQQxyfISu1H9Pttna
   M+GJZcYEzETHqGgtFMnpnAsiu1FaBLRNUBYOJLflP7njs4N6bsH2ZLLpXDA48CyDMlv3v0fGzrQR
   +5CLyeSnL+KI0MvwoRCEQ6YgiKR8ror7t5DX0WAMT2tXnef2wW6LwLUtYEXBxxDZX8VGpEUqMDRq
   wYtS3pryMDROKAiQkrgbRAdfuyjxbINrnhfBQQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=HE/kh5Jqc2fb5DqiNt9CWm+V4YwVyiMfWsi+u2oreJI=;
 b=WkyzIcJzrXfK6H+GvSdCBiliXyoIpuRYptrsseE2hnGbPPkOX0PEaO+ck4cHEgTy2MnoZUtay5jQ
   mgDebkmwTarYDb0oe34K/O6dGwfrc5X09lizdeqY2iHB3BmPWlQYo3GKDX/Lzl5sTXuzh88dGnRG
   DqkTwokphJuwff6TsUbLO5BFOxWDngshwIMPBqwoZEIZixNTuI9y29JBN1fm4NdafSBWPtxXKImx
   M8rrxP1KWqm/xQV0clVXC1UrFMCLZZKIfjaWvnHHMpKL3Q6AKd6LiXlkgjLmWLwTHjk7hMiBpnCB
   cW2MCQ8uB0NYV5MW7XdskimcEBD8FPvLGX/Tcg==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R91008MSPZFKK60@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 20 Mar 2022 13:40:27 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
Message-id: <ae21bbb1-9794-77e5-bd02-fad77096fa1d@linux.alibaba.com>
Date: Sun, 20 Mar 2022 21:40:07 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Content-language: en-US
To: Yi Li <yili@winhong.com>, linux-kernel@vger.kernel.org
References: <20220319061028.3152-1-yili@winhong.com>
In-reply-to: <20220319061028.3152-1-yili@winhong.com>
X-Source-IP: 115.124.30.43
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10291
 signatures=694221
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 malwarescore=0 bulkscore=0 priorityscore=0 phishscore=0 suspectscore=0
 spamscore=0 clxscore=181 mlxscore=0 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203200100 domainage_hfrom=8375
Cc: yilikernel@gmail.com, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: refactor the noqueue_attempted
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
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
 TI=SMTPD_---0V7esMTL_1647783607;
X-ServerName: out30-43.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: DzcBppUn8s-_RhuWjogWn8z_hXl6HxQ1
X-Proofpoint-ORIG-GUID: DzcBppUn8s-_RhuWjogWn8z_hXl6HxQ1
Reporting-Meta:
 AAGDmHQ2UQ0NYahXtxRVZsMOpduHeHdR0b4k358HHCc9oae679bpMaSAhz7z6NhD
 sQu3kCceYP3FqySunFdyAETxylBRX/MAvPq/zX2A3gdzZY1mcfgN9cDE/ksfmB+s
 qH3S71scrw7p1CxPCeQHMGhhxfAbeEmpSWBNuX5DmPhBLoPwG0f/W89idOjSgaXp
 zogvsaFVqnALKf2xSxVDimWdd3GziT2zF9YDpVLpcvO00K09LF+AqMxtH9Q5/1Q9
 5VRZxNTt368BqA4+tfrYLtoRgFytlGF5+sglw2JSN/dLKoWwRgD1tyuUONCbqkVX
 oPTgx+uvYjxqaliJe5YCWfkTzmlf+idXMuZd0lLa6gvdP/O8N7LKF8wV5R3d7iGI
 EQePoUA8IFUMyMNyeuh0aUBcrDvYhEOQ3KNID+3sA8x9fjzANrQF+sfTaQ980H0R
 TrrH0W8wxRD9hnCqM0R+C5PD52aimeLmq+MHe23ZbGYmwH9TpL+BiHm5LxJBe8TT
 a2rcPAKQaJ+lp0HDPOwHU8WMxhJm+HAytIuCet0vZfo=

Don't see any optimization after this change.

On 3/19/22 2:10 PM, Yi Li wrote:
> The variable noqueue_attempted just set when DLM_LKF_NOQUEUE.
> refactor the code.
> 
> Signed-off-by: Yi Li <yili@winhong.com>
> ---
>  fs/ocfs2/dlmglue.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 801e60bab955..6315757c164d 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -1547,12 +1547,11 @@ static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
>  	}
>  
>  	if (level > lockres->l_level) {
> -		if (noqueue_attempted > 0) {
> +		if (noqueue_attempted) {
>  			ret = -EAGAIN;
>  			goto unlock;
>  		}
> -		if (lkm_flags & DLM_LKF_NOQUEUE)
> -			noqueue_attempted = 1;
> +		noqueue_attempted = lkm_flags & DLM_LKF_NOQUEUE;
>  
>  		if (lockres->l_action != OCFS2_AST_INVALID)
>  			mlog(ML_ERROR, "lockres %s has action %u pending\n",

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
