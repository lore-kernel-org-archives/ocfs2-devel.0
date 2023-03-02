Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10499C6FA8E
	for <ocfs2-devel@archiver.kernel.org>; Thu,  2 Mar 2023 15:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=F1ArcWDsm1GhyKunBlzBT3sfPfPV7f8LPBg/mH2u3QU=;
 b=WOZ6lYv0osYAu1A3wKxLLB8LSPvUbXjfH6Z3T7xCDmSqOyjOkVTjxBQ4TZNllC5e+1Xs635CxzXk
   ePllJINhm/+eRMzthbj51spwzy5tDAgxVZLMbqFxB6Zo59gFOQeonMpdcVnvgAwcX4V7UBinF1FC
   SxxsJ8Ea8xtx4RlKmwQrraeDD1t/is31SCwMQaOcsnUFLb55g0J0Awo/sTbBkv117LFgcVjfBNgG
   qWjkW1sAsTHZF8jWEkTgm8iUGNAd+PlB0WSsHBP9nkP0bcuqCIo/FGebXdfgkPDmy+LmJVvzOY6L
   wyQoTaoEYrKebTGFJitdTZCiozzCw3K1jLDgeg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=F1ArcWDsm1GhyKunBlzBT3sfPfPV7f8LPBg/mH2u3QU=;
 b=QK+VEb/I5yKaEQhjLmaI+yZc1si0ica6a1ecD/2848tS76S3hsXdaf1uWchrN9n/bVsILS7V6NJl
   SPgv0ZddGly2psqoDbIcAYpQ0K/0nE3bB3iedPs080c7FqmWjIcYZkLlm7o96IxA/o57cQs4D5X/
   mhjvpvhEf5zZqMQHh1OUMSn67VmYKUfdKUz8Hhkp8h8F7nmvYH6CgGChzBT0LHLqYylFWHIaJrNF
   8+q6YquxSyXHC0U45yoqhjbfgVUdaBf8qgK+3rpCgdOc+W01SeFGRpDM5mgO8S2dv1ZHv7+GsCBL
   WTAWGqeRWdsb4RTrbCv7RMlUQ3TkT8c+hCUI5w==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RQW001F4GT8HTA0@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 02 Mar 2023 15:39:08 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1677771530;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=Ic6a4JKCvOEfJSHXSfajhI4WHcORLiQuhsnE+C5oJ5U=;
 b=wTG2YJwvVEu0LWGHAklq5GOutiekAACpZrLwTycR9vNhjuq7nG0fLp3dWHUCwlZZuN3ezb
 ZJeknG5aWTQs5jab8bW+B0qv5DnyPHAItJSVKxtk7HL71WYBzzSjT5az1SLz15BDugZ3OH
 Dx5jUY02htMYYnjLAURAa9MsVrz+W6w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1677771530;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=Ic6a4JKCvOEfJSHXSfajhI4WHcORLiQuhsnE+C5oJ5U=;
 b=B9sp8ZP++eLdCRbtmRslgXHMAqIUMeTNaQzxdOeHNCi6NLXD2mx5ZNzK8BPPomjrQh+i39
 tASvTNPnRYFl/6Cg==
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Thu,  2 Mar 2023 16:38:43 +0100
Message-id: <20230302153843.18499-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
MIME-version: 1.0
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10636
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 adultscore=0 clxscore=201 bulkscore=0 spamscore=0 priorityscore=111
 impostorscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=535 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303020133
Cc: Jan Kara <jack@suse.cz>, stable@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix data corruption after failed write
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
From: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Jan Kara <jack@suse.cz>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Developer-Signature: v=1; a=openpgp-sha256; l=1876; i=jack@suse.cz;
 h=from:subject; bh=/rKo0FOKiHUXGPKBoNJqtkfi9xkL98IIPrdtd0bUJoI=;
 b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBkAMLycOQHKp0sC2T/Sc+XbDDLf4n2oCUPKeKOtNRe
 v4D8uD2JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCZADC8gAKCRCcnaoHP2RA2QePCA
 DXKXTik128ek3BRYUdzOAqB5VuDGDseHDi4xjGKD7Ul6dweeUIEE2JIM9hmja0ZCFRMPDqvuHLnuWm
 1MlPbm8wh7bcniK1WzTcV4WG3Gfs0tqELsC3Hl7qdWz2RdO7VFtEyAlnSjr5dSYnd+cWdfLbj4/uyf
 9ScLL8yYO3eaBtxWy1QMf/XQ11oMsYJqpgwez8NLxsPVMWCqiJKhyjozi2QG8ofwP0z+cWuvCgGMHe
 P+vk+U1I5/m9/q50QZlbrr7GjaHFVVmF0DymC/+ONELpkX5ii3APaQJ8EcDSCSm6LhYL7Rx6016PwB
 mS4D/lHZZQ3TGH8NRPvnJbNJYEXrLx
X-Developer-Key: i=jack@suse.cz; a=openpgp;
 fpr=93C6099A142276A28BBE35D815BC833443038D8C
X-ServerName: smtp-out2.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
 ip4:149.44.0.0/16 ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
 ip4:192.31.114.0/24 ip4:195.135.221.0/24 ip4:195.135.220.0/24
 ip4:69.7.179.0/24 ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: -sqYOA8gnPJXuqNfvFGJ4CgJiyZQ3JAo
X-Proofpoint-GUID: -sqYOA8gnPJXuqNfvFGJ4CgJiyZQ3JAo
Reporting-Meta:
 AAFlLgE5nKkJoMkv5++7IOPa+PeSG5gJJ3Y8LPKcdPU5MF/jD3L8oBh91mv6meKa
 lehfPNZoWwQ/+IdAgqy3jFNN9BsjTTN4CIDG6lijejwJUr2dIX+gnMHxKhP/CM4a
 alnwC+xEnV619+KXt5ZRsCWXAn63hpEqZcY4KaaqSHYXEVKN0imh5FGP1Po/tS3/
 FRVsrCGl6k1T6ege2QUa5k2k01psj0k4LT6X3gF6qTe4smKtOK+aqaj8KrM5gfBq
 h1a819hJOkz997HsMEWV7GCOxmpA/DtcBgEFrytx7mv29kq9ImUGYqIf0ydyxaeE
 3XZRAURC69vGs+u52r3pW8OledZDCOom+dBGbRJPwxw/ucMHaYbr301GFAC+XgnX
 3F5KFDsu976sr7FXXbZjVikLtns3QvlQVCGkxBr7FjIxmB/G8iQJbR0KqLjNYZQ1
 2oreJqmjB3eutasc9BiofgJBSr53L0IcDvc6tVtweMCpTBrgN6zIO7YVa6FTNE65
 GDJM9tmVyyTwkvrhV/06EyUtgfJp1cyquFfVsaLBvA==

When buffered write fails to copy data into underlying page cache page,
ocfs2_write_end_nolock() just zeroes out and dirties the page. This can
leave dirty page beyond EOF and if page writeback tries to write this
page before write succeeds and expands i_size, page gets into
inconsistent state where page dirty bit is clear but buffer dirty bits
stay set resulting in page data never getting written and so data copied
to the page is lost. Fix the problem by invalidating page beyond EOF
after failed write.

Fixes: 6dbf7bb55598 ("fs: Don't invalidate page buffers in block_write_full_page()")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/aops.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 1d65f6ef00ca..0394505fdce3 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1977,11 +1977,26 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
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
-- 
2.35.3


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
