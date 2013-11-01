From: Guozhonghua <guozhonghua@h3c.com>
Date: Fri, 1 Nov 2013 02:38:57 +0000
Subject: [Ocfs2-devel] How to break out the unstop loop in the recovery
 thread? Thanks a lot.
Message-ID: <71604351584F6A4EBAE558C676F37CA42EC2B6FE@H3CMLB02-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi everyone,

I have one OCFS2 issue.
The OS is Ubuntu, using linux kernel is 3.2.50.
There are three node in the OCFS2 cluster, and all the node is using the iSCSI SAN of HP 4330 as the storage.
As the storage restarted, there were two node restarted for fence without heartbeating writting on to the storage.
But the last one does not restart, and it still write error message into syslog as below:

Oct 30 02:01:01 server177 kernel: [25786.227598] (ocfs2rec,14787,13):ocfs2_read_journal_inode:1463 ERROR: status = -5
Oct 30 02:01:01 server177 kernel: [25786.227615] (ocfs2rec,14787,13):ocfs2_replay_journal:1496 ERROR: status = -5
Oct 30 02:01:01 server177 kernel: [25786.227631] (ocfs2rec,14787,13):ocfs2_recover_node:1652 ERROR: status = -5
Oct 30 02:01:01 server177 kernel: [25786.227648] (ocfs2rec,14787,13):__ocfs2_recovery_thread:1358 ERROR: Error -5 recovering node 2 on device (8,32)!
Oct 30 02:01:01 server177 kernel: [25786.227670] (ocfs2rec,14787,13):__ocfs2_recovery_thread:1359 ERROR: Volume requires unmount.
Oct 30 02:01:01 server177 kernel: [25786.227696] sd 4:0:0:0: [sdc] Unhandled error code
Oct 30 02:01:01 server177 kernel: [25786.227707] sd 4:0:0:0: [sdc]  Result: hostbyte=DID_TRANSPORT_FAILFAST driverbyte=DRIVER_OK
Oct 30 02:01:01 server177 kernel: [25786.227726] sd 4:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 13 40 00 00 08 00
Oct 30 02:01:01 server177 kernel: [25786.227792] end_request: recoverable transport error, dev sdc, sector 4928
Oct 30 02:01:01 server177 kernel: [25786.227812] (ocfs2rec,14787,13):ocfs2_read_journal_inode:1463 ERROR: status = -5
Oct 30 02:01:01 server177 kernel: [25786.227830] (ocfs2rec,14787,13):ocfs2_replay_journal:1496 ERROR: status = -5
Oct 30 02:01:01 server177 kernel: [25786.227848] (ocfs2rec,14787,13):ocfs2_recover_node:1652 ERROR: status = -5
...............................................................................................................
Oct 30 06:48:41 server177 kernel: [43009.457816] sd 4:0:0:0: [sdc] Unhandled error code
Oct 30 06:48:41 server177 kernel: [43009.457826] sd 4:0:0:0: [sdc]  Result: hostbyte=DID_TRANSPORT_FAILFAST driverbyte=DRIVER_OK
Oct 30 06:48:41 server177 kernel: [43009.457843] sd 4:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 13 40 00 00 08 00
Oct 30 06:48:41 server177 kernel: [43009.457911] end_request: recoverable transport error, dev sdc, sector 4928
Oct 30 06:48:41 server177 kernel: [43009.457930] (ocfs2rec,14787,9):ocfs2_read_journal_inode:1463 ERROR: status = -5
Oct 30 06:48:41 server177 kernel: [43009.457946] (ocfs2rec,14787,9):ocfs2_replay_journal:1496 ERROR: status = -5
Oct 30 06:48:41 server177 kernel: [43009.457960] (ocfs2rec,14787,9):ocfs2_recover_node:1652 ERROR: status = -5
Oct 30 06:48:41 server177 kernel: [43009.457975] (ocfs2rec,14787,9):__ocfs2_recovery_thread:1358 ERROR: Error -5 recovering node 2 on device (8,32)!
Oct 30 06:48:41 server177 kernel: [43009.457996] (ocfs2rec,14787,9):__ocfs2_recovery_thread:1359 ERROR: Volume requires unmount.
Oct 30 06:48:41 server177 kernel: [43009.458021] sd 4:0:0:0: [sdc] Unhandled error code
Oct 30 06:48:41 server177 kernel: [43009.458031] sd 4:0:0:0: [sdc]  Result: hostbyte=DID_TRANSPORT_FAILFAST driverbyte=DRIVER_OK
Oct 30 06:48:41 server177 kernel: [43009.458049] sd 4:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 13 40 00 00 08 00
Oct 30 06:48:41 server177 kernel: [43009.458117] end_request: recoverable transport error, dev sdc, sector 4928
Oct 30 06:48:41 server177 kernel: [43009.458137] (ocfs2rec,14787,9):ocfs2_read_journal_inode:1463 ERROR: status = -5
Oct 30 06:48:41 server177 kernel: [43009.458153] (ocfs2rec,14787,9):ocfs2_replay_journal:1496 ERROR: status = -5
Oct 30 06:48:41 server177 kernel: [43009.458168] (ocfs2rec,14787,9):ocfs2_recover_node:1652 ERROR: status = -5
.............................................................................................
...... The same log message as before, and the syslog is very large, it can occupy all the capacity remains on the disk.......................

So as the syslog file size increases quikly, and is very large and it occupy all the capacity of the system directory / remains.
So the host is blocked and not any response.

According to the log as before, In the function __ocfs2_recovery_thread, there may be an un-stop loop which result in the super-large syslog file.
__ocfs2_recovery_thread
{
    ................................................
        while (rm->rm_used) {
       .............................................
       status = ocfs2_recover_node(osb, node_num, slot_num);
skip_recovery:
                if (!status) {
                        ocfs2_recovery_map_clear(osb, node_num);
                } else {
                        mlog(ML_ERROR,
                             "Error %d recovering node %d on device (%u,%u)!\n",
                             status, node_num,
                             MAJOR(osb->sb->s_dev), MINOR(osb->sb->s_dev));
                        mlog(ML_ERROR, "Volume requires unmount.\n");
                }
        ...........................................
}
...............................................
}


Is the issue had been solved or any other way to avoid it?
Thanks a lot.

Guozhonghua
2013-11-1
-------------------------------------------------------------------------------------------------------------------------------------
????????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20131101/c4913cb1/attachment.html 
