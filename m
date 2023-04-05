Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61C06C7619A
	for <ocfs2-devel@archiver.kernel.org>; Wed,  5 Apr 2023 07:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hx24fGIouNzqlHfIvKaYqL0S6+Q9Ye4jsYPdZaZwZ8g=;
 b=FRNdoJDYwrNWC2bDIuSThM6AypafG6xDhIH0xrrxIRUzx5kNkfGsG91ukfRHB7kvM81jlWixUkko
   tqzNbQJvlodHajmqqzwiDOVVfwMRISfLM9Lmu6aLUSyHE3mwyOlbN7c4luM1SPfaXWUlD2N//erN
   cfkv9s2H78vkO3Vipu0rcw+2dhVNbu5WizN9b9FF9KUab9P7sFPLd96oL+RP+QCKQBhXAO9BrYtl
   o0gmB4+SZj8fSxX8bIkvrQWLEQsBWxeyShD5O3bEN9it6gSnbuK0Lt3upxvFS+CZjc/QKLm1W2y0
   DXKeZ4yy+SVVlgfSFxUzl4pnqryIjbKI/1NZYA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hx24fGIouNzqlHfIvKaYqL0S6+Q9Ye4jsYPdZaZwZ8g=;
 b=uJXDDlDrLdaR8HePUUgQLkua7bV5gmM1LEcLUjqY9L9nvYAC4tJVubyaCilDF7bqYxBJpMlRwfyI
   Gsd8Mw9+nj1G0Fhw3LEcZDhATyo6+xYSwwcl297IBseaykFQUA2iKhuEgYyBgktYmvvslU3vd0uG
   oYCqwm225faoa2ZR82w/IhpOaBX09gS9E3wTh8REiVRBNcN7QaR1u/4sVFuaqjmmteCVT0Co+lbc
   XFOMrDhsXeGgMF8KXU5cKQ4w4aPJ0YSIB6FC9d4kdVPafJu+aJeZMnAx+MLDqwHvO3ic6dtQQ57r
   apilFjVmRlp7bKfDrykj47x2jc+AKHrB7tWquA==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSM00J4VTR4TKD0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 05 Apr 2023 07:49:52 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1680680979; bh=Weq5xIt7NaRy390+BxKr0DPL+Sx0J9wKSXtMC/5JUh0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=l5Flc0M5e8GB39z9f8BFJ5ebxS8y3KvMmKQItlraREhf8AkpnxMWHlz+JXp8p7uI1
 Kljlt0scTB58bQpEmq4GK+eEA+W3BOPA5cN1xWCrA68FuXwrY3GmcIErMd7I6tygyc
 V9JzsMXQMyO0n9SdIkQE39mGNJMhI4Juz/LKaq5zFFseVa5v/r1CJgL8buDMvRme/M
 V60YaWT3OGRM2C3c4p9BXErpUiMxTPWmcEsEkzEZBNsBmiLmJeuYqKxc6IXyHEJcg/
 oPvvLtbmc/+Gs5xXnYjOU/toIg6/1FGapaFmAgQB8BCmWBhC4ZrbJ8UgmFtFOJlHgF
 qh4BFYcRworMg==
Date: Wed, 5 Apr 2023 09:49:27 +0200
To: Zorro Lang <zlang@kernel.org>
Message-id: <20230405-bazillus-nanotechnologie-a8cf619d8454@brauner>
References: <20230404171411.699655-1-zlang@kernel.org>
 <20230404171411.699655-4-zlang@kernel.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230404171411.699655-4-zlang@kernel.org>
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
Subject: Re: [Ocfs2-devel] [PATCH 3/5] fstests/MAINTAINERS: add supported
	mailing list
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
X-Proofpoint-GUID: oXwXFRc6sqjCGKYccmWgo_9sVAwpggQo
X-Proofpoint-ORIG-GUID: oXwXFRc6sqjCGKYccmWgo_9sVAwpggQo
Reporting-Meta:
 AAGErcmlMWkTzKBZY3qNQwx19RP/HIZHcSeH6Fd//KDYcVtkBGm0WEz/7U6gGj7m
 gSkDVFs55L+Ta4nttAp/GWAwAG3cwkD86/KFJZ/O6GobKxsgi2o3uichCeqgdx4o
 Eqfrg6/zImVdVtkmyTJsYdZPAdmNDm5avRQlTAjBhDg6rYsRDEO0vZlYGEYdhWcS
 w8O8PfzhHEnVSdOCK/KSEIbuW6kB9UJvGhepCWYByJdy7I2S01HfUQjDcDZLQkC2
 ev/YmWU7c8P7AcQW+rS5ahYiaVO6xaTKhCbs8pPJVADZsiCVfcY1zoSX9fr+UdMq
 APKp5iJO8GCnWW1/KSXQ/KFk8x7jFIsxxrWrkEIx9/Ud74La5+jcEFFlFmhrdJzR
 7pvORDTe+bJ1J1gkeV+Pi9pFWhCr7tIWb6zg0XzmjjVC1y+0ytG7uNr33e/lwTyY
 fXmpcTTK5g83Z157ejKSuNRoUGTSHaecfNbTSOccafhW5dThIqs7DjsL7sNL/7Vc
 UjhnvWh2RLKA4B6+7qwMOzItSV2a4+HYK3HC0DsgkmV2UA==

On Wed, Apr 05, 2023 at 01:14:09AM +0800, Zorro Lang wrote:
> The fstests supports different kind of fs testing, better to cc
> specific fs mailing list for specific fs testing, to get better
> reviewing points. So record these mailing lists and files related
> with them in MAINTAINERS file.
> 
> Signed-off-by: Zorro Lang <zlang@kernel.org>
> ---
> 
> If someone mailing list doesn't want to be in cc list of related fstests
> patch, please reply this email, I'll remove that line.
> 
> Or if I missed someone mailing list, please feel free to tell me.
> 
> Thanks,
> Zorro
> 
>  MAINTAINERS | 77 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 77 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 09b1a5a3..620368cb 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -107,6 +107,83 @@ Maintainers List
>  	  should send patch to fstests@ at least. Other relevant mailing list
>  	  or reviewer or co-maintainer can be in cc list.
>  
> +BTRFS
> +L:	linux-btrfs@vger.kernel.org
> +S:	Supported
> +F:	tests/btrfs/
> +F:	common/btrfs
> +
> +CEPH
> +L:	ceph-devel@vger.kernel.org
> +S:	Supported
> +F:	tests/ceph/
> +F:	common/ceph
> +
> +CIFS
> +L:	linux-cifs@vger.kernel.org
> +S:	Supported
> +F:	tests/cifs
> +
> +EXT4
> +L:	linux-ext4@vger.kernel.org
> +S:	Supported
> +F:	tests/ext4/
> +F:	common/ext4
> +
> +F2FS
> +L:	linux-f2fs-devel@lists.sourceforge.net
> +S:	Supported
> +F:	tests/f2fs/
> +F:	common/f2fs
> +
> +FSVERITY
> +L:	fsverity@lists.linux.dev
> +S:	Supported
> +F:	common/verity
> +
> +FSCRYPT
> +L:      linux-fscrypt@vger.kernel.org
> +S:	Supported
> +F:	common/encrypt
> +
> +FS-IDMAPPED
> +L:	linux-fsdevel@vger.kernel.org
> +S:	Supported
> +F:	src/vfs/

Same suggestion as earlier, make that section VFS as it covers generic
functionality,

Acked-by: Christian Brauner <brauner@kernel.org>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
