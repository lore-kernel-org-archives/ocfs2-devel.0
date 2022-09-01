Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2E1CECAAD3
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Sep 2022 13:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=iRm0As0lZjXmUL885bWYdKgAFWGGR5UOBcb0oASlCXk=;
 b=XnfQUePGnVmzWZkjMuhVyd6JJP8viK9m8Y/4kv751RopfNFtBroH+A8m5YP7RX2FahmQZmPo/HGX
   yYJ6DxxNhN+EsoxrUFKP0YUd0sr00mMbfcahLPm9PwSAZrFjO/C6+0sCHXe/VdXYp261mK813tew
   xZ03wg0majkx8SbGKp4jb3+pi1o3VhY4E8VgdyFJq5PKdJgHRbMHa0fV8/9nROQxPBm3GCHJyvLq
   BJx8mCy15OjJnHeTJYduN70PCyvaoztUd/iY9gv6hKQqzsfqtsPr32TC1UmeTMEHUY6cS+Ovp3pG
   zG2lEPiiD2UKFkxcZjn/25/4QWdzxSpuyGgr0Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=iRm0As0lZjXmUL885bWYdKgAFWGGR5UOBcb0oASlCXk=;
 b=bed6NdcuggQFy9m29XKcR3XecTpIrSVvMhkQaC8Yoo8FKsCK1IRVJXhZLDtyFU1hJWPaqo8ce2wi
   xikaL1xwQno7UwjLiRyLc9B4Xqsn/wxRUnShGpbdN1MVWsd3fwDJWIOiFM5klvdweOaWMKdwRy64
   kWYKJ77AyooVlLwECNyG88OswAtW3RiDchCBWBaK3s5C35ks4xeGMjjIlX+gdojkUBxG6rvtIJlI
   AIXWkPX4ZC/mGCxrjnVqd08gKdw4OaKkwBjApxtAoe3QuyEaYUMw0bzHi3xGbKGfWZ7K9uRROh2k
   VLzSp4MugyGqQyycppi1+6TpFx0KqQ/9LfG2HA==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHJ00BMS98HZG00@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Sep 2022 13:24:17 +0000 (GMT)
To: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <cluster-devel@redhat.com>,
 <ntfs3@lists.linux.dev>, <ocfs2-devel@oss.oracle.com>,
 <reiserfs-devel@vger.kernel.org>, <jack@suse.cz>
Date: Thu, 1 Sep 2022 21:34:51 +0800
Message-id: <20220901133505.2510834-1-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-version: 1.0
X-Originating-IP: [10.175.127.227]
X-Source-IP: 45.249.212.187
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxscore=0 phishscore=0 adultscore=0 clxscore=122 bulkscore=0 suspectscore=0
 malwarescore=0 priorityscore=207 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010060 domainage_hfrom=8269
Cc: axboe@kernel.dk, hch@infradead.org, tytso@mit.edu, agruenba@redhat.com,
 yi.zhang@huawei.com, almaz.alexandrovich@paragon-software.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, rpeterso@redhat.com,
 dushistov@mail.ru, chengzhihao1@huawei.com
Subject: [Ocfs2-devel] [PATCH v2 00/14] fs/buffer: remove ll_rw_block()
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
From: Zhang Yi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Zhang Yi <yi.zhang@huawei.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500005.china.huawei.com (7.192.104.229)
X-CFilter-Loop: Reflected
X-ServerName: szxga01-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-GUID: J5Euf91dn5zZ6pzeL9y8wRBZ3G1xjo2_
X-Proofpoint-ORIG-GUID: J5Euf91dn5zZ6pzeL9y8wRBZ3G1xjo2_
Reporting-Meta:
 AAFeXXBtBrK20/UY/tLWmBm0gHF3yic0IGFertky0SEO0Iv+HjiDDVV+C01xSxXf
 gQ9tUgRDeHDt3pPnDSn4fCUWA2+shkEpAaoAEjlgD2PV3b1Dmg6LMFtPxIeXvW6M
 A/JnpGsM/VyVTBZpndW1Ywz7Mz+z3hZbCK7OT07EqCvPwMWDqnA1P9ebohlQs4y7
 MuwZhtm6hCH0ynfTb086Y7xgTm5Q8L5AfFBQktDrQxpGYGRr+kFOYNzvgEUIOXq8
 Ms+ApJSWIArBrg4DPa8ktU2NA1bO8LlO0/7+A15/N9bpGlJFtcCcDUxzhiWVTzlw
 I7C7More6lfplXpTZ0eWzr7fb082UYPD/9kzqsa328qXys/+wLsaVW421QmX4Ms4
 90rVlNhKeOfOqlvFRzVOel5LZ4VpayGWy2ZKuj9xGfuq4Pt9Z4bn1DgqNOvA+zeP
 Co17koDPvwMOkxgI2jk5x1HiovVZP/WUkZUy/y/hT3KRPG5pNHKEJUtV+JG/dZuh
 G93XamIpc/CtQTLfuiAVw5RQZ7N2yjsx2QBgfRDNaGAC

Changes since v1:
 - Remove redundant uptodate check in __bh_read(), use
   bh_uptodate_or_lock() in bh_read() and bh_read_nowait().
 - Improve the lock order in __bh_read_batch().
 - Add return value 1 to bh_read(), indicate the buffer has been
   already uptodate and no need to submit read IO, ext2 code in patch
   13 need to know this case.
 - Remove bh_read_locked() helper.
 - Exchange the parameter sequence of bhs[] array and it's number in
   bh_read[*]_batch() helpers.

v1: https://lore.kernel.org/linux-fsdevel/20220831072111.3569680-1-yi.zhang@huawei.com/T/#t

Thanks,
Yi.

ll_rw_block() will skip locked buffer before submitting IO, it assumes
that locked buffer means it is under IO. This assumption is not always
true because we cannot guarantee every buffer lock path would submit
IO. After commit 88dbcbb3a484 ("blkdev: avoid migration stalls for
blkdev pages"), buffer_migrate_folio_norefs() becomes one exceptional
case, and there may be others. So ll_rw_block() is not safe on the sync
read path, we could get false positive EIO return value when filesystem
reading metadata. It seems that it could be only used on the readahead
path.

Unfortunately, many filesystem misuse the ll_rw_block() on the sync read
path. This patch set just remove ll_rw_block() and add new friendly
helpers, which could prevent false positive EIO on the read metadata
path. Thanks for the suggestion from Jan, the original discussion is at
[1].

 patch 1: remove unused helpers in fs/buffer.c
 patch 2: add new bh_read_[*] helpers
 patch 3-11: remove all ll_rw_block() calls in filesystems
 patch 12-14: do some leftover cleanups.

[1]. https://lore.kernel.org/linux-mm/20220825080146.2021641-1-chengzhihao1@huawei.com/

Zhang Yi (14):
  fs/buffer: remove __breadahead_gfp()
  fs/buffer: add some new buffer read helpers
  fs/buffer: replace ll_rw_block()
  gfs2: replace ll_rw_block()
  isofs: replace ll_rw_block()
  jbd2: replace ll_rw_block()
  ntfs3: replace ll_rw_block()
  ocfs2: replace ll_rw_block()
  reiserfs: replace ll_rw_block()
  udf: replace ll_rw_block()
  ufs: replace ll_rw_block()
  fs/buffer: remove ll_rw_block() helper
  ext2: replace bh_submit_read() helper with bh_read_locked()
  fs/buffer: remove bh_submit_read() helper

 fs/buffer.c                 | 154 +++++++++++++++---------------------
 fs/ext2/balloc.c            |   7 +-
 fs/gfs2/meta_io.c           |   7 +-
 fs/gfs2/quota.c             |   8 +-
 fs/isofs/compress.c         |   2 +-
 fs/jbd2/journal.c           |  15 ++--
 fs/jbd2/recovery.c          |  16 ++--
 fs/ntfs3/inode.c            |   7 +-
 fs/ocfs2/aops.c             |   2 +-
 fs/ocfs2/super.c            |   4 +-
 fs/reiserfs/journal.c       |  11 +--
 fs/reiserfs/stree.c         |   4 +-
 fs/reiserfs/super.c         |   4 +-
 fs/udf/dir.c                |   2 +-
 fs/udf/directory.c          |   2 +-
 fs/udf/inode.c              |   8 +-
 fs/ufs/balloc.c             |  12 +--
 include/linux/buffer_head.h |  48 ++++++++---
 18 files changed, 146 insertions(+), 167 deletions(-)

-- 
2.31.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
