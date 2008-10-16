From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu, 16 Oct 2008 15:43:31 +0800
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: add security EA and ACL support v2
Message-ID: <48F6F0A3.5060909@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,
These three patches fix the problems in the version one.
And them base on the Tao's patches:
ocfs2/xattr: Remove unused restore_extent_block and
ocfs2/xattr: Merge xattr set transaction.

The first patch fix some problem in xattr code.
The second patch add security EA support.
The third patch add ACL support.

Best regards,
tiger
