From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 05 Jun 2008 15:16:33 +0800
Subject: [Ocfs2-devel] [PATCH 0/8] ocfs2: Add extended attributes for ocfs2.
	V1
Message-ID: <484792D1.3080802@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
	Extended attributes are used for storing POSIX ACLs, SELinux labels, 
and user accessible metadata. They are essential for deploying file 
systems exported for workgroup use via samba. The following patches 
implement extended attributes on the OCFS2 file system.

Patch 1-4: The refactoring of extent tree operation. xattr will use 
ocfs2_extent_list for both the large EA and large numbers of EA. So we 
need some refactoring so that the old code can work with them.

Patch 5: Add ocfs2 xattr header.

Patch 6: Add operations for storing large EA in ocfs2. This is also 
refactor the old extent tree a little.

Patch 7: The extended attributes for ocfs2. It enables extended 
attributes storage for both in-inode and one meta block. The main design 
doc can be found at 
http://oss.oracle.com/osswiki/OCFS2/DesignDocs/ExtendedAttributes.

Patch 8: Enables storing large numbers of EAs in ocfs2. The main design 
doc can be found at 
http://oss.oracle.com/osswiki/OCFS2/DesignDocs/IndexedEATrees. The main 
process is almost the same, but some difference is described in detail 
in that patch.

Regards,
Tiger and Tao
