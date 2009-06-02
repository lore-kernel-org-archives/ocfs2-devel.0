From: Jan Kara <jack@suse.cz>
Date: Tue, 2 Jun 2009 14:25:48 +0200
Subject: [Ocfs2-devel] Anything I'm missing for 2.6.31?
In-Reply-To: <20090602010636.GB32688@mail.oracle.com>
References: <20090602010636.GB32688@mail.oracle.com>
Message-ID: <20090602122547.GC15010@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hi,

On Mon 01-06-09 18:06:36, Joel Becker wrote:
> 	We're coming up on the next merge window, and I only have a
> couple tiny fixes for ocfs2.  I thought I'd list up what I know is
> outstanding, and I was hoping to find out if I was missing anything.  If
> I am, I need to get it in linux-next and set for the merge window ASAP.
  I've just sent off a patch series that may be worth merging for 2.6.31...
It contains some quota fixes and lockdep support for cluster locks.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
