From: Tiger Yang <tiger.yang@oracle.com>
Date: Tue, 09 Dec 2008 16:39:44 +0800
Subject: [Ocfs2-devel] two xattr fixes
Message-ID: <493E2ED0.6040105@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,
There are two fixes base on tao's patch "remove extend_trans and add its 
credits at the beginning".  They are also base on mark's merge_window 
branch.

The first patch together with tao's patch fix bug 
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1048 It's a transaction 
credits issue.

The second patch fix a problem when we set security xattr and acl xattr 
during mknod. When block size is too small, we may need xattr bucket for 
them.

Thanks,
tiger
