Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D80AAC4332F
	for <ocfs2-devel@archiver.kernel.org>; Sat, 26 Nov 2022 18:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=BsQWRe+9ZJfTuObUFlzsV2taA2SJtVVBChi8D5kJqtI=;
 b=sjX4yqB2Kna13ZbGNBq9Z7o4sXMqFSXfDeEKEj+9/4x3hPax1NotKVS4werT9veS0BsZgRVBTmU8
   fIM3fERvnjWGsTYiWUulOkJojvFE5JiR22tza54XNDY7VM0Xv6J3I42CPy5lEWBANzx05DVIWCUM
   2qPzmptvJwpRj1hCrpkAPsFIGb9+tNxXFT2+ce+AtZDvy0XQG3aKxcFK9kKX/mGeBKBiTnILrEe1
   nQ1ufPsywr41BRM9lKT5adSnqfxg3WtHVFrAuZKBbjL41ZZguGB+L9W6+COK80W0uKX5rmiAfkgY
   9P6nHdce5H/iXOzaYZFIdYdjD4UvqsEyjTLU1w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=BsQWRe+9ZJfTuObUFlzsV2taA2SJtVVBChi8D5kJqtI=;
 b=RcaHf8jlEMyXNm6w1asF7RBaIGJVIQGjLr8MALPPZfQAaI5F/iu1SfcK9Lxohv5tHbQ9Wy/fe7yy
   NXl5916mjAct/5tCmeVmfbOw8WAM77zF1T31JpUSOdylm7F2P4M4qP1OhQgJSs/MO2pL/Z8lOFyM
   GoewbQ9KmfS2isTudxc7g0rvyRv8+aMq2qCvnIBdQ3sucDhqABsq/GlRLSgjvI0QX2YevAcyL+37
   BeTheqpu3BmKrNBW2lJG8fi+5gAaE5T3nBDkUVewWhpksxP2XJ2scEoiZFuCrOiri4Muz+KO2bnM
   Z7n5hopCeBynQ00wyng98dIdWrlw2SBNowpd3Q==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLY00AUZVZ1YL70@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 26 Nov 2022 18:13:49 +0000 (GMT)
Date: Tue, 22 Nov 2022 07:06:59 +0100
To: Matthew Wilcox <willy@infradead.org>
Message-id: <20221122060659.GA14084@lst.de>
References: <20221120210004.381842-1-jlayton@kernel.org>
 <Y3xHQwM3UiD/SK0K@casper.infradead.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <Y3xHQwM3UiD/SK0K@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Source-IP: 213.95.11.211
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10538
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 suspectscore=0 mlxlogscore=680 clxscore=303 adultscore=0 lowpriorityscore=0
 phishscore=0 mlxscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 priorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220044
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
 ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
 Trond Myklebust <trond.myklebust@hammerspace.com>, linux-nfs@vger.kernel.org,
 Paulo Alcantara <pc@cjr.nz>, Jeff Layton <jlayton@kernel.org>,
 linux-kernel@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
 Steve French <sfrench@samba.org>,
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
From: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christoph Hellwig <hch@lst.de>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: verein.lst.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: tEwG3X4PQorLgdAUiwMje8_J7ukolO-5
X-Proofpoint-ORIG-GUID: tEwG3X4PQorLgdAUiwMje8_J7ukolO-5
X-Mailman-Approved-At: Sat, 26 Nov 2022 18:13:43 +0000
Reporting-Meta:
 AAGWssAnS/k6StFg12VxWIdd+jMm53JlV3NBdCRMsSqZ7ZIRQgVOOQG2XogQllyv
 jjrS2PJuJAvTPg22izQl5ILHHFty+AppD+2ewJhsfIfuyUkKLAnu87Y09G7Kq9Mo
 37BRkfsczochfgxqMJr6mX24ABBvEcDTE3kjuH2KAD3KHs4JW5jc/OD2ahNjCyZe
 orBmaKx6ZhSqBM0hPVXEDeMZUxHTQqmLomN/ytAgi72rYW8EP3Q5SP7UQTsNLLXo
 UdE28+3VvhNPO57PHILJfyxNdcBQ7bODasbt0XmQGUBWFGskb7L4q+CZWup/Cy50
 ZgeYmUG2/lCeFu6HNSBM4jJfY81EN8XyfqJyt0H/t0+rv7xx0cKcv9mkaXrxvF7s
 Q5ZI4WVWilHoCksWyGstP6U1qqAmGkXQW3FsKyEtPPVfEewdvFNN9UM+7RutJeN4
 kknNFrMhwD6VoBszpD/ovThUnEWnqDcvzaPQQ3oYj7ZM/NHxDoZ4sZ/l9o5Olffr
 5mOl/VYeDZtUu/yAJXLp87vTpCPnK0AUO0hhs0TYTIQe

On Tue, Nov 22, 2022 at 03:51:31AM +0000, Matthew Wilcox wrote:
> These two seem undefined at this point.
> 
> > +	struct fasync_struct *	fl_fasync; /* for lease break notifications */

Given that we just use a pointer to it there is no need to have a
definition.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
