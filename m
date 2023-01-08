Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E99F1C678D5
	for <ocfs2-devel@archiver.kernel.org>; Sun,  8 Jan 2023 16:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qfYKkczn219yrhrNEGuzCWkccSjMYk/7i0XOYUj3EHA=;
 b=YajuNJMgA6TMft1MS/QQwyggphmgbWO1/JkY+ZN8JJgoSZHsi8AsN4tU9mVK9JGtFBhIujvgqIMX
   Be5EGN83xcFvLhAMX7ECLBYpYehCPS6nPbr0dJKHaT54m0WGdNbxBgEWkQoSHQh/vhdGGYIClrDd
   cfaJ6vR/Zm0ujprkZjTO31S7VggBTUvBC+UKEfuYuZTsHS2WqGeEfKOuVaHK90ZeVIGa5ELep6JT
   QvQbXCXbm1LAYk10h8pXWd1HUGpv656Y55vN+3VaFcPOqNL+DgFT8CRZhf+NsalRd8xTpR/2qntq
   CrXi4Z8n7lueP0/mKL8t6Jlb1KZvDVQHhNZIcA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qfYKkczn219yrhrNEGuzCWkccSjMYk/7i0XOYUj3EHA=;
 b=XMEXnmMUk/JbdpqjNlXqAnAcTLTownuQMIqdOam3EO44PDuvn4Z99VbX9gB1ofkB6mSAjG4GB4/a
   XBuSunvROrHCyaKbpIY2L4k+97QLAsBo0P9zza4SrpOpOpb0zn7bj4P1uXBL0AXna1lRsKKdocQw
   zWG2zWTmoQM/yO6QDTDmv9eNXas/jBZQxBV8vPbscacWqcAp1qC+cMcRjdo8rIpoQB3yM9Sl+hlP
   sZr52IkCD3sy3FnBQz9jSJAH/7EZchKJRupHlWKONiXtMSRCQTws5hNggK5ywuvt1A/V2T6WHm06
   K38qwc4+butqk6U0m+YyRX5A5URtomWyfkyaXQ==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RO600CVRF3Y1F20@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 08 Jan 2023 16:57:34 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
 Content-ID:Content-Description:In-Reply-To:References;
 bh=n6RpjOdLAh3obh1YrtVlLsrD/ixSNbLSLNkGemSOvQw=; b=Tplevrq0ZXmD/12xpMEYpMkDac
 PbPaoxYOWR4aUh46qukYYZiFJY5/zifkTJnuWRA4Mi8AcmWcLyOYRWr8gqJ4u05mryKVzansHNKxM
 obMID6UuA/yndMNoIlVywMjiEU5hkA3R2ZeFhqCfQ4fxJrp1Nrwey5MC17pZ2F3DSa5M+m4iUoH3M
 1lMnjRF0s5/FNZaJaBUmaL9a8vzGE56rcAmXPIJyAd0+z+MpttizMi7V6AYhVwxj1atl+9lARZwK8
 BlPSlWPN6ZYEWSrsFA6Hxc7vYrW3HrPbdOrGd7h3KzkdK3isaTmzoLOSxULnZXjxe5vN4BUcjhpwj
 mAGkrozg==;
To: Andrew Morton <akpm@linux-foundation.org>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 Dave Kleikamp <shaggy@kernel.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Sun,  8 Jan 2023 17:56:38 +0100
Message-id: <20230108165645.381077-1-hch@lst.de>
X-Mailer: git-send-email 2.35.1
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10584
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 mlxlogscore=392 clxscore=287 spamscore=0 lowpriorityscore=0
 priorityscore=95 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301080126
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 jfs-discussion@lists.sourceforge.net, ocfs2-devel@oss.oracle.com,
 linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] remove write_one_page / folio_write_one
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
X-Proofpoint-GUID: ZW2C000mk5mlGfNVeuUbLYrrlXEt0lgV
X-Proofpoint-ORIG-GUID: ZW2C000mk5mlGfNVeuUbLYrrlXEt0lgV
Reporting-Meta:
 AAFyjRUlhGNeK0/oWd6pc5yTSP4ZpeZ8XiJ+lCG6JGze3OsQSWWEuI8cqqZ4jyKL
 UNAYl+GSwSIWjpU7c25SnMU8rfTyVFQFIut/yZ83cwwPyVCZ47YbVft8ux8uFFVL
 QtXjhAI/kiDE5fTeksUQgQBDTu4KVPeuE+ySZICMxXfWc0NTa6w0NxPESraVqRJ7
 x0l9jirILr3jY/cmO22Rm6yQDuhlWfMSRx7W5d4jxIhKqRX23OJTN1VLBDtwJ5ii
 vODRqbfr2aVvk6OJQqSofF44+Jb1RzfHATc/6HXStqBT61msvmpZBTLnqRjJ9GQ8
 CuD+Jnz9N9MleJ2vXRnCsIymBmoVkbGa3egTq8VrCdk+6soU0B1qV9thkQGh8QJN
 Aj+oi1DPIhcA0/2o4AuH/9P2EmQ4tExk3j9QE2Iu4ihgNTJJ1+hlu42/N2HOp236
 RAHtY/m2G827AswblBTVcHmIsthAKp9tYhE21/LL3QvUo9imIvWvZrt86tZDSM0z
 eJ2F5pxknfsO05R/u7vK7jEXwM/cMXIrYl48xNF6DqY=

Hi all,

this series removes the write_one_page API, and it's folioized
implementation as folio_write_one.  These helpers internally call
->writepage which we are gradually removing from the kernel.

For most callers there are better APIs to use, and this cleans them up.
The big questionmark is jfs, where the metapage abstraction uses the
pagecache in a bit of an odd way, and which would probably benefit from
not using the page cache at all like the XFS buffer cache, but given
that jfs has been in minimum maintaince mode for a long time that might
not be worth it.  So for now it just moves the implementation of
write_one_page into jfs instead.

Diffstat:
 fs/btrfs/volumes.c      |   50 ++++++++++++++++++++++++------------------------
 fs/jfs/jfs_metapage.c   |   39 ++++++++++++++++++++++++++++++++-----
 fs/minix/dir.c          |   30 +++++++++++++++++++---------
 fs/ocfs2/refcounttree.c |    9 ++++----
 fs/sysv/dir.c           |   29 ++++++++++++++++++---------
 fs/ufs/dir.c            |   29 ++++++++++++++++++---------
 include/linux/pagemap.h |    6 -----
 mm/page-writeback.c     |   40 --------------------------------------
 8 files changed, 122 insertions(+), 110 deletions(-)

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
