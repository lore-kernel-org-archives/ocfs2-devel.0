From: Richard Yao <ryao@gentoo.org>
Date: Sun, 16 Jun 2013 00:47:36 -0000
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Fix llseek() semantics and do
	some cleanup
In-Reply-To: <51BBF6FE.6080502@oracle.com>
References: <1371237814-59365-1-git-send-email-ryao@gentoo.org>
	<1371237814-59365-2-git-send-email-ryao@gentoo.org>
	<51BBF6FE.6080502@oracle.com>
Message-ID: <51BD0AFF.8010504@gentoo.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Liu <jeff.liu@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel@gentoo.org, Ocfs2-Devel <ocfs2-devel@oss.oracle.com>, Joel Becker <jlbec@evilplan.org>, Mark Fasheh <mfasheh@suse.com>

On 06/15/2013 01:09 AM, Jeff Liu wrote:
> [Add ocfs2-devel to CC-list]
> 
> Hello Richard,
> 
> Thanks for your patch.
> 
> On 06/15/2013 03:23 AM, Richard Yao wrote:
> 
>> There are multiple issues with the custom llseek implemented in ocfs2 for
>> implementing SEEK_HOLE/SEEK_DATA.
>>
>> 1. It takes the inode->i_mutex lock before calling generic_file_llseek(), which
>> is unnecessary.
> 
> Agree, but please see my comments below.
> 
>>
>> 2. It fails to take the filp->f_lock spinlock before modifying filp->f_pos and
>> filp->f_version, which differs from generic_file_llseek().
>>
>> 3. It does a offset > inode->i_sb->s_maxbytes check that permits seeking up to
>> the maximum file size possible on the ocfs2 filesystem, even when it is past
>> the end of the file. Seeking beyond that (if possible), would return EINVAL
>> instead of ENXIO.
>>
>> 4. The switch statement tries to cover all whence values when in reality it
>> should only care about SEEK_HOLE/SEEK_DATA. Any other cases should be passsed
>> to generic_file_llseek().
> 
> I have another patch set for refactoring ocfs2_file_llseek() but not yet found time
> to run a comprehensive tests.  It can solve the existing issues but also improved the
> SEEK_DATA/SEEK_HOLE for unwritten extents, i.e. OCFS2_EXT_UNWRITTEN.
> 
> With this change, SEEK_DATA/SEEK_HOLE will go into separate function with a little code
> duplication instead of the current mix-ups in ocfs2_seek_data_hole_offset(), i.e, 
> 
> loff_t ocfs2_file_llseek()
> {
> 	switch (origin) {
>         case SEEK_END:
>         case SEEK_CUR:
>         case SEEK_SET:
>                 return generic_file_llseek(file, offset, origin);
>         case SEEK_DATA:
>                 return ocfs2_seek_data(file, offset);
>         case SEEK_HOLE:
>                 return ocfs2_seek_hole(file, offset);
>         default:
>                 return -EINVAL;
>         }
> }
> 
> I personally like keeping SEEK_DATA/SEEK_HOLE in switch...case style rather
> than dealing with them in a condition check block.

I would prefer to see the code structured like this:

loff_t ocfs2_file_llseek()
{
	switch (origin) {
        case SEEK_DATA:
                return ocfs2_seek_data(file, offset);
        case SEEK_HOLE:
                return ocfs2_seek_hole(file, offset);
        default:
                return generic_file_llseek(file, offset, origin);
        }
}

Unfortunately, I just noticed that this code has a problem. In specific,
generic_file_llseek() calls generic_file_llseek_size(), which has a
switch statement for whence that fails to distinguish between SEEK_SET
and invalid whence values. Invalid whence values are mapped to SEEK_SET
instead of returning EINVAL, which is wrong. That issue affects all
filesystems that do not specify a custom llseek() function and it would
affect ocfs2 if my version of the function is used.

-------------- next part --------------
A non-text attachment was scrubbed...
Name: signature.asc
Type: application/pgp-signature
Size: 901 bytes
Desc: OpenPGP digital signature
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130616/2188112a/attachment.bin 
