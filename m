From: Darwin <darwin.xupt@gmail.com>
Date: Fri, 11 Nov 2016 11:00:06 +0800
Subject: [Ocfs2-devel] [PATCH 4/6] ocfs2: budget for extent tree splits
 when adding refcount flag
In-Reply-To: <20161110171159.GC21519@birch.djwong.org>
References: <147873186646.2820.17513529102740292215.stgit@birch.djwong.org>
	<147873189167.2820.5870521669010779004.stgit@birch.djwong.org>
	<CACbbJyYped4uF9rnEJ0RZ5dK54e8PAo8jamHpcWznb5obJ_bOw@mail.gmail.com>
	<20161110171159.GC21519@birch.djwong.org>
Message-ID: <CACbbJyZeZTR4_3_t-pbbbn3yWuMeQHmAfpBDk_O1b1-CFk0QyQ@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: mfasheh@versity.com, jlbec@evilplan.org, linux-fsdevel@vger.kernel.org, ocfs2-devel <ocfs2-devel@oss.oracle.com>

Hi Darrick,

On Fri, Nov 11, 2016 at 1:11 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
>
[snip]
> The VFS reflink interface (FICLONERANGE) and dedupe interface (FIDEDUPERANGE)
> allows callers to specify the range of bytes on which to operate, which means
> that we can share arbitrary parts of two files.  For example, let's say you
> have one regular extent in a file's block map:
>
> RRRRRRRRRRRRRRRRRRRRRRRRRRRRRR (regular extent)
>
> Now ask reflink to share the middle of that extent with some other file.
> ocfs2's extent mapping record can store a flag indicating that the
> extent could be shared, which means that the one record now splits into
> three:
>
> RRRRRRRRRRRssssssRRRRRRRRRRRRR (regular, shared, regular)
>
> This scenario happens if you run duperemove against an ocfs2 filesystem
> to deduplicate file data, since dedupe wants the filesystem to be able
> to share arbitrary blocks of files.
>
> You're correct that cp --reflink only ever deals with entire extents
> because it calls FICLONERANGE with both file offsets zero and the length
> set to the length of the source file.  The important thing to remember
> is that we are not limited to sharing entire files, even if the
> userspace utilities don't take advantage of it.

Thanks for your time! I thought it's for an existed ocfs2 issue until reaching
patch[6/6].

>
> (FWIW the duperemove program does take advantage of it.)
>
>> 2) what do you mean by "*full* extent btree"?
>
> (Slight correction to that -- I should have said "full extent tree split".)
>
> Record insertion operations on a tree structure all follow the same
> basic strategy -- search from the root towards the records in the leaf
> blocks until we find the place where the record would be, memmove() all
> the records following that spot up by one index, copy the record data
> into the newly vacated slot, and (if necessary) walk back up the tree to
> update the interior node pointers.
>
> If the desired leaf is already full, however, there is a problem -- we
> have to split the leaf into two half-full leaf blocks before we can
> insert the record.  We must also add a pointer to the new leaf into the
> next level up in the tree.  If that interior node is also full, we split
> the interior node prior to adding the new leaf block pointer.  We must
> then add a pointer to the new interior node into the next level up in
> the tree, and so on until we reach the root.
>
> In short, if we want to add a record to a tree whose blocks are
> completely full, we end up splitting blocks all the way up the tree.
>

Oh yes, thanks for pointing me to the basic tree operation - record insertion;-)

>>
>> 3) in what situation, will this happen? - "we need an extent split but
>> not a refcount split".
>> Could you please explain more by example?
>
> An extreme example would be a program like this:
>
> - write to block zero
> - for i in 1 to 524288,
>   - reflink block zero to block $i
>
> When this program terminates, the refcount tree will contain a single
> refcount record ($phys_blk, len=1, refcount=524288).  The extent map for
> this file, however, will have 524,288 extent records:
>
> ($phys_blk, len=1, offset=0, flags=shared)
> ($phys_blk, len=1, offset=1, flags=shared)
> ...
> ($phys_blk, len=1, offset=524288, flags=shared)
>
> There are 524288 records.  A 4k leaf can fit 252 records, so there will
> be 2081 leaf blocks.  A 4k node also can fit 252 records, so there will
> be 9 node blocks pointing to leaves, and one root block to point to the
> first level nodes.  Clearly, the extent tree has split many times across
> all the reflink operations.  However, the refcount tree never splits
> because there's only one record.

Excellent explanation! Now, I know that virtual blocks of a file can
share the same physical blocks.

Thanks a lot!
Darwin

>
> --D
>
>>
>> Thanks,
>> Darwin
>>
>> >
>> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>> > ---
>> >  fs/ocfs2/refcounttree.c |    3 +++
>> >  1 file changed, 3 insertions(+)
>> >
>> >
>> > diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
>> > index 59be8f4..d92b6c6 100644
>> > --- a/fs/ocfs2/refcounttree.c
>> > +++ b/fs/ocfs2/refcounttree.c
>> > @@ -3698,6 +3698,9 @@ int ocfs2_add_refcount_flag(struct inode *inode,
>> >         struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>> >         struct ocfs2_alloc_context *meta_ac = NULL;
>> >
>> > +       /* We need to be able to handle at least an extent tree split. */
>> > +       ref_blocks = ocfs2_extend_meta_needed(data_et->et_root_el);
>> > +
>> >         ret = ocfs2_calc_refcount_meta_credits(inode->i_sb,
>> >                                                ref_ci, ref_root_bh,
>> >                                                p_cluster, num_clusters,
>> >
>> >
>> > _______________________________________________
>> > Ocfs2-devel mailing list
>> > Ocfs2-devel at oss.oracle.com
>> > https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>
>>
>>
>> --
>> Thanks,
>> Darwin



-- 
Thanks,
Darwin
