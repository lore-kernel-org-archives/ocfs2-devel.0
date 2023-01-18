Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B087C38147
	for <ocfs2-devel@archiver.kernel.org>; Wed, 18 Jan 2023 17:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1bRrVJSJ0YRqm018jZ6bq9it+MZ/5y4gRoRr7JMAUZc=;
 b=xOXw0mW5lXiAlAz67Q430p+Kmyi27r0QlsbuY2jRa9WXQCXRqJZocbuVk0mIxbTcyK25KSiLLzjk
   Nh7H/Ho2kUcVjFqm2IUjuCGM1CPEUAigYOaG40fnz7ELPZUDRb2g6ichz7JnE8FIjGu5glGiLRtc
   MBZAoHldIMonQFc0rKWPwgI/3HugYDlffoDQ3IVgWWxf3SSv9dBhgwGDTo7mxYco4M3MBHJZJImi
   pW/76F8e6IwWuAMFth6Cr1AsKIyAnJD6NOuZ+QxBK7Of4BW/ukXR39yuxANb3sDmjgzJzr3Uw4wx
   vvlB1dSVb5eINm7Ckh2r0eKfUw/7bcKOmfnigw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1bRrVJSJ0YRqm018jZ6bq9it+MZ/5y4gRoRr7JMAUZc=;
 b=II+ihnAego2TWOVbVUivgps6WmH81uKXxMjeiiyLlCpXzWY3DR9Al8BTIGR2dgiIsFxf1PgT7cbu
   8uKIteYYZFjdT/T6LO1YCe/9xtbWhNDKusVrTrPijZak1XNPl1j6nGh0IwHTwwjjgpQ1S/ZjKDmo
   RYr3mQ4myqhvLgTAsXOG445mPwpBvchK20wlueHjhRIlaVSCQIMzhQW4baNn/P3FAYdTISy93jP8
   DmhKeYSlzUwr1TA/qoOHYa0d2FSptv1P4sLviYDH/gpHDQbVNnAOtZ/akNPYN22lWH7ZFAqo5cuZ
   7YiJlXOY4eYvT4kFF5xPNPgmguub5eocCCfVlA==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROO00H4PZBO59B0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 18 Jan 2023 17:31:00 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
 Content-ID:Content-Description:In-Reply-To:References;
 bh=IB6WV4RAFpXXvsO5sBFMk+O+geVt8PsPN31oUBOFl9k=; b=cy9FW+bOa13ByFBuCfAvfL/v8q
 NS1mxTNJf/T38OgWLc5a8VnouHuTDQJBbc1BjHuGyBh2TFkGfdKHzIBE3MYwEprvh5abAENudfpk+
 E8K51u3tZUT4jO3uZ91Mf8R/wDuKuQ9C7fQJk/JZX6ai8CL5vdB2/Dovn5I1GRxjLrJSeTI40pmUW
 uQRxpGUFJpXlOg5RiOfIfE63/QT1tFRff7ydAT4rtsxb7OiOFB3p45G63u2OxKrVHhGF7qo3VinQi
 iBQR5lg6roGhzoccKYSrPZ+8N8Dn2JdXK4CLioeITx5MA1iOZE31iVLb5P4fUf7QfXtDzMcda0SN2
 smzE/r5A==;
To: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Wed, 18 Jan 2023 18:30:20 +0100
Message-id: <20230118173027.294869-1-hch@lst.de>
X-Mailer: git-send-email 2.39.0
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10594
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 bulkscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 mlxlogscore=414 clxscore=181 malwarescore=0 phishscore=0 priorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180148
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] remove most callers of write_one_page v3
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
From: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christoph Hellwig <hch@lst.de>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-ServerName: bombadil.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: ZTAH44slCeRRN3CARCWUy-O82jIVsxyS
X-Proofpoint-ORIG-GUID: ZTAH44slCeRRN3CARCWUy-O82jIVsxyS
Reporting-Meta:
 AAEW5g+1e6Jr/1cRe95bTspHdlJLgYjsE32pYrSU2yNlNa1ff1DlOpYPWxamsKYz
 hlubtFaDqLsMSEBSdZZuEK5pw1DjoCV7m3a7ZR0uL2+yDHcHZy2P/TItmi9yq5Hc
 9jcYcRTVkPrdGiGoo5mY3Q9MznfdvsQvzfpb3RM0sGwQDa0VJEvhZZhXrKRDVWfW
 qdWsS/W5YEqeiqlF6BXLsOXfJz+bDc8UoRE3DrcHEJUWNDaf3UCg86Qd29K0KJOV
 6Tkep91NwUmencSW2+31/sICO//YuFgT6lI1s6ClnIO9WKt5H8cdxr5bbUkp4w3I
 wpdYtinprWH/FSlHSZWn8QH5IggirjDjAnTH+so62i1vOfR59rFhiloft6q4j9s9
 QZ5fjbzh2baqDsqI41ToTvJkMR+ZZrqDkIJRqGKu1uTE++rs2AHhiWUQg/OgC5rj
 F0lLXyie41Wp5CmsY8XrLhTkqPkKsjytcwBuOqANQxt7xtmsyjHcV9bszFJ+Wc9J
 s6vBr3vsJn+HPAnp0gdQL7Nw58xZ01w8M8u6rJzuo2oT

Hi all,

this series removes most users of the write_one_page API.  These helpers
internally call ->writepage which we are gradually removing from the
kernel.

Changes since v2:
 - more minix error handling fixes

Changes since v1:
 - drop the btrfs changes (queue up in the btrfs tree)
 - drop the finaly move to jfs (can't be done without the btrfs patches)
 - fix the existing minix code to properly propagate errors

Diffstat:
 minix/dir.c          |   62 +++++++++++++++++++++++++++------------------------
 minix/minix.h        |    3 +-
 minix/namei.c        |   27 ++++++++++++----------
 ocfs2/refcounttree.c |    9 ++++---
 sysv/dir.c           |   30 +++++++++++++++---------
 ufs/dir.c            |   29 +++++++++++++++--------
 6 files changed, 94 insertions(+), 66 deletions(-)

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
