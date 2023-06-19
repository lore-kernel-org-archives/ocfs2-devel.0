Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 007DDEB64DB
	for <ocfs2-devel@archiver.kernel.org>; Mon, 19 Jun 2023 09:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=KJvHojIJ4qCdBA8hojYuc6eHzq0pKMtF9HrQNFTt89Y=;
 b=gDMA+i/dgCnR4IHK1S0GX5J9gwoKfRU2aB4kNKf0a25SXID7vCqLLy+R9RIjE/LXxteHm5HXHSOQ
   O2ZBAAIbenWFzqbE3UwYUX7D14tXCd4Y+Uq3Pj2zCHL4YY9Jlc6cx141mrqX96wKXzPeTpMRVi2m
   4fzv4hwZxrACXEQgF6X3q652EJ8ilYmSRf8aZMmAItM/mjjJ/7eEokfk+BnVAypXpOAp1jdXbWXn
   ZezOy9blloRgHAcJrRNPsyRLwuymzbXQi2kOp++tv5VOV8sRluZ4bcmUa+miVD7/puNwfs9VfjW0
   Oi7fa/LHFkUqVFoERFBgsXxjG/rFa0GF520mNg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=KJvHojIJ4qCdBA8hojYuc6eHzq0pKMtF9HrQNFTt89Y=;
 b=cHtCDDpRCThvKyvOFR4afb83c80/i8t3fufNF+pvftPCtlJfgcGOWNbVYcmee95fRnUpvFD1oo9/
   2/YUetGNC1g7jgmD0I6sKwpeNtTmZYC46wAgXz0A9CqdLeSARCfgIR+6h4g9ZvA9acdqKfwhvMpf
   kKmam7jHX/tFGmK78PecdWITJdEnUcOl10qEyuBZgZLHW1CEcREGmGXOQkfEXjKz0236VwfdroCW
   xWI3+qIhPmAdmoTt3i40hzAgcooPDRoKhwkvK5Nmqoqmd6TRjpjpuHXzSsWViDvBnXKuuA2x4lCZ
   emIxuQHGB8n+aAM9LGwGlaT/tBA7ej2uBzgqLQ==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWH00N6LVM5NS60@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 19 Jun 2023 09:56:29 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1687168576;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=EHDB1goOIdClF7fSskWHB6HJ+dOH2Pf0/f+fBVNZKrI=;
 b=DIpsb4EieamYZhyKaJCFxmJC6JO0cddEVy/1OyL8WDxOPeQGOtKMiVGqTxsIbrpLXpkxhN
 VXpLK+f++/JuAhTySMfcouo/j1p7MERtfqsoS0ULoRTD0YkD5mE84xRomR8ypCnrHqfM37
 H8ssxvhCnHNv2dPJxVM4ndebL7WLdsY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1687168576;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=EHDB1goOIdClF7fSskWHB6HJ+dOH2Pf0/f+fBVNZKrI=;
 b=2cxWY7Vw2OWzwjCUYjwhmawhiT+eBMOhUzAYEEySvXUmGZ1RMij4oQYT3UbwcV7Dqk24XK
 dqaTNsjGYQYbioDA==
Date: Mon, 19 Jun 2023 11:56:15 +0200
To: Bean Huo <beanhuo@iokpp.de>
Message-id: <20230619095615.pr6dw773bsruwqar@quack3>
References: <20230618213250.694110-1-beanhuo@iokpp.de>
 <20230618213250.694110-4-beanhuo@iokpp.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230618213250.694110-4-beanhuo@iokpp.de>
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10745
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 mlxlogscore=698 mlxscore=0 priorityscore=95 impostorscore=0 suspectscore=0
 spamscore=0 bulkscore=0 clxscore=204 adultscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306190090
Cc: brauner@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
 beanhuo@micron.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk,
 jack@suse.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
 linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v1 3/5] ext4: No need to check return value
 of block_commit_write()
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
X-ServerName: smtp-out1.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
 ip4:149.44.0.0/16 ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
 ip4:192.31.114.0/24 ip4:195.135.221.0/24 ip4:195.135.220.0/24
 ip4:69.7.179.0/24 ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Spam: Clean
X-Proofpoint-GUID: LJZkaBD7PygdDa5m4pxSbIdZwtj1U5wD
X-Proofpoint-ORIG-GUID: LJZkaBD7PygdDa5m4pxSbIdZwtj1U5wD
Reporting-Meta:
 AAEpTbr2jEXBGqzJee3buUXVw/U7m5yt/8aEq6ibh+FW/uir9/TcyPc21aalVaW3
 r50r4/UyyAfhRpfKjbxdxWLjF8pdAAKGikrTt+TN9udmIiwkwiaHIgDodkeCWCkb
 iP3Y1nsKKkLFlQsDSY72QuaHbL3nKUFm7gHDIYCPFpRwhqU2kcrfoFKDHAXHncme
 3DixPOQ3nmkAomHnB8RpZMe5TCTblQLEgELFHOAfgJKsBw85OyttQ8hqywPjjtNL
 9VllKfYO/fHlf7jpoCDjZ0uznMM5IG/Mk/f88rSdZZrLBEe4pakhgkoXnItXEBNt
 CPOgMLwOLagJyXcrzLiCwEvAKIL/Ivw5G29i4+87QoZGIVTdt9fDYkykqeiyVkr6
 r3NtQElJDDpNg8ySpvld4Wo1XpJpBfNmYT/Z2YjKmRPR1TMNwWCf7U2dhkFjVjwO
 SxjjvK+vJt3lKtG5kmDHcl1WgwsMDxyi6lRF6JvG1MJejKxWxIp1DOWNgy5capNq
 gUgEkTXFU3MI+a1UUUQXlJ5fyZCIDump5PSLTxs2fRwa

On Sun 18-06-23 23:32:48, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Remove unnecessary check on the return value of block_commit_write().
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/move_extent.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> index b5af2fc03b2f..f4b4861a74ee 100644
> --- a/fs/ext4/move_extent.c
> +++ b/fs/ext4/move_extent.c
> @@ -392,14 +392,11 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
>  	for (i = 0; i < block_len_in_page; i++) {
>  		*err = ext4_get_block(orig_inode, orig_blk_offset + i, bh, 0);
>  		if (*err < 0)
> -			break;
> +			goto repair_branches;
>  		bh = bh->b_this_page;
>  	}
> -	if (!*err)
> -		*err = block_commit_write(&folio[0]->page, from, from + replaced_size);
>  
> -	if (unlikely(*err < 0))
> -		goto repair_branches;
> +	block_commit_write(&folio[0]->page, from, from + replaced_size);
>  
>  	/* Even in case of data=writeback it is reasonable to pin
>  	 * inode to transaction, to prevent unexpected data loss */
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
