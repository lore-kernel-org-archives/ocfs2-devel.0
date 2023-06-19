Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF624EB64DA
	for <ocfs2-devel@archiver.kernel.org>; Mon, 19 Jun 2023 09:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Qlkkd9/oYsJrX5wVs6PAQRFKWbrX7kGlFcdDEL8i8bk=;
 b=mLf56FbQrZXxdfFN2E4UuuNskZAlxoQWb9VvfYxbyTJbF5Tj4uv2Oy+5/luFmugTazXR7AY0LBEW
   H8L82fnvDGsFMyMNNt19V0Zca5z9QqTrWbhWqBLjgrjdM0+0mZfxNJrohnz0ic+xxsqye15jgl89
   Ulpdha2rWkpD5KSjJc10SrxR2dn0J1Jt9XCrr9Vvk5MX0mI1kq11L9KtZsCjVcHkqMIwAhMD31KZ
   wNyH5ayU+estRhlzrKL/PCNdgu6FSxKAV6qbDzBUthWw6wOQFB0niDu7gL2ky1Q21+wqemCLkz16
   j9RiSQQjZfPUAF3KmpmH8+pdBWfkz5bkO/H5eA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Qlkkd9/oYsJrX5wVs6PAQRFKWbrX7kGlFcdDEL8i8bk=;
 b=ddheTPCl8UaDfhE0fe2cPPiSUBqBZ+fcx5CXOjsUJ1jp6DTI9VrqhoxmR9beJdEPLkAI/O5D6WPz
   GRIeA+NUnViWIH90MZQqIgJUBJR1UrUNU0nDiUpqcpgyBgbMEGvVtfYQIYhpNJsROPL4tj7oR/w3
   ExAqeGv2nYefTszXmFszrYfhjoQUYF33v92gLAZCTyY5SrQFxlnsZmw7eUaX1w56cdejhtkBNnKx
   i81R1OoJweFSs2oVKx5CYdZDJijTk4OOpKRmeVisNfDWXE9IfONljw4NecqXYT0iHA2wMNTY8Mvp
   Wxtfi/fhWt5UmcPfD5Ba7VuEhBhOkLQcJHw+jw==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWH00OPKVMWQI30@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 19 Jun 2023 09:56:56 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1687168603;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=muUTjP25aYFmNXaLyBGB13a2mB/gemsyPXw0y/fSJkY=;
 b=tbtiGiX80YAT6jPK+U/vZj+hgHIg9p75BCFi001xezlolDZyipzy07OqrfRefEbf4dV5EM
 qXKCOaiOOm2drgGa2uzkAfBrTMGs0u6y6O+gXdLb9LR8mYoiABphYf2A+3aSuBEeJUSfl0
 080X67FW1yX8DDMW4ffGWuYyUOV+FXE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1687168603;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=muUTjP25aYFmNXaLyBGB13a2mB/gemsyPXw0y/fSJkY=;
 b=4yj3hR/7cdSaAU6VGtPxoXcyKUVufEHzpM/+ahqqUyabkHOKXKxncQcCLFyPHoWlgf1yyq
 JQEMpcSJZvgYYYBw==
Date: Mon, 19 Jun 2023 11:56:42 +0200
To: Bean Huo <beanhuo@iokpp.de>
Message-id: <20230619095642.vjb5fjyhgnbp2drc@quack3>
References: <20230618213250.694110-1-beanhuo@iokpp.de>
 <20230618213250.694110-6-beanhuo@iokpp.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230618213250.694110-6-beanhuo@iokpp.de>
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10745
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=488
 spamscore=0 suspectscore=0 impostorscore=0 bulkscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 priorityscore=181 clxscore=185
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306190090
Cc: brauner@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
 beanhuo@micron.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk,
 jack@suse.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
 linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v1 5/5] udf: No need to check return value of
 block_commit_write()
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
From: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Jan Kara <jack@suse.cz>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: smtp-out2.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
 ip4:149.44.0.0/16 ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
 ip4:192.31.114.0/24 ip4:195.135.221.0/24 ip4:195.135.220.0/24
 ip4:69.7.179.0/24 ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Spam: Clean
X-Proofpoint-GUID: ngGB41MiKCUeQLswJcmUS4UJly9s8nTq
X-Proofpoint-ORIG-GUID: ngGB41MiKCUeQLswJcmUS4UJly9s8nTq
Reporting-Meta:
 AAHzdHAKMJfkkRzVmtr61aQ2nZ79r4a9DKrLdF1DxK7yAom1D0SJ6ksO7XpOqY7s
 XIWda/JuYuv2BrsQL2klFzZTNRSoOB9A6lkgTaCOIDxTosLD0CW5BLDC4WSmYehz
 ZIf3ljxIdA+sY6H5GGkliClRdCF4cg3oXSyqzeXXBwAm0JnCOxw3SkMTUsP0pzOi
 qhjytMxrP3pAVHiD360hfMtS/P0/XmzmGuJZlP8Cqtf1Fs5ZVMOfHuMiWgH15OFi
 NxR+W21CbxKHQ8RX5aaDmEU2LOhk0HvvR7ULO5JP5BNK8UU/Q6H6XhVef39xryab
 Zxv6LCOO70tu7LKo3D6JABQgdlhhp3a2pZrk+0xmecHtKPueBQnqB5hjoe2UyhCt
 ViTi3HviAaxnmAWugpUHyQ9jLDelm+1vpJFsrsEpPiffYLXgQDXMDRJ08bO7X+4Y
 hRP+tyPKJG5qE02LHNybXxoB1M2UizaSk5yLVOdyvcgAcknEthT4f1fXBM5Gfmlm
 BQrZ6TtJSOUao9z/tpvx4uM1T6c4kBPnaKkhwnSB4eCn

On Sun 18-06-23 23:32:50, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Remove unnecessary check on the return value of block_commit_write().
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/udf/file.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/udf/file.c b/fs/udf/file.c
> index 8238f742377b..b1a062922a24 100644
> --- a/fs/udf/file.c
> +++ b/fs/udf/file.c
> @@ -67,13 +67,13 @@ static vm_fault_t udf_page_mkwrite(struct vm_fault *vmf)
>  	else
>  		end = PAGE_SIZE;
>  	err = __block_write_begin(page, 0, end, udf_get_block);
> -	if (!err)
> -		err = block_commit_write(page, 0, end);
> -	if (err < 0) {
> +	if (err) {
>  		unlock_page(page);
>  		ret = block_page_mkwrite_return(err);
>  		goto out_unlock;
>  	}
> +
> +	block_commit_write(page, 0, end);
>  out_dirty:
>  	set_page_dirty(page);
>  	wait_for_stable_page(page);
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
