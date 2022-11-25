Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E354C4332F
	for <ocfs2-devel@archiver.kernel.org>; Fri, 25 Nov 2022 10:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=M/hHLR1J3kKUaXFheMdsU03sKLPj9j4YiW2YdVMF0iU=;
 b=SjYFEydu2lcnbpdNDWRoI4FxyZgClb7XEH+HUmVy3l1zphBHVGMaC0FizdioYSwG3Cv6T3UYzSC9
   SiI0eZP7PfHm0qF11nJXJZ3ONdWc4T3r7rGYyTukmLBMtb1fbFzqxEjgvrosVKExjnzU3OxVauQy
   XITti5eTeC236qLuFhW5TWwNLYekh66Paw8vEJUFeGFX6q3+KilciNtZ/MdDE1S00LO4/uqxn7cK
   vKMEUfRiGu6THVu6qLDoFRK4skZ22WDKCfZhfaYIIvzDu8ToNE+BJ/mMLuC9RNshWBZANPYDNVtq
   yVdcttqruYlrFtviUUOELuHleL5PqfBkR1Hddw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=M/hHLR1J3kKUaXFheMdsU03sKLPj9j4YiW2YdVMF0iU=;
 b=WXwO47e9LvYpvs9W7SSM1yuVLDOBMUBDnckbZ99RMvtl1HTEnJgwNpdyRQ1xWzXpsRAe7OAKOCA7
   2oo5Ce/eOA7r7h5i2TQjRo9TxLDWKonOQULudq5jsvnavjGPDCKX3Xpr4d7gHhHAefwlKSxM320D
   MLqebpZUBY4SkEeVJGFzI6elqGZRo65L0dACz8X5gWUb3R9wWM/63Ly+vNPZraB03W6UrA9K+1J6
   qkXpWuEyqpldCfJaquNrOeQ0xBVFs64uM4s3eccP+TvBladd5IdP1ss8vh03rnR/HIO1mKX5Ig6W
   fk3kT0b6alafUJHwy4BHIpx7l7fhKoDQ+mfoxA==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLW003BZF1NOHB0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 25 Nov 2022 10:12:59 +0000 (GMT)
To: <mark@fasheh.com>, <jlbec@evilplan.org>, <joseph.qi@linux.alibaba.com>
Date: Fri, 25 Nov 2022 11:41:18 +0800
Message-id: <20221125034118.427-1-lihongweizz@inspur.com>
X-Mailer: git-send-email 2.17.1
MIME-version: 1.0
X-Originating-IP: [10.93.221.219]
X-Complaints-to: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Source-IP: 210.51.26.145
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10541
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 mlxlogscore=515 clxscore=280 malwarescore=0 phishscore=0
 suspectscore=0 adultscore=0 spamscore=0 impostorscore=0 mlxscore=0 bulkscore=0
 priorityscore=95 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250027
Cc: lihongweizz <lihongweizz@inspur.com>, linux-kernel@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix infinite loop for orphan entry list
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
From: lihongweizz via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: lihongweizz <lihongweizz@inspur.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Abuse-Reports-To: service@corp-email.com
X-ServerName: unicom145.biz-email.net
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.corp-email.com
 include:spfb.corp-email.com ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: -yhDMBlUBAdHSV00817FB-fLquPaWlJK
X-Proofpoint-GUID: -yhDMBlUBAdHSV00817FB-fLquPaWlJK
Reporting-Meta:
 AAFAfq4bbXxZXa2Xiugv7wGuk0mNhqVpaVOh69VpDddkWtFTfV/HW33Gc0NfTxOn
 cAJoIDlPdA86hqsdMxyBTyO9zhwCbORtSOEoLVzvNT+A3VujufIWAQ9krTO3spMu
 HF2Owjr8z+4AeDJCkL/n5meC8m9PUvb1f7DG4uG+GfSD10taOX+12lGRKCeSLN0z
 10iaYVieeNt5quLlSp2VXCHbsmCE8Rzm7TXawrzpD7EDzA17Q3zcEG2hGPyRtRKl
 C1M3QawHCZF5k6gZbU162svZVFqD3GfpMV10FLYnWvgONDGHVle7r0KyYbuT8KrF
 w9Q7M8fKjr4sClEWjdSjcXIMuQQ87pFYgOec1/zjs0CI1VtGfbBJFjXRrUIT+FF9
 09gO6wPLmSo3xI/kl/a1eDLY6y69PFsMTtoKU/B0S/l/DAGm5+odT8wQS9t7jRXz
 YZUP1we9v31zcf1p7N0GCoMR8h6twZJIfTbYLa9NRrawsfIDNHarC0G9a4DW1WEJ
 U/jem0F8RAn6f4IF497SMiiXKNSGtW91NeGYwZ4FY3o=
tUid: 20221125114123bca5f4d50778c114cbf93989e7e66be2
Abuse-Reports-To: service@corp-email.com

Orphan file may be in the recover list already when the ip_next_orphan
is NULL (for example, orphan file is second tail elementof recover
list). In this scenario, the file could be added to the list twice
and infinite loop happened. So we need another pointer value here(EFAULT)
 instead of NULL for the list tail element.

Signed-off-by: lihongweizz <lihongweizz@inspur.com>
---
 fs/ocfs2/journal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 126671e..4620013 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -2207,7 +2207,7 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,
 				 enum ocfs2_orphan_reco_type orphan_reco_type)
 {
 	int ret = 0;
-	struct inode *inode = NULL;
+	struct inode *inode = ERR_PTR(-EFAULT);
 	struct inode *iter;
 	struct ocfs2_inode_info *oi;
 	struct buffer_head *di_bh = NULL;
@@ -2224,7 +2224,7 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,
 	if (ret)
 		mlog_errno(ret);
 
-	while (inode) {
+	while (!IS_ERR(inode)) {
 		oi = OCFS2_I(inode);
 		trace_ocfs2_recover_orphans_iput(
 					(unsigned long long)oi->ip_blkno);
-- 
1.8.3.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
