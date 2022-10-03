Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCBAFC433F5
	for <ocfs2-devel@archiver.kernel.org>; Mon,  3 Oct 2022 21:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=xXlZTIqr+F26JpwIr6wfLPEmVLZDRBubm8/vxdHjw9g=;
 b=PesnxZZunDhvCbs5nAZidE2G/UOjfJo6HJWbZPzF9EBwyHt9yVkzRBHUZeISZ+rvw2uLM2TRfY49
   OSXO/pJa5gv4HkyExrE0rlJjXr7yOZMNcdIHcLcavk0nyUHN5Yblc8/2vwcfmACBPFFpNSXs/ltr
   uI2s0PPVOsRuQUFY7k5jPunl99N2hzZ6ym3O8EJZXZqmI7oinFe0mahJD7592Qg6JV/cjoSqaMKv
   fdfjDQuQN06vz1WmAjt54z0YUDWn8v/M4yNiHg8+SkRypWoVJXg1svs3ToeCPggKBveW6p8Py3dh
   TX8Nv/SOaRbzze1bjm655WB0F8SQ5nlMRJQnJg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=xXlZTIqr+F26JpwIr6wfLPEmVLZDRBubm8/vxdHjw9g=;
 b=Waipwax+meGkgyV5jx+UynL2+463LwvQlpW6gzjcNSseo6A+5TkAAEJvUMx1tJPGJdMErC+HF/em
   Yo9Mh/SL+96o8LvQyQLUPZeHEYpowfvW7t+sYOJI/m2cDyyrJ7EJqXEpVufgJn78U0G1di7ld4HL
   MX+sUFBzmUDpSYbiTzw8zYO5N9nfDnvj6A3EAzbHkdzOKqJdMi6mDaqe3mXuacswxeyKscGK8My6
   w29+RJu+U/3F5AaKKsX88xEqe5/AxJ6ecYUdakUC7GCoWcGG4rH4cJ2uAdTs2NQRJOu5RQ7bo/LH
   wQ1qhP6itXxI6Z7GgkaiE2VE4fGl0W4EQsOWwQ==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RJ7006OM4PXL7D0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 03 Oct 2022 21:22:45 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1664832149; bh=BXHt9A9Dlo6mucM2/e8xtqU1bC82I1EIkAe84yd8GLY=;
 h=Date:To:From:Subject:From;
 b=m2vrzIFBncuT2F7nmpn/QNV3BJinn0a5NDTpjSuK4g5pqg7TB8Lt1MOq5Y0xeemqF
 6w73YRq1dpVXtRiPL+QQGNInPe5pqMTIWKkWw3sX6KSht3/I5m2XZvA2biXJsW/M0j
 ZwKeg0ZB8S2stGHJjovoglACeNNWohQ+1XI3SpnI=
Date: Mon, 03 Oct 2022 14:22:28 -0700
To: mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
 keescook@chromium.org, junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
 jlbec@evilplan.org, gustavoars@kernel.org, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
Message-id: <20221003212229.19AE7C433C1@smtp.kernel.org>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10489
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 priorityscore=90 adultscore=0 clxscore=239 suspectscore=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210030128
Subject: [Ocfs2-devel] [merged mm-nonmm-stable]
	ocfs2-replace-zero-length-arrays-with-declare_flex_array-helper.patch	removed
 from -mm tree
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
X-Proofpoint-ORIG-GUID: 5brLzxiQwVpKj7ztCIQCUMlSxKuSwb1W
X-Proofpoint-GUID: 5brLzxiQwVpKj7ztCIQCUMlSxKuSwb1W
Reporting-Meta:
 AAF9mAJB4uOAfGh5MgaxMA8IfTueejOD8syL0O5P4+YKOyBGGV4av7zyvb5LBD6X
 Su+S6BYxmPCIjvIey0zIfSYmHFC3iyBiAWfnCgHDUcVzSWZ2Vh9X89j0vUxO8nw7
 L5/kXbOKNz/eZWVxpFus8IXXnTSppouxol1UCbOqwYaiEMGOLsJGRtv07ww5WnSs
 MqjLU5u+FAqK5t5iNYyckUu1eI2+vnq8c00Qkx8aVJLaJIFtNvSOq5NmJTKhvNq0
 EaY52KD/HovxMvy4JFrdiHep1Hapw50i2hLlUJWaFGaIIlaHhL+j7T0RB7DB12GD
 vHHotfSuxf10/mdYblxAI613qG+fiWbOO+IWKoaylOmXlkGzdyAfIotb9OppRVWi
 fAnGK6tdrFYiK0H5c/on8vKaO2RYEyrJUAMLYzrpFGfT0h7AAzpmUZDQWFc9lGGu
 W8DrFuIxCGONbtutR0cO0Swa5KaLwQ7sFH3gB4DWipvOh4uzlsBCT5eDWz5EBhMn
 wGTIp96kK/VqpF0DUkJUH4eBEWTY8z80xmmc7mBL7ZI=


The quilt patch titled
     Subject: ocfs2: replace zero-length arrays with DECLARE_FLEX_ARRAY() helper
has been removed from the -mm tree.  Its filename was
     ocfs2-replace-zero-length-arrays-with-declare_flex_array-helper.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
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



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
