From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu May 27 00:50:11 2004
Subject: [Ocfs2-devel] [IMPORTANT] OCFS2 revision 946
In-Reply-To: <3ACA40606221794F80A5670F0AF15F8404737CF4@PDSMSX403.ccr.corp.intel.com>
References: <3ACA40606221794F80A5670F0AF15F8404737CF4@PDSMSX403.ccr.corp.intel.com>
Message-ID: <20040527055007.GI25513@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sure. The other OCFS2 hackers can correct any details I get wrong:
File entries, for now, are largely unchanged. the filename and filename_len
fields are gone however as they're stored in directories now.

Directories store filename and offset information in their data blocks now.
This has the big advantage of reducing the overhead of things like
readdir(), and seperates the namespace data from the inode data so that you
can do things like renames and link and whatnot without coping file entries
around. A file entry now will *never* change offset. Making links to file
entries is as easy as incrementing link count and storing another name /
offset (remember offset will be the same though) pair in the directory data.

renaming a file doesn't even require locking the file entry. We simply
change the name data in the directory (or directories if we're renaming to a
new one). Similarly, unlinking only requires we remove the name / offset
pair from the directory.

Since there's no more dir nodes, there's no dir alloc file / dir alloc
bitmap file. file entries are now allocated out of a new "inode alloc" file
using an inode alloc bitmap. These function just like the other metadata
allocator file(s) did before. The other system files are unchanged.

Hopefully I've managed to clear things up a bit...
	--Mark

On Thu, May 27, 2004 at 11:26:49AM +0800, Ling, Xiaofeng wrote:
> Is there any simple description about the changes of the format? 
> Are there still 8 system files. Is the file entry still store in DirNode?

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
