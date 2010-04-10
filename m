From: Dong Yang Li <lidongyang@novell.com>
Date: Sat, 10 Apr 2010 01:37:58 -0600
Subject: [Ocfs2-devel] [PATCH] ocfs2: avoid direct write if we fall	
	back to buffered
Message-ID: <4BC0B776020000460001DCCA@novprvlin0050.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I still get a bug with this check and without my patch:


[16179.955148] (13400,1):ocfs2_truncate_file:465 ERROR: bug expression: le64_to_cpu(fe->i_size) != i_size_read(inode)
[16179.955157] (13400,1):ocfs2_truncate_file:465 ERROR: Inode 254789, inode i_size = 811008 != di i_size = 809011, i_flags = 0x1
the call trace is the same.


the problem is this check in ocfs2_direct_IO_get_blocks just check if we are going beyond the blocks right now,
so if a direct write won't play with new blocks but extending the i_size still get a pass, like the error above said, di->i_size is 809011, using 198 blocks and the direct write end up with i_size 811008, just same 198 blocks.


IMHO, we can add this check back and fix this check, or we don't try to do direct write if we decided we can't in ocfs2_file_aio_write, after calling ocfs2_prepare_inode_for_write as my patch said.


Comments? ;-)


Br,
Li Dongyang
>>> Sunil Mushran  04/10/10 1:42 AM >>>
  Li Dongyang wrote:
> On Friday 09 April 2010 11:32:10 Tao Ma wrote:
>> Hi Dongyang,
>>
>> Li Dongyang wrote:
>>> Hi, Tao,
>>>
>>> On Friday 09 April 2010 10:38:33 Tao Ma wrote:
>>>> Hi Dongyang,
>>>>
>>>> Li Dongyang wrote:
>>>>> This is because ocfs2_file_aio_write calls
>>>>> ocfs2_prepare_inode_for_write which sets direct_io to 0 if it finds out
>>>>> that direct IO would extend the file. But later we call
>>>>> __generic_file_aio_write which end's up calling
>>>>> generic_file_direct_write because the file has O_DIRECT flag.So every
>>>>> time we do a direct write extending the file, the inode->i_size gets
>>>>> inconsistent with the i_size on disk because we call
>>>>> generic_file_direct_write, and if we do a truncate after this, we will
>>>>> meet a bug in ocfs2_truncate_file.
>>>> yes we have O_DIRECT flag set and in __generic_file_aio_write it will
>>>> call generic_file_direct_write first and then trigger to
>>>> ocfs2_direct_IO. In this function we will check again and return 0. And
>>>> _generic_file_aio_write will fall back to buffered write if the directIO
>>>> can't write. Am I wrong somehow?
>>> yes ocfs2_direct_IO has some check, but it just check if we are
>>> appending(the i_size <= offset), if the offset < i_size and offset +
>>> count > i_size, it will do direct io anyway. seems we also can fix this
>>> by adding a check to ocfs2_direct_IO.
>> It is done by ocfs2_direct_IO_get_blocks. Just debug the kernel and you
>> will get what I mean. ;)
> Do you mean this section in ocfs2_direct_IO_get_blocks:?
> /*
>  * Any write past EOF is not allowed because we'd be extending.
>  */
> if (create && (iblock + max_blocks) > inode_blocks) {
>     ret = -EIO;
>     goto bail;
> }
>
> I was using the linus tree 
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> and we don't have that check, but I can find this in the 
> git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git, introduced by 
> commit 564f8a3228879d6962edb3432d01bcd7499a67ec
>
> and now with this check I got what you mean, you are right, but I wonder why 
> the linus tree doesn't have this check? and are we suppose to do with this?
> IMHO we can just push this commit to linus tree.

commit 5fe878ae7f82fbf0830dbfaee4c5ca18f3aee442
Author: Christoph Hellwig 
Date:   Tue Dec 15 16:47:50 2009 -0800

    direct-io: cleanup blockdev_direct_IO locking

This check was removed recently by the above patch.
