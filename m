From: Tiger Yang <tiger.yang@oracle.com>
Date: Mon, 27 Oct 2008 16:29:24 +0800
Subject: [Ocfs2-devel] ocfs2: add security EA support v4
Message-ID: <49057BE4.208@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,
I split the previous support security EA patch into four patches for 
review. Them besed on joel's xattr-28 branch and tao's patch "Merge 
xattr set transaction".

1: move new_inode out of the transaction.
2: add ocfs2_xattr_set_handle.
3: add security xattr APIs
4: add init_security in mknod.

Best regards,
tiger
