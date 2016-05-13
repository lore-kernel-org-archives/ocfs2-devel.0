From: Gang He <ghe@suse.com>
Date: Fri, 13 May 2016 02:36:25 -0600
Subject: [Ocfs2-devel] inconsistent dlm_new_lockspace LVB_LEN size from
 ocfs2 user-space tool and ocfs2 kernel module
Message-ID: <57360289020000F900036DF3@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Guys,

Here is a inconsistent LVB_LEN size problem when create a new lockspace from user-space tool (e.g. fsck.ocfs2) and kernel module (e.g. ocfs2/stack_user.c).
From the userspace tool, the LVB size is DLM_USER_LVB_LEN (32 bytes, defined in /include/linux/dlm_device.h)
From the kernel module, the LVB size is DLM_LVB_LEN (64 bytes).
Why did we design like this? Look at GFS2 kernel module code, it uses 32 bytes as LVB_LEN size, it is the same size with  DLM_USER_LVB_LEN macro definition. 
Now, We encountered a customer issue, the user did a fsck on a ocfs2 file system from one node, but aborted without release this lockspace (32bytes), then the user mounted this file system.
The kernel module would use the existing same lockspace, without creating the new lockspace with 64 bytes LVB_LEN.
 Next, the bad result was that the user could not mount this file system from the other nodes no longer.
The error messages likes,
Apr 26 16:29:16 mapkhpch1bl02 kernel: [ 3730.430947] dlm: 032F55597DEA4A61AB065568F964174D: config mismatch: 64,0 nodeid 177127961: 32,0
Apr 26 16:29:16 mapkhpch1bl02 kernel: [ 3730.433267] (mount.ocfs2,26981,46):ocfs2_dlm_init:2995 ERROR: status = -71
Apr 26 16:29:16 mapkhpch1bl02 kernel: [ 3730.433325] (mount.ocfs2,26981,46):ocfs2_mount_volume:1881 ERROR: status = -71
Apr 26 16:29:16 mapkhpch1bl02 kernel: [ 3730.433376] (mount.ocfs2,26981,46):ocfs2_fill_super:1236 ERROR: status = -71
Apr 26 16:29:16 mapkhpch1bl02 Filesystem(MITC_Pool1)[26912]: ERROR: Couldn't mount filesystem /dev/disk/by-id/scsi-3600507640081010d5000000000000082 on /MITC_Pool1

Of course, the urgent fix is easy, we can reboot all the nodes, then mount the file system again.
But, I want to if there were some reasons about this design, otherwise, I want to see if we can use the same size between user space and kernel module.


Thanks
Gang   
 
