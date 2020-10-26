From: Matthew Wilcox <willy@infradead.org>
Date: Mon, 26 Oct 2020 16:44:42 +0000
Subject: [Ocfs2-devel] [PATCH 6/7] btrfs: Promote to unsigned long long
	before shifting
In-Reply-To: <20201026163546.GP6756@twin.jikos.cz>
References: <20201004180428.14494-1-willy@infradead.org>
	<20201004180428.14494-7-willy@infradead.org>
	<20201026163546.GP6756@twin.jikos.cz>
Message-ID: <20201026164442.GU20115@casper.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dsterba@suse.cz, linux-fsdevel@vger.kernel.org, ericvh@gmail.com, lucho@ionkov.net, viro@zeniv.linux.org.uk, jlayton@kernel.org, idryomov@gmail.com, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-btrfs@vger.kernel.org, clm@fb.com, josef@toxicpanda.com, dsterba@suse.com, stable@vger.kernel.org

On Mon, Oct 26, 2020 at 05:35:46PM +0100, David Sterba wrote:
> On Sun, Oct 04, 2020 at 07:04:27PM +0100, Matthew Wilcox (Oracle) wrote:
> > On 32-bit systems, this shift will overflow for files larger than 4GB.
> > 
> > Cc: stable at vger.kernel.org
> > Fixes: 53b381b3abeb ("Btrfs: RAID5 and RAID6")
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > ---
> >  fs/btrfs/raid56.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> > index 255490f42b5d..5ee0a53301bd 100644
> > --- a/fs/btrfs/raid56.c
> > +++ b/fs/btrfs/raid56.c
> > @@ -1089,7 +1089,7 @@ static int rbio_add_io_page(struct btrfs_raid_bio *rbio,
> >  	u64 disk_start;
> >  
> >  	stripe = &rbio->bbio->stripes[stripe_nr];
> > -	disk_start = stripe->physical + (page_index << PAGE_SHIFT);
> > +	disk_start = stripe->physical + ((loff_t)page_index << PAGE_SHIFT);
> 
> It seems that this patch is mechanical replacement. If you check the
> callers, the page_index is passed from an int that iterates over bits
> set in an unsigned long (bitmap). The result won't overflow.

Not mechanical, but I clearly made mistakes.  Will you pick up the
patches which actually fix bugs?
