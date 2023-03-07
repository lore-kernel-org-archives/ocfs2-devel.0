Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D00ECC6FD1A
	for <ocfs2-devel@archiver.kernel.org>; Tue,  7 Mar 2023 14:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=gVTe9tVmvgjW1wid+WejfmK/rFB+9KjvSgitKTocMEA=;
 b=LoZ1pVGDFXc4wZpjSGUmTEfMBFji2HKLTjg47u2/NEZSP30CRqzaNxVYpU8hm4+K68G3Ka39U2rJ
   +d3dh06dn3xpPeJKrLryohJorbSQmAeTYgH3iXBoIIINCsPqd9NRkr2Ju5WoP/9CklubHNTSIHeH
   FL+g+gHqbFofzJ0Ju1IHbre/Dtgn4eWGuwFHtgTUBw5Rutx7nveUzfXkZRJ0nEyJ7+m4gDvRgqEj
   FNUW1MPuE5GTxeFkfDpIiWALsgwgVv/DBMNFBENOgvFfharWKCu/iuH3pWw9Gh7MF2naT4lsc1db
   JFPEFrLv9VmuT8MzFCRItUrBy4s9qjEmEYvoxA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=gVTe9tVmvgjW1wid+WejfmK/rFB+9KjvSgitKTocMEA=;
 b=KeZDRX/GYNkzEAg7Z7x9YfNGeMZboPWq/O35Hdof9E62tQL6l5R5EZnsPOyLS3ktalAoMEee891C
   F7q18lVu9JPJNv0prGWU1HE3VIZipiXb7KENkhPCn1vvNr6ceI4r0pPEwrC2lPr8o7cmCMpZeJcW
   CyJuoKXa+pZHV2crK/15u4qzpqHva4qcmsxYLMPdqzVFSjb/0/iu984Cj4Zx0Yo/O6xenUl2MVci
   ko+A521GDzSFpYiWZeBX7iX1ZleF0J0VyZEBcbGqs3R0NIZXlKFzqbkb0IHzHyQbiwxG9gTfzEnK
   pbpdBcIYyORtjr2qX2td6Pn8YrRirxJKym00fQ==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RR500J09N1G2820@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 07 Mar 2023 14:32:04 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
 Content-ID:Content-Description:In-Reply-To:References;
 bh=41mhvkvrB0bBLLIOVbvwz5VT/I9ahbHz7mM/x4DoM28=; b=odY1pi/+EX0cHJBBQe7YoH4I2F
 49XnfZCvIJsvOdiuUGfrq+ZvUOhR7f9Ac6loLD7FC04i1U4tE534aVQhEzW46zQyIEFTI/cSp92ZI
 LPd06bNDi/GTnQ7OhQ+ppUKkP6jGjVtqeVyl5q/e58f+RxWQQQh7UY+Q7zRMzXT5vjRxzK5SdsHn2
 U7WrCyk1oSA3RWSdMuWUQvEfnF6MsBipuBQiqKZ/04MlxlQW+d+6ALNZZ4W/BlxaKDWT7GUQ5sYUh
 El3BHy7BFFf/GFns+JybtmEb4NjUGjeBn74i1ZsyKir6UTVz7+O7LaGEavPgv/5WZbQ/H2U55LKYL
 OjX2AzUg==;
To: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Tue,  7 Mar 2023 15:31:22 +0100
Message-id: <20230307143125.27778-1-hch@lst.de>
X-Mailer: git-send-email 2.39.1
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10642
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=288 malwarescore=0 priorityscore=0
 clxscore=174 mlxscore=0 impostorscore=0 spamscore=0 suspectscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303070130
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] remove most callers of write_one_page v4
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
X-Proofpoint-GUID: N3Ku9fEtIhffANf-tapt09SntRyHmu3L
X-Proofpoint-ORIG-GUID: N3Ku9fEtIhffANf-tapt09SntRyHmu3L
Reporting-Meta:
 AAFg+p+TNnY1+vjZCRGnvZ8Dt94KniKjYg59kUfbyA1BoMkWIJZeTfP70AGPBuBj
 iuD6Jr4En5VrwHPOPpoO0Cri16FGJ/fZ3gFoBv5xHWKE7+u1+Ygim7Us1wqsb01N
 lYCCVQppuNLbqPK+pqkuxcL7JoMx+rKjDqNDJsUFIb09eYJK2KYRooNZAhlaXdWd
 issCVCKtHIFkeOQ3RB8EF98Dl/mP5gLcKd757lUFObw+FxwLvPPItFUBGvrQrOGq
 P/nwTmzmKOmy8cEsqWbt6cW9wCfgrjthn5LiJy6gJEc/RcVOcKykwRM2LnxxSKAO
 siWV8koN+eQ+jEP/vaMXePOYO4e0JIFyJX7mrgGsF+z+VmeDSS50kIeSwyHPl8e7
 +xg93EDyrNtdwoPmANmaNf7OXeGzV2V3Ot5Q3GQYUivHImyFOwE0PFu5oK8KYmM9
 /jJZhUL+uMLq5BTk3EVR1S0Ji+XPxKALv0EUxIRJL9oeGxtPY+cxatB8c8RyHrnR
 SzhIjwqE9xUjmbgj75jPh2I1fsROIqMWy5VUL8ejDCF9

Hi all,

this series removes most users of the write_one_page API.  These helpers
internally call ->writepage which we are gradually removing from the
kernel.

Changes since v3:
 - drop all patches merged in v6.3-rc1
 - re-add the jfs patch

Changes since v2:
 - more minix error handling fixes

Changes since v1:
 - drop the btrfs changes (queue up in the btrfs tree)
 - drop the finaly move to jfs (can't be done without the btrfs patches)
 - fix the existing minix code to properly propagate errors

Diffstat:
 fs/jfs/jfs_metapage.c   |   39 ++++++++++++++++++++++++++++++++++-----
 fs/ocfs2/refcounttree.c |    9 +++++----
 fs/ufs/dir.c            |   29 +++++++++++++++++++----------
 include/linux/pagemap.h |    6 ------
 mm/page-writeback.c     |   40 ----------------------------------------
 5 files changed, 58 insertions(+), 65 deletions(-)

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
