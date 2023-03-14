Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D354C6FD1C
	for <ocfs2-devel@archiver.kernel.org>; Tue, 14 Mar 2023 14:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nwQ5QgpJdeyaWBn589KxkE3bCiABrQ+3C3fVvSnPuCY=;
 b=kkovQ596/NvG7rzmyRcqCh9uKc93qJZwgT49HqAKZtVcwLM2F/dBaMm3/YpPLvCyeLYC35+fGEC1
   T4vLPFczM5crJjKwntYX8iurL01Bpemnpn5g80FbD2PdBo6L9HFFrKuKhHRFz1ljILREoQ+2SdZv
   pst7wY68SRuTa/yVNmlcIaNtDAw8Fx8389DRjwq485X1C3OMUhdi+f/EsQ1YjY6IjeNlRJM8wFdJ
   rhyyvmn229PrWVY5qLcbLtV1sZZCrYep6JVoEF+MA8rGTltHcMRxvasdRXX/QInk4HEl1fEy+x1m
   71QsilqtTUqThCh8GaHrO2FCq321QxotbGVw5Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nwQ5QgpJdeyaWBn589KxkE3bCiABrQ+3C3fVvSnPuCY=;
 b=o32sPPaCSB8RXOp+j6iaiFfOcRTBq1P7fw0Xw0Uu65IsDKjKTGeo4EF7jvPbFbfPqkHY4ejrae45
   LuNVaqgjh0343sVH0qHPCQ85qzxFFT/h7Wy0CX6EY1tFAAh7xn++/dBN9eOS5K/peBED9bRwrIq8
   3BRt3D6yEr9BGA81YQQBV+IPhfX6jCiOYWFcSE6FPDNr6D6n0K2OOjozlJcM1hUCrl96Sypts+Tv
   bz8M7nl36ENKhd5SFgwXThpBRRaO7ad9UFvorRd7im4OyuZhd1Y7vjxb27pyvD8J4OYNTa9YHhrh
   y8x/9GNFwaXKRF3o8EqkD0z6iLBEIVZR+mC7AA==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRI005W9MM20VE0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 14 Mar 2023 14:51:38 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
 Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:In-Reply-To:References;
 bh=H1QGXFGueBuHBkdVnY1gVNgWxdg/uqRKaISs/k4X5k8=; b=S7EeSUpGaZlBdHu4WUHAIdr25V
 ixFY7YsdAbe5O4aABq5JSzhjm6AQQEt3eXVPOFTCWjSNtDCgQFZErMmKupnpF9Y/4skbRxraN6HkX
 TqmDE1TcO5R6zBSPSKRc5doATbZgmLE4SGmmnROLttR98UmmdtbKjQjHzeTUwv1E1p/bjEoFFy+iH
 nyqmOOJUi5ry9SunSrF7pQBYspmk5uLVQJF6SmWk5LWJAeaLgy3Zr7wr5xxwd+hQMMwpvWD+yVxuy
 /CaVhXopsc+90LrYwApR0yOX/0l4LaCriYpzBh1LHFmzupT2UryDjtJai0v3ndjSU6zPsYceoZ+bh
 bp/MSRHg==;
Date: Tue, 14 Mar 2023 14:51:03 +0000
To: linux-fsdevel@vger.kernel.org
Message-id: <ZBCJ11qT8AWGA9y8@casper.infradead.org>
MIME-version: 1.0
Content-disposition: inline
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10649
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=39 suspectscore=0
 adultscore=0 spamscore=39 impostorscore=0 lowpriorityscore=0 mlxscore=39
 bulkscore=0 priorityscore=128 clxscore=82 malwarescore=0 mlxlogscore=20
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303140125
Cc: linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org,
 Evgeniy Dushistov <dushistov@mail.ru>, linux-ntfs-dev@lists.sourceforge.net,
 ntfs3@lists.linux.dev, reiserfs-devel@vger.kernel.org, linux-mm@kvack.org,
 devel@lists.orangefs.org, ceph-devel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] RFC: Filesystem metadata in HIGHMEM
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
From: Matthew Wilcox via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Matthew Wilcox <willy@infradead.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: casper.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 7o8Wd4pDd2EUCl-c7clrsrQHqBkbpuKR
X-Proofpoint-GUID: 7o8Wd4pDd2EUCl-c7clrsrQHqBkbpuKR
Reporting-Meta:
 AAGymKwiQXq6K+FzA12Ffiit1BSFxtyLsCf3j5oRSpn8yXqBOxOGajrRoDqO1ojs
 eZiBvndRZwCYZkxDlXsK6kexTC5xQ7bIfN96hdOE1IjVvFN2PsO0tz9/9LDC1DbQ
 2oBo5kD/OMkqRAt4K4jgWCcps/9TPRHV88wZSGiRzDid/5U6KhVc6+INqqrnua53
 bt70djcRvMaNKz2TmYE7Xs4nlhXcnf7HjiUwwFN9rGqi280dPirCCSs1sMo8Log9
 0POQfSDPHviVYFSEz7skOEO820NEoISSLxx1qVBL/iJavC3JLcOjl2MpO9vbtw/0
 6YFPNSakmhYhIJg/TxTy29SUqu2iLbYsbT1K/rQrGfG1uUT97SrQZZ5JDQOVcxx3
 KsYHXRNtxiTyGMs/ZtH+IMIrlMdWeppnaPCgOgKPNtJq5DDQg5Lp1xNU+1KIFi9q
 8iCYBpffDQK6JK1P/jQwncvxsYdAVLM7XGaEbfYqlBa1TGyhzWolaYFIOxC89xqN
 kKa6NMESylgA68H2qrRYGw8YRwyy9ppwI29UFAF1/7x0

TLDR: I think we should rip out support for fs metadata in highmem

We want to support filesystems on devices with LBA size > PAGE_SIZE.
That's subtly different and slightly harder than fsblk size > PAGE_SIZE.
We can use large folios to read the blocks into, but reading/writing
the data in those folios is harder if it's in highmem.  The kmap family
of functions can only map a single page at a time (and changing that
is hard).  We could vmap, but that's slow and can't be used from atomic
context.  Working a single page at a time can be tricky (eg consider an
ext2 directory entry that spans a page boundary).

Many filesystems do not support having their metadata in highmem.
ext4 doesn't.  xfs doesn't.  f2fs doesn't.  afs, ceph, ext2, hfs,
minix, nfs, nilfs2, ntfs, ntfs3, ocfs2, orangefs, qnx6, reiserfs, sysv
and ufs do.

Originally, ext2 directories in the page cache were done by Al Viro
in 2001.  At that time, the important use-case was machines with tens of
gigabytes of highmem and ~800MB of lowmem.  Since then, the x86 systems
have gone to 64-bit and the only real uses for highmem are cheap systems
with ~8GB of memory total and 2-4GB of lowmem.  These systems really
don't need to keep directories in highmem; using highmem for file &
anon memory is enough to keep the system in balance.

So let's just rip out the ability to keep directories (and other fs
metadata) in highmem.  Many filesystems already don't support this,
and it makes supporting LBA size > PAGE_SIZE hard.

I'll turn this into an LSFMM topic if we don't reach resolution on the
mailing list, but I'm optimistic that everybody will just agree with
me ;-)

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
