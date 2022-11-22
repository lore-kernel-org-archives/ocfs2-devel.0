Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A976DC47088
	for <ocfs2-devel@archiver.kernel.org>; Sat, 26 Nov 2022 18:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=OVM7uLtr41/1d5kSoc++nrMY44KTVSHh4jkMUJ0NzRE=;
 b=bqmAfUWhCR6P+yzwfPeG/uKVtC0DSiPrrhWF+Z2g4I+6ptFK/4hqtSQz1bDn9p3LvndGTaHi0t6C
   imclFb5ofoc7t5cr2ex5JNfS6LhbRSmhgmJeteZTCyZLQ/q2RHr7+ZeoNj23vsgcKZ5MErcd9KeH
   P1ghdOVvoFWMuJ3J9sb+4EfMHaBRyIFtKs3iI4EpQCv4LSQv2IvlxJVLHW0Z13rH8HTnBPAf8czF
   yXaRNUNxRsP2rh9o6V9guh5rROGW7fF8jtjgMv4yw434irPLC8uu9RD1ClvnSu4vHwzdWSm4UAJj
   QDjErlEByKWii+FcETbC8srhehDerypMZBeRQg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=OVM7uLtr41/1d5kSoc++nrMY44KTVSHh4jkMUJ0NzRE=;
 b=rfWBLwrvbWqSrNsUhSVTsQQhB5T3yyk27kwFQw1ekjv0zsBinl+NcIjRc8GI2JIkLVFRmkNsN4d/
   r+TKVplVNpMF25n8R7srBeUkkEJvHSCtoVsA0Ri6Nhxr2vbGr2pE8KZLW5cIG3UQh8PXuY27Apah
   6iaJZuwlPOM2LR+myt5fzFGU+hKMYnbT9ZtLI1akue6OYgjstzxuPTpnIJ8QHeVokchhWK6n2S0U
   Fso4LsFGGVHXpIIp9ghMOMugotuOuIEa0Z6Uhl3yb0uFCo1IgfDiysMAZSh+Ehs7tI2rDeQaCLH/
   EYQ214dzwVIsMYKeRiRxyQVtB1piDxhCnAKRlQ==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLY000B2VYZLR90@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 26 Nov 2022 18:13:47 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=uiFDQ6s5XgAcT9HYz21ROzPo6ZCyN/YsiViP9JuL2Vc=; b=NJJwrm6IpzOJ+nUmhrd1OXfoCk
 G7FtSuALDx10w2NwiIqoKiG9ykgmyUGgqgtM+aJpa2oS2fQRQ+RCGSFLUVL1nV3H67iQsoM+ZXI+P
 75G75qOGTBUz2j3XL00qgcUTJotjzi0OfiKIf+ALXzMf3ZoQMf3KRnGWl+fsNnIUD5GBw7fYM0qpK
 68xmJhc99PpF71YEvdwSpdkfVDQQinCYdj6BfJplncqBsPQyicO+REFgABedNNQo6QpK9GD/KJOMG
 I2YH4RdEbuSk9AKSGChXb1wwhkouk4nfTA4WUiJD8aJEXUyng2vGvKiEnZPT7EPwwj7AX43JZiVeT
 eCgYCCfg==;
Date: Tue, 22 Nov 2022 03:44:19 +0000
To: Xiubo Li <xiubli@redhat.com>
Message-id: <Y3xFkyZykWp5/Rvq@casper.infradead.org>
References: <20221120210004.381842-1-jlayton@kernel.org>
 <6627384e-5514-048f-308e-57414d0c5b31@redhat.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <6627384e-5514-048f-308e-57414d0c5b31@redhat.com>
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10538
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 spamscore=0 priorityscore=194 phishscore=0 mlxlogscore=505 impostorscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 suspectscore=0 clxscore=147
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220024
Cc: Latchesar Ionkov <lucho@ionkov.net>,
 Martin Brandenburg <martin@omnibond.com>,
 Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 samba-technical@lists.samba.org, linux-xfs@vger.kernel.org,
 Mike Marshall <hubcap@omnibond.com>, linux-cifs@vger.kernel.org,
 Andreas Gruenbacher <agruenba@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
 linux-afs@lists.infradead.org, cluster-devel@redhat.com,
 Christine Caulfield <ccaulfie@redhat.com>,
 v9fs-developer@lists.sourceforge.net, Ilya Dryomov <idryomov@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>, devel@lists.orangefs.org,
 Shyam Prasad N <sprasad@microsoft.com>,
 Eric Van Hensbergen <ericvh@gmail.com>, Tom Talpey <tom@talpey.com>,
 linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 ceph-devel@vger.kernel.org, Trond Myklebust <trond.myklebust@hammerspace.com>,
 linux-nfs@vger.kernel.org, Paulo Alcantara <pc@cjr.nz>,
 Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org,
 Ronnie Sahlberg <lsahlber@redhat.com>, Steve French <sfrench@samba.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Chuck Lever <chuck.lever@oracle.com>, Anna Schumaker <anna@kernel.org>,
 Bob Peterson <rpeterso@redhat.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] filelock: move file locking definitions to
 separate header file
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
X-Proofpoint-GUID: iUNaNM6H6XDYlnB3_lMsCVj6y1RzCFMx
X-Proofpoint-ORIG-GUID: iUNaNM6H6XDYlnB3_lMsCVj6y1RzCFMx
X-Mailman-Approved-At: Sat, 26 Nov 2022 18:13:43 +0000
Reporting-Meta:
 AAH2+oXap0+0ja48fxG522j5c8oIUnqxQBxcO3n1xjDBdfvakE/wGHkmgf8uN12I
 LnmZ1dySt9MoNH1Zpk3w5y7VFCmJHoeS7FydPbpTJ6Pv4CxZBco2uew9ufhvqyaO
 k+/YTn8CbkNzEcuQCudJwp57v3t/BQdMpsUdxs5Op8xaJPgzRw/p3fJuCIsRFwwR
 kYGhvsh7ZJwm5VCaP1tZvB2R3Ju9AYzdr4CtQVMw3FHuQLfU7pKLpkjamWNioZmR
 zPSSTHCaR4E8ExWp2pSlRS6ZPUWG2T6naY6rJp/+XQouMEf4NUziFVWcLehKOUmF
 OxMM0HbjHNu0OR/IkgF5aCYcQiM30iQ5ts0uOh9L/xNCPRSKEP/UkcGGFvrm93Hz
 UIYLbD2NIjKIBx5P1a/FcVxWq48YHvTUMIJEzfa/KwYP2Y4GbL+SAbfMWLNpK3X1
 lTkJzvgdMqxbriMBvNFZkPK8JGabJ8nNnWH2PAP6DWWk1BwujrHWP+Y0ku8XsChH
 CDeKT4ji1OFxFlDq5zpxv1MBiPV1kZFGHsAz2eEkey4X

On Mon, Nov 21, 2022 at 09:26:16AM +0800, Xiubo Li wrote:
[1300+ lines snipped]
> LGTM.
> 
> Reviewed-by: Xiubo Li <xiubli@redhat.com>

You really don't need to quote the whole thing.  Please be more
considerate.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
