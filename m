Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0E35C742A7
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Mar 2023 01:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qXZdlglj3jbZ5fkGJCjKCG3Yq7WFOeHfOAb+KYVpSCY=;
 b=RtTEFQAkFfUiFQO14SusHmeVJ43jwJbLu6uThUK3Bm1E7vMD9z5aruJjzrPlZp/dRDG1CP8hhp3N
   dAVv8xBmpkQIHXYiR26yuPQNoo0t6Wf8VmQ1jSNPT1kOcD6vkq8UsAXE3aZwbB/zDhS3O9SEpTx3
   0E1ymkNuUCOXDJ1ufl8wzGg+0LVWbHyI2bGWBvHVkEaLFKwDbNr6xK6RDwImtvbiF6QuPSPhA9Wk
   CaGJ3XCp/p4iizX4BNtPbuHHb5Vf1IGziP/NeyH/D9uEh1ubAhNCh2v1XROfzLJ+ZZg/lznC+P0I
   m+UGHjiws1KTmIh8ddWPhaIxpSYqmJHQDL+acg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qXZdlglj3jbZ5fkGJCjKCG3Yq7WFOeHfOAb+KYVpSCY=;
 b=foKM3lvUOwdzcn+zWax61PrCEv8r7UQ2oaLX1GoauiSkdu3Fz8GNVu1yeLtTzOXEpVSshdCg0cUZ
   UzkvVrNCF9K/iGn792R3hGZgnwS2ZykGD8TPtke1/VxIkdPhHnfzKC+Y4iIVxvNrAxKeYeOiMe/S
   KhuPjCQQqm27x+cJfynE+lojC2q6rPc9YA5AORwpswUvJ++d4w7VnGnN1+Rj1iohsbihrHJuPNie
   qHG5ds0lrSGUzBoQozyX8Exhm2Q3WAxQVn9d044Q7isi8opKHn/RoV8x9PhdlSUZt8ynYyM3rWaP
   WjeOvIBq51lxxAvbCtGKdVmjncxIPbTr3PYpeA==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RR600F59GDPFH60@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Mar 2023 01:05:49 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1678237536; bh=cFYwCkckI+B4WquIIgOkBqV9ynJxIGoQ71q+3c1PCi4=;
 h=Date:To:From:Subject:From;
 b=whzWSYOcItLq/trQXbR/IuQRYWOT+DxOEgfL4pI9fRdb2WzxDmS5c9e1Cf/Kxu3OA
 ZVq1+0EnIUAPtGAFaCkYNZ9jThj9RGuY/QztwnNiMvPZal22SO0v4YtmZm54ELKoYo
 ItY/iFLFCCMvIwSZwncFqg+PAgKeB+HaBrXmxDPs=
Date: Tue, 07 Mar 2023 17:05:35 -0800
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, piaojun@huawei.com,
 mark@fasheh.com, junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
 jlbec@evilplan.org, jack@suse.cz, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
Message-id: <20230308010536.55886C433D2@smtp.kernel.org>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10642
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 priorityscore=85 mlxscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 clxscore=120 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303080006
Subject: [Ocfs2-devel] [merged mm-hotfixes-stable]
	ocfs2-fix-data-corruption-after-failed-write.patch removed	from -mm tree
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
X-Proofpoint-ORIG-GUID: ed7zxmOQkSsszxk9PO9HBCOwvjoiNdSC
X-Proofpoint-GUID: ed7zxmOQkSsszxk9PO9HBCOwvjoiNdSC
Reporting-Meta:
 AAH8HvsQTfEubKfZfjcJP0llcW3GrrBUMK8ukbKgdSg/uArhMlGv8L7LabMjB6Nj
 7p/pkQc2cTuYnKFOv3WtoGXIymcAhNYxVj3YS3XZoulltbX3PabM/r60lL9ogf33
 1HMawWHmc1M6wDsFph19fUZcSz/vjPh86AIhBD81UCNF+oEuObLj/JPVaLns1V/7
 I8JIzdMf/+a+v6aKc7JSIDIzsiEyXtTJJTAtRCUN9FcwyWYj8/JYpzHkLD+IPjoY
 oezD9hj4NsWz98/EieUocY9YbbYwj8niBSYrmnaz4uMuf+rCdkuMjqal4i86lcZb
 j56TEno3GPEU0MGTv+AVDC9HY9w7hg3/aYjv1XB71SVXzGVs6Lm37ELof5a9UTTU
 MzKLhvvNMhGu8VQ3T3DQ8gZx3CU3T16v+I/p08iBxNVIsHE5KIjeOCmjvzGsQvpa
 8ugCsb3uKTtWP0QdhWdXPDTBMA3Q8rEEJXFsJNwTtOa3DPzyEF/rRLNGUYsyW14/
 WvInLMPFz29rPArPYq+MtXydUoPbLXZK+fEEBYze6pKL


The quilt patch titled
     Subject: ocfs2: fix data corruption after failed write
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-data-corruption-after-failed-write.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: fix data corruption after failed write
Date: Thu, 2 Mar 2023 16:38:43 +0100

When buffered write fails to copy data into underlying page cache page,
ocfs2_write_end_nolock() just zeroes out and dirties the page.  This can
leave dirty page beyond EOF and if page writeback tries to write this page
before write succeeds and expands i_size, page gets into inconsistent
state where page dirty bit is clear but buffer dirty bits stay set
resulting in page data never getting written and so data copied to the
page is lost.  Fix the problem by invalidating page beyond EOF after
failed write.

Link: https://lkml.kernel.org/r/20230302153843.18499-1-jack@suse.cz
Fixes: 6dbf7bb55598 ("fs: Don't invalidate page buffers in block_write_full_page()")
Signed-off-by: Jan Kara <jack@suse.cz>
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


--- a/fs/ocfs2/aops.c~ocfs2-fix-data-corruption-after-failed-write
+++ a/fs/ocfs2/aops.c
@@ -1977,11 +1977,26 @@ int ocfs2_write_end_nolock(struct addres
 	}
 
 	if (unlikely(copied < len) && wc->w_target_page) {
+		loff_t new_isize;
+
 		if (!PageUptodate(wc->w_target_page))
 			copied = 0;
 
-		ocfs2_zero_new_buffers(wc->w_target_page, start+copied,
-				       start+len);
+		new_isize = max_t(loff_t, i_size_read(inode), pos + copied);
+		if (new_isize > page_offset(wc->w_target_page))
+			ocfs2_zero_new_buffers(wc->w_target_page, start+copied,
+					       start+len);
+		else {
+			/*
+			 * When page is fully beyond new isize (data copy
+			 * failed), do not bother zeroing the page. Invalidate
+			 * it instead so that writeback does not get confused
+			 * put page & buffer dirty bits into inconsistent
+			 * state.
+			 */
+			block_invalidate_folio(page_folio(wc->w_target_page),
+						0, PAGE_SIZE);
+		}
 	}
 	if (wc->w_target_page)
 		flush_dcache_page(wc->w_target_page);
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
