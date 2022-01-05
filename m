Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02E3AC433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed,  5 Jan 2022 02:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5XNAwAMARGLhsQ+9PrIUf78jFHVlBit7VIxFxNpuP0g=;
 b=ZybljrPycPhijPBXmvo21/qAG0lMpSITc+Zr7q4BMRpby4Lw4cXV0bPbnfc72AKuarCPYLQOHCyU
   Wy04QSwyxMMxK2mfG5pu0S7k2RT5hTfQthFJO5wbcmhKgr8bLVvJJERtWoRXuXMkxH6kb5UCQC19
   XGzzkQTHRUk0rLqg8aXJUZyJoCIoU+O1lyODFpb4FClcZ5K+K13Rm/Aui4jOu2euU371xZ0Eg3uJ
   FDzsjb6sgkDGsoSY+PBnONvz015IT3j2Y2475+WvVNbwGyntEmerjWgVNJ4NEhcS/7il1+mqgTeU
   Rv/2L2a+AFgnhL6vR5fWFiV2zUgUH/nqk7Ap8Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5XNAwAMARGLhsQ+9PrIUf78jFHVlBit7VIxFxNpuP0g=;
 b=khXb6Ntg4nC3dIv24fMFY8LYhd8TpOgtZqJkIRMXDHBoENFgBlVq4l4QkDOExg0/+N6mtAaa7C1p
   c/88Ja1CCqs2YmSXB47DpKhXZ7d7RHXgPSlMa8YCk/VMALllzi2A7tQCEE/PeqC5JWbaqys3D07e
   PtH0l6RD8BF3Lsqdwp3rL3uYwkISwnW+V/Ivcwd3BU2RtXOuLhSFEEWwCj60znRC26S/9TRuo06g
   R9uyNURYQET6A+TcGWTGr9q/OZxVAjTiwW62oRoSI8eiro2hthAdCx95dJizgapJTnszFm3pBA5g
   NtOKzICSK5YPhwR4hJutY0hUviZp4fd0ria3IA==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20211209 64bit (built Dec  9
 2021))
 with ESMTP id <0R570069YSPC6350@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 05 Jan 2022 02:10:24 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
Message-id: <a96a59c2-101c-4576-b76b-d9923fca25af@linux.alibaba.com>
Date: Wed, 5 Jan 2022 10:04:21 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Content-language: en-US
To: cgel.zte@gmail.com, mark@fasheh.com
References: <20220104112332.601834-1-chi.minghao@zte.com.cn>
In-reply-to: <20220104112332.601834-1-chi.minghao@zte.com.cn>
X-Source-IP: 115.124.30.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10217
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 clxscore=260 lowpriorityscore=0
 malwarescore=0 priorityscore=211 mlxscore=0 impostorscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201050013 domainage_hfrom=8301
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R571e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01424;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0V1-Gl5B_1641348261;
X-ServerName: out30-133.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 1uF9136m9qxQH-QIJyIv989VT6V5jGhp
X-Proofpoint-GUID: 1uF9136m9qxQH-QIJyIv989VT6V5jGhp
Reporting-Meta:
 AAF+ASBrpPMYH60CHOgWzIKan8P6ubM/kvph04unO/EYAlDUFQeY2MEFY1S/pHut
 vPUJWeXjeFKBWyzmW/xsjnIHQQI6+6VQUV+CGO2C3k/vwswS9CDmleBQS3EJ+dpb
 3CSz3R0gmOSgRGlh75iEoKN78BvA7bOVCGc2f8Z9qDpM/mW66+eUr5DyoW7XxAPt
 CSF60OjEOxBQAUnEk+1TPaxsNzFK5n0Gp8QuKz3iupQJd4kgEvbToTNkLkdiVrtK
 0wnl8HmWM+ZpyQ2YG6eZ7PPLxDz0n74h2wJNHtF1o5LtCmGER22uNxRWsaVN/EfC
 dRihEfgTTfBDC/4JDlGuTxwHZmPCJuq2qPh8lVdA5jDZtCfgWdZQJ0htLgO3UBGy
 76HZEdj6dtGtxSdpSANtrOZApamzxIP4x3t+HVdH/qIWVo17Rj/BuPUztwxfoeoJ
 fwByHd5b8GRA31velQavJInBZUh6FVid6GGQFPtn61iwshjMTFM+2hEh4TND4w1R
 Zbtk2j9mvZ65iXSbp+thSwtOGOfRhsoESu9jwssM/dA=



On 1/4/22 7:23 PM, cgel.zte@gmail.com wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Return value from dlm_lock() directly instead
> of taking this in another redundant variable.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
> ---
>  fs/ocfs2/stack_user.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
> index 85a47621e0c0..3027a6a05668 100644
> --- a/fs/ocfs2/stack_user.c
> +++ b/fs/ocfs2/stack_user.c
> @@ -683,28 +683,23 @@ static int user_dlm_lock(struct ocfs2_cluster_connection *conn,
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
> +	return dlm_lock(conn->cc_lockspace, mode, &lksb->lksb_fsdlm,
>  		       flags|DLM_LKF_NODLCKWT, name, namelen, 0,
>  		       fsdlm_lock_ast_wrapper, lksb,
>  		       fsdlm_blocking_ast_wrapper);

Better to align the parameters as well.

Thanks,
Joseph

> -	return ret;
>  }
>  
>  static int user_dlm_unlock(struct ocfs2_cluster_connection *conn,
>  			   struct ocfs2_dlm_lksb *lksb,
>  			   u32 flags)
>  {
> -	int ret;
>  
> -	ret = dlm_unlock(conn->cc_lockspace, lksb->lksb_fsdlm.sb_lkid,
> +	return dlm_unlock(conn->cc_lockspace, lksb->lksb_fsdlm.sb_lkid,
>  			 flags, &lksb->lksb_fsdlm, lksb);
> -	return ret;
>  }
>  
>  static int user_dlm_lock_status(struct ocfs2_dlm_lksb *lksb)

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
