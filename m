Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37AC9C77B6C
	for <ocfs2-devel@archiver.kernel.org>; Tue,  4 Apr 2023 17:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/iu05QVa3y5rNA2NMpugmtP5VbSbC6mcMbnkzJXod/o=;
 b=E6ETq5m8hLG2cjB7jjtiXKDOLNmzeLaZwcdovem8M6F7dAR0eN9YiAed4ul3AN4fv/rK3uisjRIw
   MhnBI5OWwef5iMUS1BhYWUjGj9CuNwICJtFAiIPhiZL8t0t6gPUYby6wUNrePhtVUOJ8ABD8Fzja
   h5dCPJnZM6xw7TMfBPkZLxHKi26VfaEbrBBIBoHPbsawrhbKvY7pRWZGBHIcn5yL6f6+z6eyowEY
   XYTjLWAwpI2ETjNOoBz5ojVeHv21zCWU6MXsyRpp8Yq0UDCIubnsS0weu40rLMkoqWH+8Z8/OgAp
   by8KwfD3WQaWpKhzSgnJaWKH9ojHRipEAIr1+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/iu05QVa3y5rNA2NMpugmtP5VbSbC6mcMbnkzJXod/o=;
 b=gqxs9ImD/ZnsskSOVAM/P9v8dYj5EEWc7Oz1DCh5fp2SXFf2DvyI8NaXLwZr/sFFLc5kVqCGX3Ki
   yuwWNrsDIkKd8XUrbEHSrmYHfe242DQeBEhRus9k/+uuC20MG+0+Yd1KXHlg347eb8uDZFELkUa4
   dTvDEwTj17NzLT0VgWaGcwgteieCYp29d0B1GDxiWXv3KcNGEwpJzOuE+w0SwBK80gx1rOdVhn0O
   vzWdVfrQMBTASfXmKH/FfkUc5aJzBrdlMN3G1a4ya6w/K2EIRhzG5VbTvE46eVnzxqQ3iqDpOWFf
   COmqouEPzy1/B1L6IAe56VkXBJHZNPpehmVPAQ==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSL008D8POUMD80@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 04 Apr 2023 17:24:30 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1680628479; bh=YaUvSAb+y+Cjb64X7Lrm9tby/Kb+5UTjRbbEV78qtVk=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=AyONJpNXKaLMFKaOhSSWFqJTNcbR8KyZFi907wXZjLR8By0KvxzrxkADm26HVSJdg
 87pZbHXq117AiS7wENSNNfIIBGaAbnO09US11y0lcQ4cRw7vhTLoRx8AQsbqThN9Ti
 sAou1kJDg50Ug+NiXGtrhH9vfZiLd+zaMxfQRv/iBLxG8G70cJZ0ONrDKZEmk9+jbn
 kCzmVPLHrpa7VQ+t7BkLgv6dzA28ov1ROlx1OMrr8oRPcCylnGBRgfZOrVoatSpU46
 m8tklPFCdAHD66VUnnu6oM3EhHEURsZV4bITFuVetU4lBd7HsAjjrgjP7ohCgefa5K
 J0ZS0OzI+Bcgg==
To: fstests@vger.kernel.org
Date: Wed,  5 Apr 2023 01:14:09 +0800
Message-id: <20230404171411.699655-4-zlang@kernel.org>
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
Subject: [Ocfs2-devel] [PATCH 3/5] fstests/MAINTAINERS: add supported	mailing
 list
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
X-Proofpoint-ORIG-GUID: mzN0AU2wrMW6jKI3C8Wi8D14nNGKtvNT
X-Proofpoint-GUID: mzN0AU2wrMW6jKI3C8Wi8D14nNGKtvNT
X-Mailman-Approved-At: Tue, 04 Apr 2023 17:24:27 +0000
Reporting-Meta:
 AAEHTOj+S1MwozJ/3M6CwhBwRL7qHXwyE2zdMO8k6NpDHnVH6YycC8Ga57f3ZdO9
 rYpVgFPMrRAY6mpd9SGDMIJgw3WQUGUhhzs/JsWTyW5fw7ywfuCmRtsFnDGcUOmZ
 WvjW9ENgq9f7SOJFNAFVVcUK7yr01YhbfkETYgjLqjTyqw5FlgvmKa/72+ZpeL6M
 2u6wxE9zwFp5c4FUBkntj4BuZ7gSP3BlmDjj7Hn/YtaFDLmSVZOZbT8qSRBsrskd
 Uucbgi8Qbk6Sp1OLxf3o7iiB6+QbYwdz0iLuNeZkd2uNABXDpZqiBvEHGi6MjDxg
 fkMgZJDIcPcfL+1mYSyZi9TGkIyATImGPX7fgctnbtP8ZnVULLbElYjTrPZ1i4NM
 nWSD8cEdk0NtGqfpGjxcMH71yAC3fNex6T9A9p25NpyGENnpBBTptnY+9hs8Twme
 SfSaWYs3cyeaTQ1blKG0wnHywtpi7AUugXwKaFXTKTnamcIqGCQqw/CA+/3nXFlJ
 z6d20Qaj9glzkMGav+Z6/NxaukbsGGIxVMN8aXytuJ6H

The fstests supports different kind of fs testing, better to cc
specific fs mailing list for specific fs testing, to get better
reviewing points. So record these mailing lists and files related
with them in MAINTAINERS file.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---

If someone mailing list doesn't want to be in cc list of related fstests
patch, please reply this email, I'll remove that line.

Or if I missed someone mailing list, please feel free to tell me.

Thanks,
Zorro

 MAINTAINERS | 77 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 09b1a5a3..620368cb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -107,6 +107,83 @@ Maintainers List
 	  should send patch to fstests@ at least. Other relevant mailing list
 	  or reviewer or co-maintainer can be in cc list.
 
+BTRFS
+L:	linux-btrfs@vger.kernel.org
+S:	Supported
+F:	tests/btrfs/
+F:	common/btrfs
+
+CEPH
+L:	ceph-devel@vger.kernel.org
+S:	Supported
+F:	tests/ceph/
+F:	common/ceph
+
+CIFS
+L:	linux-cifs@vger.kernel.org
+S:	Supported
+F:	tests/cifs
+
+EXT4
+L:	linux-ext4@vger.kernel.org
+S:	Supported
+F:	tests/ext4/
+F:	common/ext4
+
+F2FS
+L:	linux-f2fs-devel@lists.sourceforge.net
+S:	Supported
+F:	tests/f2fs/
+F:	common/f2fs
+
+FSVERITY
+L:	fsverity@lists.linux.dev
+S:	Supported
+F:	common/verity
+
+FSCRYPT
+L:      linux-fscrypt@vger.kernel.org
+S:	Supported
+F:	common/encrypt
+
+FS-IDMAPPED
+L:	linux-fsdevel@vger.kernel.org
+S:	Supported
+F:	src/vfs/
+
+NFS
+L:	linux-nfs@vger.kernel.org
+S:	Supported
+F:	tests/nfs/
+F:	common/nfs
+
+OCFS2
+L:	ocfs2-devel@oss.oracle.com
+S:	Supported
+F:	tests/ocfs2/
+
+OVERLAYFS
+L:	linux-unionfs@vger.kernel.org
+S:	Supported
+F:	tests/overlay
+F:	common/overlay
+
+UDF
+R:	Jan Kara <jack@suse.com>
+S:	Supported
+F:	tests/udf/
+
+XFS
+L:	linux-xfs@vger.kernel.org
+S:	Supported
+F:	common/dump
+F:	common/fuzzy
+F:	common/inject
+F:	common/populate
+F:	common/repair
+F:	common/xfs
+F:	tests/xfs/
+
 ALL
 M:	Zorro Lang <zlang@kernel.org>
 L:	fstests@vger.kernel.org
-- 
2.39.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
