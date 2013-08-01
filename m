From: Joel Becker <jlbec@evilplan.org>
Date: Thu, 1 Aug 2013 00:20:09 -0700
Subject: [Ocfs2-devel] Why ocfs2 haven't implemented "steal" for
 local_alloc system files?
In-Reply-To: <CAEeiSHVsUGvBRR3iN4TpQqHVN4+KD6aV+e2nEGZ7ouYOWJEhpw@mail.gmail.com>
References: <51F3A091.4090605@huawei.com>
	<CAEeiSHVsUGvBRR3iN4TpQqHVN4+KD6aV+e2nEGZ7ouYOWJEhpw@mail.gmail.com>
Message-ID: <20130801072008.GA15266@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Basically, there's so little in the cache that stealing would be too
complex.  Really we just want to fall back to the global, and if that is
empty, you're near enough ENOSPC that it doesn't much matter.

Joel

On Wed, Jul 31, 2013 at 08:33:48PM -0700, Sunil Mushran wrote:
> Because it makes no sense. Unlike inode/extent allocs, local_alloc is a
> temporary cache. If you fail to allocate, you fallback to the global bitmap.
> 
> 
> On Sat, Jul 27, 2013 at 3:27 AM, Younger Liu <younger.liu@huawei.com> wrote:
> 
> > Hi,
> >   While analyzing ocfs2 block allocation, I found:
> >   When claiming space from inode_alloc (or extent_alloc) system files,
> > if there is no enough space in inode_alloc (or extent_alloc) and
> > global_bitmap, it could steal space from other slots.
> >   But when claiming space from local_alloc system files, and no
> > enough space in local_alloc and global_bitmap, it returns -ENOSPC.
> >
> >   Why ocfs2 haven't implemented "steal" for local_alloc system files?
> >   Is there any some reasons?
> >
> >
> > _______________________________________________
> > Ocfs2-devel mailing list
> > Ocfs2-devel at oss.oracle.com
> > https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> >

> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel


-- 

"Born under a bad sign.
 I been down since I began to crawl.
 If it wasn't for bad luck,
 I wouldn't have no luck at all."

			http://www.jlbec.org/
			jlbec at evilplan.org
