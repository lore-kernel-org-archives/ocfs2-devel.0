From: tristan <tristan.ye@oracle.com>
Date: Thu, 04 Nov 2010 16:10:50 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Add a new code
 'OCFS2_INFO_FREEINODE' for o2info ioctl.
In-Reply-To: <20101104062836.GB22663@mail.oracle.com>
References: <1288782126-13007-1-git-send-email-tristan.ye@oracle.com>
	<20101104011839.GA14640@mail.oracle.com>
	<4CD219F5.8020006@oracle.com>
	<20101104062836.GB22663@mail.oracle.com>
Message-ID: <4CD26A8A.6080307@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Thu, Nov 04, 2010 at 10:27:01AM +0800, tristan wrote:
>> Joel Becker wrote:
>>> On Wed, Nov 03, 2010 at 07:02:05PM +0800, Tristan Ye wrote:
>>>> The new code is dedicated to calculate free inodes number of all inode_allocs,
>>>> then return the info to userpace in terms of an array.
>>>>
>>>> Specially, flag 'OCFS2_INFO_FL_NON_COHERENT', manipulated by '--cluster-coherent'
>>>> from userspace, is now going to be involved. setting the flag on means no cluster
>>>> coherency considered, usually, userspace tools choose none-coherency strategy by
>>>> default for the sake of performace.
>>> 	This looks pretty straightforward.  Note that any non-cached
>>> allocator is going to lock, regardless of the coherency flag.  Do we
>>> want to use ocfs2_ilookup() instead?
>> A bit confused here, did you mean we use 'ocfs2_ilookup' instead of 
>> 'ocfs2_get_system_file_inode' here?
>
> 	I do.  ocfs2_get_system_file_inode() calls ocfs2_iget(), which
> will read and lock the inode if it is not in the inode cache.  Now, the
> cache-coherent case obviously wants this.
> 	But in the non-coherent case we have the following conditions:
>
> 1) We have an inode in the inode cache, we can use it to look up the
>    blkno.
> 2) We have no inode in the cache, and we have to go get it.
>
> 	Case (1) is fast.  Case (2) is not, especially because it locks
> the inode.  Why not merely look up blkno via
> ocfs2_lookup_ino_from_name() and go from there?  Note that
> ocfs2_ilookup() isn't even needed, unless you have a faster way to get
> to the blkno.
>

    Yep, you're correct, other than the operation we read inode block, 
the lookup
of blkno/inode should also be treated differently according to coherency 
flag, I
guess following logic could help:

if (cluster_coherent) {
    alloc_inode = ocfs2_get_system_file_inode();
    ocfs2_inode_lock(alloc_inode, &bh);
} else {
    ocfs2_lookup_ino_from_name("global_bitmap", &blkno);
    ocfs2_read_blocks(blkno, 1, &bh);
}
...

Above logic guarantee the performance for none-coherency case.


>> coherency flag refers to a cluster-aware lock, while 
>> ocfs2_get_system_file_inode will use iget_locked() to get
>> the inode if it didn't exist in cache, does iget_locked() also refer to 
>> a cluster-aware lock somehow?
>
> 	Yes.  If an inode is not in cache, it will eventually call
> ocfs2_read_inode_locked().
>
> Joel
>
