From: Tiger Yang <tiger.yang@oracle.com>
Date: Mon, 25 Jun 2012 16:00:19 +0800
Subject: [Ocfs2-devel] fix mlog_errno in ocfs2_global_read_info
Message-ID: <4FE81A93.6010200@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, All,

When mount ocfs2 with option usrquota and grpquota, we will see below 
message:

(mount.ocfs2,9434,1):ocfs2_global_read_info:403 ERROR: status = 24
(mount.ocfs2,9434,3):ocfs2_global_read_info:403 ERROR: status = 24

But actually this should not be a error.

In ocfs2_global_read_info, if  read_quota() succeed, status is the size 
of the struct ocfs2_global_disk_dqinfo, only when it is not equal to the 
correct size, it will be a error. So this positive value should be 
return and should not log it as a error.

I made a patch to fix this, and in the patch I removed the redundant 
mlog_errno also.

Thanks for review

Tiger
