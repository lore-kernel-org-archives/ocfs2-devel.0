Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70D1FC3DA79
	for <ocfs2-devel@archiver.kernel.org>; Thu, 29 Dec 2022 16:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=6ZNc4z7M7dM/wDzZd9AMQhLTSYEuVatI5SKI0qtttUg=;
 b=nTQIQfiGolyVanFRO3oIi6vetN75z3du6pkOBTlKhjtoiYfwavM2xgYDjrxirIRKTB82yJad5cfe
   hubgnc080mBoANv6ePUvt0o47c5mqtxnu1KNGJEjUMVrvfti9CxO4zpa6CAQe0mjA1jVrRxRFKLc
   vc1vTknKfT28RjKYEOCpXrpCurVdsTsldG5cfZuit9BUSzDmiai6i1aZNEQB1dJyZnu0Pbj6zL0h
   BWYUnHLveHsbYQdy3LC4FnEt03RjHg2kmG/yNFSOOpOQvHudDay3fbc3OBt8IaTGyYilbsixfaQv
   r91JRjJTjawiQwYiuSAOitkHM4Bw1hRMo4Y1fA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=6ZNc4z7M7dM/wDzZd9AMQhLTSYEuVatI5SKI0qtttUg=;
 b=dwQ2nxVJT9JdtJEpWjLeUG0LJJ8hnB6Q+NdjmuVTlILcAxe9Yhk/jMYy+5Es+CeblFfYiSPefjGs
   jXHCsEVS0+ss2qbE43YGGc6c2WEW115GtwQmk3HEVbxg+D2GdGRD2T5iFm0RuyG/9pC3B8t6IG5o
   iKgwiiqm+/z9WskVD2cyKCfKO4fJwMjDJuIphfhsFjgTNWD/x2w8ai2uNz60EnC8gE7x2WGbyor4
   oPPlojqPSW/d9l7TlNXTuEfTnyARP3ZYyR3Cxbf0CnspxLVvqLSH4WpNBd47LHkXpWaWnAj0EQ/t
   6uZazWmlO1smFejQZdjkqiuu2oul6+LEwHF/bg==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RNN009LXUASDK80@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 29 Dec 2022 16:11:16 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=fEUbsjBI9KXdP6pghJ78AVl7+BFXIZGKll0p9tWCLUk=; b=t1S2jL2DHoW16PA0jk/pbHQHDg
 RBs4GhrpF9YeRdVoZ5tq9A1aPdJeOjq91lfo7o5iKcunokcstvPbjfOb5C1qHOTZBoAGzMEgZ25d9
 C5o7gFDbOXlZVoosJgILi0a9I3LR4lGcXGGPpDxMY8Z08Fs+hik9wVwCAUkCmR2OV7rxGJJyr2hjp
 Zv4kGbTY2mD5jY+OJ8lwVOyAR4ZX1bDl+ikdrDdlU07hOw7f3AsQUBG1SNmOv77SPXjK1JIImv2No
 Dbh0w8jo37mco9XgGK5mLl24utTvSDtaTj3J5LiN5/5CGoVanfP2Q7XBUN+yCvVYGXOsn3vy9A0Al
 FxMX+glA==;
To: Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>,
 Jan Kara <jack@suse.com>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Thu, 29 Dec 2022 06:10:26 -1000
Message-id: <20221229161031.391878-2-hch@lst.de>
X-Mailer: git-send-email 2.35.1
In-reply-to: <20221229161031.391878-1-hch@lst.de>
References: <20221229161031.391878-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10575
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 adultscore=0 impostorscore=0 suspectscore=0 priorityscore=0 mlxscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 clxscore=315 phishscore=0
 mlxlogscore=289 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212290133
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, ntfs3@lists.linux.dev
Subject: [Ocfs2-devel] [PATCH 1/6] fs: remove an outdated comment on
	mpage_writepages
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
X-Proofpoint-GUID: NhaY5xrLI-_jUlckeuh7phIjpJA16Zdg
X-Proofpoint-ORIG-GUID: NhaY5xrLI-_jUlckeuh7phIjpJA16Zdg
Reporting-Meta:
 AAHyZQiea64e4PycuiHj5RiewnH3ccbqCIQt7WLyENpfrmnPNsvwcRaLyi+8Tu2C
 ERJxHT16gw2edOkE3yB344PJeIbQEa6YYJRnfbvUX1tL9VZlMEvCMqHK9cMFrdGg
 unVuBo414n2rG+trFlTb6aKEz/7DgwzUWrE11HWNgOez228Mjz4LdL/whhUp3lLz
 keOXCecd8bWcLlsSVaDlN1eibLeKE8nSzA4F+oBhIBdm9oYIpzblLkst8gHeseWu
 DsFHux28DDH7Opc6rpYC9OhcGl5JoJbHmayvJH3+gfPPN4Z5XWs9NmEzblkqc9HF
 uPiOO1n5HVlQLVUlNQls0rsxaJU2fx7koogr5xpdesV0+En956/CPmqotGCq0FSM
 oxOHHiTODWzbwOcgx0BpBqdSxD1jvJzr2lO9T6D56wouVt0OXVLB+pSvdvG/9cEN
 zTza5sIggTuAl/XQq8eLZcNZw3bsoiJNBZawmiZDIZQlK+dTz0let7Cmsc8l+HXM
 uHJjl+NuMecZtJNzPyaXkUsShLyw8YMNziUtvHeP1A==

mpage_writepages doesn't do any of the page locking itself, so remove
and outdated comment on the locking pattern there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/mpage.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/mpage.c b/fs/mpage.c
index 0f8ae954a57903..910cfe8a60d2e4 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -641,14 +641,6 @@ static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
  *
  * This is a library function, which implements the writepages()
  * address_space_operation.
- *
- * If a page is already under I/O, generic_writepages() skips it, even
- * if it's dirty.  This is desirable behaviour for memory-cleaning writeback,
- * but it is INCORRECT for data-integrity system calls such as fsync().  fsync()
- * and msync() need to guarantee that all the data which was dirty at the time
- * the call was made get new I/O started against them.  If wbc->sync_mode is
- * WB_SYNC_ALL then we were called for data integrity and we must wait for
- * existing IO to complete.
  */
 int
 mpage_writepages(struct address_space *mapping,
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
