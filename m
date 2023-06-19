Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40510C3DA40
	for <ocfs2-devel@archiver.kernel.org>; Tue, 20 Jun 2023 14:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=K4BGzWXVW9IofMSzvnZICrRC8W2vrC0dbDNHpy2yiME=;
 b=xWnCO7nSmSg5/IGXcmnR//C3av5Nfrmx8qBxuY5/4ZX97CmZT5DxOPonaW/phsfCOs80Tcb3hjMj
   o0v/E19DwH1+fCuuNmvbjWhyF6anga00pO6obKsJL2jLyr8hrHwP/5C28llgigedCRQnGYevpBmW
   VtLRfd1UMNA0rRnoNNLWmbdJNG6nwVkCYZtpUioAhH1XVP+7Djv84i+bzYl1VJoJQp/p4vUeBah3
   vxBr5HZ6l+yoAqG/svkiVwwKjxH5dz+OrLI1YDLORKgzlsHYmBRav6mPPAFQMRE22QebjR6ZGtqG
   cZha3WTpPIYmmwZFKJuqh9G0RfpTihxiBMolDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=K4BGzWXVW9IofMSzvnZICrRC8W2vrC0dbDNHpy2yiME=;
 b=Lq28rfsMDlFiQ1iB5HyH4Mb/Vun77QBOUd7wpiM2GcQyfgXmQ/XT9VmFT7WPiF1uxBP6RrhRjDLQ
   LE+zFUYJCAbaun/MTIOKTqiT6xrepbSei8PaIuZdjS5w3pFFtrVEWRsIOKlpnmpAz7EAn9mlBr3N
   v7Gyh3KBjwCWJurZ3S2lmF43RhR3Xx82r11appfNjSA42yD9l+zqvD7hdaIY2kXDbPRhBDZ9Ir7p
   Q1KwrA/gW2sDRpFVdCZqRg6UkgSd+XT97HkiOyBnKkmZoUVlAPqUUSZ0wTCfxmDumEt9AENlDgYj
   4lgx3n9VUA6ZDAFuNBuE7Ngmh6h1DskAknUexg==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWK0049H45YPU10@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 20 Jun 2023 14:56:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; t=1687209523; cv=none; d=strato.com;
 s=strato-dkim-0002;
 b=iXW+saF7kB84ux5Sh1GzvZJAKM5oOuBilsfWS6nJnsZqanSKwfNjFgvG+3uYC0At5T
 46+OSOvw14hhWN6sm7Q7fuSykcen5VPB9u+VR6Ks0MZDuDqDxJOH/1EQx+GI0Tt1V3wY
 V5b0WQQDknmTJSCBu1XqeLKozTUBqeIZO3aqTY8tZRz0en4UIAHlS0utuDXGJSqaRDrM
 yg3ZCSRoGdycEFF9T2xShKPKoHS8AswK+NKMBJiWfWoO99oGiS+4c9DJptA9zpLxX7Mf
 r8lguh0sBxgDMd83ERZopQUICpfj25TduZPOGqceozxeJfI1NEDsIX9MVJv7XaRmunfH t5ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1687209523;
 s=strato-dkim-0002; d=strato.com;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=CKdAZMZFL1lysf+KGzAf1YfN52/k1jfBpqK7BEK4ECQ=;
 b=NdjepsXemP4zX5eP3+nASzm2MBNXIYeXB5ZOeZYL7NaB2qDBYchN58t2uXgJ7ajkPI
 kIeJVCh6dwRAtRDgPoCTb+wmqKQcQl1ETExCOA3GpIPBKAnvwGDeTRNsKf4rb1qurIHv
 mu9UlQhGvnN/octEhj8+IFkfNqEW0fYPt9qGbrMgbMlE+fP6RhTOFbMs1XXSiduTcI6w
 w0uWSS/XdOmXQaHWK4Imb0gLj77x7hLzS+QMkugDtzVYuMMWUvSXg64/GDBHPhZjAiN4
 xhju/kIw3MUXy5Aw+lbD91HWLDrEm+1USzWhnNRf3sMBxi4YY0XPrmJqHzesDqWRiAsA Q0yw==
ARC-Authentication-results: i=1; strato.com;    arc=none;    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1687209523;
 s=strato-dkim-0002; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=CKdAZMZFL1lysf+KGzAf1YfN52/k1jfBpqK7BEK4ECQ=;
 b=EvvbgWM/eCMk0n1VSSbXT5rhdyml+1hWKggc7OV/TwNzf/lpxIRIiAsZ/IxitXniZY
 L3eFUQ1m/YIeeOrkAqyaWo8LAbRKm+8bwV1Ui+7s3nf22PWg+Ep5dWyWWSITcXZeWJJ4
 hNCb4IvvFumuArPd1HZDHAoXshSeoCVCIqwYdjknsaDDW2um3+K+lQVQfW9HgBGYulSV
 Yl4kFTUp3hEgo8eR0lJAKVP+IbW7eTh3i/7Cvp1kuwfhwAOxmWOSxrTMVyQ11S8+B3u9
 h7jBvR1GbtaYn9hKMeq26e56ajUUGopdYp2L9jBuKWQBDohJ1OecAzcdk8JaMPp6ixEp aShw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1687209523;
 s=strato-dkim-0003; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=CKdAZMZFL1lysf+KGzAf1YfN52/k1jfBpqK7BEK4ECQ=;
 b=QqgNxw3eGfr+h4MqDUBKk1EMddioMAgXV+MI/gO1qh6s+TOSnMStcOSBEOs8ATjUi0
 bWc3AC1Oo2rjqpMNwIDg==
To: viro@zeniv.linux.org.uk, brauner@kernel.org, akpm@linux-foundation.org,
 jack@suse.cz, jack@suse.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Date: Mon, 19 Jun 2023 23:18:24 +0200
Message-id: <20230619211827.707054-3-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20230619211827.707054-1-beanhuo@iokpp.de>
References: <20230619211827.707054-1-beanhuo@iokpp.de>
MIME-version: 1.0
X-Source-IP: 85.215.255.80
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10746
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 mlxscore=0 malwarescore=0 unknownsenderscore=20 spamscore=0
 impostorscore=0 mlxlogscore=789 suspectscore=0 phishscore=0 bulkscore=0
 clxscore=36 priorityscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2305260000 definitions=main-2306190196
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, beanhuo@micron.com
Subject: [Ocfs2-devel] [PATCH v2 2/5] ext4: No need to check return value of
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
 ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSedrgBzPc9DUyubU4DD1EQ33bneoxgmq7ABeEwyjghc0WGLJ+05px4XK4px0+bSzE8qij5Q="
X-ServerName: mo4-p02-ob.smtp.rzone.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: 89T7dFLORMot4TxWJz0flcNugMGrwfQW
X-Proofpoint-ORIG-GUID: 89T7dFLORMot4TxWJz0flcNugMGrwfQW
X-Mailman-Approved-At: Tue, 20 Jun 2023 14:56:20 +0000
Reporting-Meta:
 AAHAtckAKFi1UxcRjLIJBvtI9yXX2DEYEQ8aAG/WoXG6qJbuYAXwL/Lb+twLNtON
 7rbh37hFE+lKFzvq6RRxLu3K1ToOKZDEuJhycptYvkRt28GG9eSUNGmsopGOphUp
 a4HrOEoz7Rv66jIsqD62fruH2x0RAeN1U5t7QvolZg5BECvcuJ67KxXydvXc70cC
 EwdJSAtROsA63mghXXCCAr+lDiKTZUf2RrhF6cRvXHh1FMZcXgWaghac2qCWSzIU
 xGIQL84ZtI7st2yEjfhRm6WiLQnWe2Cn7Me4aubi4ipZDAxThR0LAilvbcCrcyWz
 7UbWm/4LNfVmczFCQNC+Hr2cVPy/IVorPD2kwgRynVR3v0vU2v1r1fx4RljJv0DO
 2sbWDMnGZiK5IGKnz1w9sLn7z5jCIdDzfQc8oSX9xVs9VT5tYgorQ2EtQd7LH2Yl
 j+3Mss3/Q0wlLoljahTCjjR/DMTmf4gCYJeSfrjvQPCmmtvPFrKGwcIqbLQVZDb6
 YrIvRPUUq9IyL4c/rVaSWK0ptCKNtnkHjSas4Rmi1qI=

From: Bean Huo <beanhuo@micron.com>

Remove unnecessary check on the return value of block_commit_write(),
because it always returns 0.

Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Jan Kara <jack@suse.cz>
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
