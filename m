From: Chen, Yukun <yukun.chen@intel.com>
Date: Fri Aug 20 03:25:29 2004
Subject: [Ocfs2-devel] 
	[2.6.6 svn 1364]System hang randomly when writing to the same file
	from different processes of the same node
Message-ID: <B44D37711ED29844BEA67908EAF36F039A20ED@pdsmsx401.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all

 

Steps to duplicate:

1.Do some operation ,such as mkdir&touch , on node A and node B

 

2.on node A process1  write to a file at a specific position(such as
offset 1000) ,100 times

 

2.also on node A, at the same time , process2 write to the same file at
the 

 

same position, 100 times

 

Repeat step 1-2 several times, system will hang with the following
message found in node A:

 

state=1, lockid=22765568, flags = 0x1000, asked type = 5 master = 1,
state = 0x0, type = 5

(18397) ERROR at /tmp/trunk/src/dlm.c, 461: status = -110

(18397) ERROR at /tmp/trunk/src/vote.c, 910: inode 5558, vote_status=0,
vote_state=1, lockid=22765568, flags = 0x1000, asked type = 5 master =
1, state = 0x0, type = 5

...

 

on node B , error message with dmesg:

Call Trace:

recalc_task_prio

shedule

ocfs_comm_process_msg

ocfs_dlm_recv_msg

worker_thread

ocfs_dlm_recv_msg

default_wake_function

....

 

Any ideas on it? thanx.

 

Aaron

Intel China Software Lab

Tel:  8621-52574545 Ext.1587

E_mail:yukun.chen@intel.com

 

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040820/51ee0f1b/attachment.htm
