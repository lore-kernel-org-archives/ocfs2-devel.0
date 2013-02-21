From: Zach Brown <zab@zabbo.net>
Date: Thu, 21 Feb 2013 10:00:39 -0800
Subject: [Ocfs2-devel] [RFC PATCH 0/3] copy-on-write extents mapping
In-Reply-To: <20130221152520.GA17067@quack.suse.cz>
References: <51244A15.2060508@oracle.com>
	<20130221152520.GA17067@quack.suse.cz>
Message-ID: <20130221180039.GX22221@lenny.home.zabbo.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: Jeff Liu <jeff.liu@oracle.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger@dilger.ca>, Dave Chinner <david@fromorbit.com>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, Chris Mason <chris.mason@fusionio.com>, Christoph Hellwig <hch@infradead.org>, ocfs2-devel@oss.oracle.com

>   Can you gather some performance numbers please - i.e. how long does it take
> to map such file without FIEMAP_FLAG_COW and how long with it? I'm not
> completely convinced it will make such a huge difference in practice (given
> du(1) isn't very performance critical application).

Seconded.

I'd like to see measurements (wall time, cpu, ios) of the time it takes
to find shared extents on a giant file *on a fresh uncached mount*.

Because this interface doesn't help the file system do the work more
efficiently, the kernel still has to walk everything to see if its
shared.  It just saves some syscalls and copying.

That's noise compared to the io/cache footprint of the operation.

- z
