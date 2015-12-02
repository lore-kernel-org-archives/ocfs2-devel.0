From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 2 Dec 2015 10:47:16 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: return non-zero st_blocks for
 inline data
In-Reply-To: <BAA384F0-637C-406B-AED2-3ED9E6BCA7D2@oracle.com>
References: <1448399221-6109-1-git-send-email-john.haxby@oracle.com>
	<1448399221-6109-2-git-send-email-john.haxby@oracle.com>
	<565D4783.2090501@oracle.com>
	<BAA384F0-637C-406B-AED2-3ED9E6BCA7D2@oracle.com>
Message-ID: <565E5BB4.8000207@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 12/02/2015 06:33 AM, John Haxby wrote:
> 
>> On 1 Dec 2015, at 07:08, Junxiao Bi <junxiao.bi@oracle.com
>> <mailto:junxiao.bi@oracle.com>> wrote:
>>
>> On 11/25/2015 05:07 AM, John Haxby wrote:
>>> Some versions of tar assume that files with st_blocks == 0 do not
>>> contain any data and will skip reading them entirely. See also
>>> commit 9206c561554c ("ext4: return non-zero st_blocks for inline data").
>>>
>>> Signed-off-by: John Haxby <john.haxby@oracle.com
>>> <mailto:john.haxby@oracle.com>>
>>> ---
>>> fs/ocfs2/file.c | 8 ++++++++
>>> 1 file changed, 8 insertions(+)
>>>
>>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>>> index 0e5b451..d631279 100644
>>> --- a/fs/ocfs2/file.c
>>> +++ b/fs/ocfs2/file.c
>>> @@ -1302,6 +1302,14 @@ int ocfs2_getattr(struct vfsmount *mnt,
>>> }
>>>
>>> generic_fillattr(inode, stat);
>>> +/*
>>> + * If there is inline data in the inode, the inode will normally not
>>> + * have data blocks allocated (it may have an external xattr block).
>>> + * Report at least one sector for such files, so tools like tar, rsync,
>>> + * others don't incorrectly think the file is completely sparse.
>>> + */
>>> +if (unlikely(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL))
>>> +stat->blocks += (stat->size + 511)>>9;
>> From filesystem side, looks reasonable that data block is 0 for
>> inlined-data file. This is like a hack to filesystem to fix tools issue.
>> Indeed tar-1.26-27 have been fixed to not think file with st_blocks == 0
>> empty. But I am not sure why ext4 merge that fix.
> 
> It?s not just tar and it?s not just ext4.   Programmers not unreasonably
> assume that a file occupying zero blocks contains no data (where would
> you put it?)
> 
> ext4, btrfs and ntfs-3g all give inlined files a non-zero block size to
> avoid surprising programmers.   There?s nothing in Posix that says what
> stat?s st_blocks so in this case it?s right for the file systems in
> question to stick to the principle of least surprise.  In this case, it
> would be surprising if some small files suddenly started occupying no
> space while being non-empty.   It?s not as though it would be
> consistent: some small files would occupy space and some would not.  We
> want to present a consistent view of files to the user.  It?s not as
> though we?re breaking du either: it already tells lies :)
> 
> Does that make sense now?
OK. Thanks you for the explanation. We'd better not surprise programmers
and keep align with other fs. So

Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
> 
> jch
> 
> 
>>
>> Thanks,
>> Junxiao.
>>
>>>
>>> /* We set the blksize from the cluster size for performance */
>>> stat->blksize = osb->s_clustersize;
> 
