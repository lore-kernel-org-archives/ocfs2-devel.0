Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8258BEB64DA
	for <ocfs2-devel@archiver.kernel.org>; Mon, 19 Jun 2023 09:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=J11ax+XtYs9kqNPpvWcOFCgo8tfchOL4JHJTcNKLr9I=;
 b=usS7hrzkofNfNnTlnIC+AWh/JwcniWQCGbcY4K2QmuUSS8F3/3hFAknlzxAt8HalBM7mL7CIKoGN
   ziKV3vCVgEcLafaCC51P+KKKngord4MGsjFB6dXno1Gj+WDhMAmtYtba7mpPyxE54t8BjUa50xv7
   Y4d2+G50k/Lm4NOZ/ds2cxEuI1UgIKW40gphA6UG5NTzyPXfGvgV7RzdN8zyw74UE9Pl5fjr0HOg
   SN0IqANCCZvw0O340gQcNpx6u3e3L5Ed2GcyFVTD86yUJX5Ogu54neXjcpVWcyUPHigRDk1r2oJj
   zIcsp/glxFdwTIpPXzmJqGeA4Y/z/qxX8K9Wng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=J11ax+XtYs9kqNPpvWcOFCgo8tfchOL4JHJTcNKLr9I=;
 b=ItpZj5RFYs67ihPiOjodP9m6wDCK+gu1fLmSOTAqv8j5U0nlWQCII1wwZU7s+pSAsqmaSga7egY2
   j2Kn+kxS9WzZoC4OSANFSUhgMVNLK1hkqRY6wWNlN/o8yPMClkW0vJyP5IQPo0VmXRTSeHWWcUD4
   D/WGL8LQW5P8Vh2pxptQwu/TIGnN6+LB890LC+uhmdeMtKk1jhdoI+PoCpgia6trLGxm91HC45Ry
   ozmSmNIXn28gRI2K18prTkicNvi9Iumt4CaUcwa5XYf3jux8KbKmRnnZYl4OnYqapziUS4+gymaK
   sxY1aBsT76Zqdtjm3NLnUVfUIVp/Pq4spSq+XQ==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWH00N7HVMHNS60@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 19 Jun 2023 09:56:41 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1687168589;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=NQVAvWxLe8ddOnT0x92jyszEXcQ2Ez0WGCSpMTarvf8=;
 b=O7ivCX7C1pmL0yBAJe7Ne+Y+kth455ZJUYF10UMTbSbKG39ENlmViLSrEC1BGNn2VxTtMc
 3CRtP2k1YSIlYIVybmbfACDfVqq4ifeSNuarWY2bERzoWseJBGvX4b/BH4FHxoL7kcshex
 vMQP+ioZCg5BLuPhPVBDJESP+ixptYw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1687168589;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=NQVAvWxLe8ddOnT0x92jyszEXcQ2Ez0WGCSpMTarvf8=;
 b=yVCXTvzoVEmetaKWn5zm+QI1WM708Q/50rB5VjHCe1WHoS6NF1tvR9p7MyqanZqNB4z/dn
 GVYPWKjBPL19cvAQ==
Date: Mon, 19 Jun 2023 11:56:29 +0200
To: Bean Huo <beanhuo@iokpp.de>
Message-id: <20230619095629.qicy2guryvryc7el@quack3>
References: <20230618213250.694110-1-beanhuo@iokpp.de>
 <20230618213250.694110-5-beanhuo@iokpp.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230618213250.694110-5-beanhuo@iokpp.de>
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10745
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 mlxlogscore=586 mlxscore=0 priorityscore=0 impostorscore=0 suspectscore=0
 spamscore=0 bulkscore=0 clxscore=196 adultscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306190090
Cc: brauner@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
 beanhuo@micron.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk,
 jack@suse.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
 linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v1 4/5] fs/ocfs2: No need to check return
 value of block_commit_write()
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
X-Proofpoint-ORIG-GUID: Y4zEffvDRjpUDTD9fbNfVWkauigQ2BfU
X-Proofpoint-GUID: Y4zEffvDRjpUDTD9fbNfVWkauigQ2BfU
Reporting-Meta:
 AAF3HEHbjSNvXa2cGCI9LZCB94EYA10XoszqoOpyCTx7Gxbttts82shb+QlXpZGe
 nbeBMlgmsxrR1Gm18HkEj+SnDFX4iRH1dUmfTk9BzGSdRQWbYuDbR/GluhuR/Pyt
 p7gCZQynZqG8szSGRIZFTYT88btlg8AbsC3Sk6frOdqEyNco+o0Ttit46HYQ08b+
 FPcBHQ5c0eW59v5aVRWYquNsCBcmkSRRwGK8I/9N9AWoUKHpJ+SgQUvcIqKzXuK0
 DHEcaWd5V0SZPi0RbI1QRKo6+O8T0eWIqw4lXLvVtFRk3S3pBGZ2U2CyCglohTTD
 7cM9axOA9CFc/mVz15Mg2RImjhWmEqDWV5sZoEjE1VpmwBFEZYqKMbngeD8oFOMk
 d+oj7I3k26EFy/q/wASy0J3U7JzxrUDf2+P3A+zjgPkOxpZZknwVTWOGS+TtHrr0
 soKd916ga4N+koFTMDpyfedWTH2DY19HYjrMJNlchCPamAdBuxyVETn+BSjFCY9w
 TGMQ0+nLEjI0rz9E8iBrz9RT6/AHmiiRnbH2aBNk5qBf

On Sun 18-06-23 23:32:49, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Remove unnecessary check on the return value of block_commit_write().
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ocfs2/file.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index efb09de4343d..39d8dbb26bb3 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -808,12 +808,7 @@ static int ocfs2_write_zero_page(struct inode *inode, u64 abs_from,
>  
>  
>  		/* must not update i_size! */
> -		ret = block_commit_write(page, block_start + 1,
> -					 block_start + 1);
> -		if (ret < 0)
> -			mlog_errno(ret);
> -		else
> -			ret = 0;
> +		block_commit_write(page, block_start + 1, block_start + 1);
>  	}
>  
>  	/*
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
