Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 941B7C43334
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 19:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=K9v9DPxn+mJb5tvuQhD70u6/oCl/WItuuinEwGlYuV8=;
 b=f7U6CqkI0bhbk6DOss1tFsUQmeqPQg5FSWwyURbzNzhhUwPWTyIsi5H0TSAqjcrTETx2ISit6b9d
   DPxCO9xfCMpyOoAHFR9f/3wcnb6ZVy0hVvbvmlvh76pSFljD7cmxu/Lt7MiBwtv2O3RIIje18ZrJ
   2vvKuyP2wKPTV9hNx4s8R/vcZxPGFiW8ZJasxSktOxYVw6Bar/ZVCwS3VCsNDqXW3O1Z0qL+RLrZ
   5YntvDBy538EMcfJhL/xKWMS3SWweSSnRQeNoV/V3M98vsqEcLVyGBAcBQdBzY+nNIod7jduePaa
   +euzc4oK2jWOmXHb/Fhr4QLyXpgjDzjUNBix/w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=K9v9DPxn+mJb5tvuQhD70u6/oCl/WItuuinEwGlYuV8=;
 b=RY2Y2jlh+xPmfVvybDRwBFY3tnNmuNX8V6TrTzA2DWAjhelIURtDpkeGx+n14NCd3OyzCdRfcOEi
   hc3q+ZJLX+J94+h0W4rfQb82FvvnzEMIW9Ri016VvsUFlMm1NueVJ2XcNmVSstedEAyzwSZnZmEm
   A78CXdMpCn4JjJXKFCGIqZNscxTgDpohgcyYCFDD9LkeEVbG7EvPOYs0qwHrXiMzCKj8QMC5lZDu
   dnjK30enc+EUwD6eX2pmFDepdmrpANpADDAjDYu1UVfBvEdUpgtcZnchBO9Z5/bWeHmcYadoLmSN
   UmspcvVByNv6ajJerlSveRL+MpUtII4h/b71+A==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD600ON3AWA7210@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 19:16:58 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1654715802; bh=8b8WtB3jh8oHsF9CVp9WaKMezK6m6AS+PttRgAH4nxg=;
 h=Date:To:From:Subject:From;
 b=V8xNZp9ZVtEU8wmnVZf+A242TWIof8+Ts9WOM0JYXb4G8ElyjhYH0HGwcYKWMVIrm
 jkPGh7lQdrj3jMWaxRWh38tQtUHMUUy8zpm7HdYlOAkBsteTY47Pj3ZwS6pSsv+cNP
 NGnZmLsdmwJGGUVONNjsHFwe8bsKYvqZm22C/c8w=
Date: Wed, 08 Jun 2022 12:16:41 -0700
To: mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
 junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
 ghe@suse.com, gechangwei@live.cn, ocfs2-devel@oss.oracle.com,
 akpm@linux-foundation.org
Message-id: <20220608191642.08EACC34116@smtp.kernel.org>
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10372
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 spamscore=0 priorityscore=30 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 clxscore=157 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080075
Subject: [Ocfs2-devel] + ocfs2-kill-ebusy-from-dlmfs_evict_inode.patch added	to
 mm-nonmm-unstable branch
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
From: Andrew Morton via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Andrew Morton <akpm@linux-foundation.org>
MIME-version: 1.0
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: CCte88gNvzME8afExyvKNwvZN6qTEH-V
X-Proofpoint-ORIG-GUID: CCte88gNvzME8afExyvKNwvZN6qTEH-V
Reporting-Meta:
 AAFGNSJR4rX/CwyTGduzWUJA/ncjlffhypss/P5dm3X+fWBs0U/QKyNPG4mlNQAs
 /QYisRAnrAY4S0P96T958SKEC2XM0ejDhYnpMPGNGpp0H00XwTrVT4IfdSlCmYoo
 BMfaV9Hy7qN8EMzvFMjkydfA2Z/eNG2xW7uU7FGo9Vm7K41bbqyYNHPxRMibU/AE
 pl/1tai0kME1z1oI6Y+YU/KjmttL0gLWOfe9WGSDHc/vIAVO17qIpHZgtUWS0qzq
 V6ZNz06IBChSr39VVGva0nTMbUG5zitkF5/tEJduaZMxNyjMN0XOPGXHGwiM86OO
 GEKTJ6igGD7i6K/Da3vrbICwLt2P1X4dXxgp0JD0ZlseB2pE2x+aDekvy3IjFIK1
 01Lazfer0uCTywQ0s64cxFE4pi85IMCJLkfha1Ip1P48mjEH5GqLhAFDBgMD8Dsw
 Tear7u6mZof2YY1YYgnaJp4luoXT5VEXrvwn9jzYopVD9iDmov7Jcwf89IEDGaCD
 1Oz+u6Q/cmAG8d8/+klrJOlPJuxEzQosB/i4hdAf95mI


The patch titled
     Subject: ocfs2: kill EBUSY from dlmfs_evict_inode
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-kill-ebusy-from-dlmfs_evict_inode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-kill-ebusy-from-dlmfs_evict_inode.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Junxiao Bi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: kill EBUSY from dlmfs_evict_inode
Date: Tue, 7 Jun 2022 10:12:26 -0700

When unlinking a dlmfs, first it will invoke dlmfs_unlink(), and then
invoke dlmfs_evict_inode(), user_dlm_destroy_lock() is invoked in both
places, the second one from dlmfs_evict_inode() will get EBUSY error
because USER_LOCK_IN_TEARDOWN is already set in lockres.  This doesn't
affect any function, just the error log is annoying.

Link: https://lkml.kernel.org/r/20220607171226.86672-1-junxiao.bi@oracle.com
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmfs/dlmfs.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/dlmfs/dlmfs.c~ocfs2-kill-ebusy-from-dlmfs_evict_inode
+++ a/fs/ocfs2/dlmfs/dlmfs.c
@@ -296,17 +296,25 @@ static void dlmfs_evict_inode(struct ino
 {
 	int status;
 	struct dlmfs_inode_private *ip;
+	struct user_lock_res *lockres;
+	int teardown;
 
 	clear_inode(inode);
 
 	mlog(0, "inode %lu\n", inode->i_ino);
 
 	ip = DLMFS_I(inode);
+	lockres = &ip->ip_lockres;
 
 	if (S_ISREG(inode->i_mode)) {
-		status = user_dlm_destroy_lock(&ip->ip_lockres);
-		if (status < 0)
-			mlog_errno(status);
+		spin_lock(&lockres->l_lock);
+		teardown = !!(lockres->l_flags & USER_LOCK_IN_TEARDOWN);
+		spin_unlock(&lockres->l_lock);
+		if (!teardown) {
+			status = user_dlm_destroy_lock(lockres);
+			if (status < 0)
+				mlog_errno(status);
+		}
 		iput(ip->ip_parent);
 		goto clear_fields;
 	}
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are

ocfs2-kill-ebusy-from-dlmfs_evict_inode.patch


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
