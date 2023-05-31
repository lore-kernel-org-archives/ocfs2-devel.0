Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1726C7EE23
	for <ocfs2-devel@archiver.kernel.org>; Wed, 31 May 2023 22:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yyvAAP84+WgTKR8Km/dMHAD8mixahp9wDxK3BjibkpE=;
 b=eUKYwnbZtvJdgTzt5o4Eeso/NY0ss6e57Ivl9jIrC8m+k965FhOm2wOjZRbu3SEoOsdDxZObZbbM
   bPuJlqGQp8UNutMgvadnzt3aslxO3KLhALEadVCCPQwc4afDOwZqP+1bu0oHksUlx+WTnHvCBx9m
   oh4IuGkJm7EGE2NAHvURepENohkwwmSeXKtvSwQLZLlCO/YJHQ+t5rakT7KcWxDcMZJSazNVc+Fw
   FKB0Drhe6PSFe7H6rlfBedCIpiacwY++LFnMWVAqJtLJ9x9TdoLZtoyoNQpIwHBs0YW08KGYNrb9
   YZ/0L2f1T28uoujjo4Fn6gsftwUtPD9hXRilTg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yyvAAP84+WgTKR8Km/dMHAD8mixahp9wDxK3BjibkpE=;
 b=cau9MvNmEasDwpx5XusnWvLC9vn7ZJse8By5HGtrKeqL0MMXgIuOskxQxnqxE1ipZVkP/X/C/dbs
   o5RjAaPGSxKC8G/yaS/b2XbuRsJhAwHiNiGr9+caWqdhXTLko+HkFL2j0KWmfMPvTZmXoOlA/9qX
   EypEK9u4qCvLmc0UZ/fGmqS0gAhQ62UIzCnEb24I0mMRAs+/uHa+tgltjGRAftmBZ1rKdlREKdRt
   dRHusihd7K+gzT+/m5k77A5n+aK8P8t5oEnwKwVyu+ov9qKXCK/YISAFAqySY0cZlpadHJPKMcD1
   MrmmKItwWzgl5ODa4peMUorYvzz+cWa/fBFFRw==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230522 64bit (built May 22
 2023))
 with ESMTPS id <0RVJ00HU4N4RKX60@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 31 May 2023 22:14:51 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1685571277; bh=ep+xAxQZMew8zv3uP+eMQY86pESh0Ng4iHByI3d7BjY=;
 h=Date:To:From:Subject:From;
 b=2fuTUfpAumsMVFVP20L7rIaP8GzoIFJhDZO87FvhGrgKGsi+2SOuA7CWirR6jU/lN
 of/VQsZBOd+Btyld4YQywxraOVTum+biVKFRgCkqATyd9T/Djh4Jpjur7MaZQ/n3RT
 EEy2FYU+BgHu/rB7Fhtd1QZI1dkH4WVN30mJMf8I=
Date: Wed, 31 May 2023 15:14:36 -0700
To: mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
 lhenriques@suse.de, junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
 jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
Message-id: <20230531221437.2B54FC433EF@smtp.kernel.org>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10727
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 clxscore=181 mlxlogscore=999 impostorscore=0 spamscore=0 lowpriorityscore=0
 phishscore=0 priorityscore=30 bulkscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305310187
Subject: [Ocfs2-devel] + ocfs2-check-new-file-size-on-fallocate-call.patch
	added to mm-nonmm-unstable branch
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
Content-type: multipart/mixed; boundary="===============4396259428494810224=="
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: rSQ75I0y-P8Hv2U71Ctks6NTZbyqeRwj
X-Proofpoint-GUID: rSQ75I0y-P8Hv2U71Ctks6NTZbyqeRwj
Reporting-Meta:
 AAGI6saUUYrNqo3lTClTHjfof4aBD6Z/PMlLUmUWAV8g/QGYXCayRhuVoIV6hGFS
 plnPloZsjJukyTxBv41bZjQfUmjG2Z10RDA9/cshiTrSDeoNLrV9ZtvX3OoQTKAj
 O2kFBqP/A3Kj+nszWq2oZMiPLmzIKLesP7ojpnSEy7WdEpj0lpqeOE5ohvtzDUYT
 Gm7xAPbVGfFTvKOkqGPAOGpW0LKhXDkW8eZYNM5OUqe1lZOz8QvZWsVqwoqBwV6n
 YwMmEg1pTxE02ntNYhfjQ7p9zlAyuJ1VCaxfK2/cqQB4MKD4zidwEd+0KtqYawew
 BUMhkpjXRuxo3mx30V3pqadLHzRzi5JJSpMQAmKTkQ676Y1y5jku8HfesrahPCQ5
 fMO2s8pGGcbEDGkKMGd3Cc2qtXATUZgE450zBejohozKOy6NmbYUFj7oMWQ9g/je
 2YTnHerOfijcctBWMe3U2Kw8ZtN0fyEyD3Kr+eVAF+ddccLzhlkw+H0WhaVgikFC
 ocW4Vxdmmwfd7BwlNJ0BdtewlTsjhoPxyQkWhpZDRaEJ

--===============4396259428494810224==
Content-Type: text/plain


The patch titled
     Subject: ocfs2: check new file size on fallocate call
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-check-new-file-size-on-fallocate-call.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-check-new-file-size-on-fallocate-call.patch

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

ocfs2-fix-use-after-free-when-unmounting-read-only-filesystem.patch
ocfs2-check-new-file-size-on-fallocate-call.patch



--===============4396259428494810224==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
--===============4396259428494810224==--
