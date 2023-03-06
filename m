Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6658CC61DA4
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Mar 2023 13:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=RdxCh7zfNofAYhbw3+rGy7ZPDiP7Ps6om6siu6I21xk=;
 b=BVi3jmHRLrCzV07YUYGfYyrGYFyfdkhWCEK82rkJezoBF1sIVdLURQR+D3XGzV+r2VrrnV3yhsW6
   5D6f5hng6MSQatQtFd7ZyivVYYLpxZmt+Ophs3H6C8C88yD0ZvusHJqqxwrM1podW3YAGZDS0olW
   wIwFlL3n1wBuWCR7CqZaaq5gZXaaXmfNQ0iQpssYIYj82FEHtb8gBVNZQ/7aMr6HvRPN2LssG/P0
   8vnrpgG8+DwWeL9h3gFpup2zgqYnI9pQ4cdwE9YYHocg/iySkMb1UBDzY4LYyN1cp7hwp0srZJqd
   4S1RW+a18++UnTtdj0BvbwUnd0A8eRzfv5FcgQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=RdxCh7zfNofAYhbw3+rGy7ZPDiP7Ps6om6siu6I21xk=;
 b=dHqxqz4IRMDOuu0CmaoWX4/qO7UXWZy7LRkSThKzzcdPD/x2fyc9gT/q3mcx65k8gcizxPbtgm5O
   ISTO4bEHVv9Ck5+rlVDohoVa4OXbCQEGERKteT9E8zN5n6Ss0a8EBIxk5G4PUbmq0oTnG2onXo6X
   9f0f1X9Wu1c2sONcIqaS2xk3KMNKIBE545aUn1Ymo4Kp6/V4ICJQSvQzNEd3tnO2evR2qsMWEwBe
   YUZXqSRbPx8o/jLOw72dbriQqKiCk1ZrruOzVWp3QgKQxQNMh04ti0ngI8ksxAhfvzY96BWHvOnb
   MpgOcAA+wTZ4RrgdNbVu6RQVaN4elEMvXSSNCg==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RR300HPYQBD5VC0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Mar 2023 13:47:37 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1678110444; bh=q1vl+x4MCyONryOMr6x7B6pHQ3BP/yAOStzXbzeh2mE=;
 h=Subject:To:Cc:From:Date:From;
 b=dsZpN3jEDsZBhj5fE6gWRRgYuJQNEAu1Ro9zqDXVtKtpFFmMOGyHSaAvZszIOQs56
 dUVUIrD2opcvic2LFBz/FYyCGdWZQPEwIETpboX/gEhaQftjETlY211esynWCxflnQ
 eP9+pmLtAIWDRKpbqAPTyIiZvFE3QOWZVW67WvdI=
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
 gregkh@linuxfoundation.org, heming.zhao@suse.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com,
 ocfs2-devel@oss.oracle.com, piaojun@huawei.com
Date: Mon, 06 Mar 2023 14:44:12 +0100
Message-id: <167811025223124@kroah.com>
MIME-version: 1.0
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10641
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 suspectscore=0 clxscore=254 malwarescore=0 impostorscore=0
 mlxscore=0 priorityscore=158 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303060122
Cc: stable-commits@vger.kernel.org
Subject: [Ocfs2-devel] Patch
 "ocfs2: fix non-auto defrag path not working	issue" has been added to the
 5.10-stable tree
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
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: 8EbSCA4JWlCav4EQJuuQ0ejYTJl0vXbn
X-Proofpoint-ORIG-GUID: 8EbSCA4JWlCav4EQJuuQ0ejYTJl0vXbn
Reporting-Meta:
 AAG+R/aY3nzT221x4YbB7wXcFNhi2DZiw70w9DujuXVng7ykHt4a7pk5Smwb4fmW
 Fai+QoLfj5gk1led23hJ+mmwmnX9Z6SHOQZaoO1LrImnguSt6U8XvofjuaSKvVgy
 kVZN8QsRcdpgqmCQ+6CILbIbyJTNPqin2d0HBDuzfviXZw5RisMHuq3un44Q8k6h
 9LHv32F8Am4PX2ug4UvosSoCiweXE5QrnaRedEIM+bu2zB196NuJ2WsW43wrzX42
 xxJ/AFYkTep/YieA2oo3zTdKe8CgsEpWJ+nv2r2fRsK2QqXFX0STLJaSoze6X+qG
 TkZPOQe3GAhOlLlyku2YFZZ7jMxhWwJuKk9URn3C4rsRbM12wsqAXYfpAlPwx4ho
 8ApAzdCBYi+0fGhjX5+KIBhKsJQfV3L6uCUmfv+aWCxcIM7hslmig1/LTppODsiX
 0QxnIg+lC27/DJYwzsQRTMK1gUOj5s1o3Zd+koPYC1hZQ7XMf/61qWW3CG07ZAuu
 35PfhjleEWN1F9mpdU0NoURW8EKQACn7lZmrnDhlUZf3


This is a note to let you know that I've just added the patch titled

    ocfs2: fix non-auto defrag path not working issue

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ocfs2-fix-non-auto-defrag-path-not-working-issue.patch
and it can be found in the queue-5.10 subdirectory.

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
@@ -436,7 +436,7 @@ static int ocfs2_find_victim_alloc_group
 			bg = (struct ocfs2_group_desc *)gd_bh->b_data;
 
 			if (vict_blkno < (le64_to_cpu(bg->bg_blkno) +
-						le16_to_cpu(bg->bg_bits))) {
+						(le16_to_cpu(bg->bg_bits) << bits_per_unit))) {
 
 				*ret_bh = gd_bh;
 				*vict_bit = (vict_blkno - blkno) >>
@@ -551,6 +551,7 @@ static void ocfs2_probe_alloc_group(stru
 			last_free_bits++;
 
 		if (last_free_bits == move_len) {
+			i -= move_len;
 			*goal_bit = i;
 			*phys_cpos = base_cpos + i;
 			break;
@@ -1022,18 +1023,19 @@ int ocfs2_ioctl_move_extents(struct file
 
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

queue-5.10/ocfs2-fix-non-auto-defrag-path-not-working-issue.patch
queue-5.10/ocfs2-fix-defrag-path-triggering-jbd2-assert.patch

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
