From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Fri Jul 16 05:00:11 2004
Subject: [Ocfs2-devel] 
	A patch to improve the metadata reading throughput (against svn
	1267)
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E04B13BD8@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

	This is a new patch to increase the metadata reading throughput
for OCFS2. Our approach is to make the metadata reading operation via
routine ocfs_read_bh() cacheable and keep consistency through routine
invalidate_bdev() when receiving lock release notifications, such as
FLAG_FILE_CREATE, FLAG_FILE_DELETE, FLAG_FILE_TRUNCATE,
FLAG_FILE_EXTEND, etc. These notification is sent in routine
ocfs_release_lock(), which is invoked in the journal commit thread.

	We also did some benchmark.
	The directory creating rate is about 4000/s with this patch and
1400/s without.
	The directory removing rate is about 740/s with this patch and
10/s without.

	Please refer to the attachment. It is against svn 1267.

	This patch is not stable yet. Known issues:
1. We still need to check all code which read the metadata. Figure out
if that metadata is suitable to be cached.
3. Current OCFS lock mechanism may cause dead lock in some cases after
we change to cache metadata and release lock in journal asynchronously.
We plan to fix it in a new patch.
4. readdir() may get old data after the data is written back to disk in
journal asynchronously. It is not a bug. But which way is better, sync
the new data to disk when other nodes notify READONLY message or just
let them get old data?

	We are working to improve this patch. Any suggestion?
	Thank you very much.




*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
*********************************************  

-------------- next part --------------
A non-text attachment was scrubbed...
Name: ocfs2-metadata-2.patch
Type: application/octet-stream
Size: 9512 bytes
Desc: ocfs2-metadata-2.patch
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040716/8474cd98/ocfs2-metadata-2.obj
