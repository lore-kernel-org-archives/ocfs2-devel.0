From: Dave Chinner <david@fromorbit.com>
Date: Wed, 22 Jan 2020 19:21:55 +1100
Subject: [Ocfs2-devel] [Lsf-pc] [LFS/MM TOPIC] fs reflink issues,
 fs online scrub/check, etc
In-Reply-To: <CAPcyv4iPX4fDZGFwCkJxMDc-+1DjOMVZYVqnE=XTZpis6ZLFww@mail.gmail.com>
References: <20160210191715.GB6339@birch.djwong.org>
	<20160210191848.GC6346@birch.djwong.org>
	<CAH2r5mtM2nCicTKGFAjYtOG92TKKQdTbZxaD-_-RsWYL=Tn2Nw@mail.gmail.com>
	<0089aff3-c4d3-214e-30d7-012abf70623a@gmx.com>
	<CAOQ4uxjd-YWe5uHqfSW9iSdw-hQyFCwo84cK8ebJVJSY_vda3Q@mail.gmail.com>
	<20200121161840.GA8236@magnolia>
	<20200121220112.GB14467@bombadil.infradead.org>
	<CAPcyv4iPX4fDZGFwCkJxMDc-+1DjOMVZYVqnE=XTZpis6ZLFww@mail.gmail.com>
Message-ID: <20200122082155.GA9317@dread.disaster.area>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-ext4 <linux-ext4@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>, xfs <xfs@e29208.dscx.akamaiedge.net>, Steve French <smfrench@gmail.com>, ocfs2-devel@oss.oracle.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lsf-pc@lists.linux-foundation.org, linux-btrfs <linux-btrfs@vger.kernel.org>

On Tue, Jan 21, 2020 at 04:47:27PM -0800, Dan Williams wrote:
> On Tue, Jan 21, 2020 at 2:02 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Tue, Jan 21, 2020 at 08:18:40AM -0800, Darrick J. Wong wrote:
> > > On Tue, Jan 21, 2020 at 09:35:22AM +0200, Amir Goldstein wrote:
> > > > On Tue, Jan 21, 2020 at 3:19 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> > > > >
> > > > > Didn't see the original mail, so reply here.
> > > >
> > > > Heh! Original email was from 2016, but most of Darrick's wish list is
> > > > still relevant in 2020 :)
> > >
> > > Grumble grumble stable behavior of clonerange/deduperange ioctls across
> > > filesystems grumble grumble.
> > >
> > > > I for one would be very interested in getting an update on the
> > > > progress of pagecache
> > > > page sharing if there is anyone working on it.
> > >
> > > Me too.  I guess it's the 21st, I should really send in a proposal for
> > > *this year's* LSFMMBPFLOLBBQ.
> >
> > I still have Strong Opinions on how pagecache page sharing should be done
> > ... and half a dozen more important projects ahead of it in my queue.
> > So I have no update on this.
> 
> We should plan to huddle on this especially if I don't get an RFC for
> dax-reflink support out before the summit.

It would be a good idea to share your ideas about how you plan to
solve this problem earlier rather than later so you don't waste time
going down a path that is incompatible with what the filesystems
need to/want to/can do.

Cheers,

Dave.
-- 
Dave Chinner
david at fromorbit.com
