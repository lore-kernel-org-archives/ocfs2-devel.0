Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 846FDC54EE9
	for <ocfs2-devel@archiver.kernel.org>; Sun,  4 Sep 2022 20:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/dLGXdPrOpqAXUHqCT9s9tdENCK8ibS9MGMJxQ6w64w=;
 b=ea5g2jvEjlr/H4OzxYeZDkulya31ltgu0N5kbsQa4X6nimEGUBIMRE2j96bG/XSqUnODNPlbNHfl
   jpjQfijv6w88iFkxrZjGoRlZlsKog9LhRLJSkzqSJMSwk+JXGTsWtu/1XNTaFP3vZb9xQVUT3PcB
   CNoXGWBEXCtcrDiwBx+uGPLLTWU4fYt1/y3eviU4cnF2W6rHsIf6VGASpSC8MTUWJLPzMIYkRVg/
   d+jGttj+qlgIWmlJjft9gY7pAm6B2nHdhB4eOu+PRnD4cFugYKj3Vy4BhsmAIpwX2wrJzvUi1T0Z
   v7JUDdhpJe33Cj1fTp/O7Nj5hryaGqawtaZcoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/dLGXdPrOpqAXUHqCT9s9tdENCK8ibS9MGMJxQ6w64w=;
 b=r5/JSsgShAJvlfj4BdeiiAJoFVx9hrWFUW2VjNooIhOwSk/gRWR0Wg45uKpgcxzaINqiey15jQF8
   aRNn1nuJJMvHCbfcHcM6Yi9P6wQWMbLu7xQwqU6xx6c5MO4liMBPxN+Y/Enf5QJF/KvfB85fAoVU
   kS3L7/w4cBHYf+8qG6thJ7VS/rk8Y8aCSUlzlCrMG7ra3MOdexzqEvvNoqTIHo3ifY6E/n6waYDD
   2xJ0/iCb+AIarUELqQmbsNqyBp+5sKVI75qVFIzqyehw5Q4gmluAbyltObi9X+w8LWObbR3s7MSM
   zHaiGGHv+w2fxevMtCMaExbNkLrMlxN7W4LlsQ==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHP00OUWDX3V880@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 04 Sep 2022 20:51:03 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1662315865; bh=dUp9R5uJX2JF2sPY8tWynB9S3INulUNeaZcc2IiM1Os=;
 h=Date:To:From:Subject:From;
 b=ymWl2W2XsVeA5xfCy6nTgECO9l9D3BYUjdno2DGpI7o8MFbma663u7jK7Tyf9XuxP
 nCTfCQSdYKb4Yws4GsLOoJ6ApwLCLe8U+xZiUxzhR0IpMMDxc+gxmq2XijFgWBslve
 EL0RCIEEYt9u6XJS01mvZMVDdG1RffHcZX635FSk=
Date: Sun, 04 Sep 2022 11:24:24 -0700
To: mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
 keescook@chromium.org, junxiao.bi@oracle.com, jlbec@evilplan.org,
 jiangqi903@gmail.com, gustavoars@kernel.org, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
Message-id: <20220904182425.0E319C433C1@smtp.kernel.org>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10460
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 impostorscore=0 spamscore=0 priorityscore=48 phishscore=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 clxscore=173 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209040094
Subject: [Ocfs2-devel] +
	ocfs2-replace-zero-length-arrays-with-declare_flex_array-helper.patch	added to
 mm-nonmm-unstable branch
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
X-Proofpoint-ORIG-GUID: No3Zkmf8Ks6yWJ8D6y0v5u-4Oja1-jNM
X-Proofpoint-GUID: No3Zkmf8Ks6yWJ8D6y0v5u-4Oja1-jNM
Reporting-Meta:
 AAEX6ccTAlT4zdJEGABcfzgSR+ptUF2Kw55SPYoeeUJiVFqbuMrfUM2JH76tY5bc
 878CUuRDMNrgrwh7KGHH4cZLTrk+GaV15bGk9fPBoast8YyxOPLcCi++ICgjAXfZ
 FjpOk+ihblmm0SoJ+1CE/VLQ2x5LOmQswepe3wXnxg3A0sl3B8ca702OutExSngS
 q5RNBqdNxS3LwiLLB4jxa00MnIYfrZ0RuT9fHm1M73olQHpD9Kkh3ZyEN82nOYDv
 YcW1gT0TopqLrDJkfyk2OLAiYRe7kgYbQInclh9klNfDQmBx3gFi4aYvSKCkbH6k
 gPHQprmE2+r1UrfyYU4iaRIf+hm8zod6eBXbT4wYx/FgKsosHfBxqfa5FhDatC8V
 Tg9fIaMSMB53sLD2dX9EKlsN4iQuTDy9hhwHIAD5VCiLzuOd4fksAY8OZZasvdal
 zOkBnnK00jw0regZu8HnIZzBip3sWO5baSlpvkMiNXJDn14cfNDO6uO++DS5nDmm
 NhS4sddNaxzo9eDXrLqPBVtUxhH+5sdtFHkb2mncQvt0


The patch titled
     Subject: ocfs2: replace zero-length arrays with DECLARE_FLEX_ARRAY() helper
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-replace-zero-length-arrays-with-declare_flex_array-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-replace-zero-length-arrays-with-declare_flex_array-helper.patch

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
From: "Gustavo A. R. Silva" <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: replace zero-length arrays with DECLARE_FLEX_ARRAY() helper
Date: Sat, 3 Sep 2022 00:59:36 +0100

Zero-length arrays are deprecated and we are moving towards adopting C99
flexible-array members, instead.  So, replace zero-length array
declarations in a couple of structures and unions with the new
DECLARE_FLEX_ARRAY() helper macro.

This helper allows for a flexible-array member in a union and as only
member in a structure.

Also, this addresses multiple warnings reported when building with
Clang-15 and -Wzero-length-array.

Lastly, this will also help memcpy (in a coming hardening update) execute
proper bounds-checking on variable length object i_symlink at
fs/ocfs2/namei.c:1973:

fs/ocfs2/namei.c:
1973                 memcpy((char *) fe->id2.i_symlink, symname, l);

Link: https://github.com/KSPP/linux/issues/21
Link: https://github.com/KSPP/linux/issues/193
Link: https://github.com/KSPP/linux/issues/197
Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
Link: https://lkml.kernel.org/r/YxKY6O2hmdwNh8r8@work
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2_fs.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/ocfs2_fs.h~ocfs2-replace-zero-length-arrays-with-declare_flex_array-helper
+++ a/fs/ocfs2/ocfs2_fs.h
@@ -527,7 +527,7 @@ struct ocfs2_extent_block
  * value -1 (0xFFFF) is OCFS2_INVALID_SLOT.  This marks a slot empty.
  */
 struct ocfs2_slot_map {
-/*00*/	__le16 sm_slots[0];
+/*00*/	DECLARE_FLEX_ARRAY(__le16, sm_slots);
 /*
  * Actual on-disk size is one block.  OCFS2_MAX_SLOTS is 255,
  * 255 * sizeof(__le16) == 512B, within the 512B block minimum blocksize.
@@ -548,7 +548,7 @@ struct ocfs2_extended_slot {
  * i_size.
  */
 struct ocfs2_slot_map_extended {
-/*00*/	struct ocfs2_extended_slot se_slots[0];
+/*00*/	DECLARE_FLEX_ARRAY(struct ocfs2_extended_slot, se_slots);
 /*
  * Actual size is i_size of the slot_map system file.  It should
  * match s_max_slots * sizeof(struct ocfs2_extended_slot)
@@ -727,7 +727,7 @@ struct ocfs2_dinode {
 		struct ocfs2_extent_list	i_list;
 		struct ocfs2_truncate_log	i_dealloc;
 		struct ocfs2_inline_data	i_data;
-		__u8               		i_symlink[0];
+		DECLARE_FLEX_ARRAY(__u8,	i_symlink);
 	} id2;
 /* Actual on-disk size is one block */
 };
@@ -892,7 +892,7 @@ struct ocfs2_group_desc
 /*30*/	struct ocfs2_block_check bg_check;	/* Error checking */
 	__le64   bg_reserved2;
 /*40*/	union {
-		__u8    bg_bitmap[0];
+		DECLARE_FLEX_ARRAY(__u8, bg_bitmap);
 		struct {
 			/*
 			 * Block groups may be discontiguous when
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are

ocfs2-replace-zero-length-arrays-with-declare_flex_array-helper.patch


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
