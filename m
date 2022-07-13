Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04747C43334
	for <ocfs2-devel@archiver.kernel.org>; Wed, 13 Jul 2022 11:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=MPVEb7K8h5TywANVjitXcF7I2MyOb4ftTgnccMb5JV8=;
 b=ttoSu1LB42X5vJZc8gxXjEZ0lXzhedhOrZTJdG/tpybZeKjxrLS540IJhnlSD6CcKMpLpH4MpTSF
   mvPkwxAa2u83AhabwVetmSyOnvZiHtKuqnb2yPjPFpsJSD35EOH0tRwLpe2WL+Gb7XRmgg0gLHtx
   8Qra8051ZNSCk/vecIP7SWA8DRlSfZdmFifZi3KIbw9N7Q5bvCLMyTjIzQLBCi558dwdXMPrx/V0
   qqs4UpZwpb+SjVSUGO1OGIWjD+VFb0283ktN76gksfsilzTdE5wEY6cFleAMQMq7eOUGehXVcIPc
   nuOs0l2h2V89knwhbNN3P2pNsPk8zboTnLK5DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=MPVEb7K8h5TywANVjitXcF7I2MyOb4ftTgnccMb5JV8=;
 b=keR9/7H1neYc3rWZ1fjCm3rXSdoBT8xA7EUfwv5MZkDa+pyNgAeTcUml2XLwgqdFq6SDt7jrMj09
   a6JKKPEgH1kvq6IJalmlzILnNYH966+Ijdi1eQ2tD85Y5MxIG6r+4RhWT5PelwfLyR6J195FSvaj
   3BFgGQKBVcdDTdZL2zekIVvRjQukB+LSMxFRZrB+lonmypdb+cbSwcNyqjr/Exg76KG/+Ish4Pvt
   23FQIEYTKC3vDcV6zTu08li0xvKu4oiXEi3X8M5U2KENLkjDopjfARnrjif+1fEmZhtlEN3kxRoV
   IWXPYyVpWGewblly0kcwe3J3nOsDASZROxzMAw==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220603 64bit (built Jun  3
 2022))
 with ESMTPS id <0REY00JD4HC34SB0@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 13 Jul 2022 11:02:27 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
 Content-ID:Content-Description:In-Reply-To:References;
 bh=KrpjvwUcHbQf2YuRp2OWaODTDZci6DgQG3eP4OSBmUI=; b=YRBK/+Qzhe+1221YOQ4iqzLn/5
 4Vwf1PyNclwthcoNXZ8KOoB+GAm/JBggQtmauR03xvzEJ6HJrky94ioJYu/id13gc3E8Vp3eEjaPZ
 4/U7tIzjiBG7yOAf5AudMpRTfWM/glZnmH0Q5KsdHn9yGpUBaGPrRgAqZ84jMYIXbbDNEzhIhaeXE
 HPqbGv7ZwbHz+9nAFWGg1NsiY6L75v7smtXveUpmZ+cLceuQWo6JUhgy4Vj3ymFqb/j70IVLdScfi
 nMcJLQNaBI3D7FKAwYGd4Ir2YoBbRsfjJA6+RJnMFwO2T37jlyn5qeZ+yBeFjFD20xwQM/46VSp4+
 +bC9PZdw==;
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 13 Jul 2022 07:53:08 +0200
Message-id: <20220713055317.1888500-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10406
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxlogscore=505 spamscore=0 phishscore=0 adultscore=0 malwarescore=0
 clxscore=295 priorityscore=0 mlxscore=0 bulkscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207130023
Cc: linux-block@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
 Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
 =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
 "Md. Haris Iqbal" <haris.iqbal@ionos.com>, linux-ext4@vger.kernel.org,
 Jack Wang <jinpu.wang@ionos.com>, ocfs2-devel@oss.oracle.com,
 drbd-dev@lists.linbit.com
Subject: [Ocfs2-devel] remove bdevname
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
X-Proofpoint-GUID: aXXBvo2HPw2Fv_dFnPdDLWyZX6Ppw0jh
X-Proofpoint-ORIG-GUID: aXXBvo2HPw2Fv_dFnPdDLWyZX6Ppw0jh
Reporting-Meta:
 AAFSUxiObS6g5VnzfhDeQ/Z6XVJulv+2q1i5iWn/roOpvgehYRWUbd46307KouAe
 32iGLqaNAqxnaCWgtnb9MsXzINeN9dCvfMrwXgoGKjSY8U9/uxCZCdfebMLTM5vu
 lV2c4WWx+nRefAV6m74ansGGzahiGxLRZ7BMptHBTEvXZaXzkR4JV7PIRP5AWYwY
 Cg0PDkYmsQrAmiqBM48K8Ytys2rLQqk2Yal3z1XhTBoljclvNfjct1+lYycwATQM
 Revklk7G3+PtUXRO0/oaWXsUJYVSqJLmRu6ye2X6Y/+RYPQjzwHUPhlkWBrochQQ
 yvl3x2hc5ACyPfiPDOZg/CtEiZk4exPvCjcpYF5C8jY6JC/6kb/UffOFOwBO1IaU
 LaJNA23t0JKft82mkYANfmezCWuHicoOwGZqZ7WXu9NWcHjhQyWZxFlPruhauriH
 gk70GtNvF1qjWlW0Qp0DgjeEr8fRth0Q+bbVWLo3zWVgfMGEl4CXrgYbxNVTA5G3
 sQhyAcmMP6Nk9IiGnXIx1mj5I2/BANMn8qeCpszlHVs=

Hi Jens,

this series removes the final uses and the implementation of the bdevname()
function.

Diffstat:
 block/bdev.c                        |   10 ++---
 block/blk-lib.c                     |    6 +--
 block/genhd.c                       |   23 ------------
 drivers/block/drbd/drbd_req.c       |    6 +--
 drivers/block/pktcdvd.c             |   10 +----
 drivers/block/rnbd/rnbd-srv-dev.c   |    1 
 drivers/block/rnbd/rnbd-srv-dev.h   |    1 
 drivers/block/rnbd/rnbd-srv-sysfs.c |    5 +-
 drivers/block/rnbd/rnbd-srv.c       |    9 ++---
 drivers/block/rnbd/rnbd-srv.h       |    3 -
 drivers/md/md.c                     |    2 -
 drivers/md/raid1.c                  |    2 -
 drivers/md/raid10.c                 |    2 -
 fs/ext4/mmp.c                       |    9 ++---
 fs/jbd2/journal.c                   |    6 ++-
 fs/ocfs2/cluster/heartbeat.c        |   64 ++++++++++++++++--------------------
 include/linux/blkdev.h              |    1 
 kernel/trace/blktrace.c             |    4 +-
 18 files changed, 62 insertions(+), 102 deletions(-)

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
