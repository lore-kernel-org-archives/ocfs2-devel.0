Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE6BFC433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu,  6 Jan 2022 10:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=AIh411P/Bg27C3ptsT22+jWRvoNZ8Nvf6RiYgn44BMY=;
 b=i/5BdkLPOi+LRO24Erqd3CFGwjiZWdnrzAhT3WRVP5ugdSsmlsYEkXCjF5GEgIAstde8+iKZ+bhF
   AXmTvKtNTi7qR6upAlF+QWHNBqw82jKOC3hAunLVIHTN9bCo5tbiufUJc20Kc45QlXEgYx7Oktva
   fM2RiXqcW0oizivxPbBCI+jCaW2GUcQtecpTQGVQOyG5SIH+KZUzIxXzIG63ZD6WyJnOoRvZghvQ
   dWTQrKNG2C+qKu5KyfXoa7Q+6TNlOlFZVXcw1FDr2ZqDKE9pwXN4R2VR7yvNs/7ponYDRyoMR9H0
   M71TMudBpxTNZ43LzFsAX4eaRLVdDHFAYQ5PNg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=AIh411P/Bg27C3ptsT22+jWRvoNZ8Nvf6RiYgn44BMY=;
 b=b6qGOn2heMiuHudaSwzCVmVHf0ylBdjFIU/1EY+UfsUiZdiCOYy2VeJRwnREz2Rw7RjK/P5590af
   RjzpYwjCyVc9WplBk/idubIl6fw50BtfegSepVw1kSdiMiKeYYLS/Udb2wLlBXffiMzgLvOIDcj8
   pR7/OJLQgfhbddeArqH+/pTXlFcuQCD9V3Ic1Mt+FzSLfJHdUtHziIF5N+qeVUt4Yrqpjzaxeazc
   v1UDGpVzCqEjpGYV0FpZYPaNKaei66xnCqAlD7DW/XvzI3AGifL9iehkIsGglLcKlpVw5pVaV3GN
   qOQjIOCwS4fYn/TGLvFGTQSoibCu4qEGQhotLQ==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20211209 64bit (built Dec  9
 2021))
 with ESMTP id <0R5A008EXA2LOG00@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 06 Jan 2022 10:20:45 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=permerror
 smtp.mailfrom=gregkh@linuxfoundation.org; dkim=pass header.s=korg
 header.d=linuxfoundation.org; dmarc=pass header.from=linuxfoundation.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1641464431; bh=W9u8F+egG7FJT2/aw81C8uDLm3ZwqvfOJn6J5z/Jd3Q=;
 h=From:To:Cc:Subject:Date:From;
 b=gGY6KgsrLpLgla+eN+5WgKdMkTjJGQIpcB1g1A9mSDmA9l3WGrytXxWsql6zk/PU5
 xD++mpPci/kq9fGtUTzLXbgp+iaU8nNjb3M1eOHLIUe7H53oi1lwVoiHmIjeDu2qbH
 nWGqkjm3SYMtSrLJIe3mxq83fYx68zHZplROyB3A=
To: linux-kernel@vger.kernel.org
Date: Thu,  6 Jan 2022 11:20:28 +0100
Message-id: <20220106102028.3345634-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10218
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 priorityscore=403 suspectscore=0 bulkscore=0 mlxlogscore=775 malwarescore=0
 mlxscore=0 clxscore=357 lowpriorityscore=0 adultscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2112160000 definitions=main-2201060073
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Miguel Ojeda <ojeda@kernel.org>,
 Masahiro Yamada <masahiroy@kernel.org>, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH] ocfs2: cluster: use default_groups in	kobj_type
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
From: Greg Kroah-Hartman via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Developer-Signature: v=1; a=openpgp-sha256; l=2200; h=from:subject;
 bh=W9u8F+egG7FJT2/aw81C8uDLm3ZwqvfOJn6J5z/Jd3Q=;
 b=owGbwMvMwCRo6H6F97bub03G02pJDInXDuVo7ey6n/KjoHDJd/7fCexs7PFCGwStrm8NbSgK+/Pp
 9k3vjlgWBkEmBlkxRZYv23iO7q84pOhlaHsaZg4rE8gQBi5OAZhI6i2G+QGXdhg/1EsusE/bwaES82
 dn7oSekwzzPcuaBUIjfgfUXzt5vfGTAltVQAwbAA==
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp;
 fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 include:_spf.kernel.org
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: ZMBlw2qHdnycVxDLn6ZTogswT1AQTmpE
X-Proofpoint-GUID: ZMBlw2qHdnycVxDLn6ZTogswT1AQTmpE
Reporting-Meta:
 AAF0qP+VMBzc4MiwH+2XdPpw5bPzzaigIyyBGvvadJ1iQ7qJZmaBOb9+zf+H0xg4
 Rl3TamnjtRxnfEeyUB9kQXEdBwdaHVRGvtcUQTi1Za7T6XHI09hVbOfffQHSmQUs
 DsQtZZEh71WJ0mj8bwQ3utKycrZaLxDosMsm0SStY2buHpKLP0x6lANbBfq/8U5d
 1VqRTH5/L196RCDdgPFJ0Uj7b1D6EVp2HYnkHL8L/kshy6EEL9bD5WJF+nIIAIZJ
 10F1j7ux2bIIgiuIjpwkndNCyvD/Ooq3IOOtmEh0wHugx/dLtecfywqUztzs6PbX
 Oj8RWXt2KWMTeffuxrbcCkF43fOHXjB01BYrvKLoKrecDHq316HSTcrL0BY154Gv
 c1k3SwvdXunnBbsyvjZSg+8jgMM1XksG7R9cyF9kc1+JRvuho8ZTMuw/VRX5bEb7
 TwVTAIk05QmUOjWnNl1WXvUedBp8EZPJGrhr6jjPLuYMtUxxPed1msbr1sRLAZ7D
 X8LtKIYpOhENZfVJnuPoJc0K7Dmo8JM+0e6EnIQCERCU

There are currently 2 ways to create a set of sysfs files for a
kobj_type, through the default_attrs field, and the default_groups
field.  Move the ocfs2 cluster sysfs code to use default_groups field
which has been the preferred way since aa30f47cf666 ("kobject: Add
support for default attribute groups to kobj_type") so that we can soon
get rid of the obsolete default_attrs field.

Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: ocfs2-devel@oss.oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/cluster/masklog.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index 810d32815593..563881ddbf00 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -120,7 +120,8 @@ static struct mlog_attribute mlog_attrs[MLOG_MAX_BITS] = {
 	define_mask(KTHREAD),
 };
 
-static struct attribute *mlog_attr_ptrs[MLOG_MAX_BITS] = {NULL, };
+static struct attribute *mlog_default_attrs[MLOG_MAX_BITS] = {NULL, };
+ATTRIBUTE_GROUPS(mlog_default);
 
 static ssize_t mlog_show(struct kobject *obj, struct attribute *attr,
 			 char *buf)
@@ -144,8 +145,8 @@ static const struct sysfs_ops mlog_attr_ops = {
 };
 
 static struct kobj_type mlog_ktype = {
-	.default_attrs = mlog_attr_ptrs,
-	.sysfs_ops     = &mlog_attr_ops,
+	.default_groups = mlog_default_groups,
+	.sysfs_ops      = &mlog_attr_ops,
 };
 
 static struct kset mlog_kset = {
@@ -157,10 +158,10 @@ int mlog_sys_init(struct kset *o2cb_kset)
 	int i = 0;
 
 	while (mlog_attrs[i].attr.mode) {
-		mlog_attr_ptrs[i] = &mlog_attrs[i].attr;
+		mlog_default_attrs[i] = &mlog_attrs[i].attr;
 		i++;
 	}
-	mlog_attr_ptrs[i] = NULL;
+	mlog_default_attrs[i] = NULL;
 
 	kobject_set_name(&mlog_kset.kobj, "logmask");
 	mlog_kset.kobj.kset = o2cb_kset;
-- 
2.34.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
