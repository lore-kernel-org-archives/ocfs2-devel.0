Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A042FC7EE23
	for <ocfs2-devel@archiver.kernel.org>; Wed,  7 Jun 2023 20:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ka+QJC3ziNpcp1BA31thTgSDtjpee88JcUCFc37/jos=;
 b=H3f6KH2qdLnjmWdKVU2rpkUCWb3/vt0TUCvKaL11gr8XL7mMmZdQj3x91OcWPlLMY2Ohw66iIBZZ
   +Av++FmtfjeKLg0hM8NMCFCSAjHCnljIYBCe6PgiEA9+d93m/p20iqJFPDJvdWSyjmqk9jw4eCkM
   m5wqgp8cv02UXH4HksjKB2GuagoSOj60xKua4paN2+rQXG7loXqJ13y7gJK9KUgZp94GlzHp0U2q
   JTpYtvQlSqjYSSt78a6LnK3sXvWitw/0cg069PrKuKAbhN3iB/w3lmVEqn796cH07EG0nB8ZsfSb
   Kzwjoj/J1MvWLjcgXNoaS0eLIX8kT3826d3t8g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ka+QJC3ziNpcp1BA31thTgSDtjpee88JcUCFc37/jos=;
 b=tZY2TMj7hemGsMyXv1kN9HVx4XONjs1EuNkfkIfk4arl3bAJwJ/0s2jcFilr083hfeq6yZnZVeCO
   OWqz24EAqODOKAFiPxb3ed05Nz5tLUKU+7666nvc+kYZcowVFUmHwfKBcbBa2C8Z8f8KifCGVWaN
   8H8sgFf05aKyQYIKUmAMwroKeU5hI36cxMNZxmDaUmm0fcO1ViqA2g0UaSWUsRvoLXHN8t/XV5Si
   v3TmUmiOlO2+KSbLd5KSpWnw5vMyQegZAHTEeQRcyDfyw3SXRYbLaaS1v6/wOBmcXw759RsnLPk5
   H4wPkC8FdEKdfU9oDkD/7TPPygTyMu48bw2ZpA==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RVW001GRFKVGY90@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 07 Jun 2023 20:00:31 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1686168018; bh=jxnfoYpXrY6yUsF0XkdI8bJfzO95D9eFQhQYpKJPm24=;
 h=Date:To:From:Subject:From;
 b=jUaHV9JZxHoLj+pWgXm1QVuu+z4Y3ZWxeAmF5TDWsnqqolbIjDmN2n11sKu2NRh/2
 F7WwOCITWIwl7i3TbMS6cajl3OafSM38UevDuYY7VTNBh1cRoVZnn3SUQBidWGZ20C
 1MCjOS2TnfyVKjsChMvSSVhH0g8shFosu37TQfII=
Date: Wed, 07 Jun 2023 13:00:17 -0700
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, piaojun@huawei.com,
 mark@fasheh.com, lhenriques@suse.de, junxiao.bi@oracle.com,
 joseph.qi@linux.alibaba.com, jlbec@evilplan.org, ghe@suse.com,
 gechangwei@live.cn, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
Message-id: <20230607200018.6A0B9C433D2@smtp.kernel.org>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10734
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 lowpriorityscore=0 priorityscore=181 spamscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 clxscore=189 adultscore=0 suspectscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306070173
Subject: [Ocfs2-devel] [merged mm-hotfixes-stable]
	ocfs2-check-new-file-size-on-fallocate-call.patch removed	from -mm tree
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
Content-type: multipart/mixed; boundary="===============4275501965390892617=="
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: cXvVcYDhC9qJUXQNO9ciM3ELfRog79Sz
X-Proofpoint-ORIG-GUID: cXvVcYDhC9qJUXQNO9ciM3ELfRog79Sz
Reporting-Meta:
 AAFCFvipfFw2qlTQHc0udJiN53BW518Rt3a7L8zo3QCzLtB2hPQWMpyZhXGHOf65
 4gdEMeGvc5MLfLbLgJkoTU7NRjr3WjtBsf+UsdoaVpvn2ibcANnzhUfl3LKZhgPf
 SIZr6dKRgdGRavZE/g0zt+hbvnj60SQSKIC7tetED6qpwtMrbCwOIAsu0IcrHHni
 1XJBE+vybMgwzgdUQuOocERcIQVb4S/FZjVHavt49i/75kLlmEa889kMqGXD3yxX
 xAMumYcIFc7muUDH73L5Tlm3sGlHc/XqSOKb12KweHnEYZpkdjD1eSl0dVDu12ft
 O+MWZ+d80+YVZJdEhYHrJJpKYS2Qf+eUE6vLTP5vL++5EWGx1Mz0inuyPbuaM/S8
 Uj379Edw1fJMIweQ58r9Vno3f63hE3q1LKbFt4VixYzDO6DI/SLxj+Q2Fu6jhJfV
 0hO12M2OPgr1t7MoMF627AYMhpmZmR8/aPfHWq7V8QEpQkeJoCihXR1pe/ggn618
 sqnwgBmmFGBZzlNGx3ACfVLl/Iz4DjqG7t2PngMYm8S+

--===============4275501965390892617==
Content-Type: text/plain


The quilt patch titled
     Subject: ocfs2: check new file size on fallocate call
has been removed from the -mm tree.  Its filename was
     ocfs2-check-new-file-size-on-fallocate-call.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Luís Henriques <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: check new file size on fallocate call
Date: Mon, 29 May 2023 16:26:45 +0100

When changing a file size with fallocate() the new size isn't being
checked.  In particular, the FSIZE ulimit isn't being checked, which makes
fstest generic/228 fail.  Simply adding a call to inode_newsize_ok() fixes
this issue.

Link: https://lkml.kernel.org/r/20230529152645.32680-1-lhenriques@suse.de
Signed-off-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Mark Fasheh <mark@fasheh.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/file.c~ocfs2-check-new-file-size-on-fallocate-call
+++ a/fs/ocfs2/file.c
@@ -2100,14 +2100,20 @@ static long ocfs2_fallocate(struct file
 	struct ocfs2_space_resv sr;
 	int change_size = 1;
 	int cmd = OCFS2_IOC_RESVSP64;
+	int ret = 0;
 
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
 		return -EOPNOTSUPP;
 	if (!ocfs2_writes_unwritten_extents(osb))
 		return -EOPNOTSUPP;
 
-	if (mode & FALLOC_FL_KEEP_SIZE)
+	if (mode & FALLOC_FL_KEEP_SIZE) {
 		change_size = 0;
+	} else {
+		ret = inode_newsize_ok(inode, offset + len);
+		if (ret)
+			return ret;
+	}
 
 	if (mode & FALLOC_FL_PUNCH_HOLE)
 		cmd = OCFS2_IOC_UNRESVSP64;
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are




--===============4275501965390892617==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
--===============4275501965390892617==--
