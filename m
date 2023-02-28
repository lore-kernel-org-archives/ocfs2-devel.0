Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38355C64ED6
	for <ocfs2-devel@archiver.kernel.org>; Tue, 28 Feb 2023 01:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ottAWnUBHg8eE5PXmRwp424Z7Zvv7KZe2ewuGfcn+ik=;
 b=FhQC4/iO4v4rs2tP/g2WeDY5h+ghXqQdhZMkvgxpqjK4xJaaJvG0gMKVNJEwo89q6MmsEnL24AJ9
   ooHj/mw7QFfi1ts63oFBNNaMhazCWVQmZtsjCLWRIu6tkU2oNsy8gmRvUaC3Ig0pBlQcohI/2FA7
   GF7Pq9t5/5m+rYKVVWvWeB8y28W2UbODhGDFJKyMRp+7L74aHghwo6dw3a1BLJ5fRcPuROHI78lU
   wM9INqye3g7xr1wfSpKnvuKGvYya7wvuVNx3AxzBgAzi+Xn/vExFwSU2wVjb2gmk3kq0RsMRPPB3
   tPSQXHveMMtcdkJutbrCunjeqWA2ePoOxwLPww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ottAWnUBHg8eE5PXmRwp424Z7Zvv7KZe2ewuGfcn+ik=;
 b=sZl1ifso6hEmC6fNWlJ5/7cOLsMUn0yB0une3ushlSx+PIUrmgzAk1gPhjtE3HbMI9lOv6M1h/hu
   kRbva4OGGPJyld+vExNG7CpxaZMVIDbqw4Zb8RI6sH9SgVE/SbnN9ETJp2FRd3CGgQ/WXZHuJ2mI
   K64gtFktvhm6LNuy7Jdw2uB2NPl0cUCJteNlgS9T7VlIHRfdArvve+fM9N3M/1bCdBXKpJcUD5J4
   5vItoXt9j5ovW2njDWe/qoFmJMNwOEsrxbcovVfF0N71o/71hU1DxeT9jXIoBAkuf5LW1Xjz94tL
   hnjpvDvASCXo84F7TYgj7Hc6SlgooiORvogqeg==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RQR00GY6MU2BPA0@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 28 Feb 2023 01:01:14 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1677546055; bh=Ko782N5a6gWJk9FWNpuI0NPz2reCRh+cyzct4IiG+Qk=;
 h=Date:To:From:Subject:From;
 b=EstmpxfEXkps/rpyDX7mXpsJxiSboEx/55dXKyM8cltibk9E+pC6SXYx6bAWiTvQm
 wbXozrQ36GL0lAAFFs2r0/Y8rmGBIZw3sqSH5zWoA0bD/+6pUnAGFum0apfBzxkFcj
 oGtEi71CapbhHEkYM3/+/Hvkp9cP8pbByHvy+y1w=
Date: Mon, 27 Feb 2023 17:00:54 -0800
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, piaojun@huawei.com,
 mark@fasheh.com, junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
 jlbec@evilplan.org, heming.zhao@suse.com, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
Message-id: <20230228010055.6B6F4C433EF@smtp.kernel.org>
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10634
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
 spamscore=0 clxscore=183 mlxscore=0 malwarescore=0 priorityscore=70
 impostorscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302280006
Subject: [Ocfs2-devel] [merged mm-hotfixes-stable]
	ocfs2-fix-non-auto-defrag-path-not-working-issue.patch	removed from -mm tree
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
X-Proofpoint-ORIG-GUID: u1zoa_Wpnfe8HsacYG3Q_HRFK824WUbL
X-Proofpoint-GUID: u1zoa_Wpnfe8HsacYG3Q_HRFK824WUbL
Reporting-Meta:
 AAGyuaU9d8V56o0TBI5eXKTR7Sg4pPkEhwJnqWJdNZ1R1KDiMCviwD2BeiYqQnqr
 nJVhGlKymK6C7PT1YDc3bYl6GE8EbHydroGF9feOmSdT4k0Rj6jY8zNuOyfdMm/y
 FvQ/k/n/zbXYZ7zbsrNmY2CiAtsjX8lCS2Z0fxwq39nPbDidzuWUFrhBTnS01dfQ
 uCvCnCL80uqkvCiXTnMUCtOlqCK/eI3OboNor+ReYk8crGbjyZIa35FduwNtdung
 GayTSt1GhXseWa4z8LjKSDjT/f/XhyNYMaOCeLqceOniY6eZ49M48COeYCAw/5+u
 dfNEZXnCW6C/9oVFgRdp/olIPhjO3nFpL7L1zs2pHScZFuFO7tR5FhzpjAdqI0OU
 tC6OXe5LoUtJ3KPhzBqGVrp7rAsjYnSIadbg8ew/eJfJaSqdtgdIA8+0io8dv/X4
 IpNAmhLU9oXarJeIjyNYBF4zHuAPK74lzDqSObUosTJtXNyAjEspyESHjnWwetTu
 G+WhWtC8Zqu81AyC9WahXIkC8Ch/m0A8vzb4QqMDkSc=


The quilt patch titled
     Subject: ocfs2: fix non-auto defrag path not working issue
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-non-auto-defrag-path-not-working-issue.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: fix non-auto defrag path not working issue
Date: Mon, 20 Feb 2023 13:05:26 +0800

This fixes three issues on move extents ioctl without auto defrag:

a) In ocfs2_find_victim_alloc_group(), we have to convert bits to block
   first in case of global bitmap.

b) In ocfs2_probe_alloc_group(), when finding enough bits in block
   group bitmap, we have to back off move_len to start pos as well,
   otherwise it may corrupt filesystem.

c) In ocfs2_ioctl_move_extents(), set me_threshold both for non-auto
   and auto defrag paths.  Otherwise it will set move_max_hop to 0 and
   finally cause unexpectedly ENOSPC error.

Currently there are no tools triggering the above issues since
defragfs.ocfs2 enables auto defrag by default.  Tested with manually
changing defragfs.ocfs2 to run non auto defrag path.

Link: https://lkml.kernel.org/r/20230220050526.22020-1-heming.zhao@suse.com
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/ocfs2/move_extents.c~ocfs2-fix-non-auto-defrag-path-not-working-issue
+++ a/fs/ocfs2/move_extents.c
@@ -434,7 +434,7 @@ static int ocfs2_find_victim_alloc_group
 			bg = (struct ocfs2_group_desc *)gd_bh->b_data;
 
 			if (vict_blkno < (le64_to_cpu(bg->bg_blkno) +
-						le16_to_cpu(bg->bg_bits))) {
+						(le16_to_cpu(bg->bg_bits) << bits_per_unit))) {
 
 				*ret_bh = gd_bh;
 				*vict_bit = (vict_blkno - blkno) >>
@@ -549,6 +549,7 @@ static void ocfs2_probe_alloc_group(stru
 			last_free_bits++;
 
 		if (last_free_bits == move_len) {
+			i -= move_len;
 			*goal_bit = i;
 			*phys_cpos = base_cpos + i;
 			break;
@@ -1020,18 +1021,19 @@ int ocfs2_ioctl_move_extents(struct file
 
 	context->range = &range;
 
+	/*
+	 * ok, the default theshold for the defragmentation
+	 * is 1M, since our maximum clustersize was 1M also.
+	 * any thought?
+	 */
+	if (!range.me_threshold)
+		range.me_threshold = 1024 * 1024;
+
+	if (range.me_threshold > i_size_read(inode))
+		range.me_threshold = i_size_read(inode);
+
 	if (range.me_flags & OCFS2_MOVE_EXT_FL_AUTO_DEFRAG) {
 		context->auto_defrag = 1;
-		/*
-		 * ok, the default theshold for the defragmentation
-		 * is 1M, since our maximum clustersize was 1M also.
-		 * any thought?
-		 */
-		if (!range.me_threshold)
-			range.me_threshold = 1024 * 1024;
-
-		if (range.me_threshold > i_size_read(inode))
-			range.me_threshold = i_size_read(inode);
 
 		if (range.me_flags & OCFS2_MOVE_EXT_FL_PART_DEFRAG)
 			context->partial = 1;
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
