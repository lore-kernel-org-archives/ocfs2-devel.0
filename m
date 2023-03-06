Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E792AC678D4
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Mar 2023 13:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ZVK25/4D5TYWTBTi8N5kgP5Wi8ljCo2fw1QT/emSQ8I=;
 b=NSn2J+NJ+6kZGPJxicCWOlc25GHT64n0jRS76FyeQFme8K5VtCOB/BDfPx0yQIs71LlbYy/bO7B8
   wy9axbyXfkFomsmOdKF78szGOVKENYd5r3NED8z4V6TPf5u5w7YTQAf9biqSTVUu3HFluMER9fC6
   JJLkLsvvhBp9f0D61TrHZSpthGZMaEIGz79RzoxiEtNLrc3Fmn6MF0QRvKpqHPDxlkEnOhdh2Coe
   prJnKkzqBZsv4X8RwoUjx5JmSNDw4gQHaMaU9lb0ugqvMw8Du6URGseRKmf3DCjQQWvl2pKrwm9z
   ai1Z7qZNml/wsv8diz0EWH6bBYdWz1Xl0hlIYw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ZVK25/4D5TYWTBTi8N5kgP5Wi8ljCo2fw1QT/emSQ8I=;
 b=n857fF/q97zyh57JPb/DRCAi4xkIUb0msr3yNVwrdFDNlns5edlBm7IBHXyYqRdiUT84Z8CiIQvo
   gkMa0INwcTe7cNZabBoC/8Yu7IGPF8xmmPS/rtilsZ1RqTyabEhH3NXSixW/Ul2iUoSxBniU1vYU
   wXLzgA64z5YtYOh635iYlaiBcN7I5vSD6wNBUir1MCuwKA1JTlp+Ce8dWRgTVOLSW2AlRXw7YuZI
   4Kp6SmrVOs/Q3P7aCCrLCl2ne/bGx1/AZy6cL14UD+DYdt3DPXDY7XomyQLHrECC78w9LAxy1i0+
   89MYK2/20H6xABmTrH0ikRMG1mdL5hG/xZqk4w==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RR3000TDQD6R090@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Mar 2023 13:48:42 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1678110509; bh=Fi10gb3gk2kvEYwGfjR9Wq7OefhJOucNJdcQL8ILDEE=;
 h=Subject:To:Cc:From:Date:From;
 b=qZnGdkQxRas1gEYeHfvCMn3HH4zqtTtHu8WEEOrkOVkgusS+Ic7u41ocaCDQFZSDY
 M2Pr6W8XuPc4g5Et5Ei1JSn4j1+AThXyIXb8hRyoIvEDfE74f30b3IK1yBOxi2n+4p
 pbqHrbOc2Qff4SBtxHq7b+SWSW7tRnovKErv34Qk=
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
 gregkh@linuxfoundation.org, heming.zhao@suse.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com,
 ocfs2-devel@oss.oracle.com, piaojun@huawei.com
Date: Mon, 06 Mar 2023 14:46:02 +0100
Message-id: <167811036239225@kroah.com>
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10641
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=163
 mlxlogscore=999 phishscore=0 impostorscore=0 bulkscore=0 priorityscore=203
 adultscore=0 spamscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303060122
Cc: stable-commits@vger.kernel.org
Subject: [Ocfs2-devel] Patch
 "ocfs2: fix non-auto defrag path not working	issue" has been added to the
 4.14-stable tree
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
From: gregkh--- via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: gregkh@linuxfoundation.org
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-stable: commit
X-Patchwork-Hint: ignore
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: qmJgUI2te5hHXxxgKC8sq0wV-XcrwWGI
X-Proofpoint-GUID: qmJgUI2te5hHXxxgKC8sq0wV-XcrwWGI
Reporting-Meta:
 AAFYlgHU7BiFv8ZmfAJAwl5GbGGKp3+2ZbVDVGt+xsaujcWaJ5cVghME2iO2+Pb5
 XX5a36f7ApQt/ZMNpjLgXOiFqQvPv63eRxzxuMAm1U7aA0SRLaxs+pbLy9FbBlwr
 PUIgZFrwtf3jXqcAVmCfPwHcwQIrI+BKlcoS2fIL1fpV0x5HLD1EowqSwdT/J5Mv
 lw6WOvVn/htweDbyJbOC8wQ7HQUaMTA72DsciOSVZ2Y2ZRRhqet+nP3aQSdkVpR+
 a8t8mzSYw3m5zSMgtkiWoSqDEhYehRTLP5e7JjHVb1Ho/J7AvsBmKJxdCwBobpXK
 muGVC+I8+Gb/61vrIgiCMwQ+9IC+bTo+rpneN7Rqp7gStJx9MaNje00L45EFGiZa
 U2lKHBT0gnJoJ4TJje0+FM90Fl4tzii1pAH5835EcrY1rKGEWzjVhP635GNccIjG
 lZQc4ymyVmZR0qoAMAYHKKzdHidyNieWYFzt5UzRezqdZPpi0XWjfHKAOymHVvKM
 tvKjAMkC89/YdTgSU42UhLxrFekPOzZKUYejvgGphw==


This is a note to let you know that I've just added the patch titled

    ocfs2: fix non-auto defrag path not working issue

to the 4.14-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ocfs2-fix-non-auto-defrag-path-not-working-issue.patch
and it can be found in the queue-4.14 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From 236b9254f8d1edc273ad88b420aa85fbd84f492d Mon Sep 17 00:00:00 2001
From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Date: Mon, 20 Feb 2023 13:05:26 +0800
Subject: ocfs2: fix non-auto defrag path not working issue

From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>

commit 236b9254f8d1edc273ad88b420aa85fbd84f492d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/move_extents.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -444,7 +444,7 @@ static int ocfs2_find_victim_alloc_group
 			bg = (struct ocfs2_group_desc *)gd_bh->b_data;
 
 			if (vict_blkno < (le64_to_cpu(bg->bg_blkno) +
-						le16_to_cpu(bg->bg_bits))) {
+						(le16_to_cpu(bg->bg_bits) << bits_per_unit))) {
 
 				*ret_bh = gd_bh;
 				*vict_bit = (vict_blkno - blkno) >>
@@ -559,6 +559,7 @@ static void ocfs2_probe_alloc_group(stru
 			last_free_bits++;
 
 		if (last_free_bits == move_len) {
+			i -= move_len;
 			*goal_bit = i;
 			*phys_cpos = base_cpos + i;
 			break;
@@ -1030,18 +1031,19 @@ int ocfs2_ioctl_move_extents(struct file
 
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


Patches currently in stable-queue which might be from ocfs2-devel@oss.oracle.com are

queue-4.14/ocfs2-fix-non-auto-defrag-path-not-working-issue.patch
queue-4.14/ocfs2-fix-defrag-path-triggering-jbd2-assert.patch

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
