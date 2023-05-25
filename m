Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F73CC77B7A
	for <ocfs2-devel@archiver.kernel.org>; Thu, 25 May 2023 20:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=C7IQGGlPRHExzqs2CP9fDn+vlXIa7OhSAOEpk5oD3j8=;
 b=Xf2iVrGY9gH2UFTMtWZDl8n0Cb61+VlUkUuf24YxCLI+QAyi7ZIj7dpDTi6SLDpltxSHYi2j32JF
   Qln4ARh3gWUIkGpuZzJrmSrKHjy5+xDl1IAkRFcgMvDnAWUqdNykX50IJeTEKbys0MvOu6gUU9Ok
   Hj0CVzVS7wUwwEhDPKZ8dJs16N2jraJcUTjjAy5EaA8+H0nC/aE1Vf0q+50OFNlFgVC98A2wyIsm
   BOGu3qVzvh3SHd/GDap5wfeOxCdKJad95DMcxQJJgAAZ5vzxhdzOHt1ZXbScIZzQ8wo7ndLAUVRA
   ig1n/Zl62BxpXxdgc13Jibt5Q0K5MBOUaJpN7g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=C7IQGGlPRHExzqs2CP9fDn+vlXIa7OhSAOEpk5oD3j8=;
 b=pPsnDvnQzBBe7D8uFzFCgYfimLQ4/Ev9CLpWGn5q1yl6T/rmnyGlkmMD+o1GaaVWde69jAItGwhv
   feyYB9MwmDnkDoKS3OHvMrYiLOxRRjKtcJL6pKsq+xgs49JGLWWHiKgLChVCUYxM+CWjI7y/ZYN8
   Jli1gn4cl6+oAdgGDUiPyywT2iXSAO06NQsKOLYKdZtknAj56ny7kYB2Q4qHoS2CbTuW50U2aslJ
   O07uUoE+2/bojuQXFnA6PusuzXpXIM7KBGUsErdJwDBigbb6rnSMW44SUMKGFnkRLMtbl5TmLioG
   HwJB1bzmprF0hBSLKioJkQgGgdCSGGwelMyPgg==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230522 64bit (built May 22
 2023))
 with ESMTPS id <0RV8006HSFHNJP50@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 25 May 2023 20:56:11 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1685048156; bh=o2OK3TySxMj6OOXTaue1qCUcjs2WJ5xD3+m+uRqDHXY=;
 h=Date:To:From:Subject:From;
 b=PgNaqWx3hSWpYBkILKR8/zWP1W1+UiujIg1SMrcEw6Zphz2QrJlS+Bwpi2Ut7qdWt
 J7NSmOLO6/3JkIt3L9rhUzsaqnGWRUMAuq+D2fw/rThtvW7UIjmwR3k461BBAmn3J8
 31iVdQpEu5VBrnehruPjssFTf6h+BPlH4i7ZyRV8=
Date: Thu, 25 May 2023 13:55:55 -0700
To: mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
 lhenriques@suse.de, junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
 jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
Message-id: <20230525205556.680DCC433EF@smtp.kernel.org>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10721
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 clxscore=195 priorityscore=108 spamscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305250177
Subject: [Ocfs2-devel] +
	ocfs2-fix-use-after-free-when-unmounting-read-only-filesystem.patch	added to
 mm-hotfixes-unstable branch
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
Content-type: multipart/mixed; boundary="===============2521465920344230136=="
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: U2i6A9PErelhx9QWqmbOiGy93xQYPVmF
X-Proofpoint-ORIG-GUID: U2i6A9PErelhx9QWqmbOiGy93xQYPVmF
Reporting-Meta:
 AAFLvLgbBwsTTR2Kg4jEPkoNg5q1QSmQCHQZL7OdZZcaTNQAQwT++oCJ088wsKUj
 TmZcBOdKLQD5WtoTMgNvAa+jJu0ENAOs1+NpL40FDWJE5/G8XPiwKC2no99EKndh
 gQruYVmlNrUVf2eF4M4n81BsmqEiWfoYBrJ1n6GMyLgoPUvMBH6I3JuVAZZgOcpb
 141LE1VjmS088e7fKRMaI/FFljmu9zYwJqnOSG2IlnpCDFJov1tamKiVxWK6teaS
 GNPl23gy8vvcFA3x5Wpii1IVZ48nOTPo/9TbxpGEEBghHwqli8+8dnoEV503tRsx
 lAtxcbrVwm0wO3mC+9wX/CndZQUWSHZJ12cSKk7N1XiHSDqvmiyPIW3QHZZIbnSG
 Jg4fCVnOChanplhM6WUQ10MEKLb0Sd45Sm5Hsb/FKhFNGT1bSLapIwmWeLHYSi0w
 /Mbg2LQwstZaFUF9R3P6yAPqtQCCt2aZ7sgFtwsijJmKhJ1lrZCXe10Pflsh0gaf
 ZpOivlwoiXdzWGFRpxltLLYPDB+GPFuW/oVgh2HXtSt/

--===============2521465920344230136==
Content-Type: text/plain


The patch titled
     Subject: ocfs2: fix use-after-free when unmounting read-only filesystem
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-fix-use-after-free-when-unmounting-read-only-filesystem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-use-after-free-when-unmounting-read-only-filesystem.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Luís Henriques <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: fix use-after-free when unmounting read-only filesystem
Date: Mon, 22 May 2023 11:21:12 +0100

It's trivial to trigger a use-after-free bug in the ocfs2 quotas code
using fstest generic/452.  After mounting a filesystem as read-only,
quotas are suspended and ocfs2_mem_dqinfo is freed through
->ocfs2_local_free_info().  When unmounting the filesystem, an UAF access
to the oinfo will eventually cause a crash.

Link: https://lkml.kernel.org/r/20230522102112.9031-1-lhenriques@suse.de
Signed-off-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Tested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/super.c~ocfs2-fix-use-after-free-when-unmounting-read-only-filesystem
+++ a/fs/ocfs2/super.c
@@ -952,8 +952,10 @@ static void ocfs2_disable_quotas(struct
 	for (type = 0; type < OCFS2_MAXQUOTAS; type++) {
 		if (!sb_has_quota_loaded(sb, type))
 			continue;
-		oinfo = sb_dqinfo(sb, type)->dqi_priv;
-		cancel_delayed_work_sync(&oinfo->dqi_sync_work);
+		if (!sb_has_quota_suspended(sb, type)) {
+			oinfo = sb_dqinfo(sb, type)->dqi_priv;
+			cancel_delayed_work_sync(&oinfo->dqi_sync_work);
+		}
 		inode = igrab(sb->s_dquot.files[type]);
 		/* Turn off quotas. This will remove all dquot structures from
 		 * memory and so they will be automatically synced to global
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are

ocfs2-fix-use-after-free-when-unmounting-read-only-filesystem.patch



--===============2521465920344230136==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
--===============2521465920344230136==--
