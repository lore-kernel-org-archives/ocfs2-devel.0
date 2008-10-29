From: Jan Kara <jack@suse.cz>
Date: Wed, 29 Oct 2008 02:57:32 +0100
Subject: [Ocfs2-devel] [PATCH 00/00] Implement quotas for OCFS2 (version
	2)
In-Reply-To: <1225192987.17596.20.camel@tristan-laptop.cn.oracle.com>
References: <12248859043309-git-send-email-jack@suse.cz>
	<1225098534.6525.43.camel@tristan-laptop.cn.oracle.com>
	<20081027112312.GA18903@duck.suse.cz>
	<1225159789.6555.24.camel@tristan-laptop.cn.oracle.com>
	<1225192987.17596.20.camel@tristan-laptop.cn.oracle.com>
Message-ID: <20081029015732.GB24732@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

> Jan,
> 
> Sorry for making the noise again:)
  I'm happy the patches finally appply fine for you :).

> I'm just curious about one thing, as you said we choose quotaon to
> enforce the quota limitation on ocfs2 to keep the consistency with other
> fs, and the quotaon finally call the quoctl with the cmd word
> 'Q_QUOTAON', here i found the quoctl() need a agrumnet to point to  the
> path name of file containing the quotas for the filesystem,but
> unfortunately these files were hidden from userspace on ocfs2. so this
> quotactl call for turning on the quota will definitely fail, is that the
> case?
  No, the quotactl won't fail because OCFS2 kernel module overloads
function implementing the Q_QUOTAON handling and so filename is actually
ignored and it provides corresponding system inode instead.

> Since the existing POSIX quota tools did not work  under ocfs2
> currently, i've written a simple version of the quota tools(just
> including getquota,setquotas and quotactl) by the help of quotactl()
> API.  All of its binaries and src attached.
  It is strange that they don't work for you. Are you using the version of
quota-tools I sent you (like week ago after I sent the first set of
patches)? Because the changed version of quota-tools works here for me just
fine... I'm attaching it to this mail again just in case it got lost somewhere.

> As what i said above, my version of quotaon(invoked by 'quotactl -o')
> also did not work here ,and fortunately, we really do succeed to set/get
> the quota for usr/group.
> you can have a check in your env if you wish.
  Well, having your own tool for turning quotas on is possible as well, but
I think it would be better if you used provided quota-tools.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
-------------- next part --------------
A non-text attachment was scrubbed...
Name: quota-tools-ocfs2.tar.gz
Type: application/x-compressed-tar
Size: 419370 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20081029/200da1c3/attachment-0001.bin 
