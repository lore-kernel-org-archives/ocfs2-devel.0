Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABC24C46467
	for <ocfs2-devel@archiver.kernel.org>; Wed, 11 Jan 2023 04:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ONrAI05Ge8D8xKMFhMwi96DXe89gxlbshJ49M2mHMvQ=;
 b=neIlV8kB2CorrXLjKP3KrX5UymAkG+x1XRszRlu/kAEvfdO1Teci7dUg06VkvQB00JnhwmMM7y9z
   mA+Xkyuw/zc+vnrEyDJGlr/t0Eu7BJ4ErBv7JPT69QuC9oDliP1LFqT238xr55fEOle0btD5337E
   +8GrJlQmg/dGtLDIDetQq0nou187x53/bC+NkRRDsy8PNqUdDI/3BT0LN1SHnpwWfkRsZR+CexXu
   5TV2vou8nUi2EA8oSbgkj0DxNLRF9Thj9vxz9kARXMunQUWBdQGC1bBkCwRI2QBDU01MYJQ9CDrn
   bG3FiT/6YEp75NaO7qpWVWlMZopMBAhc8eX64g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ONrAI05Ge8D8xKMFhMwi96DXe89gxlbshJ49M2mHMvQ=;
 b=q6azHLxBv4eCpx7o/cptIOn4hQvau/cOFNbSs/EKzyhpRwVMlPK9ZgAb/bKcYPR5e+vDFbSHbift
   B969HnpfunJsskqSRlOl8apAK29GWGLU66M4Nl7f9GwhdmUHWfOG7UsOzv3GyXai5OqCv/c0aOTr
   UFw5TZ/8HVGkALdXc5ESq/8bZfEpWLsiGiWzBGWUrix9/w26k7s08J0pM8WdBvo2KRinQ8uYKLmB
   Z1CM1zmDgvR/z/7Ky0TNtj/NQXZamjiW01QF/CDmVJmO2KKL4077Ef2kAUV2ez1Y8mydK9yLQGI0
   eI/l5+0drXlciZzVnaRW+OQOQBGmKuIiuMAJiQ==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROB00B2H0D15XA0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 11 Jan 2023 04:27:01 +0000 (GMT)
Date: Wed, 11 Jan 2023 05:26:41 +0100
To: Al Viro <viro@zeniv.linux.org.uk>
Message-id: <20230111042641.GA15181@lst.de>
References: <20230108165645.381077-1-hch@lst.de>
 <20230108165645.381077-4-hch@lst.de> <Y7sy5jzjT7tpPX6Z@casper.infradead.org>
 <20230110082225.GB11947@lst.de> <Y74c+WSEajAic3Kh@ZenIV>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <Y74c+WSEajAic3Kh@ZenIV>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Source-IP: 213.95.11.211
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10586
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=498
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 spamscore=0 malwarescore=0
 priorityscore=0 impostorscore=0 bulkscore=0 clxscore=203 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301110033
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Evgeniy Dushistov <dushistov@mail.ru>, Josef Bacik <josef@toxicpanda.com>,
 linux-mm@kvack.org, Chris Mason <clm@fb.com>, ocfs2-devel@oss.oracle.com,
 David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 3/7] minix: don't flush page immediately for
 DIRSYNC directories
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
X-ServerName: verein.lst.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: 1XFC4HoPHDah65lzPovt1SfBnjlaeUs-
X-Proofpoint-ORIG-GUID: 1XFC4HoPHDah65lzPovt1SfBnjlaeUs-
Reporting-Meta:
 AAFtZ/0x27hGVrnzHEinBeiyFdmf0qDWupnMJ47iQ63Ji+FuSs0tANMKJPVJ7O7K
 eMUX8ehOcJ8L7nqxpkm4F06fRxbbRKA7rdaB/N+//yKRAjfdoqYVaXaj9mvzarwv
 4ShEIFPgd0hKvagRkawmwy+1BY9+IAQsJEOn3HllNNXowM+wvNKrM8hpiYLxy/Zu
 pxY8OrjTBwO1ZvoOXj4asbmMXr+hfSKFSRLSkNOzG9QWSwO6YR/5FaGZl6BwUyzq
 qaD58t17r0v6VPLhLN6x7S2eUCdYzGPoOVOB5kPyyxhnc3uUkFoiztsu9oHxPEEY
 D/HmdzmrDr8xLxA4uGnaHq0rzYmxPKmbQGycwYVvIVuZrVLKNzcX8hWiOTGP/saK
 PY0b3zaJy82UIIYT/lpKsjkbUj3EtbeBRi/FQFUaKJPLBBZhwSFhXsmwim2uIOR6
 CgZbOdZYvE91P3Cvvv1Be0d5vNEhTJjy/9KkxIEw8ViaBCUh2iJb5MBvZQ5Q1izp
 W0lEHVjmqw0QsPe1yoYPu4I9imuqJafgsY/43KmfVig=

On Wed, Jan 11, 2023 at 02:20:41AM +0000, Al Viro wrote:
> More seriously, all those ..._set_link() need to return an error and their
> callers (..._rename()) need to deal with failures.

That's actually what I did yesterday:

http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/remove-write_one_page

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
