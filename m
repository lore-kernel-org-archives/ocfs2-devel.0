From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Thu, 21 May 2015 06:57:21 -0500
Subject: [Ocfs2-devel] Read IOPS storm in case of reflinking running VM
 disk
In-Reply-To: <2137407.TBXHbaxxee@evis>
References: <2921711.4r2dU24ThL@evis> <16475571.Tn5VYR8sPy@evis>
	<555A2544.2070607@suse.de> <2137407.TBXHbaxxee@evis>
Message-ID: <555DC821.5010603@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 05/20/2015 05:33 PM, Eugene Istomin wrote:
> Goldwyn,
>
> thanks for the answer!
>
> I read
> https://oss.oracle.com/osswiki/OCFS2(2f)DesignDocs(2f)RefcountTrees.html
> carefully to understand the problem.
>
> As i understand:
>
>  1. There are B-Tree structures for reflink: ocfs2_refcount_tree;
>     ocfs2_refcount_block -> ocfs2_refcount_list -> ocfs2_refcount_rec
>  2. "The refcount tree root is a refcount block pointed to by
>     i_refcount_loc"
>  3. Some operations needs extra uncached lookups
>
> Also i dumped frag/stat/refcount from production hypervisor node using
> debugfs.ocfs2, files are in attach (url as alt way -
> http://public.edss.ee/tmp/debugfs.tar.gz ).
>
> Hypervisor OCFS2 mount options:
> rw,nosuid,noexec,noatime,heartbeat=none,nointr,data=ordered,errors=remount-ro,localalloc=2048,coherency=full,user_xattr,acl
>
> Mkfs string:
>
> mkfs.ocfs2 -b 4KB -C 1MB -N 2 -T vmstore -L "storage"
> --fs-features=local,backup-super,sparse,unwritten,inline-data,metaecc,refcount,xattr,indexed-dirs,discontig-bg
>
> Can you please explain why there are so many extent blocks (204)? Is it
> really impossible to store plenty of clusters in single extent (like
> #25, block 3874095 -> 20847 clusters)?
>

A file's extent tree is based on your usage pattern and what is already 
present on disk. Creating a new file, with large block writes, on a new 
filesystem with no other nodes may create a file with small number of 
extents.

Modifying refcounted files can increase number of extents. The answer 
lies in the document you mentioned:

<quote>

Refcount records do not map 1:1 with extent records. A large extent may 
be split by a CoW operation. To unchanged inodes, they have one extent 
record covering the entire extent. The changed inode will have an extent 
record for the unchanged portion and a new extent record for the changed 
portion. The refcount tree will have similarly split the single refcount 
record into two. The changed portion will have decremented the reference 
count by one, as the changed inode is no longer using that physical extent.

</quote>

HTH,

-- 
Goldwyn
