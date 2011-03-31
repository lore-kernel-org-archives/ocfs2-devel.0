From: Joel Becker <jlbec@evilplan.org>
Date: Thu, 31 Mar 2011 16:44:55 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] VFS/ioctl: Add punching-hole support
	to ioctl().
In-Reply-To: <20110331225618.GB7484@dhcp231-156.rdu.redhat.com>
References: <1301556810-8438-1-git-send-email-tristan.ye@oracle.com>
	<4D94EEC3.2030206@oracle.com>
	<20110331225618.GB7484@dhcp231-156.rdu.redhat.com>
Message-ID: <20110331234454.GB18808@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josef Bacik <josef@redhat.com>
Cc: Sunil Mushran <sunil.mushran@oracle.com>, Tristan Ye <tristan.ye@oracle.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, chris.mason@oracle.com, tm@tao.ma

On Thu, Mar 31, 2011 at 06:56:18PM -0400, Josef Bacik wrote:
> On Thu, Mar 31, 2011 at 02:14:43PM -0700, Sunil Mushran wrote:
> > Frankly I see no point extending the ioctl interface when we have
> > a syscall interface.
> >
> 
> I'd even go so far as to say we could probably axe the xfs and ocfs2 ioctls
> since we have the fallocate interface :).  Thanks,

	These ioctls are in long use.  Granted, it is for the small
subset of users that know xfs and ocfs2 can do this, but still.
<venkman>Breaking userspace is *bad*.</venkman>
	More interesting would be to bring the ioctls up to generic code
and have them backended by fallocate.  I'm not sure they map without
looking deeper, but it's at least an idea.

Joel

-- 

 print STDOUT q
 Just another Perl hacker,
 unless $spring
	- Larry Wall

			http://www.jlbec.org/
			jlbec at evilplan.org
