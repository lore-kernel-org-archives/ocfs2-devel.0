Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D66EFC64ED8
	for <ocfs2-devel@archiver.kernel.org>; Thu, 23 Feb 2023 21:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+Erhcik9dnQ2gWPeWz+dlog/7j+KpJJRXv2732/+25A=;
 b=UdCQTTQXeNgDL6MZ5++XilI/TGtNMCgLDEdVi3GB4oSA6qYmXa2S4ZjL2ZV8vCItsdfXU8slf847
   KAupq5YsKI5cAd1HSMuvf0M4/Q8OwrO1iA3e45lpzhA74b/9GQBQcq1POQAbn7Xzu7e7Zyqx/PWr
   /mtZOzduUXuwzEyPEf9T7uLuXczj/AgJzcXmIlMbqCZARRp0O662hehVRTkrTahqLt2A66RMMoV6
   VEAbShWx/0fqBpts53dcZ2cjiqbGigpkxD+EZ0qYBx1BwcyEEi37rhRR/qXzHCQQx9uCiwj0yVKc
   3LwyRpm1GqrVBQ3BssftElyFRoSjM2Fw7grI8w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+Erhcik9dnQ2gWPeWz+dlog/7j+KpJJRXv2732/+25A=;
 b=WrhfUeTO7xUhUZn6BJJb+LjQX5mbv8jW6NTblHzxEP9vAHOoAcm7LLLC//ViYuN2aXta+kbkVLFD
   S2A21Os+l0ge84OxoSNvQf44VWRf19ZTAQThebbZqweSxKaxBbGjLUrMisR8G7gB/WngSIhuWPAr
   3suT2QF4MqoYui1pLO6symvNj5hcSitVXKHCz6nKByLXdW8x9Z3W6jygBZjgoEw91y0HZTUQE8qZ
   DOBlT/e4laFHoB9TjCoe/jUYyNrVjlS/RVtYxHnQ0yqv0SQGTIEiD6tdZRNU7yu7KzGEkkwonI1P
   Cb0ATFHTl4y87Kv0g2/XzyeoEEdQOwdE0ImS2w==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQJ00EO7XBE1700@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 23 Feb 2023 21:06:50 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1677186388; bh=46eNsRC3mfD38LEk7IkS4/LHgA+yCMd0QH7FJUCXC8k=;
 h=Date:To:From:Subject:From;
 b=Vt/3mbg3MrhV7h4DJuCz/b9e/pmMUfrfaqXFmWfedDvNGBqE57UQfdr7vZKy/WT1m
 4fCcosRhbkFB0uvc1J4t4i8a9IDF/GAuQc0PAUZRQ6Th2Nq2FgnfLcGP+3Mt9KLNhJ
 FyVTfh3R/N5QEsd1Cqnp2l6jafrKqP5BeFp7itf0=
Date: Thu, 23 Feb 2023 13:06:28 -0800
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, piaojun@huawei.com,
 mark@fasheh.com, junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
 jlbec@evilplan.org, heming.zhao@suse.com, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
Message-id: <20230223210628.B9768C433D2@smtp.kernel.org>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10630
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 clxscore=182 bulkscore=0 suspectscore=0 priorityscore=118 phishscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 mlxscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302230174
Subject: [Ocfs2-devel] +	ocfs2-fix-non-auto-defrag-path-not-working-issue.patch
 added	to mm-hotfixes-unstable branch
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
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: 1VWU8Lw96cUDCoE0dOGbuIPcLyCl7SjM
X-Proofpoint-ORIG-GUID: 1VWU8Lw96cUDCoE0dOGbuIPcLyCl7SjM
Reporting-Meta:
 AAEYmtKZVdZGmUvnZ4LmT6PBlrSFFCkIV2KUi3dX1DhXQR5Lf0LdXq9PZpxxt4Gm
 0u/QUvEN/h+j5QlfONYE5KLDYn4udsVkMr731nFivKu2zwc/HAeok9Pj9vNvAdm3
 I9uQFV8q9x3YSyWtm10dBh49StG8Em7WRgpcipR3htLS2pTgQooQG41mfc5haXVS
 GrVGAhv0DRjThzd9zfQnf8sK39uJBz0dM9yYqPoGPzmSMZBKhekIV1w7lHkcy6Q1
 2or+n11Lygmt5us+f+OzhtUHLRR+VxtDu0kSsZDI3TQzx1z6rDmrn6LLP5ff+8zk
 V97Wg5VkcubNUjxL20/0jeMr+GkPAR3zg004+J5eWqDpPJSr4lIHzT2jg2AtvN4z
 XKhKD7JkInVbaE3HKLLyrGyYxizRuXO5OY49PHyOd4xuCuakvPflBWGSjGunjUjJ
 cp1b5JB6hhkbhLY6XIiB0DyPcppmXZ8hRjef9iGXDzK6xpexfY1nHS0nDP6WodhS
 q82zpO01Ylu6VQPM5uhtc64gBsxTwkCEO16XLD8QGZNR


The patch titled
     Subject: ocfs2: fix non-auto defrag path not working issue
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-fix-non-auto-defrag-path-not-working-issue.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-non-auto-defrag-path-not-working-issue.patch

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

 fs/ocfs2/move_extents.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

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

ocfs2-fix-defrag-path-triggering-jbd2-assert.patch
ocfs2-fix-non-auto-defrag-path-not-working-issue.patch


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
