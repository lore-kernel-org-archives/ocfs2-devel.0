From: Josef Bacik <josef@redhat.com>
Date: Thu, 31 Mar 2011 20:34:50 -0400
Subject: [Ocfs2-devel] [PATCH 1/3] VFS/ioctl: Add punching-hole support
	to ioctl().
In-Reply-To: <20110331234454.GB18808@noexit>
References: <1301556810-8438-1-git-send-email-tristan.ye@oracle.com>
	<4D94EEC3.2030206@oracle.com>
	<20110331225618.GB7484@dhcp231-156.rdu.redhat.com>
	<20110331234454.GB18808@noexit>
Message-ID: <20110401003450.GD7484@dhcp231-156.rdu.redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josef Bacik <josef@redhat.com>, Sunil Mushran <sunil.mushran@oracle.com>, Tristan Ye <tristan.ye@oracle.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, chris.mason@oracle.com, tm@tao.ma

On Thu, Mar 31, 2011 at 04:44:55PM -0700, Joel Becker wrote:
> On Thu, Mar 31, 2011 at 06:56:18PM -0400, Josef Bacik wrote:
> > On Thu, Mar 31, 2011 at 02:14:43PM -0700, Sunil Mushran wrote:
> > > Frankly I see no point extending the ioctl interface when we have
> > > a syscall interface.
> > >
> > 
> > I'd even go so far as to say we could probably axe the xfs and ocfs2 ioctls
> > since we have the fallocate interface :).  Thanks,
> 
> 	These ioctls are in long use.  Granted, it is for the small
> subset of users that know xfs and ocfs2 can do this, but still.
> <venkman>Breaking userspace is *bad*.</venkman>

Yeah I wasn't serious, though I do wish there was a way to mark these sort of
interfaces deprecated to give us a path to retire old interfaces.

> 	More interesting would be to bring the ioctls up to generic code
> and have them backended by fallocate.  I'm not sure they map without
> looking deeper, but it's at least an idea.
> 

I just did a cursory look and it seems like that would work out ok.  Thanks,

Josef
