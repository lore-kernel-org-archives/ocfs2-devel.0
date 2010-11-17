From: Josef Bacik <josef@redhat.com>
Date: Wed, 17 Nov 2010 06:32:21 -0000
Subject: [Ocfs2-devel] [PATCH 4/6] Ext4: fail if we try to use hole punch
In-Reply-To: <20101117030640.GD3290@thunk.org>
References: <1289840723-3056-1-git-send-email-josef@redhat.com>
	<1289840723-3056-5-git-send-email-josef@redhat.com>
	<4CE2783F.1020004@redhat.com>
	<20101116125016.GA31957@dhcp231-156.rdu.redhat.com>
	<4CE28211.6060204@redhat.com> <20101117030640.GD3290@thunk.org>
Message-ID: <20101117063125.GE5618@dhcp231-156.rdu.redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@mit.edu>, Avi Kivity <avi@redhat.com>, Josef Bacik <josef@redhat.com>, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vge

On Tue, Nov 16, 2010 at 10:06:40PM -0500, Ted Ts'o wrote:
> > >There is no simple way to test if a filesystem supports hole punching or not so
> > >the check has to be done per fs.  Thanks,
> > 
> > Could put a flag word in superblock_operations.  Filesystems which
> > support punching (or other features) can enable it there.
> 
> No, it couldn't be in super_operations.  It may vary on a per-inode
> basis for some file systems, such as ext4 (depending on whether the
> inode is extent-mapped or indirect-block mapped).
> 
> So at least for ext4 we'd need to call into fallocate() function
> anyway, once we add support.  I suppose if other file systems really
> want it, we could add a flag to the super block ops structure, so they
> don't have do the "do we support the punch" operation.  I can go
> either way on that; although if we think the majority of file systems
> are going support punch in the long-term, then it might not be worth
> it to add such a flag.
>

Yeah thats alot of extra code just for one part of fallocate.  Calling into
->fallocate is perfectly reasonable, especially since ext4 works the way it
does, I'm going to leave things as they are.  Thanks,

Josef 
