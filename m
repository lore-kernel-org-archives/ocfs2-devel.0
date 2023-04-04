Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F022C6FD1D
	for <ocfs2-devel@archiver.kernel.org>; Tue,  4 Apr 2023 23:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=b8AyPdYQ4E30DscfnL+ksjcDRChTjKpCGHJmXHQJGS0=;
 b=okDtoV23MTlVjMPaaLGedY+ODwyzQJ0LoH+zghWUAlmzdFHI3IvOB4WDalzxGwNFcCiOJ8y1HPwM
   sC4tPeud/u8C9d5FKvlVbSKdLEvWU4Giff8Sxg4ZId4J+3GarhrWNv47VKTkcgCF8MxS8+2gmCQK
   Fnsvoh34gwP3xsjKmRETAJb5AHf9zu8CI1L6nRhh5knCn9al7dn1i3kB0ja7+kACyqW8mJbXvFvp
   9LhEW8gwJEMS9djFLZiJ0PFrNX0eU9A32igVfgNAjafMSRFCT9NsepPKKHF1JA2dK6Tb1GlkrMlH
   9BeFX29wlYmnQfXrVasjfUn2CA8l0RPGmZxaVA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=b8AyPdYQ4E30DscfnL+ksjcDRChTjKpCGHJmXHQJGS0=;
 b=mRPy3z3Qme3bNaMUhujsYegHqFsTBrxC9U6Hau7ZDKzitMG/RPFR1cY3uqsgDan7PSNLvC4dblc8
   8vv49FMTz/OJbq7k50kV0xmQqu0S+oV4U+MaHH3iLXRopDIs4wwHcUdM0cib8xkhgrsWZKUHaARm
   Bk8kLoiZzWKA8u3ysa0SnF8GQEOMI5tYkXVTZgTBtYMhRLHjlNPgSwlpKBuZ3KamGYhpDHtXoglW
   oD93uJY0sRLYGSFPprS66MVM9yZH33lLBW7Ual8LXrjeierzdxm/F+OZvvyS7K/Fpoxcqmbf6mUY
   0wADHoRkHsEOEWSA5B+H9fFqG/2u4IQlUHzWJg==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSM00KCZ6G58P30@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 04 Apr 2023 23:26:29 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1680650777; bh=/JyZmGk+myakLaCI1hhSwfIXR6hWB6PhXWV1RmrEmtQ=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=SAMn41ZDLqNoE6Vm+Ws6NlgV5JNtcTsUfptIJYmSWkQXDoMlNthiN90l/6s3+s165
 zakb05T4J4axjmNGiNnSg/PLXu2mm3dIwNe0EsxcSRGtsA6eQKHcGUglH5oPWJiPln
 Dnh6qUYxcYXaByVI2SRX7KIUb5nJ3EW1SYPR/1H9VUb+ZU1nIskrAL356E3Fr1G3fL
 phSprFPiWpHqQwH9IaxCrGVhnGNlQ+9W281nygerSAi/jRifQP+6OPEKpbziDA2KNC
 ugBoZkZROddJxKcgQ9Fr3rXsP5BUTRC+q5V4S69CQ1Y9d015ztJzol3MHxJztXrSe+
 8F3ncUmDR1/ag==
Date: Tue, 4 Apr 2023 16:26:16 -0700
To: Zorro Lang <zlang@kernel.org>
Message-id: <20230404232616.GE109960@frogsfrogsfrogs>
References: <20230404171411.699655-1-zlang@kernel.org>
 <20230404171411.699655-6-zlang@kernel.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230404171411.699655-6-zlang@kernel.org>
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
Subject: Re: [Ocfs2-devel] [PATCH 5/5] fstests/MAINTAINERS: add a co-maintainer
 for btrfs testing part
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
X-Proofpoint-GUID: pCO9kL-b5neVuYVkR6uL9NnTDIcVygRa
X-Proofpoint-ORIG-GUID: pCO9kL-b5neVuYVkR6uL9NnTDIcVygRa
Reporting-Meta:
 AAGz6udDEsxnw6NS1PXWyyddnihhENYnq9rih5SqfHK2SWVDVkKfiz+RzksEqNei
 25qmnPGOaZhz9NxjgjFY548bM6kmruP+oUFezsUfZt1DK75j6Y9pln+E3g4WBm7I
 /nonwUiKmrGfPJ8l6RagAojIhX7FnIGYzzbmLnfIQ4NHGJz9XNF1Co7z2I7ixzmN
 GiNVckzqRwql9TPIte3uhvOyeMFnGqLbAmg3DrjdaPoXnbH8JsZKfpCfMHjAYswI
 S6ScS4JTO0TkF5wCj0FEy7xSaeHMCorkPsZqK7jZplx1OyuXT56UBdiM1aiHT+lC
 jEoh3hVCJOwGaEZ1JfSGpmR7rVTrTcv7soeL4VfU5w3xMgR2r3TuifiP0lsRGLqD
 XOoGVHkDdVPELioKT7xuc+ZM2MT9l58f0UfxDUVF4JBU4Bx445B8H912LBhR8fJk
 56xg0i8PSnkcvpdu5Y6mAX4DQSdD887d29PS2Pn6xyeJMaeg01XWx/YJmHXiSiw7
 7WPxfJcjBoXQQPavcf/GfRHaiicG953PNqZ/gmnJaFD0Uw==

On Wed, Apr 05, 2023 at 01:14:11AM +0800, Zorro Lang wrote:
> Darrick J. Wong would like to nominate Anand Jain to help more on

In case anyone's wondering how this all came about -- Anand asked me how
he could do more upstream fstests review work, so I suggested that he
and I talk to Zorro about delegating some of the review and maintainer
work so that it's not all on Zorro to keep everything running.

> btrfs testing part (tests/btrfs and common/btrfs). He would like to
> be a co-maintainer of btrfs part, will help to review and test
> fstests btrfs related patches, and I might merge from him if there's
> big patchset. So CC him besides send to fstests@ list, when you have
> a btrfs fstests patch.
> 
> Signed-off-by: Zorro Lang <zlang@kernel.org>
> ---
> 
> Please btrfs list help to review this change, if you agree (or no objection),
> then I'll push this change.

This is what Zorro, Anand, and I sketched out as far as co-maintainer
resposibilities go:

> A co-maintainer will do:
> 1) Review patches are related with him.
> 2) Merge and test patches in his local git repo, and give the patch an ACK.
> 3) Maintainer will trust the ack from co-maintainer more (might merge directly).
> 4) Maintainer might merge from co-maintainer when he has a big patchset wait for
>    merging.
> 
> Thanks,
> Zorro
> 
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0ad12a38..9fc6c6b5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -108,6 +108,7 @@ Maintainers List
>  	  or reviewer or co-maintainer can be in cc list.
>  
>  BTRFS
> +M:	Anand Jain <anand.jain@oracle.com>

I would like to hear agreement from the btrfs community about this
before making this particular change official.

--D

>  R:	Filipe Manana <fdmanana@suse.com>
>  L:	linux-btrfs@vger.kernel.org
>  S:	Supported
> -- 
> 2.39.2
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
