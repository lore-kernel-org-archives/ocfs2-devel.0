From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Thu May 27 01:52:40 2004
Subject: [Ocfs2-devel] [IMPORTANT] OCFS2 revision 946
Message-ID: <3ACA40606221794F80A5670F0AF15F8404737EAE@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

So seems the file_entry struct is much like the ext2_inode struct in =
ext2/3 file system now.
Another effect is we lose a simple way to list the all files without =
going to each directory recursively.:)
How about the root, is there a file_entry for root directory and as the =
first one in "inode alloc" file?


>-----Original Message-----
>From: Mark Fasheh [mailto:mark.fasheh@oracle.com]=20
>Sent: 2004=C4=EA5=D4=C227=C8=D5 13:50
>To: Ling, Xiaofeng
>Cc: ocfs2-devel@oss.oracle.com
>Subject: Re: [Ocfs2-devel] [IMPORTANT] OCFS2 revision 946
>
>Sure. The other OCFS2 hackers can correct any details I get wrong:
>File entries, for now, are largely unchanged. the filename and=20
>filename_len
>fields are gone however as they're stored in directories now.
>
>Directories store filename and offset information in their=20
>data blocks now.
>This has the big advantage of reducing the overhead of things like
>readdir(), and seperates the namespace data from the inode=20
>data so that you
>can do things like renames and link and whatnot without coping=20
>file entries
>around. A file entry now will *never* change offset. Making=20
>links to file
>entries is as easy as incrementing link count and storing=20
>another name /
>offset (remember offset will be the same though) pair in the=20
>directory data.
>
>renaming a file doesn't even require locking the file entry. We simply
>change the name data in the directory (or directories if we're=20
>renaming to a
>new one). Similarly, unlinking only requires we remove the=20
>name / offset
>pair from the directory.
>
>Since there's no more dir nodes, there's no dir alloc file / dir alloc
>bitmap file. file entries are now allocated out of a new=20
>"inode alloc" file
>using an inode alloc bitmap. These function just like the=20
>other metadata
>allocator file(s) did before. The other system files are unchanged.
>
>Hopefully I've managed to clear things up a bit...
>	--Mark
>
>On Thu, May 27, 2004 at 11:26:49AM +0800, Ling, Xiaofeng wrote:
>> Is there any simple description about the changes of the format?=20
>> Are there still 8 system files. Is the file entry still=20
>store in DirNode?
>
>--
>Mark Fasheh
>Software Developer, Oracle Corp
>mark.fasheh@oracle.com
>
