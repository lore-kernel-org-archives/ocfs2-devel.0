Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 324E8C001B3
	for <ocfs2-devel@archiver.kernel.org>; Tue, 20 Jun 2023 14:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lG2T/FJIByT5VG7I5YhVY0Jwy2klt3itcagU5HAZQgg=;
 b=Y/emj/0EEXa+Mgg1JbcxiLZd38Mqg92dfXHju/LfzouX7cVxn8PZYHWw4fIW7Gt0u1BeWsNZewNp
   QQxM6BX204pOXpkR4XQihgLszTQksI/IP9ixBcsXWIDVMv+Oo5PQCQsA9gKyFAvAKBECZgUR7BP5
   Sj80TXQfRt4cEm6f4oXngqqg7I74EyincS7KOeuZ+nA83C+r2VN8Jy440V4VsLl8a+iVAysZ2tKd
   MGklEX+K7MoDsgN97wY+7XSx3Kw/OWuRMpypw6mklIQTAXkzBMlxMysX6M31ZZM5NcQ0NQi2Yh3V
   S7ObSfl1HhuWiyAM41HZeSZEyn93OgeEPaduAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lG2T/FJIByT5VG7I5YhVY0Jwy2klt3itcagU5HAZQgg=;
 b=b6m+kQQgpoZNyDuHkpCOCzjXt2HsUBNFv8RZQp//48V8+blZpTMWzSSsPl4qyw88gdWIvTknJhf9
   foTgQnlJsRMgU/t9RbjTyahJiyrYLIGXJI829+Ogi+8TsHjEDAm02lgdpohjyYbJEqiJeABvUwLb
   uCYzb0XAazDcmnKgoX2DIsE/amKLYxgobNwS7LhqDFsnv2UC+NUJ8B8PJ7dR5EORbCE16VNyoYhN
   ZUINjpJGHp1CAp7lfoOpXIY0PElLj4wsRCYvnmpqFyekuZN2yjzzm3+0ETrFz1fFGYTdx2U60hk3
   bBGUYgkSUp7WOuFlV8QeYI8Nxd48u+4Wfjgx8w==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWK00FA745YXV90@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 20 Jun 2023 14:56:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; t=1687123986; cv=none; d=strato.com;
 s=strato-dkim-0002;
 b=VM4BVadLBxSmWrHdO2AnIMFg3ThohSaWQHyt8CN0gGgrgT5Efki2XHTvsdgrx1ulnu
 gi1cVRMSfGGBnxqq3Up+SVlG+6HLgZhTJ+pEKilpmwR2A4+BFS9DoFhf3z0sgA8O+SmS
 +nEEpKuMAaL+L7rzmqyg8GpEFroyX8gqjmMCjftc6+gE0I4cP5FKwRB/GIUme3aNGAjQ
 Mu9f5JPR+wgaBVmKO0LuS1DA5hLKntZTsVoTvEhI9tQ7B/+gmj9Fq7j6CU+xz3RdGfm7
 x01gQu+hPEqCr5fg+ETD82JFu/XYJAIf2k3ebb2hjNJqje57KvmfnK9wwbX2M7wYVRLR fReg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1687123986;
 s=strato-dkim-0002; d=strato.com;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=6ppbOx/Qif038c3YguD4sRfoT+KAp+bNCu/5t81cezc=;
 b=Ne0eZfHTFUALLrUFdk+Mulsr50qZ7017Hu6VyizDLMjGT45FpEu8baz/jcu33NlyhR
 kNT0gTjYuWT5l7lxhTATOY+4uQnJqU4xPyKBmq3d8g895uLh1PuSwXlXH59hZB6Hj/kV
 /RPpksFyRS9tHYP7tQb2F2wWF39Kay4SpNY2QYV+2SvbGyFx49NKr2KTpco9f5R2erVZ
 tA38sJhLXJaNmQYypvIRVUgg58TFeSyG3qelpcWjbSpGHLxYWDo1JDk4GopqXW6KvaaJ
 dJXTHLmnMQCbKYsgWTwtcW9nND/cnQ4Jm8zr6ihU8EY8iQUacB3nzWzq6twRa4qNiZdG 7NnA==
ARC-Authentication-results: i=1; strato.com;    arc=none;    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1687123986;
 s=strato-dkim-0002; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=6ppbOx/Qif038c3YguD4sRfoT+KAp+bNCu/5t81cezc=;
 b=rm1C4aDn5s8p0jiPCSQS5e33N+QMhMYX/pDLrHunRRLY82ZzC79ofe7ts6o6S9db1m
 Lv7Y5hzySS8uRR66xnJLkU2Sjeyuj8Adcq48IFxbNoq03zd70IyYvmu0Pkd/JfsZhHio
 2JMb7GZaAA3fGeds4hxUJieADdqHEeB3ehdTQinwcA3J82eiAGQUgpWU/6speQS27RgD
 wCMRuwmubaVUc159E62Bm6I9RmJUR5MoHjQLTv2f9hqsvHVNCaKLw8e8ro+CLkRSir1+
 Pt6a1MhtQExsqm+6T6TVUNbTmw+FqRMdzeJfiN6csLCKWsVaGLvAEJJwvy097UnGynCk cfIg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1687123986;
 s=strato-dkim-0003; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=6ppbOx/Qif038c3YguD4sRfoT+KAp+bNCu/5t81cezc=;
 b=NvePtc2m2+fdgfTJNzrxCVuc1a5tkuX9Juc9ovSF6j+el0TNLXge5NTjT7AAYUd0kv
 N5FeFsHWiyo5iEgg0QDg==
To: viro@zeniv.linux.org.uk, brauner@kernel.org, akpm@linux-foundation.org,
 jack@suse.cz, jack@suse.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Date: Sun, 18 Jun 2023 23:32:48 +0200
Message-id: <20230618213250.694110-4-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20230618213250.694110-1-beanhuo@iokpp.de>
References: <20230618213250.694110-1-beanhuo@iokpp.de>
MIME-version: 1.0
X-Source-IP: 81.169.146.170
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10745
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 adultscore=0 priorityscore=0 unknownsenderscore=20 bulkscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 mlxlogscore=881 impostorscore=0
 clxscore=86 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306180205
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, beanhuo@micron.com
Subject: [Ocfs2-devel] [PATCH v1 3/5] ext4: No need to check return value of
	block_commit_write()
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
From: Bean Huo via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Bean Huo <beanhuo@iokpp.de>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-RZG-CLASS-ID: mo02
X-RZG-AUTH:
 ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSedrgBzPc9DUyubU4DD1EQ33bneoxgmq5ARfEwes1hW/CxwfjqKzP/cKnUXGNs35zouFQhI="
X-ServerName: mo4-p02-ob.smtp.rzone.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: ForvyZ7dh3Z17C0rYIIcW3Xf3OtdIJZB
X-Proofpoint-ORIG-GUID: ForvyZ7dh3Z17C0rYIIcW3Xf3OtdIJZB
X-Mailman-Approved-At: Tue, 20 Jun 2023 14:56:20 +0000
Reporting-Meta:
 AAEruL5YbLIsbriU3ClZK31pcw8ZCPwgKGl9le7FhcWDzqklneNQF04TClkysMsL
 8+i18KixXkP0/AI4gzbQ/QbzmvlKnTnPTrOmgnK9L2AvseCuT8UpEc672HyK1a4d
 frb/YFBwKHmApdzLDRAK86xqVwv4eWlVdZt/xbgZcjoFsnzyDG6qpUR4rcKlNC9/
 sqv3qlQvVbWu743yyAfl/meFsyeWBUMqa3bWiMUr2hHwvVoECAiE9V47fMi4ePQm
 PN5EowgcCPFyVfhoYwKYL8A0HCizRhcW3q3PEeMoV6l1GBE8ti5Yav9rIRUNtlfk
 S8xlSwustJgIn1GLxGs73Mk0216FMyKOqpAFQG4N5KC5uzZK5pZkcWGhVKiiqeEG
 0/ZkhOLPH7D2XVudOjwGw/q0UTyWnkhvcc+0Dcm/VUdC2IEliG7+mxMr1OEv1ucJ
 QkBqeva89JRZzilpwysh7hDOZI8atWytOcZitI9/e6tjmDwG4XnVqhHfdczp7VZo
 WeCHTeR6v+bdsKsoBs4xkEaemhrkNV1MGEyqxAujXkyY

From: Bean Huo <beanhuo@micron.com>

Remove unnecessary check on the return value of block_commit_write().

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 fs/ext4/move_extent.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index b5af2fc03b2f..f4b4861a74ee 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -392,14 +392,11 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 	for (i = 0; i < block_len_in_page; i++) {
 		*err = ext4_get_block(orig_inode, orig_blk_offset + i, bh, 0);
 		if (*err < 0)
-			break;
+			goto repair_branches;
 		bh = bh->b_this_page;
 	}
-	if (!*err)
-		*err = block_commit_write(&folio[0]->page, from, from + replaced_size);
 
-	if (unlikely(*err < 0))
-		goto repair_branches;
+	block_commit_write(&folio[0]->page, from, from + replaced_size);
 
 	/* Even in case of data=writeback it is reasonable to pin
 	 * inode to transaction, to prevent unexpected data loss */
-- 
2.34.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
