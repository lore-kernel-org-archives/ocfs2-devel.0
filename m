Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B91FEC76188
	for <ocfs2-devel@archiver.kernel.org>; Tue,  4 Apr 2023 23:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=tZJxonlVUMXEhhLz+KUYGEj6cTZqNPl9M0zTz5/flCA=;
 b=Ibe4GiB/ee5boLpFbGkcB9/5GSNC0mBMIZ9xmYjX7T1k5EmyDhIgm5Y4Y9/Kn/hWGJiQ3kzpo3ls
   ndEj4rpfbRUGSiID2KfwE+uUSU3IlwOpozUV/PYqwzgvk/nruOd6yepC97eWbxBgnssMNquPdgiB
   DJoMlZaHPfiUO/TLRr6Q8sRW5k2Jjq4tXOHSGWLUP/CTOkg9zFgPCezxKO7ePbGIXIj9Svs497OU
   X8MdNExNzjG7hE4ts8mRmYPT33yZR/AK1Lt4NAs0ngAhV8mH4NaYfAkA/jLYgxFyncEIKuky60y3
   EOCYkdt9Ug0gEIvIJroA776PZ/2KH5O7neAicQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=tZJxonlVUMXEhhLz+KUYGEj6cTZqNPl9M0zTz5/flCA=;
 b=FXzBILJoHq7Z2yLcXiISrNrDgTaZcVgCDYqW/QULUDP/55LDtMRJZxV68S0MBHWej5rwHMDLYo3E
   BfQEt3pD17pHJlpxvpAHpDNUaNC/hgHAyMpKJKH9vMnw3GjShn/gxgDVxrgEYJKe2v5y8Kgsd9Zf
   nCrtdocGtqiCYlC6UY1iEuizjjqNEb8NR7CqtYhalR9kxGW4J2gyInD6IouAisG1m5SbfVHW0eV5
   +7/Fl7lb/WpqOXG3ZGnurKPpoxxpjluP8JjLWKgXCop1cyjk8jgNkKwlG9bNdWUlgTZepL4IY8Eh
   7kDv7NGutVCfpmNNz6XidsM6OD/YVTqf/wycBg==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSM00EQ16BDM110@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 04 Apr 2023 23:23:37 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1680650582; bh=n/9jmBZO4HC87mIQyzeLEmcpGLyNDj01f1vbSC9mn1Q=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=b5+6maz5xNhwYCtGwMq8kBY6ewuVOIdTUKUDsuMQwiiVGRZ4JLKIYUBPjB2R83qK2
 jmGenLfcD91UqsPu8iPNLDQItXW3gHeC3I3+QXoAFh+P/RTje+RB6N+AVCH6go5t7H
 lFGiVsSBrnYilekJWLE6vxyxrlVTrpCB4T4Y9zy6W5+71+O7LZHNDuLkkIeCmSFMdd
 LnjJ5ISVLkFIasoDRJ2L6Z+C/842tcZjmW0jqL8fTsEkpwRvnDkEqNPwfaJWuniC/G
 qFkKLchRB/hFADz1nfVP1I1Ba9kxaadE3S8FPdnJd+Kyn/HycjKR2qAf5p461PbUhh
 fEgpj2mzxoQVg==
Date: Tue, 4 Apr 2023 16:23:02 -0700
To: Zorro Lang <zlang@kernel.org>
Message-id: <20230404232302.GD109960@frogsfrogsfrogs>
References: <20230404171411.699655-1-zlang@kernel.org>
 <20230404171411.699655-5-zlang@kernel.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230404171411.699655-5-zlang@kernel.org>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10670
 signatures=596816
Cc: brauner@kernel.org, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
 ebiggers@google.com, amir73il@gmail.com, linux-unionfs@vger.kernel.org,
 fstests@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, fdmanana@suse.com, ocfs2-devel@oss.oracle.com,
 jack@suse.com, linux-fsdevel@vger.kernel.org, anand.jain@oracle.com,
 ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 4/5] fstests/MAINTAINERS: add some	specific
 reviewers
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
From: "Darrick J. Wong via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "Darrick J. Wong" <djwong@kernel.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-ORIG-GUID: aHZZOK2RctEnJgfE3adVYmzVX9jg4Sn8
X-Proofpoint-GUID: aHZZOK2RctEnJgfE3adVYmzVX9jg4Sn8
Reporting-Meta:
 AAFNj7Bvu8+cp7WLv6KLZ1+SvbQNDzsr1CZK37z6sc1xTT32UEa5qWVKW/I9/3aX
 kDFZXawTfdTLzCfS0XB1+zugRyYamZqkbX31WrUV4UnWPb9cqbwIjudCQmPxrhhS
 dFfBF8RukJ1N1Pbq3KedKW5oyE5VFdV4UCbrbErQYmssQmlSRrz52is7TSMQmY40
 tH7aVGu05kx87P9xcfiOUSB8rk+NOLuqdvJubTNzt8sWIAGymyeLJoOVHIH/Lr5B
 KyRJ5npaT5+9pbAJVYuKf/v1jURLNzyCUfB30yBvtCzuQnyZ6hrg6tp8g2MIOKmf
 2vZTcJ/8BYG7NmBUFLJyojLfc5+yiO6Mebo+qQ91A/JXN0sj1Q95U7tbzg2d6Viv
 +kRaDJlXp953d90QfPqpUXZd7ykcDLqwXe5iNfhu9ay0DBhc8KUHJMYi9R1Ixh2K
 fONVmSO+RzJdpP21l23/j/JUgRnPCXAWW6Y91l0bJDLRzYZlKsV7vFE7qcKC53Er
 CzXtp3dbdtiV6ih89ZOo98v00XVeGO0niaHhEcLN3e2a

On Wed, Apr 05, 2023 at 01:14:10AM +0800, Zorro Lang wrote:
> Some people contribute to someone specific fs testing mostly, record
> some of them as Reviewer.
> 
> Signed-off-by: Zorro Lang <zlang@kernel.org>
> ---
> 
> If someone doesn't want to be in cc list of related fstests patch, please
> reply this email, I'll remove that reviewer line.
> 
> Or if someone else (who contribute to fstests very much) would like to a
> specific reviewer, nominate yourself to get a review.
> 
> Thanks,
> Zorro
> 
>  MAINTAINERS | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 620368cb..0ad12a38 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -108,6 +108,7 @@ Maintainers List
>  	  or reviewer or co-maintainer can be in cc list.
>  
>  BTRFS
> +R:	Filipe Manana <fdmanana@suse.com>
>  L:	linux-btrfs@vger.kernel.org
>  S:	Supported
>  F:	tests/btrfs/
> @@ -137,16 +138,19 @@ F:	tests/f2fs/
>  F:	common/f2fs
>  
>  FSVERITY
> +R:	Eric Biggers <ebiggers@google.com>
>  L:	fsverity@lists.linux.dev
>  S:	Supported
>  F:	common/verity
>  
>  FSCRYPT
> +R:	Eric Biggers <ebiggers@google.com>
>  L:      linux-fscrypt@vger.kernel.org
>  S:	Supported
>  F:	common/encrypt
>  
>  FS-IDMAPPED
> +R:	Christian Brauner <brauner@kernel.org>
>  L:	linux-fsdevel@vger.kernel.org
>  S:	Supported
>  F:	src/vfs/
> @@ -163,6 +167,7 @@ S:	Supported
>  F:	tests/ocfs2/
>  
>  OVERLAYFS
> +R:	Amir Goldstein <amir73il@gmail.com>
>  L:	linux-unionfs@vger.kernel.org
>  S:	Supported
>  F:	tests/overlay
> @@ -174,6 +179,7 @@ S:	Supported
>  F:	tests/udf/
>  
>  XFS
> +R:	Darrick J. Wong <djwong@kernel.org>

For this one hunk,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  L:	linux-xfs@vger.kernel.org
>  S:	Supported
>  F:	common/dump
> -- 
> 2.39.2
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
