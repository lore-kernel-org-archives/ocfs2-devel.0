Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 562ADC6FA99
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Mar 2023 13:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=LFGmSRAJYMWiBJtk8gXC8WreTKW7ril6jlHr/68HL8A=;
 b=bQqchUfVYIwocezin34Ki3zGU8IBhMjTS2mKv+bE+W0UzNGuaCQTpt7omcGE+XXUoN1+2Umo3fKa
   RwkHQPV5CcFMpi8DwMuFR4BnBOjwU+poC/wq5eDMpitLkaQ3lRCXBUHTAmln+L7Q7BF1gaDqzsjG
   /MUQxqbyA+pwLI1W4KCmhpTMg+BZvyTWsvARha2UQM/s+IidgIutJnL4YKX+nIYl37+9T/2HNK+8
   Kjpk/ZPFtYcAimgOcyhBT6s3mfMsHKBGRZ1zfE+qgXuGILMYd9zh9FRUCGIJT1MtFAkGSj4WE4zH
   woL7Vq0Hkb3wCZFsc2Aq7Q51I391gJ5Zgw6oYA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=LFGmSRAJYMWiBJtk8gXC8WreTKW7ril6jlHr/68HL8A=;
 b=fZVrCCLT178uyYcmBwS4DNE8A96UJaTPUhiVl/WCP6dSpp2yelLHOyzfU83eVK3hmFCgOahjjJAY
   JmEnr3i/OwOb6aykDBMC2jXVOJrk2d/CWNXZ35Y4+9A881jSXj6bfBmiJzlbPoQTtlnSwShnPiHn
   6RTMIipJX/FbmM79kA8FeFipHjp8ImCy0WcDy94qHd8A/5jriuDFuJ4Xg0av5U2WYs9fjO2JtzrT
   oSaid0TK57n9lvLobOFJIgVhBzBzAVwFtOGOBiMxAZvMSmXIIuzJ0mnFoezdnNtenuaTPaeFU4Pk
   LEHqg8vP7BSt13yFal+SnAg8mVwy2VOSa3EPQw==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RR3003PZQDUQX30@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Mar 2023 13:49:06 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1678110533; bh=rMZil/HYn3UdtqLsHfngubwgCyXW37OW/mfbfIjIpic=;
 h=Subject:To:Cc:From:Date:From;
 b=AZslYd7q4MMmosRmgbBrQKSMR3ETYar9ozkT9eprzp0CeociiS+YxZBwiVX6kX0ET
 MxSX+EIGEe+c7s+9XVoB9ptKpPmtTsWJjK88L7szhQfACEPM9fjZm/FAb3jFL1xnfp
 fl4Z248zuQpfa+yFpzqRfazTTsN+BjQNPT4WcPO4=
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
 gregkh@linuxfoundation.org, heming.zhao@suse.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com,
 ocfs2-devel@oss.oracle.com, piaojun@huawei.com
Date: Mon, 06 Mar 2023 14:46:11 +0100
Message-id: <1678110371234153@kroah.com>
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
 4.19-stable tree
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
X-Proofpoint-GUID: dajWKAm9SnsgH6Z-R9XLcHjPY-yrFMdQ
X-Proofpoint-ORIG-GUID: dajWKAm9SnsgH6Z-R9XLcHjPY-yrFMdQ
Reporting-Meta:
 AAFfRYOIawOgNcg9bgf0ieVwLbE/9NRTZhAxZ4lkaR7eVrDAALOq6OpuCOW+DnZG
 6aluOYPUaMN8z57Yke3cfXoeARuGP3RFu4KR9JauZ5tDOVHpJXywmz+EtBB3AzWs
 5JR0aZ6f0bOcfttTKpipSqyqIS7IzYvcvFAtxfy9pxuzxoW7MRupSE9/PgmGR4sm
 Sha45pzEB0/pPJ8nppCUqKfq9WU/iJkGtapnjq3G5GcZTQ1QD+vo/cBu+Kn907hj
 GH1A1LKJJne9bxf1NnCCkOvM9ctl6TP9umgMFq/g01bIIPrGSxz/0IXMu+ss/RjU
 as2FAT4sVf+QNpE6rxv96rxyCHKCiAdV+IfKh6XqBfqaFKv6mfhCYzT7gPU9BRsT
 qDqSZy6kmL6YKGBfFlPTnXuueba4FCJTaVuEE8AKlczmLuCG/Cd81i37o5jSarAo
 lSUGw0npBg9ND4b/IngrDNdmsy/iHg5vXW2KTTQ85ZFTvgnwWyFQvXiCSr+GjUXp
 AqHx9U+RmNKf1JcCXMQr00FOKfGyHjcBNzeE131u2qs=


This is a note to let you know that I've just added the patch titled

    ocfs2: fix non-auto defrag path not working issue

to the 4.19-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ocfs2-fix-non-auto-defrag-path-not-working-issue.patch
and it can be found in the queue-4.19 subdirectory.

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

queue-4.19/ocfs2-fix-non-auto-defrag-path-not-working-issue.patch
queue-4.19/ocfs2-fix-defrag-path-triggering-jbd2-assert.patch

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
