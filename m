Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC199C4167B
	for <ocfs2-devel@archiver.kernel.org>; Thu, 29 Dec 2022 16:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Szyz+BkXwpCLRWVaGJfxQ1/RUXgam+ew7CE6W7n12bk=;
 b=ok3iueMDclHD+qMuo1WBaa37m39gptgVhemVhQv8/nCJHIgpZM+eIxM91uGRvzMHOEWGjf3xpW1m
   52W3eIFoYtiAkT+y1VX3GT0aFbnuruMyPxyeSFz1DOc9nGm25BSi8ojtrwv3q5Wic7v3UDVXJ+1M
   So7sVX0LmkCG6YKo2wSuyUR2ufqz/77oWtOp3T5JWvVjxaUKnb9y15cggEMs/NgY54DuY8scpalY
   LMsiA09qIgnt0kB9bg4xvFAJZIe0orJHotHMSkUSxyloV+gcp+6NgKWYIvBEMYZPvoZAx6gyJ++r
   335oJuRav+Bc5xOCrPo661OjCcVUv+fmTTBj+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Szyz+BkXwpCLRWVaGJfxQ1/RUXgam+ew7CE6W7n12bk=;
 b=E96ubZYKq6Bpy4bkRMn7UkJ073NLKqf1RjaOjxb/vvZuMP26usRq/ob83V2vTSGAKHAYDQudDK2h
   LX7O20+putEXwOlI4vACjr8RRtI2aXScL3k508RINjVPC5ZnzG/p+d6J0+AmlYqwxU3VpyDpiqBy
   ihrJTdwfS78Ix5aaHqBWvnhrDE6+PUkEyI+cud/pasls6UPh0NijZtnF3dtDn7rOpJZmC23fVZQT
   /NtEXdXXMrKuqk2WI22cl80xpb3SjpE5aYkR8SINgzU5zWYet8CjK5YiwGhvorQikxrjtAEWz6CY
   +ub4JXEiZmXhlpNer0qsEUGosZCOaYqhbJ8OGw==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RNN009GFUATRCA0@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 29 Dec 2022 16:11:17 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
 Content-ID:Content-Description:In-Reply-To:References;
 bh=rRMjyybI4BLGnpomTYi5lWNLUT7Kcy+Hv5Mat8aX7RQ=; b=30PC0fVD2644K3q35Oc0cw5f1v
 LTpWsGmTAvtWdovsneRivRCLXQqwtM1G/u5qMZ5ReUGiW2Bqqbmpak/j5/zXkmZE70FB7O3OIzsPw
 bnM+fLK7J9EoU3zXk5qFE5qD0b4FftkAYzJbSDH8SyjZzLfSLu8MinxJO6b5m0Y3eHuy0fPDRKsdz
 MQ1tnejaevDS0o1+/tm8Uhlrx2xgd6/YjnsvkyvwBiI/b/8osn+I7sutWA8g4koNVqcjSQY1ulCGe
 7bYVL4pD9JBD2CGWxGIZ0qwEV/fMEKKx0GrCUmjV5QQYg2eju3SaZHsWOZq67PuuaYSXwL7trb+2q
 bCFKXNtQ==;
To: Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>,
 Jan Kara <jack@suse.com>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Thu, 29 Dec 2022 06:10:25 -1000
Message-id: <20221229161031.391878-1-hch@lst.de>
X-Mailer: git-send-email 2.35.1
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10575
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 clxscore=256 priorityscore=1501 mlxlogscore=355 suspectscore=0 impostorscore=0
 spamscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212290134
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, ntfs3@lists.linux.dev
Subject: [Ocfs2-devel] remove generic_writepages
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
X-Proofpoint-ORIG-GUID: P-HkG2hcCbc6KAfOAjDtlvvCLaKzcQk0
X-Proofpoint-GUID: P-HkG2hcCbc6KAfOAjDtlvvCLaKzcQk0
Reporting-Meta:
 AAEq7225Co5b9lUCrWsoZfZ/AuYC2bCK+0sGMbDM1uZ2E8xtG9YU4gjG55RLSmkz
 pQd4XwodVnWuIS5nfb0mStBWqWkqbMnvlk5B+IAnfMz8l7eQhFLbkozKwXrOF9OW
 B9MivgvOmxQeDuatukoku/9nsIBDOPqoJH5P1y4xHTyacP4G3XLuR37fkGr8PObV
 SMro5fj+X2CgxxJidYPifzOjgaR4mbiQor/eYdNa+vRDVIQzapPHYgWMarhM7RDW
 3cmst4K6PSLqesJuI3SfO9/TuyQny650a8iu020IIgILhSis+jeKUbxBCiNRZqDU
 lPqFHZ9kk1BGbXoFhm1g17HeQjzhxABdujq+zLVt5nkl9o5WnzL599R1EWBqZKBB
 BG39UQj3D6ykre9H7IHGDQ2Rv3uHK4LRKV+cDnckrF1COQhCG4N1PNQtqDWPKdkO
 2virhp0fgdUi9HkJI6P1nVfJzOfNH6GU9fZmQJCo5nx1uxDGc15T4Ow8+ZeSci0K
 OcEruF1s2BToT0vRXOKsNfa0ZRhcnrPqy1JtK/oI5Q==

Hi all,

this series removes generic_writepages by open coding the current
functionality in the three remaining callers.  Besides removing some
code the main benefit is that one of the few remaining ->writepage
callers from outside the core page cache code go away.

Note that testing has been a bit limited - ntfs3 does not seem to
be supported by xfstests at all, and xfstests on ocfs2 is a complete
shit show even for the base line.

Diffstat:
 fs/jbd2/commit.c          |   25 ---------------------
 fs/jbd2/journal.c         |    1 
 fs/mpage.c                |    8 ------
 fs/ntfs3/inode.c          |   33 +++++++++++++---------------
 fs/ocfs2/journal.c        |   16 +++++++++++++
 include/linux/jbd2.h      |    2 -
 include/linux/writeback.h |    2 -
 mm/page-writeback.c       |   53 +++++++++++++---------------------------------
 8 files changed, 45 insertions(+), 95 deletions(-)

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
