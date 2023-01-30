Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34030C54EAA
	for <ocfs2-devel@archiver.kernel.org>; Mon, 30 Jan 2023 09:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hY8aCZHOsD+JTxyKN6EaaTZfmkp+88AOcQns5xET7d0=;
 b=zKOBHUM6EPmq90DLgRV3KFSgMQb/mJkZyecmXICBL66dWi6uNXeXpkcQ3dHwhKeiekfs5gfFE5Qi
   +Fz+HTTfYaYGUSxZ4tEN1+CGFYyDJQAc94kPHynn+wgwNckNG/UJ9FMpJX/pdAtXbxHWVKAIK0co
   pqnP0i7SK1kbMbBxevHxtSfPTR4j2/Ux+fz2WO4cclWKXrnYoAOrrRpOJb5DxmuvFtiNFddjcJAz
   Q8hJieQU+7/Z7twos9EZK4/n6F0LXkKRuiyZChhATKg+SemLziU/JgXHsbbRyMAUygUUz+XfpTT1
   rTTJbessS2lUFFFNWdBsRPkLUmRQ2qauYwk1Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hY8aCZHOsD+JTxyKN6EaaTZfmkp+88AOcQns5xET7d0=;
 b=ZBCeFDd5zPmAncNT8jw1V6+K6n6B5Q7uQGIz4UZnM/RRzdJ1qHgKYOoyD/Q1aG5ucYDudQ0Hm2Of
   KOeCH6mU8SyVRBxEmUP5IYlW6oRd1dekfzpesoA4PiIn14yL9pkl4GDVfNrod2D2+f80VoXvOs0v
   PwFwYMhsrrsxb/H7zgRvMh60SnCWgDRnQQA2KfiPCqUrleVdtTnhmi0qAMrkLOxwdLURUeByIZNQ
   4wFBlsr91xFL+E4dHKIpd1EQelot7RmW1/rIqx4RwLtPz9Y1YMn4lbBgyHElkvwtmVXKFMd5M9tc
   IYyhWwJu928pPCYmJ6vdgMTB0weK7n6iNXY/Tw==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230118 64bit (built Jan 18
 2023))
 with ESMTPS id <0RPA00NO7KFLEV50@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 30 Jan 2023 09:16:33 +0000 (GMT)
Date: Mon, 30 Jan 2023 10:16:15 +0100
To: Christian Brauner <brauner@kernel.org>
Message-id: <20230130091615.GB5178@lst.de>
References:
 <20230125-fs-acl-remove-generic-xattr-handlers-v1-0-6cf155b492b6@kernel.org>
 <20230130091052.72zglqecqvom7hin@wittgenstein>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230130091052.72zglqecqvom7hin@wittgenstein>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Source-IP: 213.95.11.211
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10605
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 phishscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0 mlxscore=0
 priorityscore=0 impostorscore=0 clxscore=276 spamscore=0 mlxlogscore=723
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301300088
Cc: reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-mtd@lists.infradead.org, Seth Forshee <sforshee@kernel.org>,
 Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 ocfs2-devel@oss.oracle.com, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [Ocfs2-devel] [PATCH 00/12] acl: remove remaining posix acl
	handlers
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
X-Proofpoint-ORIG-GUID: vfM6_VqNE1lVhAbXTJe3aqz1qbxHoPjL
X-Proofpoint-GUID: vfM6_VqNE1lVhAbXTJe3aqz1qbxHoPjL
Reporting-Meta:
 AAFURT/GarsvUEWBR6RsZduPrEty6jV5pFF9A/9U8bRjQAhwtw4cj5f20bpXVoKJ
 vAvBktTX6/NfFnQ0MSbdVM5juRjcqGn0dahY61eG/xeQwRecwU3QAAPcgMFR8s98
 kX2K3MlQxpgzTxLsDiTDGUZzpgnPRBogOXw7XFT4rStjDNB9LvSZY0cJ2S/IoJ3h
 dV1VpyuvimK9quYnjzQe1P6E7ODXSmIceymumB7GQNn1h/tpVpjN+zy5y5NEFqbs
 FHijcQkoLHdTPuyqztXaVCj28tCPmKsebcBuAME2M+4/s4L5DtxrQIHzgqab1LXv
 TPAjuyLHbjlupUDsAnPHaCqE41CmsURe5ur4wAMabIxKD6rif4BtCk24RZ79cBvZ
 Cm9F3P274eADdGNNa9kkHLiU/5g9SqgUNaKZMjOCigmFeelLU7xHCyz9oaX2szHV
 fsN/y1xw5Tr9E7nVNY7qYK1jk4WdHMBawQ7jcMbOLdpyQF2y1jNbaPyhMJOcHbEd
 Tf/H/sJmGzH2AHhUiCnmj8MEAeIty6re8BAU/5sy1Jvx

On Mon, Jan 30, 2023 at 10:10:52AM +0100, Christian Brauner wrote:
> However, a few filesystems still rely on the ->list() method of the
> generix POSIX ACL xattr handlers in their ->listxattr() inode operation.
> This is a very limited set of filesystems. For most of them there is no
> dependence on the generic POSIX ACL xattr handler in any way.
> 
> In addition, during inode initalization in inode_init_always() the
> registered xattr handlers in sb->s_xattr are used to raise IOP_XATTR in
> inode->i_opflags.
> 
> With the incoming removal of the legacy POSIX ACL handlers it is at
> least possible for a filesystem to only implement POSIX ACLs but no
> other xattrs. If that were to happen we would miss to raise IOP_XATTR
> because sb->s_xattr would be NULL. While there currently is no such
> filesystem we should still make sure that this just works should it ever
> happen in the future.

Now the real questions is: do we care?  Once Posix ACLs use an
entirely separate path, nothing should rely on IOP_XATTR for them.
So instead I think we're better off auditing all users of IOP_XATTR
and making sure that nothing relies on them for ACLs, as we've very
much split the VFS concept of ACLs from that from xattrs otherwise.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
