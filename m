Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60D31C77B70
	for <ocfs2-devel@archiver.kernel.org>; Tue,  4 Apr 2023 17:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=U4mo/x5FFjVEe3JOKPg35r03h/04NRb6eup9BVQW564=;
 b=2DVAh/C8F0j6n7ae/xa1LMrFMECP5ApqDJFMgApTOVYdyGm/Uz1gQopa0478QVoPAOpD3Y1BOs5V
   Pzpaw1w42/Ow+mfXIrXxSmDdfYzVVrUaaHtjDRB7g1kVzVnrJVGGLu/w+iQ+wuTVVZHQrmud1beJ
   JDmvoxnXPRqdXuDhHgtYcXAZ9/CYNrTKzJfx5IAukKoJ+XLQN3EASxHCWPbUX0EM7UdhyJd/rCYt
   uBR8nH0O3Uwyb0Ah4O+mE/Z++ib50+jgqkgM/Ydc871GFqf+xGMnT2ZCIpd1R+jNgx5oOcmwqPGQ
   dduhDa1OQVZCef3kguK2LZpsKFTCZkJ4iB/nhQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=U4mo/x5FFjVEe3JOKPg35r03h/04NRb6eup9BVQW564=;
 b=S8N1UsdUixZCNCHLIRYtWc9zmiHt3d8ctCCfGoQ1+hP7pcIMbys7mHY/TodIxoyvKKoCRttKiDAW
   1eRGMb6b2tptF2t2dXoehDbNRkFnvcdnhcZxDsm0J5wLzYt/GFae33bYiSjZT6FEZqr1fYa3KCOI
   vczBn6AyZruadmEs0gS3Y/lNgdtKjmlDIh6eGYSlBSJDDLUjs0I/mEyENhpBnfl4KvJU2az42BEQ
   zCA/Bc9gRMQF9EP7Rqv6Vvlo3jzvNuL06l88cEJew7hQy1T+ANysmGoiAnYlrY4UV5KeyCK69F2s
   wc0cQmHKw66Ah9bzh9KGNmBjKgs2X/+0JUTlbw==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSL008E0POVMD80@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 04 Apr 2023 17:24:31 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1680628492; bh=NBUCaONjYi40Vbcu4o/CCPE2N3ymcLwg1V2SlbPeNJs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=mHGfLFO/6lWqvTQg3dD+ZiGLcThFJvk3b7nrRH/m3eMGcgcPfBNNFG6drzx4LOJrr
 /L6gN7acWGxiBVx7p9NtIy5ewclLB0T6z2nezlnjEKe4jCcFHpTj+cWbZfV+OPUa2n
 Iuen29mduilHjKHmQMesnJATtLYk/UwJ2N+ZcuULKiETcbcfpeRkdzP6zHKyZ13BTC
 l1QSKNjtUu7bwyO3EmM9BAGxTJOyRw/W/BmSLbpWzEP3LFtJIg1yBIIQcywBu14GE/
 x/lbszQJwhPGa/5cqaAEZXkLpxfPtRy5Ltc8ciKsMrx7HIMYtZ+fI8cOlbIdlK5RVw
 wd+gJ7j1HfZrQ==
To: fstests@vger.kernel.org
Date: Wed,  5 Apr 2023 01:14:11 +0800
Message-id: <20230404171411.699655-6-zlang@kernel.org>
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
Subject: [Ocfs2-devel] [PATCH 5/5] fstests/MAINTAINERS: add a co-maintainer	for
 btrfs testing part
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
X-Proofpoint-GUID: 8w4OIxRvRoteTjgdW_WKeiqNMF_hxqF2
X-Proofpoint-ORIG-GUID: 8w4OIxRvRoteTjgdW_WKeiqNMF_hxqF2
X-Mailman-Approved-At: Tue, 04 Apr 2023 17:24:27 +0000
Reporting-Meta:
 AAGHfNR5rPedKIimEuP6yQ5VO/RbwF9+IjwVRUCSB15ibjmF83XwV8/r3d90IGvT
 AP6o9Oh7ywhWgq4Ofzoapvod67VUhPfsMQIfCDVW1YknqDx5PLb56nJAmyxpNYBC
 f5UtETBCAo8G6ZNIRLalf1u0LUBMQDNSj7idDQiC/6Eh0Z5K/GbkidPqKHOdNRyq
 kbh+M+gxTSfpUHDpY52vrhHOJI0+iB7ZZkO2BA9YLcbQ0BVC2I3Jl/vhBk8BnIxO
 Dwb3sAN9Pku8e9bt6DK0FYP+XkyzdMk78TNsKVRDRttH6l3qqnZGws2Sggey+L0i
 QBsO5ZobONPNid2wx7d1QQCg/UDCBesf2qKpe+A89an0nxnhvohbMb04GczRfLJ0
 0OpPaqU/hx/+eG6Rf8aqRE8eIMxy62Re8EFiaOqVbtAxSU2Sax2K++Kw7Pha8agJ
 OVYlGYKM8gG/IwrYq7uPdD2UnnLgcsY5E3XVS4+c+3gf2cUikHY0IsXZukQ652EP
 cJNVh9cTPHe/thiTOZ9TtiEwJTBRbsbXiJi24AGvos+pIw==

Darrick J. Wong would like to nominate Anand Jain to help more on
btrfs testing part (tests/btrfs and common/btrfs). He would like to
be a co-maintainer of btrfs part, will help to review and test
fstests btrfs related patches, and I might merge from him if there's
big patchset. So CC him besides send to fstests@ list, when you have
a btrfs fstests patch.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---

Please btrfs list help to review this change, if you agree (or no objection),
then I'll push this change.

A co-maintainer will do:
1) Review patches are related with him.
2) Merge and test patches in his local git repo, and give the patch an ACK.
3) Maintainer will trust the ack from co-maintainer more (might merge directly).
4) Maintainer might merge from co-maintainer when he has a big patchset wait for
   merging.

Thanks,
Zorro

 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0ad12a38..9fc6c6b5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -108,6 +108,7 @@ Maintainers List
 	  or reviewer or co-maintainer can be in cc list.
 
 BTRFS
+M:	Anand Jain <anand.jain@oracle.com>
 R:	Filipe Manana <fdmanana@suse.com>
 L:	linux-btrfs@vger.kernel.org
 S:	Supported
-- 
2.39.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
