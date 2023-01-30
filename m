Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2991FC54EAA
	for <ocfs2-devel@archiver.kernel.org>; Mon, 30 Jan 2023 10:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=AmXIOqtjMhqKkhRRZSt3GmTxKd726K/C8RF0faoTqik=;
 b=cuM2AAqBjVLR/gTzoSgV59Fq0dpXPuJndTscuDY9rWSxNMipn6bbLpFGq60Lgho77DJj1o9vgwOX
   B25nfOqTpjW9RHcC4OfmkPmEf7POB8QMUKzDCMCglAwVOpa67jJncnVxox7EMBFHP45yWl63SoGt
   Hy/bG0SRpZubt5gstORQNpnfj4KuIPy9P4O0h1ZZJTwaAqAT93auLBGT/IHqp0XGX99PQAdmr0IS
   vSWsg3gTTF+L2bTr8xsrIRsbT7n+gsQ/o/CArlVY3bp8u7MV8epIVZmt1tMUVoVbPVX6rG5GBVBg
   dcWhvlgXI5yaMi/bgpf3wUJvNm+BjTzQ9X92xQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=AmXIOqtjMhqKkhRRZSt3GmTxKd726K/C8RF0faoTqik=;
 b=Gu4RWRYt/SBwQqzaMQn4uAz9SPJRCaDITisw1lL89gMFEJn0kTl+fD4u6ILYJ/OOaxeXdkRKlSI+
   rkJTPxcIzgr9m4wlCvL7A/aTv1ICFiBthGTsBk8F7vgYbjcjStYQz0AitErfhhGXxuon6ZBKb2bL
   btDRj1WlxpnnKh5lAeR7nMF0YepwUxu22xigAQ6b+GVfC5EJNf2aEM+ZyXyt3l47M2QLUqwIbmt8
   MVj9SlCfDVx27jSlopox/ZGl9mbfftBnvv8y0Hsf/jvkA++js2MrD87/wjI6HPhKhRdTC64XpSly
   +GBhHEy8XTHtMAMY0oHTL5X9S6gKy8S1C87Idw==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230118 64bit (built Jan 18
 2023))
 with ESMTPS id <0RPA009BKNJH5370@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 30 Jan 2023 10:23:41 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1675074209; bh=JNTyAwdnYzLmCEymJc/ZUWnk+Q8qvEe4IQT1QMUZUUk=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=JN3lXwEWVDPGXUGplDwCOYjrW8++AmiuyWsKytBrUAmwH5pYzbdpE0vlm5QMheggM
 NBh8TxCmRl0oiVPGeH0p588WtzUGa4Dhxdj47urWqRw5C3YGCL7sEtEpljLyqeU2qK
 hZMY3SfpZs4a7G1hzx2PjWG4oBFdjJLdjf/CAOLVLdkBRxoWDtbAN1LxJYt5Pv5/uW
 JiIhf6J6BcQzCzFwiWHxFBJvn0+sgbTbzFveW5be89tbifEA4YoFlo/yhqSIZATMj0
 cya32Nkc883EMLF+aa2JEWlyaIljfcXui3HQsRaEUKig3vqEj5vhHo9pWtvCv6EINs
 lzNgfo6NIXgGw==
Date: Mon, 30 Jan 2023 11:23:22 +0100
To: Christoph Hellwig <hch@lst.de>
Message-id: <20230130102322.kkq5u72skrmykilh@wittgenstein>
References:
 <20230125-fs-acl-remove-generic-xattr-handlers-v1-0-6cf155b492b6@kernel.org>
 <20230130091052.72zglqecqvom7hin@wittgenstein> <20230130091615.GB5178@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230130091615.GB5178@lst.de>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10605
 signatures=596816
Cc: reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-mtd@lists.infradead.org, Al Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 ocfs2-devel@oss.oracle.com, Seth Forshee <sforshee@kernel.org>
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
From: Christian Brauner via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christian Brauner <brauner@kernel.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-ORIG-GUID: D89tRlnkeyhB8n0WwWWuhg8sUmSnMHOq
X-Proofpoint-GUID: D89tRlnkeyhB8n0WwWWuhg8sUmSnMHOq
Reporting-Meta:
 AAFO/p010hEBNmYjMgWhSACTLdYOEmKw2frsMNccRRWLncOP+xnya7oEVbbvbT9W
 XVCdwFsRjhmWMvfa1KUcfeku7GZY08XHDCK87bfPTOmrAdDee9GGTX3mH0CggMBb
 2AhOmNsZorREi2Z++aR4lS64rtzMDsPxCGuA+JlOW5MokCVB/7wLEXfP45EhbjT0
 SemBK0tLbEoNsFdB6J3dlofOcB7FFsJ9czWruYDhY9sKPiwZiNxxvu/8k3AJjuhZ
 vRfNAuaO1zWzBlpUwW43JwtfifVZUufr+HgOZ3HwEx/n7QsUdO5Rhjv8OpyZm1My
 I6NUGDTSbpfOQ0FqgIuxxbt6lF119ebYi71tagze+v0NUwxvBDQZQ+LAKiFjOt98
 1OhEzuEYzp4Ho12zDySFO3YQWydwUdlsieQQEMTjJU6r00O0r1WGLtLNsZYr6d5w
 9IMwU7gRgUjR+wflIGS30AEKWgPj9N2CjZYrNupWxoovsyWa2gBC54Bsq6uQMOKn
 5MMNzCbna0jreQxCckDs+VmueE9qkd4A6rKE2EMUzJA=

On Mon, Jan 30, 2023 at 10:16:15AM +0100, Christoph Hellwig wrote:
> On Mon, Jan 30, 2023 at 10:10:52AM +0100, Christian Brauner wrote:
> > However, a few filesystems still rely on the ->list() method of the
> > generix POSIX ACL xattr handlers in their ->listxattr() inode operation.
> > This is a very limited set of filesystems. For most of them there is no
> > dependence on the generic POSIX ACL xattr handler in any way.
> > 
> > In addition, during inode initalization in inode_init_always() the
> > registered xattr handlers in sb->s_xattr are used to raise IOP_XATTR in
> > inode->i_opflags.
> > 
> > With the incoming removal of the legacy POSIX ACL handlers it is at
> > least possible for a filesystem to only implement POSIX ACLs but no
> > other xattrs. If that were to happen we would miss to raise IOP_XATTR
> > because sb->s_xattr would be NULL. While there currently is no such
> > filesystem we should still make sure that this just works should it ever
> > happen in the future.
> 
> Now the real questions is: do we care?  Once Posix ACLs use an
> entirely separate path, nothing should rely on IOP_XATTR for them.
> So instead I think we're better off auditing all users of IOP_XATTR
> and making sure that nothing relies on them for ACLs, as we've very
> much split the VFS concept of ACLs from that from xattrs otherwise.

I had a patch like that but some filesystems create inodes that
explicitly remove IOP_XATTR to prevent any xattrs from being set on
specific inodes. I remember this for at least reiserfs and btrfs.

So we would probably need IOP_NOACL that can be raised by a filesystem
to explicitly opt out of them for specific inodes. That's probably fine
and avoids having to introduce something like SB_I_XATTR.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
