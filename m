Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58D48C6370A
	for <ocfs2-devel@archiver.kernel.org>; Sat, 26 Nov 2022 18:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=uz5ssRa96SFtMhefq2nRg0PvqRr4Jm4ZvgtykAfRfLU=;
 b=CmWwXmzNRCe6pnjweQOVeR7csQO/U6/jMmvGCQFjZJ9TlDCBhboKGJldfNRAwwn8ylNWU6W6NrW4
   LlSdHUkIiv/JGcxIAyZkSq/spFPKD6wKtBRuknkRLTfD6NC9ZKNTXgOrwBNWaqMIcGlBaauy/COq
   xHpF23j/wwCmSuRGy1tRBaKIITWlBlWzJ2S3GZZZlf4rNQqfeSLJcLi6XbDGX5sRKf8wcFEBjIRD
   TZ/xhFailN9BRVxhvFfiB/uAj35mWKfSgQD9KpyCUmGml90a76CJTJx1WAYAnYYAkk1RlpyMKe38
   VQGzs0gzAuMx6MEj1PT3yJQsRbkaGKAeCjngRA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=uz5ssRa96SFtMhefq2nRg0PvqRr4Jm4ZvgtykAfRfLU=;
 b=YqxW8QzsuAZEkRQx82pLmtXX7Zk+HLKJaWdXK01dCwf6CAOdZn+g9OahS6e8nWI+TKOcBFB3OaIt
   rsqLOUFiW3gOBLSFvlbAPLE4B2B7AJbNgTic5L+EMwUETDa1dvDGNk4mCDuwDMMvszhh8HwrQeAp
   4ScHVOyy7u+CcFQ/qLsyPQnnEg6i9z2o3XMsl0rbRUj4OKq2ULLSExOj1uYYFiznwU4Bic5NQY3t
   lVE7C+hdGV8nAzFc83xq9GtJKy2cTW6HR8sywRaHQ65UroBMWUP4RpEV35hFbiyA+oubdWOuUsb6
   cR/8myhXGmeR8oOL8ws18BqXSBDLeC36HBhM6g==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLY00CDKVZ1E1B0@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 26 Nov 2022 18:13:49 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1669382630; bh=EGJ1sbVmh8zfuee638fIF/XO+8/weuDlINdqpi5zZtE=;
 h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
 b=ITYmgIWGeb/7tfCFFc4kVDpIzqmupq1CVJap5fhBl/OT/PtkT4fvz+47vLok2k5y+
 9CRsV+JeWA0KEW85LVZu0FSIZep4yXbkGkq4EGBqpjWl9J4R07ZmdftvaN+jO6GvVh
 UV+8CnZQsig9drGP5ocCBKCwdeh2CEjv01ouksVCHxKjEnYvQ0VQOwyYDVIftWVHKE
 GsZuPwqfzHVqHsCgI2NSiNlqWlCXseI+0MB2Oq49i12gvBk+OTgmkxmQgpHo2z4CO0
 KgxgBErlyuKDTZUoexdSzNPrYs0i7nPI8jo2JLFO4nl05cBpvzph4ae7XpMCDCSp+4
 bOGw2Qy+6YgWg==
Message-id: <1d474f53670771f324745f597ec94b63a006d687.camel@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Date: Fri, 25 Nov 2022 08:23:45 -0500
In-reply-to: <Y4A6/ozhUncxbimi@ZenIV>
References: <20221120210004.381842-1-jlayton@kernel.org>
 <Y4A6/ozhUncxbimi@ZenIV>
User-Agent: Evolution 3.46.1 (3.46.1-1.fc37)
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10541
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
X-Proofpoint-GUID: XATU7Uicp2CyeUkt6pLXQRHysExubzV8
X-Proofpoint-ORIG-GUID: XATU7Uicp2CyeUkt6pLXQRHysExubzV8
X-Mailman-Approved-At: Sat, 26 Nov 2022 18:13:43 +0000
Reporting-Meta:
 AAEmrC2/UhTqKnLmm/sYlqSb+ARjmOWiGpOLyoFrD9XjLFWZ0a+vIi2a3YlRJAce
 2B0Fh4N+fgHqIbVArOAtVXgwkV9zWPuE0hu0qy0N7NHVlIK4YRwpCV3UNnwqXwzF
 uHQwZcEhrQ0DnoFs9PZl1E/t3Olq+djM6YPcdqhrKcVrEf0nWXJpYv6/wiI/SAJY
 N71hvIDn30WLo/nkxi5HzDLZhO8dnsM41LlK4dsmU1rdAu2encOZlIoX8pGL+fE1
 +jC4C4ngq7hehkmiBs1ve8m/hWSWT+Hnmms+iqXh6cZOpE6jqim7xd4bCnHUNwWa
 fNW5MRm5iOvzLnj4HSchmuM4ZOUKirCWehDEmfBOwkg1klOGxVAjg+7aErdTO4Bk
 AeUgf/vm3txcHeUtTR+X20VEq4uLW5068z7iXMbPSwLm3+OWYK2gFkG00ttJYjVm
 tt/xZ9R3BJQfwjdmvnHwBWv0iuLCxyAU2/8yqC3A01qFb6CDcUQdMaDw7mAfULgD
 /da+gRJfnLEZAE+ruKZfCsoWLDvXBtGKtI2t//zbicfqXQ==

On Fri, 2022-11-25 at 03:48 +0000, Al Viro wrote:
> On Sun, Nov 20, 2022 at 03:59:57PM -0500, Jeff Layton wrote:
> 
> > --- /dev/null
> > +++ b/include/linux/filelock.h
> > @@ -0,0 +1,428 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _LINUX_FILELOCK_H
> > +#define _LINUX_FILELOCK_H
> > +
> > +#include <linux/list.h>
> > +#include <linux/nfs_fs_i.h>
> 
> Umm... I'd add a comment along the lines of "struct file_lock has
> a BS union by fs type; NFS side of things needs nfs_fs_i.h"
> 

Ok.

> > +struct lock_manager_operations {
> > +	void *lm_mod_owner;
> > +	fl_owner_t (*lm_get_owner)(fl_owner_t);
> 
> Probably take fl_owner_t to some more neutral header...
> 

I left it in fs.h for now. Some of the file_operations prototypes need
that typedef, and I figure that anyone who is including filelock.h will
almost certainly need to include fs.h anyway. We could move it into a
separate header too, but it's probably not worth it.

HCH mentioned years ago though that we should just get rid of fl_owner_t
altogether and just use 'void *'. I didn't do it at the time because I
was focused on other changes, but this might be a good time to change
it.

> > +#define locks_inode(f) file_inode(f)
> 
> Why do we still have that one, anyway?  Separate patch, obviously,
> but I would take Occam's Razor to that entity...
> 

I can spin up a patch to nuke that too. I count only 30 callsites
remaining anyway.

> > +struct files_struct;
> > +extern void show_fd_locks(struct seq_file *f,
> > +			 struct file *filp, struct files_struct *files);
> 
> If anything, that would be better off as fl_owner_t...  Again, a separate
> patch.

I'm not sure what you mean here. This prototype hasn't changed, and is
only called from procfs.

-- 
Jeff Layton <jlayton@kernel.org>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
