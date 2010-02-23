From: tristan <tristan.ye@oracle.com>
Date: Tue, 23 Feb 2010 09:34:52 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Handle deletion of refcounted
 oprhan_inode correctly.
In-Reply-To: <4B8321F9.6000203@oracle.com>
References: <1266740977-8638-1-git-send-email-tristan.ye@oracle.com>	<1266740977-8638-2-git-send-email-tristan.ye@oracle.com>	<4B80F4F4.8020604@oracle.com>
	<4B80F5A6.3070600@oracle.com> <4B80F71D.2030009@oracle.com>
	<4B8321F9.6000203@oracle.com>
Message-ID: <4B8330BC.1010805@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil Mushran wrote:
> Tao Ma wrote:
>>
>> tristan wrote:
>>> Tao Ma wrote:
>>>> Hi tristan,
>>>>
>>>> Tristan Ye wrote:
>>>>> Current ocfs2 semantic for reflinking a file firstly create a
>>>>> new orphan_inode in orphan_dir, then remove it to target dir
>>>>> after refcounting operation done, these 2 steps makes logic
>>>>> straightfoward, and guarantee a crash during reflinking can
>>>>> be replayed(half-refcounted inode can be removed), while it
>>>>> brings us another issue cause these 2 steps is acquiring the
>>>>> orphan_dir lock respectively, the problem is, orphan_scan()
>>>>> may detect the half-refcounted inode in orphan_dir as its
>>>>> proper candidates to wipe off in a later time. actually it's
>>>>> not of course, we'd handle this correctly.
>>>>>
>>>>> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
>>>>> ---
>>>>>  fs/ocfs2/inode.c |   32 ++++++++++++++++++++++++--------
>>>>>  1 files changed, 24 insertions(+), 8 deletions(-)
>>>>>
>>>>> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
>>>>> index 88459bd..61fb546 100644
>>>>> --- a/fs/ocfs2/inode.c
>>>>> +++ b/fs/ocfs2/inode.c
>>>>> @@ -892,14 +892,30 @@ static int ocfs2_query_inode_wipe(struct 
>>>>> inode *inode,
>>>>>      di = (struct ocfs2_dinode *) di_bh->b_data;
>>>>>      if (!(di->i_flags & cpu_to_le32(OCFS2_ORPHANED_FL))) {
>>>>>          /* for lack of a better error? */
>>>>> -        status = -EEXIST;
>>>>> -        mlog(ML_ERROR,
>>>>> -             "Inode %llu (on-disk %llu) not orphaned! "
>>>>> -             "Disk flags  0x%x, inode flags 0x%x\n",
>>>>> -             (unsigned long long)oi->ip_blkno,
>>>>> -             (unsigned long long)le64_to_cpu(di->i_blkno),
>>>>> -             le32_to_cpu(di->i_flags), oi->ip_flags);
>>>>> -        goto bail;
>>>>> +        if (!(di->i_dyn_features &
>>>>> +              cpu_to_le16(OCFS2_HAS_REFCOUNT_FL))) {
>>>>> +            status = -EEXIST;
>>>>> +            mlog(ML_ERROR,
>>>>> +                 "Inode %llu (on-disk %llu) not orphaned! "
>>>>> +                 "Disk flags  0x%x, inode flags 0x%x\n",
>>>>> +                 (unsigned long long)oi->ip_blkno,
>>>>> +                 (unsigned long long)le64_to_cpu(di->i_blkno),
>>>>> +                 le32_to_cpu(di->i_flags), oi->ip_flags);
>>>>> +            goto bail;
>>>>> +        } else {
>>>>> +            /*
>>>>> +             * It did happen to us, though it's a rare case:
>>>>> +             * orphan_scan() detects the half-refcounted inode
>>>>> +             * in orphan_dir, and delete_inode() attempts to
>>>>> +             * wipe it after reflink operation done later. now
>>>>> +             * we're not allowed to delete such a valid inode,
>>>>> +             * instead, just bail out.
>>>>> +             */
>>>>> +            mlog(0, "Skipping delete of %llu because it's a "
>>>>> +                 "reflinked inode\n",
>>>>> +                 (unsigned long long)oi->ip_blkno);
>>>>> +            goto bail;
>>>>> +        }
>>>> We set i_dyn_features when when attach the tree to the file. This 
>>>> is very early. So I am curious why i_dyn_features can tell you 
>>>> whether this isn't a crashed reflink inode? Oh, you mean you will 
>>>> never delete a reflinked inode in orphan scan?
>>> Tao,
>>>
>>> Not exactly, if it's reflink operation was crashed somehow, it's 
>>> OCFS2_ORPHANED_FL must be set:), and if it was the case, we then 
>>> will never skip the deletion which is really needed.
>> oh, so this is really a hack for reflink. I am not sure whether it is 
>> appropriate. So let Joel decide whether it is OK or not. ;)
>
> I'm confused. How will the OCFS2_ORPHANED_FL be set for reflinked inodes
> if the node crashed?

Sunil,

Reflink separates all of its operation into 3 parts.

1. Create target inode in orphan_dir.

2. Do refcounting thing.

3. Move target inode from orphan_dir into desired place.

Once reflink operation crashed at step 1, no OCFS2_ORPHANED_FL set, and 
also there is no entry in orphan_dir, and if nodes crashed at step2,3, 
the reflinked inode still in orphan_dir with OCFS2_ORPHANED_FL set, so 
it can be used for replaying when doing recovery.

The reason why I used OCFS2_ORPHANED_FL for checking is that,

As you know, our orphan_scan thread scans the orphan_dir at a fixed 
interval, and put the oprhan inodes into a queue, which will be 
iput()'ed in a later time. As a result, our half-refcounted inodes in 
orphan_dir will be taken into account in that case, and 
ocfs2_delete_inode() may be invoked as we set i_nlink=0 in reflink 
codes, that's the root cause of bz1215 I guess. so OCFS2_ORPHANED_FL can 
be used for determining if we're deleting the refcounted inode(in crash 
case) at the recovery stage or we're trying to delete a alive 
half-refcounted inode.


Tao,

How do you think about this?


Tristan.
