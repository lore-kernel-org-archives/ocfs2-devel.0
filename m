Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44E94C76188
	for <ocfs2-devel@archiver.kernel.org>; Wed,  5 Apr 2023 07:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=SleHXq7YbkwB1R+Al8L2rBWehd/Vr0jz12STFJBnX0I=;
 b=sI2HmGYfnlf/41+bNsSf7zrJWV2YAJLrXarMGw2fCVmDhzuxVxZFgp/EThJMJsQB5fLah//R+CCo
   va4rfXppPpczjJo4QHkAoTT+wnq407KsWdN5L3MeS+1aNi5x1EJ5Z+0Jo4bbxWbH9gKYGVyoqqZh
   D95wihyTXVC9ToJtF2TeBseT0gMIJQFgzHLExlBH/iJw/31l0GHmKcVxRlOJmNGTF6sk10fuCRE4
   bqIP2Cylwe0tLVy0ODTCC00BnGzTQAq5v2dcqx6G8azqKg01IzDSR1DtGMCEQjEhXaOOIQORCzYE
   EftHw7EXpvKeOYXO3h+uTuS0FsVabbYG+bxRdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=SleHXq7YbkwB1R+Al8L2rBWehd/Vr0jz12STFJBnX0I=;
 b=h3U2DwG6HF2lo9pM3FUoAR18o9OtIgrzLWErfC0qmY0AYjOG0QbnsRGv5aCoOuqhbyzdkdUmPAiY
   ooEO7ArTa5QvgU2+WFpmSFWqqqiNLJL2WgnrQTdkt5+MZw3PUSyfFPwso+2hDXI8THSd77PSvCKO
   er/gmJC0PfpKzOk00x6fdOkgbO5B/ntETHsA+Qnhq0Q+mXO1mqOyhBGLdichXJzB9+tXI7X3oSLY
   QOkK8m1nIj4EZYrwVxF1m5sBDjf4jKubKLkjB6/FLURDHN/ukeeMcd0dIgPKf0YJXhaspJPJnh/F
   kLFIIUQpuWIX7JpqPyCsEhfWF8AOfR0JRER5IQ==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSM007IKTOXFC50@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 05 Apr 2023 07:48:33 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1680680882; bh=iG+5hwZ+00F79HrZr+lwoC/xHcVnBc+M7O/KLljWetw=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=m1DKSbXsJkksJc50fMfe9E5d0vBrvfPBTXO+qnnm/ZTsLLxsc3tXPBZId8QVlQtiU
 tWKlNvtJ2Q9dVvvTQaFHWMtwuARGM7dZZzXwR1ttFnc3yyiYR3q57p8NorQfAf9uMS
 WsYimi1fhn1ocdkp7W7ZJLsA6QYxBXFg7FavFla8XWJ5S5YKn159fdD1V4pR8gIHND
 qxBCxbTyh5rPT8Q+Juc3t5cHT4YE/gnWHSbjyB0IaJjhxN+JqgPh5ilGsz5wD3K0w/
 xDKn7EIvgns7JH0LBxr6f6iI2aFLM9jWYK+if8Z7xiHJJyBx7qo9ajvgpuWUUL/rKD
 j5n5m82ILoILw==
Date: Wed, 5 Apr 2023 09:47:55 +0200
To: Zorro Lang <zlang@kernel.org>
Message-id: <20230405-idolisieren-sperren-3c7042b9ed1f@brauner>
References: <20230404171411.699655-1-zlang@kernel.org>
 <20230404171411.699655-5-zlang@kernel.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230404171411.699655-5-zlang@kernel.org>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10670
 signatures=596816
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, ebiggers@google.com,
 amir73il@gmail.com, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 fdmanana@suse.com, ocfs2-devel@oss.oracle.com, jack@suse.com,
 linux-fsdevel@vger.kernel.org, anand.jain@oracle.com,
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
From: Christian Brauner via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christian Brauner <brauner@kernel.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: 4bUPbm5UK6ze2cW4EtDLo-uJU6f54nhe
X-Proofpoint-ORIG-GUID: 4bUPbm5UK6ze2cW4EtDLo-uJU6f54nhe
Reporting-Meta:
 AAGDqt1S1+uJVnThrq5QqYxJmxeG9ntWtteujXMJN/Tt+HxZ2I+JDfIYNeQdIXA5
 1qJI2H/1qhlcxUZIihlTl7qT9ADMWsiPOPhSRPU8fB4TehcdT2VHyfcZjs2pbyxJ
 yTovvwo5n5sH6h2q/4xZMFvY3uh9iNFyw3qTZQ6ZXAmGD86E6xbCLI7n1F7CP4L3
 4VJh6IoJao0GZ9Q721onkJRYUS5Z7vphaCqIG8/b8FugK58jDSkSj/JGbvkdFmMm
 qg1nnr3OwCb/nOayrD2N53BK/IzAyEh6SBMMiQb63kyge0Zx3VSINzWE4F519R0x
 Bil+Z04LzlXOMrv8xueUkyfduRbS43Iedxe1Z3Sg48D5ipGRQEx4ETNpDPNLePg8
 ww+js8ZISxpfKvZBWEWMgph6TmL2R6bsBPVFJp68l/PsfIKKnUzQLTbGQ1XSr2M2
 84riUi4CxwXDKiBPxQcAuL9E4rhpq6pJPbU8EyZeSXnt9Hpu8diOwNPy3eWX2Hsy
 UbqpZ03v7psL4IovUwc7/tjPGRtOZH0s8EhTmR0FaW4zmA==

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

I'd just make this VFS since src/vfs/ covers generic vfs functionality.

But up to you,

Acked-by: Christian Brauner <brauner@kernel.org>

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
