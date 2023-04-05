Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5C89C76188
	for <ocfs2-devel@archiver.kernel.org>; Wed,  5 Apr 2023 09:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=TLA4Cz4HQ8ZkfxC5Dkfw/P4LsEKLD/0UhYeA8iQXxAQ=;
 b=nfo8jxfZoTIrpACL00Xt27/BWMR1j0Aj0f2EMVoVVfR68E2wvhDQ9MnG78BEP/VQD0OkoKZRTQoq
   72GB3J75rLEnguCLl+69NwOtpSm6PN9NUF5+Zklz29qm4cl2PLC0IcZh8BL9LTgty02GwaILCEaF
   aF+Ghni6u+KpcXDv8TgCz5LCcY/DRPT8xIurvG60VSl1M3H9eSqwDCDVFpQhZ29sSsjjtgDx6AZH
   cdNoeDvFI2KcfSHqmPBiHzvEV0rgFoLypS3kWAe+ONwKq8j6L438jfoGcdYPrul66F5y1OrpFkx3
   s4FoarDa/ieJ8poBuptLWJ0HigTQKboVDfPjHw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=TLA4Cz4HQ8ZkfxC5Dkfw/P4LsEKLD/0UhYeA8iQXxAQ=;
 b=EJJbc3yvGpqjnj3SIvD7qweeRd+bJySSmxoqfrCDOG0gVxpUX0c0h7DqzBNicPcR5mUEpV8b93fC
   MZsYiTPBv/r84hGhex9QYvOyRHtOFxtIrNGghObM5hS3nbpkMVdm2eB/fzRKlzLcy06NzgFKOi32
   XrQ5Lb8NvHshOvq1gY9SdoMMJTqsAcghBDS/bGKQ7E7y+9lksV0daVuzNGEez+o6PpJQeHXZRgbe
   /wya455kKoNizj+7hqexmdo0a1C3OE4uACHdCrYOqr6pMjpFGDymr3NpeZiTDA85dWpDS4BD71CD
   uvFKGQPlmD+qL3WdF/krtoS0djEJgxG8NdBzDw==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSM004XXZFRBYC0@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 05 Apr 2023 09:52:39 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1680688340;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=5kxEOZs1Ac76OBwtijAiq1LEHzxrTF/ESnoZeBX1s5U=;
 b=IRxH5dLldXbzWoseDDJFLON27UWQisexrdux6pTmZwMEJUh7+KDDgOL2FFGwMdw4qXX+88
 SZXtRstArd4pzrgcJ8oig7KPreFloNY/MGYHpRLp72bp2qfZlFYU7wFiZqAGyQ0vGW2203
 wLigaRb7GuLAIa/y7Wt2ZqyTi00uXvE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1680688340;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=5kxEOZs1Ac76OBwtijAiq1LEHzxrTF/ESnoZeBX1s5U=;
 b=9GU3V54N4nWUFuOORZ946DHhtbHXxKXuPtMcQGot4qVFgX8PM9hEOJcrOnifZQlqrRHef3
 ++8hpDdRa+nWC8Dg==
Date: Wed, 5 Apr 2023 11:52:19 +0200
To: Zorro Lang <zlang@kernel.org>
Message-id: <20230405095219.fx2lw4dt25gn34ib@quack3>
References: <20230404171411.699655-1-zlang@kernel.org>
 <20230404171411.699655-4-zlang@kernel.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230404171411.699655-4-zlang@kernel.org>
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10670
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 spamscore=0 priorityscore=148
 impostorscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0 mlxscore=0
 clxscore=166 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304050090
Cc: brauner@kernel.org, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
 ebiggers@google.com, amir73il@gmail.com, linux-unionfs@vger.kernel.org,
 fstests@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, fdmanana@suse.com, ocfs2-devel@oss.oracle.com,
 jack@suse.com, linux-fsdevel@vger.kernel.org, anand.jain@oracle.com,
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
X-Proofpoint-ORIG-GUID: O_18ror5igNvDdM94OBOndLrE3i46bT0
X-Proofpoint-GUID: O_18ror5igNvDdM94OBOndLrE3i46bT0
Reporting-Meta:
 AAGcnbFP4VwFik9q8Hqd/vHN9/+yv2a5Ec5IlEBDgSl9yqeYeRYJWxRmyLge3K2v
 yce16SLWHX9Kw/+r+Q4UB6L7gSXg4yEnLrCPrnZDU8J/RrGPoijqZczRcOitp/HG
 4ZEkVBo6szDCEFB4SWnUBAEz5wIK+/lApMzeXXpqO7fCopnQR9/dqNGFQ6hzNGlr
 t8v4/ujr0HCDkXn1LObUvNqtJeSW2i9rHZTHSJeNcNiJVRJYLe12iQ4ztLhnKZFF
 qXYfgsMQhU9Dtdsada29HevhO28P3euJRTY6YaDeY7WXftsdVt2dzQ963SiviaA0
 gzPWuwUlLOLbDdo758IkNeMFE9ExSjRGH+AZCzg6D8R2tMNYDMQX5iQvmFwke84+
 yMStfzpCZnv+EQtFJFfTVq1kBVit9NtlEAHpOdIrBv6udJ5tJWPsPNj9olxwk54w
 kSVw5t8knT6SqETJTdczlZo7HD2KVXmJRGEPyb1PBpvpcdgEXfuGrx5VSwe3e0gV
 oN6YjXL9/8Rh7rpY8Dclg0XzWrBxykI2VRUWk4O0THfJ

On Wed 05-04-23 01:14:09, Zorro Lang wrote:
> The fstests supports different kind of fs testing, better to cc
> specific fs mailing list for specific fs testing, to get better
> reviewing points. So record these mailing lists and files related
> with them in MAINTAINERS file.
> 
> Signed-off-by: Zorro Lang <zlang@kernel.org>
> ---

Looks good to me. Feel free to add:

Acked-by: Jan Kara <jack@suse.cz>

								Honza

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
> +
> +NFS
> +L:	linux-nfs@vger.kernel.org
> +S:	Supported
> +F:	tests/nfs/
> +F:	common/nfs
> +
> +OCFS2
> +L:	ocfs2-devel@oss.oracle.com
> +S:	Supported
> +F:	tests/ocfs2/
> +
> +OVERLAYFS
> +L:	linux-unionfs@vger.kernel.org
> +S:	Supported
> +F:	tests/overlay
> +F:	common/overlay
> +
> +UDF
> +R:	Jan Kara <jack@suse.com>
> +S:	Supported
> +F:	tests/udf/
> +
> +XFS
> +L:	linux-xfs@vger.kernel.org
> +S:	Supported
> +F:	common/dump
> +F:	common/fuzzy
> +F:	common/inject
> +F:	common/populate
> +F:	common/repair
> +F:	common/xfs
> +F:	tests/xfs/
> +
>  ALL
>  M:	Zorro Lang <zlang@kernel.org>
>  L:	fstests@vger.kernel.org
> -- 
> 2.39.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
