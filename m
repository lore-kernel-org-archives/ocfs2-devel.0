Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84241C77B71
	for <ocfs2-devel@archiver.kernel.org>; Tue,  4 Apr 2023 17:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=R998Judt02NBAVEkiTh9ZsH3qyMICwsJELyRA3ffGB0=;
 b=11JXZamZWiWWtgKAts6sp1ICm61/1Nf4MT3N0OHZ40vStLdxfthZfX87x5QGe7xZuenzbpWtFxka
   zKkChzUUulxDP8KlvuRLqgDgD9u3l/BdJ6yiIjQCaUKLZZZtp93EFfOJWx+/okK4QV8EHlMYZS2j
   y9nldJaF33rwbVCbHOj5XikYDMpdAkd+dgrpIOf3+TFYPS0p9mem7d1+rnFWRLh0YcR7RItowNVc
   eJRZFgzR6oeHH894YE1Hk8XUN4MTGOV7bsf5ZTJznlRrntj8U2/TwHPqV7ypJJPK9DuHUuXiEWMM
   GN8wChv3JobOHUgbxt5771ag4VEqeGwpA1B5ZQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=R998Judt02NBAVEkiTh9ZsH3qyMICwsJELyRA3ffGB0=;
 b=OAMOKwGZKAMtXvH1FO3PxxW5R9CWl+X/xDLHfT9F7dQGf2bcxb+NHwDcQs0MbS7N4jB9Sb6Y2AKa
   Y5JPIdkgkg8F0iuhMKAPhSfBeN+GifXl9Q6gvSJOHgnIAb1VT0kA1+6ToYOFRXQGkjjnjLdT5Hxi
   8WnD+NmmIKE7o7NgM28muGcYo1+klSYWPHexCPVeE6mzeOf9VovDoGBWOX5Ux6yHMqXkrV5DPHGE
   zfSHKmeNBj+g5f9gGi9aS2UuqoZFJ8qwsYZzAiFHDCxhbURrCC7rMHSRZcr0TVO6Y3EDOH3XLzBi
   BFZogwUu1aoGD9UF7u3x8D35sfMZCDmyXg6L9A==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSL00BL9POUN860@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 04 Apr 2023 17:24:30 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1680628485; bh=qEU5p/rrPBMCcC0b9NygBo0CKzlLnTtdCdY5YHNjXz8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=a7ZekHh0kNeqmVuQWe3cMaiVtL9ICvdGaufuyHnjBLAPy3EG4Jf6gOeacxzbQ4xn9
 QTLN3vKygazocZQuD6bz67l1p9bYvsCQZAYHJlFOw35kzra2NO6G33uE8wOfolwziO
 xj2ficCC1e0A9/fy64r5Y7LewDk8qhNPbg49nwMZJMp/fJTKljG3nDKPjkpWSZdtho
 abvZl57ghjk+PPSUaejv8IyCjJtYWhsS9ciQ8B3XXbSWjI+n64WX+Hxqboqjc22ttP
 ennHYz2Fk0PjdGRvcCJxw+lWV5D5mNtZv205GCv6lzOzACCpuUuMXBIGpDSPMvIi9E
 239Szkhk1pZQw==
To: fstests@vger.kernel.org
Date: Wed,  5 Apr 2023 01:14:10 +0800
Message-id: <20230404171411.699655-5-zlang@kernel.org>
X-Mailer: git-send-email 2.39.2
In-reply-to: <20230404171411.699655-1-zlang@kernel.org>
References: <20230404171411.699655-1-zlang@kernel.org>
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10670
 signatures=596816
Cc: brauner@kernel.org, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
 ebiggers@google.com, amir73il@gmail.com, linux-unionfs@vger.kernel.org,
 anand.jain@oracle.com, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, fdmanana@suse.com, ocfs2-devel@oss.oracle.com,
 jack@suse.com, linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 4/5] fstests/MAINTAINERS: add some specific
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
From: Zorro Lang via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Zorro Lang <zlang@kernel.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: fuqE32bsgwHFmWb3Ab-2Tc6C_UQ-RmG-
X-Proofpoint-ORIG-GUID: fuqE32bsgwHFmWb3Ab-2Tc6C_UQ-RmG-
X-Mailman-Approved-At: Tue, 04 Apr 2023 17:24:27 +0000
Reporting-Meta:
 AAFGjExPnqksaP92YgCD2nro3rODTpz+8HfpOxCw4TiawxIjK3+ciWotAr6t9P45
 NigoXz3X3cB/8PcJXSjbegTiOA4JgH5oB/BTu99PdDMnQPllNNZfzy9mzgo9eRHj
 hPv+VyM261ie8WGcZOvkrzUe7Jq24dzBOT7JXP/ZBwPJ0UDwD4ZOlUlQ8foNYphr
 2uMG8i3l8Ae3JjiulWJYWWW2Eaadg98PZ21kQu07rJpTv+WflNSLm5P7VasllGpd
 xQAwyp0rO4u9kW8kQrWH4YCo9IorA4NVOTM8J8nThrcROiDpwESMkX69LTYKeswP
 S1w9Y0eNzioflobViHf15iak3evqHySQCSNEw4XntrBHpU2eSfB/pX+WssDXrhgN
 fpqVCBBiYOif6331gli4YjzaoBz+jruKFhFFSgFyIv39rbTn3wYyKvRfHuxOf9Iz
 k3LP2X9n1jSHaOOuz2eVQBwvArmrpBCFilo5I8LyoqFYgzhYw3ew7AjgQcT0ypaL
 KyjRVhcGIbC/OLPsB7PAuAF+ukmTWrdnagw3qwg8Ftjkfw==

Some people contribute to someone specific fs testing mostly, record
some of them as Reviewer.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---

If someone doesn't want to be in cc list of related fstests patch, please
reply this email, I'll remove that reviewer line.

Or if someone else (who contribute to fstests very much) would like to a
specific reviewer, nominate yourself to get a review.

Thanks,
Zorro

 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 620368cb..0ad12a38 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -108,6 +108,7 @@ Maintainers List
 	  or reviewer or co-maintainer can be in cc list.
 
 BTRFS
+R:	Filipe Manana <fdmanana@suse.com>
 L:	linux-btrfs@vger.kernel.org
 S:	Supported
 F:	tests/btrfs/
@@ -137,16 +138,19 @@ F:	tests/f2fs/
 F:	common/f2fs
 
 FSVERITY
+R:	Eric Biggers <ebiggers@google.com>
 L:	fsverity@lists.linux.dev
 S:	Supported
 F:	common/verity
 
 FSCRYPT
+R:	Eric Biggers <ebiggers@google.com>
 L:      linux-fscrypt@vger.kernel.org
 S:	Supported
 F:	common/encrypt
 
 FS-IDMAPPED
+R:	Christian Brauner <brauner@kernel.org>
 L:	linux-fsdevel@vger.kernel.org
 S:	Supported
 F:	src/vfs/
@@ -163,6 +167,7 @@ S:	Supported
 F:	tests/ocfs2/
 
 OVERLAYFS
+R:	Amir Goldstein <amir73il@gmail.com>
 L:	linux-unionfs@vger.kernel.org
 S:	Supported
 F:	tests/overlay
@@ -174,6 +179,7 @@ S:	Supported
 F:	tests/udf/
 
 XFS
+R:	Darrick J. Wong <djwong@kernel.org>
 L:	linux-xfs@vger.kernel.org
 S:	Supported
 F:	common/dump
-- 
2.39.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
