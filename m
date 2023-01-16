Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E366C678D7
	for <ocfs2-devel@archiver.kernel.org>; Mon, 16 Jan 2023 08:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ZpvKS8DDF8fSg59/Xrbfurh4Asji/qDj6UQDZO3ksu8=;
 b=1/MKi/x5ymnjg1qTroqAYmjxHf7JYd07gugU1+nh6+VWKrTbP7IxgQpHRiSyWzt0TuNJnRI9sc2X
   CE+eSd1+/ErE1mkY7R31keDUHNX9FtFZir0s+w4gjycUuGnWA6NoY8+5nMcE2QmGbsVX7Z0ZKH+0
   JSF9nC7nrd/saX+GZTZJga6oSEolv+wu2N5D5q+4A8zxsqDf330Qrfx5ugVpCrcoJ10JRAhhso5p
   l0kTOQigPJk6sYqdTR7hwl3LjguQ+R1YsHGawHjFIjXO4r0ljyELEqdRYiRU0tYEMHj7dLZy/CvV
   pilzoISQTDthIlohE6LL0ts1OhxiI/zwj6NXGA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ZpvKS8DDF8fSg59/Xrbfurh4Asji/qDj6UQDZO3ksu8=;
 b=Pv4iKSt08YYFf972WspomHB9+B5B5BDEbH1VHHMpgBIh9aIEC4W8g/GE3T3rrYC+VsF0AcBDTdKL
   7C7trVbVc8v9xRw3RyOMNQArCzwgsVvGYC1x/molLLMulEe0+nJUG/3rhvXoWZ8q/HnzeoQ5qn70
   ZpZUx0j7je49Dufodl7qVLys1XoDRSCRQVYiSfQVO2n3WPt5w6SuS+hhCXYktR6YTLyxawLesQL9
   9BkBnoj75IJwVaUopz/zqBCdOJ2HRODr6VPLXuDkh5tET68one+prWdLJChtBvQC1GOLTwLqyVV8
   IkricTcskJLIKJigJXiKD5vK3Q/xWCPwcNS/fg==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROK001ORM5591B0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 16 Jan 2023 08:55:53 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
 Content-ID:Content-Description:In-Reply-To:References;
 bh=0UWsapgUoOVMvQv6PjY0zlY78zJSlkYkDKlwFKIolPQ=; b=Z0KodtN0L42bsRBsgpO4T6vPhi
 9Qx683mxnIqYbI262J9wRoLkKaSTPg9pQIhtRcRPLNXC/3meGfI6O9GJqhfXv9biPdt4AVWt9sJe2
 v9OE6X/VsY250d/Zi1PG7wSXEcjpFTCxnNdsKv8vMWZkLsiGyl/WqUPmU0VVdhRayKyheHCFzDi84
 n+YiUlINRP5lV4XsxJLsexGt9ar3bM667lUhuuJwwbXdcryZzR3o/3ECHrkLJPdfM7hu1IXA1+CH2
 PK8WsVneScALkDnI6kOZv68rPwZzEgWR/6Vz7gLNJ1abFxHqrx32+Lyb37qWfTiTExam6aSxYNX5j
 f8ZzPNIw==;
To: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Mon, 16 Jan 2023 09:55:17 +0100
Message-id: <20230116085523.2343176-1-hch@lst.de>
X-Mailer: git-send-email 2.39.0
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10591
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 priorityscore=0 lowpriorityscore=0
 mlxlogscore=477 mlxscore=0 impostorscore=0 spamscore=0 suspectscore=0
 clxscore=258 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160065
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] remove most callers of write_one_page
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
X-Proofpoint-GUID: 3Ld4MvQ-KbH-iEtyz9mY89qws2Gd6wt8
X-Proofpoint-ORIG-GUID: 3Ld4MvQ-KbH-iEtyz9mY89qws2Gd6wt8
Reporting-Meta:
 AAFKtTt40o07TbZsfZXtM6r829noUcogN4tSbHhOwwxdXtPR4rojwroPj5J1uJLc
 ziwTSkt40ZDzkIEtonlizafL4vFgS536TSM7mEC2BHsGiOcWRsCfTlbBYHFvXbqN
 8RcRUIV4ynS38qlft0tMOUhig40lND+FdPtaowxMQ+9TyMDxwAXNpwqTsRAC7Cj+
 Ef2IZNiNAgjPQoNXA8ukkM5d3AvTfKFKtCfPrtgGtEKpRc9P+CFiYmP0Zx2SEbJV
 KI+r6PpUTLpoNKpb2NIo3QtVawRNH/6oxdfEADHD8IgShmsxMWQNuDXvwFPqUSCr
 xybC42y2D6IgzDz4StZWRG5/aiyaW4HCeOpL1H43Qf/3lLyXKK0R/m8Q4QMwDO6C
 6w8Hzgjz4KjYUjcwgRJdqUI33jEPsvX8DkBGACtPvbR3rATPNh36HP8iGrcnYByN
 25r3O0PZ4uShfAdsgfeLBJ2l8/oi0E0eb06rau6D5Btv4f6WGnTF2NY7V3SjPc51
 5s0G5oJyumEo2vFpxasT4BRKjtfsvA/o6tb9RKl/g2U=

Hi all,

this series removes most users of the write_one_page API.  These helpers
internally call ->writepage which we are gradually removing from the
kernel.

Changes since v1:
 - drop the btrfs changes (queue up in the btrfs tree)
 - drop the finaly move to jfs (can't be done without the btrfs patches)
 - fix the existing minix code to properly propagate errors

Diffstat:
 minix/dir.c          |   67 ++++++++++++++++++++++++++++++---------------------
 minix/minix.h        |    3 +-
 minix/namei.c        |    8 +++---
 ocfs2/refcounttree.c |    9 +++---
 sysv/dir.c           |   30 ++++++++++++++--------
 ufs/dir.c            |   29 ++++++++++++++--------
 6 files changed, 90 insertions(+), 56 deletions(-)

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
