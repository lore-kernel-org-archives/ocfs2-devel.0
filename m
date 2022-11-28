Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79A64C43217
	for <ocfs2-devel@archiver.kernel.org>; Mon, 28 Nov 2022 14:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EiO04qnSX4G0LhikqKLahXj1TOIoi4U22OypERnJmGE=;
 b=avC4szcPEuUa6z6EFFwgI9OvBNBfrDo7MKpmLSN14xhF535ONgFqoOjGbdCYnfnaZpxZSoGgXKKL
   EJES4/JXV25+QXEkwdC7cDm0+u044IT1Y7BjD5PpBhlgqGqudICS95Iw+iyo/fSPonMGl3xifYLR
   YEa3JKCMECcBtWM9mLoSElSvoAcWzQKA3uLp87PJ8uuqK2S6JPFN/WqNlmVp7bZar0L2JZzaLGNG
   9oG/1kgkPJDOcvrEdxP3s5DdAufKdUy5/FaYwZYzNAagzKEC5LoSqL39szdlLxQYVlrjaM6OKvq3
   ywq+6yDi6pdUuu7GuksoHdYZINb9HF9aGlid1Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EiO04qnSX4G0LhikqKLahXj1TOIoi4U22OypERnJmGE=;
 b=P1HZO5M7AsnCW9s6d/rJ7u0zh+xY4vI7j5DJrlyp4+DEr9neq+sX2XWPG2L9qNPFQmDdabAENFk5
   4wMOHiCmZNCoMfQM079oDvjA5H5aiQupxZaLSy0AW/qJABzh904VZLPvP1cC3uIwzS/lOBQ4vkc+
   IciIevJmnJ2H1f2oNuKsWHceJm3Shuh7XzXrNw1VPnUN8Oh3TfdWByMpTjXQhSRVBNxCJQ76e2n4
   SSpcr3uuLoY0t9GFr014BdNP8WBUkg7n5SJ5Cg8pEY89rJBvM8JSDUeU/e1zoRErSeJSyaplCo3z
   HdInrzvF8UaA2aLZntXyPYVjrVHPWHXfZ4ktPA==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RM2009HQAFAC400@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 28 Nov 2022 14:18:46 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1669632839; bh=TCH4X0vYXDYZIjposZLwuZH5bK38a+ap9JQQcvpsmrQ=;
 h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
 b=NiNiD/NIPJwPZZvubu2no8wdsdDDjItBldgVSQaImG5cxRrl7n6IQYZBc0nV5JpBQ
 xVnrX+B1v8v8ehMk7vofau11mkaKHiqPTVjq0mOg6uPLSQDNcWU6ra7XZX/5SPPGhe
 3NTDUsRcNblciTaLJIOHNpisMvl41lRYHx3bKhRvui4ToVySHHAMBffDg6ovppKkDe
 qsAeUfpeq06hna20AvMvcPdONgQBIVeU0n576fCL1sfDRo1XzYu64pPEHg4b2C61ur
 Lr2NVgPJPqeEYUjJtggTrBXIJXDvpIqIvFPOspCvYeix5kRtYTD6U+z1lN7Xo1zCxs
 ZI6W95+J1AmkQ==
Message-id: <6a093484bb977355db40c70ffa51386f3d4ed57b.camel@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Date: Mon, 28 Nov 2022 05:53:54 -0500
In-reply-to: <Y4Dw65Nzt4bX9esd@ZenIV>
References: <20221120210004.381842-1-jlayton@kernel.org>
 <Y4A6/ozhUncxbimi@ZenIV>
 <1d474f53670771f324745f597ec94b63a006d687.camel@kernel.org>
 <Y4Dw65Nzt4bX9esd@ZenIV>
User-Agent: Evolution 3.46.1 (3.46.1-1.fc37)
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10544
 signatures=596816
Cc: Latchesar Ionkov <lucho@ionkov.net>,
 Martin Brandenburg <martin@omnibond.com>,
 Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 linux-xfs@vger.kernel.org, Mike Marshall <hubcap@omnibond.com>,
 linux-cifs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
 Miklos Szeredi <miklos@szeredi.hu>, linux-afs@lists.infradead.org,
 cluster-devel@redhat.com, Christine Caulfield <ccaulfie@redhat.com>,
 v9fs-developer@lists.sourceforge.net, Ilya Dryomov <idryomov@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>, devel@lists.orangefs.org,
 Shyam Prasad N <sprasad@microsoft.com>,
 Eric Van Hensbergen <ericvh@gmail.com>, Tom Talpey <tom@talpey.com>,
 linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
 Xiubo Li <xiubli@redhat.com>,
 Trond Myklebust <trond.myklebust@hammerspace.com>, linux-nfs@vger.kernel.org,
 Paulo Alcantara <pc@cjr.nz>, samba-technical@lists.samba.org,
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
From: Jeff Layton via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Jeff Layton <jlayton@kernel.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-ORIG-GUID: Mx5C06zkQNuaCAQM-2TTfuaV6IjSjJ3d
X-Proofpoint-GUID: Mx5C06zkQNuaCAQM-2TTfuaV6IjSjJ3d
X-Mailman-Approved-At: Mon, 28 Nov 2022 14:18:44 +0000
Reporting-Meta:
 AAEZhIsZV6YrwUhhwOnwS3G04eG9q/cmvpkZOrHzv5yf8FglRHF6XXRYx4R1sRBx
 RsPFWkmKo4/mmI8mQvdIPmDFxJAcd46plucfL5W3Ka9X5oG7V+h7TBOjGC6aVpNn
 sAingthqhN7vdExvooLG6/cnZo9f0mNKzyet2q6cT9GGBRxe4il58tjDvZtpLDVn
 5pC5OO0/kNjBRV9xho2ug2KD1ggF1gSfarurFSD8IbeoNLhFRrNNtwE/YcR+HQkL
 PvQArCdr2pSAeSk/IzDHFBDkFzKwZGzgTe4Xv17sJRvlZVeQutt0KFobggxposEN
 h4eFFy6slDiw0UsmOc1xsZPddsI+oLSNHtMQjmMzRG9S3/9MdJgO2FuRpbqMbOFU
 1DV5TIY/50TeQhmKHrO6NoUV+KetKGzmbwFkPUaRLj2Q1+nvdkLin5vFqrjp8aDd
 AEXXdS+u9O2/NlwTzlAMwW2hCOZFxEnEAV5xW/0nemcvSrgFtdvtHzAAzGroR8gr
 QWEHxqKdaBDPFWNYhUir3My9X1pR4CaUvs0rqi6EvkMH

On Fri, 2022-11-25 at 16:44 +0000, Al Viro wrote:
> On Fri, Nov 25, 2022 at 08:23:45AM -0500, Jeff Layton wrote:
> 
> > I left it in fs.h for now. Some of the file_operations prototypes need
> > that typedef, and I figure that anyone who is including filelock.h will
> > almost certainly need to include fs.h anyway. We could move it into a
> > separate header too, but it's probably not worth it.
> > 
> > HCH mentioned years ago though that we should just get rid of fl_owner_t
> > altogether and just use 'void *'. I didn't do it at the time because I
> > was focused on other changes, but this might be a good time to change
> > it.
> 
> Might be...
> 
> > > > +extern void show_fd_locks(struct seq_file *f,
> > > > +			 struct file *filp, struct files_struct *files);
> > > 
> > > If anything, that would be better off as fl_owner_t...  Again, a separate
> > > patch.
> > 
> > I'm not sure what you mean here. This prototype hasn't changed, and is
> > only called from procfs.
> 
> Take a look at that function and its caller.  The use of 'files' argument there
> is (and can be) only as an opaque pointer to be compared to ->fl_owner; at that
> point it might be pointing to freed memory, for all we know (and give false
> positives if already reused).

Ok. What we want this function to do is show any traditional POSIX or
OFD locks that were set on a particular file. The logic in
__show_fd_locks looks right, but you're correct that we don't want
anyone dereferencing those pointers in that codepath.

Note too that this info is not wholly reliable. POSIX locks can merge
with other locks that were set within the same process (same
files_struct) but on different fds.

I think we want to get rid of fl_owner_t anyway. Maybe we should replace
it with an unsigned long instead of void * to discourage anyone from
trying to dereference those pointers?

> TBH, I'd never been able to finish the audit of files_struct pointers passed
> into locks subsystem; there definitely are moments when code from fs/locks.c
> is dealing with pointers to already freed instances - show_fd_locks() at the
> very least.  They are not dereferenced, but beyond that...

Yeah. In general, we try to ensure that locks are torn down before the
file with which it is associated, but with some of the delayed freeing,
they can outlive the file at times. For example:

    https://tracker.ceph.com/issues/57986

-- 
Jeff Layton <jlayton@kernel.org>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
