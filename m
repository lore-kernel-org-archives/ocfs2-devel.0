Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A8F3C6FD1D
	for <ocfs2-devel@archiver.kernel.org>; Tue,  4 Apr 2023 23:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=wLAe8Se7+Cx2n07jETsIq7X3ne/OP8X/T4OgJLQ8KuU=;
 b=HcUKCGBfz5ipmpOgcS0T/MwpYcGrlIDfLwM/7qnFlX7GayQQ9dxLygzE0193BOfN9J8M9R+Eq4jV
   74avNaroKn4SKiJU/vl/ny2xdjoDKWoO/13spy3uxCiF6KIIX9btwl4w/l4BQWemzDZd8tmuKJVR
   zVKafQ96urlmSZEBiQLbqGN1pD3cG5ZdqRyV828oRYJ+YH3qg3v4xtJc/+cFtWmNVV4oZynwYHfI
   tjLkikqbBCnh4uG0YJkLXNQ7ZG+4GSWne/tAWq+e3lyq4TBrPiHLXz8pd0RtUEBrLkX79zHPOwmB
   Zj9fKSoi8v457yBTW4r8vZ5I1uNh/z3gfJ7lIw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=wLAe8Se7+Cx2n07jETsIq7X3ne/OP8X/T4OgJLQ8KuU=;
 b=WcwqhRUX3W6iijm9tItSg9hwqc2KnQvBnPkUU70dInEcD0kUglEFO9r+Ept58ux7Ec061UwiQML7
   CcyJhuNqNeUpQEh/BCDlrM8EELxiCUFigXxMAIgb7aR4Dgh94kb1vCcQ+ZuNO3uCZD/MxeaPYQ+x
   UYu/3aphL8yh8ESg33tT6T5SzkzjJe5gJtvu1h+DvomrvbiI7PW09hsR9qFofGDbu6PC7V/2fKuX
   B9MjuN6PJQeURma8yWoDxiHsjRuLXuoU1LGL6VAVQKFuPzSdWuIlp2CckX1PnDcBktW+B774Ta/+
   cknn9Wj3+T/rG4aU2SS1BkLs+GisZUahDB15rQ==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSM00809694OS40@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 04 Apr 2023 23:22:16 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1680650519; bh=x8IC7E1FkVoNUQvJT9/z2Y21e0Mz1+IdIig/qJszVw0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=o8ifUstyPaXndA/90D8GuOl0gsJSWLIXqbvQEjHGmCwpAU0zkQYKO/UsNnon6tWld
 Xd4eTMwrBUiwkKj2/4U4CDT5PQdMPtygcXrZXXPpz6rOqZURoDtFo8aR7dGfFS6guz
 A+cwDtVvT+oRkVAh5k57a3K+DdgeScWW1yFbddp7s45Gb5tZYMSzjk1ZGOi7E8FI1v
 ihdlUbh6+3H5uI0A39UjG7KPJiaoYrqk6uG4+XmzU4HNqbXl0Ty/A574/j55zI3/Y9
 TMPjV7V6YJd/xLb/OTmpeuVwksZ1BO2byjRD+OfbZL82uXT96Fk1mUfIYD9a+QoGXf
 +X8tdg7VhNl1Q==
Date: Tue, 4 Apr 2023 16:21:59 -0700
To: Zorro Lang <zlang@kernel.org>
Message-id: <20230404232159.GB109960@frogsfrogsfrogs>
References: <20230404171411.699655-1-zlang@kernel.org>
 <20230404171411.699655-4-zlang@kernel.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230404171411.699655-4-zlang@kernel.org>
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
X-Proofpoint-ORIG-GUID: ozOG41K-3sQJjucMWqaDrcJHwFAYqant
X-Proofpoint-GUID: ozOG41K-3sQJjucMWqaDrcJHwFAYqant
Reporting-Meta:
 AAHhpJxSDrt7lQz+eTpelPPHAdUqVEw/qWoxz1QgLPTVzNr9QKoCIyDgOhR6b9H8
 R1VaNSYUOZRX8Trb9RVWXynj9JsU2+wEwnsNzTmfC8ZeixWrNOAFjDml2Qg2zWTW
 E04iYvQPTH/RdfvZ3LaVDG58kMeJYOLkR3FFWq+FwpAkoJcJ08pPyu3RdXf7/3sl
 jyMSvhhsqSPqqVv54RpR0KP3QXoIDleEseSyohQ0Ssbtqjz7DE6SXrPYqKC7HxgB
 1Vw2Dirvi3JV/BYnPvGBSVqWO2j6bqqVfHctQlu567MERQ4qbo47xpXYyZW+FzrM
 xeDUrhHSSNvB31seLUGbtmNLklDsWD81Qt+OnwFVsxQirDLTxPmV+w2SbfArdYzg
 pDNxqWIOBJatrNmTZ6kUmImPuHstEPIFJfqRt0oo/FmTHZBpbBA7r3hmYBSTuUY6
 cb1zvjGfqMdPbky0lzNlkCEcJN0igB1Xx3wN9zx0+GV7TtOuWVl0lQwwHE7y6C5n
 U9ZA79ylZIJtcsnUBRVKLTu6IPkks5YMUHkNQzCoSHOI

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

note that populate and fuzzy apply to ext* as well.

> +F:	common/repair
> +F:	common/xfs
> +F:	tests/xfs/

Otherwise looks good to me,

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +
>  ALL
>  M:	Zorro Lang <zlang@kernel.org>
>  L:	fstests@vger.kernel.org
> -- 
> 2.39.2
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
