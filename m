Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAFD9C6FA82
	for <ocfs2-devel@archiver.kernel.org>; Sun,  4 Sep 2022 16:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mSuInP5fHr3pHBohwFaRmo72bTE4sg+O0L+62p9AKis=;
 b=D54+JRz5tq+MjUnxFfYksAnsBFtUnGyuw1pa+mMIUcDSAIvSI05jp+amTOt4CRTgyca3MwZs2pn6
   cNEBqNW9RQaJ+2yeJRKi72yZv57kToqEN1urj7uKuEnXm8vxJZ0L+eqWh1h8glHpb2ZDPTCjaH7E
   w25BUH7WX0OTauIRe2TUECWjODIqnxTA3auqi0oQE2Kv/uYlr0EvdyA+550ikGZ8xhLUPV5xUmIi
   HUA2AAbvDWTcBFNs4PE7qZYdcDAFKNV4vr+NK1t8nyQ2i5xSi+K42sYyyglagztNpNDU6RTzbbIs
   8+n28Q2ARfRq0lazKZgg5KXBeox4p/1/xdu3hA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mSuInP5fHr3pHBohwFaRmo72bTE4sg+O0L+62p9AKis=;
 b=QHtREfr3kipOdRkvMgINg1HZ/GqNWbGWM5cT88MPu0r8dB/Hrwkyv65/dWQE8jEHI91joF2WGMhO
   Wehoq9tTq768HfGA/buf7bObRHxtZAomp7zhmlbZp+hFvqkLJUkqm1NsyrqvAZlnTbZrs7oNKrqC
   mwIKi4AQglhOspibp6RAZcm5+IhZAKxYKNi7XdZWVK2BxJmG+LwfwAvcCj1jR+U0lOH8BmiV73hL
   r4wQI04SF6hab2PB82QRGXRqNno7P9dPB/f7G8rlVeG1F+hMkwBvW7ToDFSeabqtv4R0Paw6RiJS
   fJvZiEMr0JoFVQsulpEAYobkphDBj5DhD6BXHA==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHP002J01MWMHE0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 04 Sep 2022 16:25:44 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1662163181; bh=W8ti3zVsha1L/AuHd1jDm7TAZKo5OlYXymvwuJgcnwU=;
 h=Date:From:To:Cc:Subject:From;
 b=l9jtwONRVIVTIJa3K7WkVc/D1kdK/D6TwoCMfUVuAoH1ZA7cP/yop/OX8voudx6VY
 6/diT/UQ61Pl1qXTaqXxi+ZluebGjPnRucjzG/rIWAomcUfNgnI5R7G2zlNPxxRNSX
 Ee8MWIpkEiGbbK63H7lT5t9plciDdADlP0uWUjfon3RiYR6H/H9sZKbLdXaXevwIod
 Qch7ZJ12/fI3kEYzttCHkZ73k5EmREeuVHTbzSaEsLoLoKO0/i3rxCgj2eWS4wEChs
 ICjFCb0XzziiTLFcnFwBJ1HomvhX138/swPaqdQ6zbrdMfo2BIgH2YFjGai52mvgwf
 rPSTmP1lj6FQw==
Date: Sat, 3 Sep 2022 00:59:36 +0100
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>
Message-id: <YxKY6O2hmdwNh8r8@work>
MIME-version: 1.0
Content-disposition: inline
X-Source-IP: 145.40.73.55
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10458
 signatures=596816
Cc: linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
 ocfs2-devel@oss.oracle.com, "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [Ocfs2-devel] [PATCH][next] ocfs2: Replace zero-length arrays with
 DECLARE_FLEX_ARRAY() helper
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
From: "Gustavo A. R. Silva via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: sin.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: S3CZmulD8wSOIRVJh8w0O8XcHqq39kw8
X-Proofpoint-ORIG-GUID: S3CZmulD8wSOIRVJh8w0O8XcHqq39kw8
X-Mailman-Approved-At: Sun, 04 Sep 2022 15:07:10 +0000
Reporting-Meta:
 AAFgj5L8DEPU+/I58wJOlzi8gv27Co+N8+EYgFqRv2CbGFFKgC/KudiY5yFp0lJ7
 6SbBUS6uyzhViJ+DKELOdhHn21FDOpQZN+tJ2jMSf1UkpTTR9YLZBgl9ojWqsoYD
 94+SrJocnDYzi/SE4IWhrXqlBkWKouP6uQh+QXSXt41wnJjETTAaNKjbpDnWDKlO
 Bau2Wed+RBxu6xs/JRaQbTphgxQZ4N5he+u6MN8xu8tJnRqxgQRcWWouMR9SHLq6
 MDNYe3rLdoG6J3nmjDLUDlv0KXGfmTWnrYMVLNXbYEJxjQzIogadBUliy3YSZI1X
 DBoh1wb7LonKF2EqIsLvY000K2wHLL46uhLGKlIpSRTZoTIp4/IBsfyfkBpAVKbT
 mCyEigFtFPoAkS9UavSOVg2uWnLy+lsVaJk/HHR25+LE2KRIH9bcz38EmEHnz5Pa
 563KTkk+rMCw/eafeXNxSYpJDj46RGwCa66GxPKSL8LHgUv3W7H6vTILtwme2gSu
 BTweGh6BCGwAF3J4haRuq0eoXOiUXMAKEfK37yoRSqap

Zero-length arrays are deprecated and we are moving towards adopting
C99 flexible-array members, instead. So, replace zero-length array
declarations in a couple of structures and unions with the new
DECLARE_FLEX_ARRAY() helper macro.

This helper allows for a flexible-array member in a union and as
only member in a structure.

Also, this addresses multiple warnings reported when building with
Clang-15 and -Wzero-length-array.

Lastly, this will also help memcpy (in a coming hardening update)
execute proper bounds-checking on variable length object i_symlink
at fs/ocfs2/namei.c:1973:

fs/ocfs2/namei.c:
1973                 memcpy((char *) fe->id2.i_symlink, symname, l);

Link: https://github.com/KSPP/linux/issues/21
Link: https://github.com/KSPP/linux/issues/193
Link: https://github.com/KSPP/linux/issues/197
Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 fs/ocfs2/ocfs2_fs.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 638d875eccc7..7aebdbf5cc0a 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
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
-- 
2.34.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
